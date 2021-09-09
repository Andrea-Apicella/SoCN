function perron_eigenvector = F_power_method(A, varargin)
%function perron_eigenvector = power_method(A, v0, max_iterations, normalize, tolerance)
%calculates the perron eigenvector of a non-negative matrix.
% Input: 
%                    A = (n x n) non negative matrix.
%                   v0 = optional, v0 = ones(n,1) by default. (n x 1) or (1 x n) vector. Starting vector for the first iteration of the power method.
%       max_iterations = optional, max_iterations = 1000 by default. Positive number. Specifies the maximum number of iterations of the power method. The algorithm terminates in advance if convergence is met.
%            normalize = optional. Boolean, true by default. Specifies wheter to normalize (with L2 norm) the eigenvector calculated at each iteration.
%            tolerance = optional, tolerance = 1.0e-06 by default. Positive number wich specifies the maximum error allowed when comparing vectors of two subsequent iterations (needed to test convergence).
% Output:
%   perron_eigenvector = dominant eigenvector of A.
p = inputParser;
v0 = ones(size(A,1),1);
max_iterations = 1000;
normalize = true;
tolerance = 1.0e-06;

addRequired(p, 'A', @ismatrix);
addParameter(p, 'v0', v0, @isvector);
addParameter(p, 'max_iterations', max_iterations, @mustBePositive);
addParameter(p, 'normalize', normalize, @islogical);
addParameter(p, 'tolerance', tolerance, @mustBePositive);
parse(p,A,varargin{:});

v0 = p.Results.v0;
v0 = reshape(v0,[],1);
if p.Results.normalize
    v0 = v0 / norm(v0);
    vold = v0;
    vnew = zeros(length(vold),1);
        for iter=1:p.Results.max_iterations
            vnew = A*vold;
            vnew = vnew / norm(vnew);
            diff = abs(vnew - vold);
            if all(diff < p.Results.tolerance)
                disp('Power Method converged after ' + string(iter) + ' iterations');
                perron_eigenvector = vnew;
                return
            end
            vold = vnew;
        end
else
vold = v0;
vnew = zeros(length(vold),1);
        for iter=1:p.Results.max_iterations
            vnew = A*vold;
            diff = abs(vnew - vold);
            if all(diff < p.Results.tolerance)
                disp('Power Method converged after ' + string(iter) + ' iterations');
                perron_eigenvector = vnew;
                return
            end
            vold = vnew;
        end
end
    perron_eigenvector = vnew;
    disp('Power Method converged after max_iterations ' + '('+max_iterations+')');
    return
end

