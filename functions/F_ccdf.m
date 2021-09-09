function ccdf = F_ccdf(A)
%ccdf = F_ccdf(A)
%Calculates the cumulative complementary degree distribution.
%   Input:
%                A = Adjacency matrix (n x n).
%   Output:
%                ccdf = (n x 1) vector containing the ccdf.

d = sum(A,2);
k_values = unique(d);
k_length = length(k_values);
pk = hist(d, 1:max(d));
pk = pk / sum(pk);
pk_length = length(pk);

Pk = ones(k_length,1);
for i=1:k_length
    Pk(i) = sum(pk(i:pk_length));
end
ccdf = Pk;

