function [A,xy] = RGG_geo(n,rho)
% function [A,xy] = RGG_geo(n,rho)
% Random graph generator - geometric model (no loops)
% Input:
%    n = node number
%    rho = connectivity coefficient (optional; default: 1)
% Output: 
%    A = adjacency matrix (sparse, n x n)
%    xy = array (n x 2) of cartesian coordinates 
%
% Example: n = 20; [A,xy] = RGG_geo(n); F_gplot(A,xy)

if nargin == 1
    rho = 1;
end
r = sqrt(2/n) * rho;
xy = rand(n,2);

I = [];
J = [];

for i = 2:n
    for j = 1:(i-1)
        diff = xy(i,:) - xy(j,:);
        if norm(diff) <= r
           J = [J ; j];
           I = [I ; i];
        end
    end
end
    
S = ones(2*length(I),1);
A = sparse([I J],[J I],1,n,n); 

