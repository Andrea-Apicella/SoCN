function F_gplot(A,xy,v,nodesize)
% function F_gplot(A,xy,v,nodesize)
% gplot-like command with node editing options
% usage:        A = adjacency matrix (n x n)
%              xy = node coordinates (n x 2)
%               v = node color index (scalar or n-vector; optional)
%        nodesize = node marker size (scalar or n-vector; optional)
%
% Nodes with NaN values are represented by hollow circles

% Dario Fasino, May 2018


n = length(A);
if nargin < 4, nodesize = 8; end
if nargin < 3, v = []; end
if isempty(v), v = zeros(n,1); end
if length(v) == 1, v = repmat(v,n,1); end
if length(v) ~= n   % throw an error
   v = A*v; end
if length(nodesize) == 1, nodesize = repmat(nodesize,n,1); end
    
gplot(A,xy); 
set(findobj('Type','line'),'Color',[.5 .5 .7]);
map = colormap;         % get current figure's colormap
nmap = length(map);
vmax = max(1,max(v)); vmin = min(0,min(v)); 
ivmap = round(interp1q([vmin;vmax],[1;nmap],v(:)));

hold on
for i = 1:n
    if ~isnan(v(i))
    plot(xy(i,1),xy(i,2),'o',...
        'markersize',nodesize(i),...  
        'markeredgecolor','none',...
        'markerfacecolor',map(ivmap(i),:))
    else
    plot(xy(i,1),xy(i,2),'o',...
        'markersize',nodesize(i),...  
        'markeredgecolor','k',...
        'markerfacecolor','none')        
    end
end
hold off
axis off
caxis([vmin,vmax]);     % Set CLim for colorbar scaling