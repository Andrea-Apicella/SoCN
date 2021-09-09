function [centrality_scores, topk] = F_centrality_analysis(A, varargin)
% function [centrality_scores, topk] = F_centrality_analysis(A, varargin)
% Computes clustering coefficients
%
% Inputs:  
%                  A = Required. Adjacency matrix (n x n). 
%          nodenames = Required. (n x 1) strings vector containing the name of each node.
% centrality_indices = Optional. Vector of strings containing the names of the centrality measures to calculate. The default value is centrality_indices = ["indegree","outdegree","incloseness","outcloseness", "pagerank", "hubs", "authorities","betweenness"];
%              tplot = Optional. Logical value wich specifies wheter to plot the correlation between each pair of centrality measures or not. The default value is false.
%              color = Optional. Color of the Markers in the plots. The default value is 'r';
%                  k = Optional. Number of nodes with highest centrality scores to show in the table topk.
%         show_units = Optional. Logical value to specify wheter to show the units in each plot or not. The default value is false to save some space in the figure as it may contain a large number of subplots.

% Outputs:  
%  centrality_scores = Map Container containg the scores for each centrality measure specified in centrality_indices.

%               topk = table containing the top k nodes names and values for each centrality measure.;

p = inputParser;
toplot = false;
color = 'r';
k = 12;
show_units = false;
centrality_indices = ["indegree","outdegree","incloseness","outcloseness", "pagerank", "hubs", "authorities","betweenness"];
addRequired(p, 'A',@ismatrix);
addRequired(p,'nodenames');
addOptional(p, 'centrality_indices', centrality_indices);
addOptional(p, 'toplot', toplot,@islogical);
addOptional(p,'color',color,@ischar);
addOptional(p,'k',k,@mustBePositive);
addOptional(p, 'show_units', show_units,@islogical);

parse(p,A,varargin{:});

color_component = 0;
switch p.Results.color
    case 'r'
        color_component = 1;
    case 'g'
        color_component = 2;
    case 'b'
        color_component = 3;
end
centrality_indices = p.Results.centrality_indices;
clear p.Results.centrality_indices;

G = digraph(A);
l = length(centrality_indices);
scores{1,l} = [];
for index=1:length(centrality_indices)
    scores{index} = centrality(G, centrality_indices(index));
end
centrality_indices = [centrality_indices,  'KATZ'];
scores = [scores, F_KATZ(A)];
centrality_scores = containers.Map(centrality_indices, scores);
l = length(centrality_indices);

   if p.Results.toplot
       color = [0,0,0]; 
       figure();
       t = tiledlayout('flow');
       title(t,'Correlazione tra le misure di centralità', 'fontweight','bold','fontsize',16);
       subtitle(t,'Maggiore è il coefficiente di correlazione e maggiore è l''intensità del colore');
       index = 1;
       for i=1:l
           for j=index:l
               if i~=j
                   measure1 = centrality_indices(i);
                   measure2 = centrality_indices(j);
                   if measure1 ~= measure2
                       nexttile
                       correlation_index = F_pearson(centrality_scores(measure1), centrality_scores(measure2));                       
                       color(color_component) = interp1([-1 1], [0 1],correlation_index);         
                       plot(centrality_scores(measure1), centrality_scores(measure2), 'Marker','o', 'MarkerEdgeColor','none', 'MarkerFaceColor',color, 'MarkerSize',4, 'LineStyle','none');
                       if ~p.Results.show_units
                       set(gca,'XTick',[], 'YTick', []);
                       end
                       title('Pearson: '+string(correlation_index), 'FontWeight','normal');
                       xlabel(measure1,'FontWeight','bold');
                       ylabel(measure2,'FontWeight','bold');
                   end
               end
           end
           index = index+1;
       end
   end


topk_values{1,l} = [];
topk_nodenames{1,l} = [];
topk_indices{1,l} = [];
topk_keys = centrality_indices;

sz = size(p.Results.nodenames,1);
names = strings(sz,1);
for i=1:sz
   names(i) = convertCharsToStrings(p.Results.nodenames(i,:));
end


topk = table();
for i=1:l
    key = topk_keys(i);
    [topk_values{i}, topk_indices{i}] = maxk(centrality_scores(key),p.Results.k);
    topk_nodenames{i} = names(topk_indices{i});
    str = convertStringsToChars('top '+string(p.Results.k)+' '+key);
    tnew = table(topk_nodenames{i},topk_values{i},'VariableNames',{str,convertStringsToChars(key)});
    topk = [topk, tnew];
end
end

