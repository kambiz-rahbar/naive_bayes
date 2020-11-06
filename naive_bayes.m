function [sel_class] = naive_bayes(data,cnd)

X = data(:,1:end-1);
Y = data(:,end);

Y_labels = unique(Y);

for k = 1:length(Y_labels)
    data_class{k} = X(Y==Y_labels(k),:);
end

%% calc evidence
for c = 1:size(X,2)
    sel_X = X(:,c);
    X_labels = unique(sel_X);
    P = zeros(size(X_labels));
    for k = 1:length(X_labels)
        P(k) = sum(sel_X==X_labels(k))/length(Y);
    end
    P_x{c} = P;
end

%% calc likelihood
for c = 1:size(X,2)
    sel_X = X(:,c);
    
    X_labels = unique(sel_X);
    Pc = zeros(length(X_labels),length(Y_labels));
    for k = 1:length(X_labels)
        for s = 1:length(Y_labels)
            sel_cond_X = data_class{s};
            sel_cond_X = sel_cond_X(:,c);
            Pc(k,s) = sum(sel_cond_X==X_labels(k))/sum(Y==Y_labels(s));
        end
    end
    Pcond_x{c} = Pc;
end

%% calc prior
prior = zeros(1,length(Y_labels));
for k = 1:length(Y_labels)
    prior(k) = sum(Y==Y_labels(k))/length(Y);
end

%% calc posterior

%      [Outlook_sunny_indx, Temperature_cool_indx, Humidity_high_indx, Windy_fast_indx];
%cnd = [1,                  3,                     1,                  2];
evidence = 1;
likelihood = ones(1,length(Y_labels));
for k = 1:length(P_x)
    evidence = evidence * P_x{k}(cnd(k));
    likelihood = likelihood .* Pcond_x{k}(cnd(k),:);
end

posterior = likelihood .* prior / evidence;

[~, sel_class] = max(posterior);

disp(table(posterior, sel_class))

