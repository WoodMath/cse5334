function [ v_mean, mat_covar, eig_vect ] = fnPCA( mat_points )
% fnPCA takes a series of n-Dimensional pints
%   returns the mean, covariance matrix, and corresponding eigen-vectors


    i_num_points = size(mat_points,1);
    i_size_dimension = size(mat_points,2);

    v_mean = mean(mat_points,1);
    
    mat_mean = repmat(v_mean, [i_num_points,1]);
    mat_diff = mat_points - mat_mean;
    mat_covar = mat_diff'*mat_diff / i_num_points;

    if(i_num_points == 1)
        eig_vect = zeros(i_size_dimension);
    else
        [eig_vect,eig_val] = eig(mat_covar);
    end

end

