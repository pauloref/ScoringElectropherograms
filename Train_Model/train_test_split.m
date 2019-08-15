function [x_tr,x_te,y_tr,y_te] = train_test_split(x,y,p)
N = length(y);
idx=randperm(length(y));
n_tr = floor(N*p);
x_tr= x(idx(1:n_tr),:);
y_tr = y(idx(1:n_tr),:);
x_te = x(idx(n_tr+1:end),:);
y_te = y(idx(n_tr+1:end),:);
