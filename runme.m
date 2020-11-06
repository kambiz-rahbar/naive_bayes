% implement based on https://www.youtube.com/watch?reload=9&v=CPqOCI0ahss

clc
clear
close all
format rat


data = [CONST.Outlook_sunny,    CONST.Temperature_hot,  CONST.Humidity_high,   CONST.Windy_slow, CONST.Play_no;   % 1
        CONST.Outlook_sunny,    CONST.Temperature_hot,  CONST.Humidity_high,   CONST.Windy_fast, CONST.Play_no;   % 2
        CONST.Outlook_overcast, CONST.Temperature_hot,  CONST.Humidity_high,   CONST.Windy_slow, CONST.Play_yes;  % 3
        CONST.Outlook_rainy,    CONST.Temperature_mild, CONST.Humidity_high,   CONST.Windy_slow, CONST.Play_yes;  % 4
        CONST.Outlook_rainy,    CONST.Temperature_cool, CONST.Humidity_normal, CONST.Windy_slow, CONST.Play_yes;  % 5
        CONST.Outlook_rainy,    CONST.Temperature_cool, CONST.Humidity_normal, CONST.Windy_fast, CONST.Play_no;   % 6
        CONST.Outlook_overcast, CONST.Temperature_cool, CONST.Humidity_normal, CONST.Windy_fast, CONST.Play_yes;  % 7
        CONST.Outlook_sunny,    CONST.Temperature_mild, CONST.Humidity_high,   CONST.Windy_slow, CONST.Play_no;   % 8
        CONST.Outlook_sunny,    CONST.Temperature_cool, CONST.Humidity_normal, CONST.Windy_slow, CONST.Play_yes;  % 9
        CONST.Outlook_rainy,    CONST.Temperature_mild, CONST.Humidity_normal, CONST.Windy_slow, CONST.Play_yes;  % 10
        CONST.Outlook_sunny,    CONST.Temperature_mild, CONST.Humidity_normal, CONST.Windy_fast, CONST.Play_yes;  % 11
        CONST.Outlook_overcast, CONST.Temperature_mild, CONST.Humidity_high,   CONST.Windy_fast, CONST.Play_yes;  % 12
        CONST.Outlook_overcast, CONST.Temperature_hot,  CONST.Humidity_normal, CONST.Windy_slow, CONST.Play_yes;  % 13
        CONST.Outlook_rainy,    CONST.Temperature_mild, CONST.Humidity_high,   CONST.Windy_fast, CONST.Play_no];  % 14
    
X = data(:,1:4);
Y = data(:,5);

X_play_yes = X(Y==CONST.Play_yes,:);
X_play_no = X(Y==CONST.Play_no,:);

%% manual solution

% how to calc...

% p_play_yes = sum(Y==CONST.Play_yes) / length(Y);
% p_play_no = sum(Y==CONST.Play_no) / length(Y);
% 
% p_outlook_sunny__play_yes = sum(X_play_yes(:,1)==CONST.Outlook_sunny) / sum(Y==CONST.Play_yes);
% p_outlook_sunny__play_no = sum(X_play_no(:,1)==CONST.Outlook_sunny) / sum(Y==CONST.Play_no);
% 
% p_outlook_overcast__play_yes = sum(X_play_yes(:,1)==CONST.Outlook_overcast) / sum(Y==CONST.Play_yes);
% p_outlook_overcast__play_no = sum(X_play_no(:,1)==CONST.Outlook_overcast) / sum(Y==CONST.Play_no);
% 
% p_outlook_rainy__play_yes = sum(X_play_yes(:,1)==CONST.Outlook_rainy) / sum(Y==CONST.Play_yes);
% p_outlook_rainy__play_no = sum(X_play_no(:,1)==CONST.Outlook_rainy) / sum(Y==CONST.Play_no);
%
% ...

% conditional outlook | count(play_yes) | count(play_no) | p(play_yes) | p(play_no)
% ---------------------------------------------------------------------------------
% sunny               |                 |                |             |
% overcast            |                 |                |             |
% rainy               |                 |                |             |
% ---------------------------------------------------------------------------------
r = 1;
for k = CONST.Outlook_sunny:CONST.Outlook_rainy
    cnd_Outlook(r,:) = [sum(X_play_yes(:,1)==k), sum(X_play_no(:,1)==k)];
    r = r+1;
end
cnd_Outlook(:,3:4) = [cnd_Outlook(:,1)/sum(Y==CONST.Play_yes), cnd_Outlook(:,2)/sum(Y==CONST.Play_no)];

% Outlook  | count |  p
% -----------------------
% sunny    |       | 
% overcast |       | 
% rainy    |       | 
% -----------------------
r = 1;
for k = CONST.Outlook_sunny:CONST.Outlook_rainy
    Outlook(r,:) = [sum(X(:,1)==k)];
    r = r+1;
end
Outlook(:,2) = Outlook(:,1)/length(Y);

% conditional temperature | count(play_yes) | count(play_no) | p(play_yes) | p(play_no)
% -------------------------------------------------------------------------------------
% hot                     |                 |                |             |
% mild                    |                 |                |             |
% cool                    |                 |                |             |
% -------------------------------------------------------------------------------------
r = 1;
for k = CONST.Temperature_hot:CONST.Temperature_cool
    cnd_Temperature(r,:) = [sum(X_play_yes(:,2)==k), sum(X_play_no(:,2)==k)];
    r = r+1;
end
cnd_Temperature(:,3:4) = [cnd_Temperature(:,1)/sum(Y==CONST.Play_yes), cnd_Temperature(:,2)/sum(Y==CONST.Play_no)];

% Temperature | count |  p
% --------------------------
% hot         |       | 
% mild        |       | 
% cool        |       | 
% --------------------------
r = 1;
for k = CONST.Temperature_hot:CONST.Temperature_cool
    Temperature(r,:) = [sum(X(:,2)==k)];
    r = r+1;
end
Temperature(:,2) = Temperature(:,1)/length(Y);

% conditional humidity | count(play_yes) | count(play_no) | p(play_yes) | p(play_no)
% -----------------------------------------------------------------------------------
% high                 |                 |                |             |
% normal               |                 |                |             |
% -----------------------------------------------------------------------------------
r = 1;
for k = CONST.Humidity_high:CONST.Humidity_normal
    cnd_Humidity(r,:) = [sum(X_play_yes(:,3)==k), sum(X_play_no(:,3)==k)];
    r = r+1;
end
cnd_Humidity(:,3:4) = [cnd_Humidity(:,1)/sum(Y==CONST.Play_yes), cnd_Humidity(:,2)/sum(Y==CONST.Play_no)];

% humidity | count |  p
% ----------------------
% high     |       | 
% normal   |       | 
% ----------------------
r = 1;
for k = CONST.Humidity_high:CONST.Humidity_normal
    Humidity(r,:) = [sum(X(:,3)==k)];
    r = r+1;
end
Humidity(:,2) = Humidity(:,1)/length(Y);

% conditional windy | count(play_yes) | count(play_no) | p(play_yes) | p(play_no)
% -------------------------------------------------------------------------------
% slow              |                 |                |             |
% fast              |                 |                |             |
% -------------------------------------------------------------------------------
r = 1;
for k = CONST.Windy_slow:CONST.Windy_fast
    cnd_Windy(r,:) = [sum(X_play_yes(:,4)==k), sum(X_play_no(:,4)==k)];
    r = r+1;
end
cnd_Windy(:,3:4) = [cnd_Windy(:,1)/sum(Y==CONST.Play_yes), cnd_Windy(:,2)/sum(Y==CONST.Play_no)];

% Windy | count |  p
% -------------------
% slow  |       | 
% fast  |       | 
% -------------------
r = 1;
for k = CONST.Windy_slow:CONST.Windy_fast
    Windy(r,:) = [sum(X(:,4)==k)];
    r = r+1;
end
Windy(:,2) = Windy(:,1)/length(Y);

% play | count |  p
% -------------------
% no   |       | 
% yes  |       | 
% -------------------
r = 1;
for k = CONST.Play_no:CONST.Play_yes
    Play(r,:) = [sum(Y==k)];
    r = r+1;
end
Play(:,2) = Play(:,1)/length(Y);


%     [Outlook_sunny_indx, Temperature_cool_indx, Humidity_high_indx, Windy_fast_indx];
cnd = [1,                  3,                     1,                  2];

p_play_yes = Play(2,2);
p_play_no = Play(1,2);
p_x = prod([Outlook(cnd(1),2); Temperature(cnd(2),2); Humidity(cnd(3),2); Windy(cnd(4),2)]);
p_x__play_yes = prod([cnd_Outlook(cnd(1),3); cnd_Temperature(cnd(2),3); cnd_Humidity(cnd(3),3); cnd_Windy(cnd(4),3)]);
p_x__play_no = prod([cnd_Outlook(cnd(1),4); cnd_Temperature(cnd(2),4); cnd_Humidity(cnd(3),4); cnd_Windy(cnd(4),4)]);

yes_posterior = p_x__play_yes * p_play_yes / p_x;
no_posterior = p_x__play_no * p_play_no / p_x;

format short

disp([no_posterior, yes_posterior])
if yes_posterior > no_posterior
    disp('PLAY: YES');
else
    disp('PLAY: NO');
end

%% result for naive_bayes function
[sel_class] = naive_bayes(data,cnd);
if sel_class > 1
    disp('PLAY: YES');
else
    disp('PLAY: NO');
end
