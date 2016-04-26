function [ mat_dist ] = fnDist( mat_test, mat_train )
%UNTITLED Summary of this function goes here
%   Takes an matrix SxC matrix 'mat_test' and RxC matrix 'mat_train' and
%   calculates distance from every point in 'mat_test' to every point in 
%   'mat_train'. Resulting matrix 'mat_dist' is RxS
    

    if(size(mat_test,2)~=size(mat_train,2))
        error('Mismatch in dimension size of points');
    end

    mat_dist = zeros(size(mat_train,1), size(mat_test,1));
    parfor i_inc = 1:size(mat_test,1)
         % Expand test point to matrix to do distance calculation
         % against training matrix
         mat_test_row = repmat(mat_test(i_inc,:), size(mat_train,1), 1);
         % Cacluate square distance by summing up square distnance of
         % all vector components along row
         mat_square_dist_row = sum((mat_test_row - mat_train).^2,2);
         % Get actual distances
         mat_dist_col = mat_square_dist_row.^.5;
         % Each test point its own column
         mat_dist(:,i_inc) = mat_dist_col;
        
         
    end
          
    return
    
    i_test_points_count = size(mat_test,1);
    i_train_points_count = size(mat_train,1);
    
    %% Rearrange Test points along 3rd axis
    mat_test = permute(mat_test, [3,2,1]);
    % Replicate for size of points to whose distance you wish to calculate
    % (For each test point)
    mat_points = repmat(mat_test, [i_train_points_count,1,1]);
    
    %% Get toal distance
    mat_train = repmat(mat_train, [1,1,i_test_points_count]); 
    mat_diff = mat_points-mat_train;
    mat_dist = mat_diff.^2;
    
    %% Sum along all dimensions of each point
    mat_dist = sum(mat_dist,2);
    mat_dist = permute(mat_dist,[1,3,2]);
%     mat_dist = permute(mat_dist, [2,1]);
    %% Get acutal distancs
    mat_dist = mat_dist.^0.5;

end

