function [ mat_dist ] = fnDist( mat_test, mat_train )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    % Calculates distance from each point in 'mat_test' to every point in
    % 'mat_train'

    if(size(mat_test,2)~=size(mat_train,2))
        error('Mismatch in dimension size of points');
    end

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

