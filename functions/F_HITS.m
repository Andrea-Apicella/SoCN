function [h,a, Mhub, Mauth] = F_HITS(A, varargin)
% function [h,a] = HITS(A, optimize_memory, tolerance)
% calculates Hub and Authority scores for each node as defined by Jon Kleimberg for the HITS alghoritm
% If A is symmetrix h and a will be the same vector, equivalent to the Bonacich's index.
%   Input:
%                A = adjacency matrix (n x n).
%  optimize_memory = optional. Boolean, true by default.
%                    If true Mhub and Mauth matrices will not be
%                    pre-calculated and held in memory. The F_power_method
%                    will be called directly on A*transpose(A).
%        tolerance = optional. Positive real number,the default in F_power_method function
%                    is 1xe^(-5).
%                    Passed to F_power_method.m to specify the maximum error
%                    allowed when comparing vectors of two subsequent
%                    iterations (needed to test convergence).
%   Output:
%                h = (n x 1) vector containing normalized (with L2 norm) hub scores for each node of the graph.
%                a = (n x 1) vector containing normalized (with L2 norm) authority scores for each node of the graph.
p = inputParser;
optimize_memory = true;
addRequired(p,'A',@ismatrix);
addOptional(p, 'optimize_memory',optimize_memory, @islogical);
parse(p, A, varargin{:});

if issymmetric(A)
    h = F_power_method(A);
    a = h;
    disp('The input matrix is ​​symmetric. Hub and authority scores coincide with Bonacich scores (eigenvector centrality)');
    return
end


if p.Results.optimize_memory
    h = F_power_method(A*transpose(A));
    a = transpose(A)*A*h;
    a = a / norm(a);
else
    Mhub = A*transpose(A);
    Mauth = transpose(A)*A;
    h = F_power_method(Mhub);

    a = Mauth*h;
    a = a / norm(a);
return
end
end

