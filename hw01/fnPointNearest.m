% function [] = fnDist(v_point, v_group)
% fnDist 
%   measures distance betwen EACH 'test point' in 'v_point' and 
%   EVERY 'group point' in 'v_group'
    
    v_point=[2,3;4,5;7,8];
    v_group=[1,3;3,6;7,8;9,10;1,5];
    
    %% Rearrange Test points along 3rd axis
    v_point = permute(v_point, [3,2,1]);
    % Replicate for size of points to whose distance you wish to calculate
    % (For each test point)
    v_points = repmat(v_point, [size(v_group,1),1,1]);
     
    v_group = repmat(v_group, [1,1,size(v_points,3)]); 
    v_diff = v_points-v_group;
    v_dist = v_diff.^2;
    v_dist = sum(v_dist,2);
    v_dist = permute(v_dist,[1,3,2]);

    v_index = fnSortedIndex(v_dist);
    %% Distances between each Test points occur along 2nd 
%     v_dist_rearranged = permute(v_dist, [3, 2, 1]);
%     v_dist_rearranged = repmat(v_dist_rearranged, [size(v_dist_rearranged,3),1,1])
%     %   find ordered index
%     v_sorted = sort(v_dist);
%     v_sorted_rearranged = repmat(v_sorted, [1,1,size(v_sorted,1)])
% 
%     v_equal = v_dist_rearranged == v_sorted_rearranged
%     error('message');
% end