function [ mat_new ] = fnReduceDimensions( mat_data, i_dimension_count )
%fnReduceDimensions reduces data
%   takes data from 'mat_data' and reduces it to 'i_dimension_count')

    %% Input will be 400x644
    %% Make it 644x400 To perform analysis
    mat_data = mat_data';


    %% Using SVD
    v_mean = mean(mat_data,2);                              %% Need mean
    mat_mean = repmat(v_mean, [1, size(mat_data,2)]);       %% in order to
    mat_data_less_mean = mat_data-mat_mean;                 %% center Data

    v_var = var(mat_data,1,2);                              %% Will need
    mat_var = repmat(v_var, [1, size(mat_data,2)]);         %% Standard
    mat_stdev = mat_var.^0.5;                               %% Deviation

    %% Create a data matrix X such that the r-th Row, c-th Column of
    %% X*(X^T) will give the correlation (per class instruction) of the
    %% r-th and c-th variable. Do this by making r-th Row, c-th Column
    %% equal to SumAllXsubR(x_R-Mu_R) * SumAllXsubC(x_C-Mu_C) / (stdev(x_R) * stdev(x_C))
    mat_X = mat_data_less_mean./mat_stdev;

    %% Instead of using PCA to get Eigen vectors of 'mat_X*mat_X^T'
    %% We only need use SVD on 'mat_X' to get Eigen vectors

    [mat_U, mat_S, mat_V] = svd(mat_X,'econ');
    %% Find mat_Xdlm_ito_eigU st it is 400x400
    %% mat_data_less_mean = mat_U * mat_Xdlm_ito_eigU;
    %% mat_U' * mat_data_less_mean = mat_U' * mat_U * mat_Xtlm_ito_eigU
    %% inv(mat_U' * mat_U) * mat_U' * mat_data_less_mean = inv(mat_U' * mat_U) * (mat_U' * mat_U) * mat_Xdlm_ito_eigU
    % pinv(mat_U') * mat_U' * mat_data_less_mean = inv(mat_U' * mat_U) * (mat_U' * mat_U) * mat_Xdlm_ito_eigU

    
    
    
    
    
    %% Find data points 'mat_X' in terms of Eigen vectors, rather
    %% find 'mat_Xdlm_ito_eigU' in 
    %% mat_data_less_mean = mat_U * mat_Xdlm_ito_eigU;   
    %% Because 'mat_Xdlm_ito_eigU' is we cannot find an inverse.
    %% So we get pseudo inversoe of
    %% mat_data_less_mean = mat_U * mat_Xdlm_ito_eigU;
    %% mat_U' * mat_data_less_mean = mat_U' * mat_U * mat_Xtlm_ito_eigU
    %% inv(mat_U' * mat_U) * mat_U' * mat_data_less_mean = inv(mat_U' * mat_U) * (mat_U' * mat_U) * mat_Xdlm_ito_eigU = mat_Xdlm_ito_eigU
    mat_Xdlm_ito_eigU = inv(mat_U' * mat_U) * mat_U' * mat_data_less_mean;

    
    %% Get first 'i_dimension_count' Eigen vectors - mat_U(:, [1:i_dimension_count])
    %% and the first 'i_dimension_count' vector components - mat_Xdlm_ito_eigU([1:i_dimension_count], :)
    %% and add back the mean
    mat_new = mat_U(:, [1:i_dimension_count]) * mat_Xdlm_ito_eigU([1:i_dimension_count], :) + mat_mean;

    %% previous will be 644x400
    %% Make it 400x644
    mat_new = mat_new';


end

