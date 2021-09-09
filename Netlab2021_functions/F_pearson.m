function r = F_pearson(x,y)
% function r = F_pearson(x,y)
% Pearson coefficient for vectors x and y
x = x - mean(x);
y = y - mean(y);
r = dot(x,y)/(norm(x)*norm(y));