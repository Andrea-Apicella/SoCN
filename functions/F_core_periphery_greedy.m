function [A_reordered,S,k_star] = F_core_periphery_greedy(A)
%function [A_reordered,S,k_star] = F_core_peripher_greedy(A)
%   Computes an optimal core-periphery partition. 
%This function is a non official implementation of the work:
%  "A Fast and Exact Greedy Algorithm for the Core–Periphery Problem" by D.Fasino e F.Rinaldi"
% INPUTS:
%             A = adjacency matrix, for a network that is undirected. If you provide a network that is directed, this code is going to make it undirected before continuing.
%
% OUTPUTS:
%   A_reordered = Input matrix with the nodes reordered according to the sorted degrees vector.
%             S = Array of indices of the core nodes.
%        k_star = Cardinality of S.

if ~issymmetric(A)
    A = (A+A')/2;
end

d = sum(A,2);
[~, I] = sort(d,'descend');

n = [1:size(A,1)];
n = n(I);

k = 1;
while d(n(k)) > k - 1
    k = k + 1;
end
k_star = k;
S = n(1:k_star);
A_reordered = A(I,I);
end

