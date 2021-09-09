function [degree_distribution,ccdf] = F_distribution_analysis(A)
%function [degree_distribution,ccdf] = F_distribution_analysis(A)
%Calculates and plots the degree vector, the degree distribution (in non log and log scales) and the ccdf (in log scale).
%   Input:
%                A = adjacency matrix (n x n).

%   Output:
%                degree_distribution = (n x 1) vector containing the degree distribution of A.
%                ccdf = (n x 1) vector containing the ccdf of A, calculated via F_ccdf(A);

neutral_color = '#2c3e50';
d = sum(A,2);
figure();
tiledlayout(1,5);
nexttile
plot(sort(d, 'descend'),'Marker','o', 'MarkerFaceColor',neutral_color,'MarkerEdgeColor','none', 'MarkerSize',4, 'LineStyle', 'none');
xlabel('Nodi');
ylabel('Gradi');
title('Vettore dei gradi');
grid
nexttile
hd = hist(d, 1:max(d));
dk = hd / sum(hd);
degree_distribution=dk;
plot(dk,'Marker','o', 'MarkerFaceColor',neutral_color,'MarkerEdgeColor','none', 'MarkerSize',4, 'LineStyle', 'none');
title('Distribuzione dei gradi');
xlabel('Grado dei nodi');
ylabel('dk (frazione di nodi di grado k)');
grid
nexttile
loglog(dk,'Marker','o', 'MarkerFaceColor',neutral_color,'MarkerEdgeColor','none', 'MarkerSize',4, 'LineStyle', 'none');
title('Distribuzione dei gradi in scala logaritmica');
xlabel('Grado dei nodi');
ylabel('dk (frazione di nodi di grado k)');
grid
nexttile
ccdf = F_ccdf(A);
loglog(ccdf,'Marker','o', 'MarkerFaceColor',neutral_color,'MarkerEdgeColor','none', 'MarkerSize',4, 'LineStyle', 'none');
title('CCDF in scala logaritmica');
xlabel('Gradi dei nodi: k');
ylabel('Pk');
grid

end

