function [A,xy] = G_ws(n,k,p)
% Generate adjacency matrix for a small world (Watts-Strogatz) network.
%
%   Input   n: dimension of matrix (number of nodes in graph).
%           k: radius of nearest-neighbours to connect. Defaults to 2.
%           p: rewiring probability. Defaults to 0.1.
%
%   Output  A: n by n (sparse) symmetric matrix.

% DF, May 2018

if nargin <= 2
    p = 0.1;
    if nargin == 1
        k = 2;
    end
end

I = kron(1:n,ones(1,k));
temp = repmat(0:k-1,1,n);
J = mod(I + temp,n) + 1;
A = sparse([I J],[J I],1,n,n);

for i = 1:n
    for j = 0:k-1             % rewires forward edges
        if p > rand    
            notdone = true;   % there is an edge to rewire
            while notdone
               jnew = mod(i+randi(n-1,1),n)+1;   % avoid forming loops
               if A(i,jnew) == 0, notdone = false; end
            end
            jold = mod(i+j,n)+1;
            A(i,jold) = 0; A(jold,i) = 0; 
            A(i,jnew) = 1; A(jnew,i) = 1; 
        end
    end            
end

if nargout == 2
    theta = 2*pi*(1:n)/n;
    xy = [cos(theta') sin(theta')];
end