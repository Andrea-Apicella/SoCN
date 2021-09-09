% [nComponents,sizes,membership] = F_connected(A)
% Computes connected components
%
% INPUTS:
% A       adjacency matrix, for a network that is undirected. If you
% provide a network that is directed, this code is going to make it
% undirected before continuing. Link weights don't matter.
%
% OUTPUTS:
% nComponents   number of components in the network.
% sizes         a vector of component sizes, sorted, descending.
% membership    membership(i) is the component number of the i-th node

% Daniel Larremore & Dario Fasino

function [nComponents,sizes,membership] = F_connected(A)
% Number of nodes
n = size(A,1);
% make symmetric, just in case it isn't
A = logical(A+A');
% Have we visited a particular node yet?
membership = zeros(1,n);
nComponents = 0; % 

% check every node
for i=1:n
    if ~membership(i)
        nComponents = nComponents + 1;
        % started a new component so add it to members
        members = i;
        % account for discovering i
        membership(i) = nComponents;
        newmembers = 1;
        while newmembers > 0
            % find neighbors
            nbrs = find(sum(A(:,members),2));
            % here are the neighbors that are undiscovered
            newNbrs = nbrs(membership(nbrs)==0);
            % we can now mark them as discovered
            membership(newNbrs) = nComponents;
            % add them to member list
            newmembers = length(newNbrs);
            members(end+1:end+newmembers) = newNbrs;
        end
    end
    % component visit complete, record size
    sizes(nComponents) = length(members);
end

if nComponents > 1
   [sizes,idx] = sort(sizes,'descend');
   iidx(idx) = 1:nComponents;
   membership = iidx(membership);
end
end