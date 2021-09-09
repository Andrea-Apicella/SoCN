function k = F_KATZ(A, varargin)
% function k = F_KATZ(A,varargin)
% Computes Katz centrality index.
% Input:
%                A = adjacency matrix (n x n).
%            alpha = optional. Positive number. The default value is 0.5. Damping factor.
%      orientation = optional. String. The default value is 'in', meaning that the Katz algorithm will use directed paths entering the nodes. If orientation is 'out' directed paths wich exit from the nodes will be used.
%   Output:
%                k = (n x 1) vector containing the katz score of each node.
%                
p = inputParser;
alpha = 0.5;
orientation = 'in';
addRequired(p,'A',@ismatrix);
addOptional(p,'alpha',alpha,@mustBePositive);
addOptional(p,'orientation', orientation, @isstring);
p.parse(A,varargin{:});

if strcmp(p.Results.orientation,'in')
    A = A';
end

B = eye(size(A)) - p.Results.alpha*A;
ones_vec = ones(size(A,1),1);

v = linsolve(B,ones_vec);
k = v - ones_vec;
k = k / norm(k);

end