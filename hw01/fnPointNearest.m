% function [] = fnPointsNearest(mat_point, mat_group, mat_class, k)
% fnDist 
%   measures distance betwen EACH 'test point' in 'mat_point' and 
%   EVERY 'group point' in 'mat_group'
    
    k=3;

    mat_point = [1,12;3,9;9,5;11,5];
    mat_group = [2,10;2,8;3,7;4,10;4,8;5,9;7,5;8,6;9,7;10,6;10,4;8,4];
    mat_class = [1,1,1,1,1,1,2,2,2,2,2,2];
    
    
    %% Rearrange Test points along 3rd axis
    mat_point = permute(mat_point, [3,2,1]);
    % Replicate for size of points to whose distance you wish to calculate
    % (For each test point)
    mat_points = repmat(mat_point, [size(mat_group,1),1,1]);
    
    %% Get toal distance
    mat_group = repmat(mat_group, [1,1,size(mat_points,3)]); 
    mat_diff = mat_points-mat_group;
    mat_dist = mat_diff.^2;
    
    %% Sum along all dimensions
    mat_dist = sum(mat_dist,2);
    mat_dist = permute(mat_dist,[1,3,2]);

    mat_index = fnSortedIndex(mat_dist);
    %% Distances between each Test points occur along 2nd 

    
% end