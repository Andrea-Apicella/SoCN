function v = F_kcores(A)
% function v = F_kcores(A)
% Compute the core number for each vertex in the graph.
% Output: v = vector of core numbers
%
% Example: To extract the k-core: 
% v = F_kcores(A); I = find(v >= k);

% DF, May 14, 2018

A = (A+A' > 0);   % binary and symmetric
n = length(A);
A(1:n+1:end) = 0; % remove loops
v = zeros(n,1);
d = sum(A,2);
todo = n;
k = -1;
while todo > 0
    k = k+1; 
    ix = find(d <= k); 
    done = length(ix);
    while done > 0
        v(ix) = k; 
        todo = todo - done; 
        d = d - sum(A(:,ix'),2); 
        d(ix) = NaN;
        ix = find(d <= k); 
        done = length(ix);
    end
end

