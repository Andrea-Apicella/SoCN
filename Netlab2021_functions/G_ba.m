function A = G_ba(n,m)
%G_ba       Generate adjacency matrix for a scale free random graph.
%
%   Input  n: dimension of matrix (number of nodes in graph).
%          m: number of new edges per node. Defaults to 2.
%
%   Output  A: sparse n by n symmetric matrix 
%
%   Description:    Nodes are added successively. For each node, m edges 
%                   are generated. The endpoints are selected from the 
%                   nodes whose edges have already been created, with bias
%                   towards high degree nodes. This is a 
%                   revised version of the script CONTEST/pref.
%
%   Example: A = G_ba(100,2);

%   DF, April 2018

if nargin == 1, m = 2; end

K = triu(ones(m+1,m+1),1);
[I,J] = find(K);
k = length(I);

% static allocation 
I = cat(1,I,kron((m+2:n)',ones(m,1)));
J = cat(1,J,zeros(m*(n-m-1),1));

% add new nodes
for v = m+2:n
    for i = 1:m
        r = ceil(rand*2*k); 
        if r > k, J(k+i) = I(r-k); 
        else J(k+i) = J(r); end
    end
    k = k + m;
end
A = sparse([I;J],[J;I],1,n,n);
