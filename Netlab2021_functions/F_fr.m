function xyout = F_fr(A,cluster,mode)
%F_fr  A force-directed graph drawing algorithm 
% Computes a 2D node placement based on Fruchtermann-Reingold method
%
% xyout = F_fr(A,cluster,mode)  
% 
% Input:
%        A - adjacency matrix
%  cluster - a vector that assigns nodes to clusters (optional)
%     mode - working mode (optional) - 0: silent (default); 
%                                      1: show animation;
%
% Output:
%    xyout - array (n x 2) of cartesian coordinates 
%            to be used with gplot-type commands
%
% Reference: Thomas M. J. Fruchtermann, Edward M. Reingold.
%            Graph Drawing by Force-directed Placement
%            Software-Practice and Experience, 21 (1991), 1129--1164.

% Dario Fasino, May 2020

TPAUSE = 0.02;                 % Animation frame time  
A = double(A+A');              % acts on symmetric, unweighted graph
n = length(A);
if nargin > 1                  % increase intra-cluster attraction
    A = scale(A,cluster);
end
nstep = 200;                   % iterations
if nargin < 3, mode = 0; end   

xy = rand(n,2);                     % choose random initial layout
xy = bsxfun(@minus,xy,mean(xy));    % balancing mass center
damping = 0.5;                      % motion damping coefficient
% if mode > 0, figure; end          % open figure for animation

dxy = zeros(size(xy));
for i = 1:nstep
    dold = dxy;
    dxy = damping * dold + shuffle(A,xy);
    delta = norm(dxy)/norm(xy);   % step size heuristic rule
    xy = xy - .1/(2*delta+1) * ((nstep-i)/nstep) * dxy;
    if mode > 0                   % Draw graph animation
        splash(A,xy) 
        pause(TPAUSE)
    end 
end
if nargout > 0
    xyout = xy; 
elseif mode == 0
    % figure; 
    splash(A,xy); 
end
end

function splash(A,xy)
gplot(A,xy); 
set(findobj('Type','line'),'Color',[.5 .5 .7]);
hold on; plot(xy(:,1),xy(:,2),'.r'); hold off; 
axis equal; 
end

function dxy = shuffle(A,xy)
% Compute total forces. 
% If d is distance then: attractive force: d^2/k (linked node pairs)
%                        repulsive force: -k^2/d (all node pairs)

n = length(xy);
k = 1/sqrt(n);   % Fruchtermann-Reingold balancing rule
g = 0.5/n;       % gravity coefficient

x = xy(:,1);
Mx = bsxfun(@minus,x,x');
y = xy(:,2);
My = bsxfun(@minus,y,y'); 
D2 = Mx.^2 + My.^2 + eye(n);   % squared distance matrix, plus identity
DA = sqrt(D2).*A;

dx = sum(DA.*Mx,2)/k - k^2 * sum(Mx./D2,2) + g * sum(Mx,2); 
dy = sum(DA.*My,2)/k - k^2 * sum(My./D2,2) + g * sum(My,2); 

dxy = [dx dy];
dxy = bsxfun(@minus,dxy,mean(dxy));
end

function A = scale(A,cluster)
if length(cluster) > 0 
% Modifies adjacency matrix to increase intra-cluster edge weights
cluster = reshape(cluster,[1,length(cluster)]);
coef = 10; % This must be checked by trials
for i = unique(cluster)
    I = find(cluster == i);
    A(I,I) = A(I,I) * coef;
end
end
end