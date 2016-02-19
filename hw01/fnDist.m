function [ mat_dist ] = fnDist( mat_test, mat_train )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    if(size(mat_test,2)~=size(mat_tran,2))
        error('Mismatch in dimension size of points');
    end

    %% Rearrange Test points along 3rd axis
    mat_test = permute(mat_test, [3,2,1]);
    % Replicate for size of points to whose distance you wish to calculate
    % (For each test point)
    mat_points = repmat(mat_test, [size(mat_train,1),1,1]);
    
    %% Get toal distance
    mat_train = repmat(mat_train, [1,1,size(mat_points,3)]); 
    mat_diff = mat_points-mat_train;
    mat_dist = mat_diff.^2;
    
    %% Sum along all dimensions of each point
    mat_dist = sum(mat_dist,2);
    mat_dist = permute(mat_dist,[1,3,2]);
    mat_dist = mat_dist.^0.5;

end

