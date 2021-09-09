function [M,Q]=F_louvain(A,gamma)
%F_louvain   Optimal community structure by Louvain algorithm
%
%   M     = F_louvain(A);
%   [M,Q] = F_louvain(A,gamma);
%
%   The optimal community structure is a subdivision of the network into
%   nonoverlapping groups of nodes which maximizes modularity.
%
%   Inputs:
%       A - directed/undirected weighted/binary adjacency matrix            
%   gamma - resolution parameter (optional)          
%           gamma > 1       detects smaller modules
%           0 <= gamma < 1  detects larger modules
%           gamma = 1       classic modularity (default)
%
%   Outputs:
%       M - cluster affiliation vector
%       Q - modularity by cluster
%
%   Mika Rubinov, U Cambridge 2015-2016 (BST/community_louvain)
%   Revised: Dario Fasino, May 2020

A = double((A+A')/2);        % symmetrize and convert to double format
n = length(A);               % get number of nodes
s = sum(sum(A));             % get sum of edges

if ~exist('gamma','var') || isempty(gamma)
    gamma = 1;
end

if min(min(A))<0
    err_string = 'The adjacency matrix contains negative weights.';
    error(sprintf(err_string))          %#ok<SPERR>
end

B = (A-gamma*(sum(A,2)*sum(A,1))/s)/s;  % generalized modularity matrix

M0=1:n;   % Initial community assignment

[~,~,Mb] = unique(M0);
M = Mb;

Hnm=zeros(n,n);                         % node-to-module degree
for m=1:max(Mb)                         % loop over modules
    Hnm(:,m)=sum(B(:,Mb==m),2);
end

Q0 = -inf;
Q = sum(B(bsxfun(@eq,M0,M0.')));        % compute modularity
first_iteration = true;
while Q-Q0>1e-10
    flag = true;                        % flag for within-hierarchy search
    while flag
        flag = false;
        for u=randperm(n)                               % loop over all nodes in random order
            ma = Mb(u);                                 % current module of u
            dQ = Hnm(u,:) - Hnm(u,ma) + B(u,u);
            dQ(ma) = 0;                                 % (line above) algorithm condition
            
            [max_dQ,mb] = max(dQ);                      % maximal increase in modularity and corresponding module
            if max_dQ>1e-10                             % if maximal increase is positive
                flag = true;
                Mb(u) = mb;                             % reassign module
                
                Hnm(:,mb) = Hnm(:,mb)+B(:,u);           % change node-to-module strengths
                Hnm(:,ma) = Hnm(:,ma)-B(:,u);
            end
        end
    end
    [~,~,Mb] = unique(Mb);                              % new module assignments
    
    M0 = M;
    if first_iteration
        M=Mb;
        first_iteration=false;
    else
        for u=1:n                                       % loop through initial module assignments
            M(M0==u)=Mb(u);                             % assign new modules
        end
    end
    
    n=max(Mb);                                          % new number of modules
    B1=zeros(n);                                        % new weighted matrix
    for u=1:n
        for v=u:n
            bm=sum(sum(B(Mb==u,Mb==v)));                % pool weights of nodes in same module
            B1(u,v)=bm;
            B1(v,u)=bm;
        end
    end
    B=B1;
    
    Mb=1:n;                                             % initial module assignments
    Hnm=B;                                              % node-to-module strength
    
    Q0=Q;
    Q=trace(B);                                         % compute modularity
end

% Post-processing - Renumber clusters from largest to smallest
% and return modularity of each cluster
% DF, May 2020

nc = max(M);
size = histcounts(M,'BinMethod','integers');
[~,idx] = sort(size,'descend');
iidx(idx) = 1:nc;
M = iidx(M);
Q = diag(B);
Q = Q(idx);
end
