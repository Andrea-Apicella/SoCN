function rho = F_assortativity(A,v)
%A_assortativity   Assortativity coefficient
%    Assortativity with respect to scalar (e.g. binary) property
%
%    rho = A_assortativity(A,v) returns the assortativity coefficient
%    of the graph with adjacency matrix A if node i      
%    is given the scalar value v(i).
% 
%    Example: A_assortativity(A,sum(A)) computes the assortativity 
%    coefficient with respect to degree.

% Dario Fasino, May 2020

[I,J] = find(A>0);
% for i = 1:length(I)
%     s(i) = v(I(i));
%     t(i) = v(J(i));
% end
s = v(I);
t = v(J);
rho = F_pearson(s,t);

end

