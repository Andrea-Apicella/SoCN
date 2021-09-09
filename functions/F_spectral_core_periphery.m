function [eigenvectors, eigenvalues] = F_spectral_core_periphery(A,k)
%function [eigenvectors, eigenvalues] = F_spectral_core_periphery(A,k)%Plots spy(A), where A where A is the adjacency matrix with the nodes reordered according to the eigenvectors 1, ..., k associated with the k largest eigenvalues. 
%   Input:
%                A = adjacency matrix (n x n).
%                k = number of eigenvectors to use.

%   Output:
%     eigenvectors = (n x k) matrix containing the top k eigenvectors of A.
%      eigenvalues = (k x k) diagonal matrix containing the eigenvalues on the main diagonal
if ~issymmetric(A)
    A = (A+A')/2;
end
[eigenvectors,eigenvalues] = eigs(A,k);
figure();
tiledlayout('flow');
n = size(eigenvectors,2);
for i=1:n
    v = eigenvectors(:,i);
    [~, I] = sort(v,'descend');
    A_new = A(I,I);
    nexttile
    spy(A_new,'b');
    title('Nodi riordinati in base all''autovalore n° '+string(i));
end
end

