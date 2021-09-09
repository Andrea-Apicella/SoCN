function [C,cws,cnn] = F_clustering(A)
% function [C,cws,cnn] = F_clustering(A)
% Computes clustering coefficients
%
% Input:   A = adjacency matrix (n x n). 
%              The algorithm is applied to the symmetrized,
%              unweighted, loopless version of the graph.
%
% Output:  C = vector of clustering coefficients (n x 1)
%              Undefined values are returned as NaN.
%        cws = Watts-Strogatz clustering index:
%              average curvature (ignoring undefined values)
%        cnn = Newman clustering index

% Dario Fasino, April 2018.

A = double(A+A' > 0);
n = length(A);
A(1:n+1:end) = 0;   % zeroing the diagonal
d = sum(A,2);       % degree vector
den = d.*(d-1);
diagA3 = zeros(n,1);
for i = 1:n
    col = A(:,i);
    diagA3(i) = dot(col,A*col); % computes (A^3)_ii
end
C = diagA3 ./ den;
cws = mean(C(~isnan(C)));    % Watts-Strogatz index
cnn = sum(diagA3)/sum(den);  % Newman index
