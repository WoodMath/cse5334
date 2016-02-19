function [ v_class, mat_classes_of_closest ] = fnKNN( mat_test, mat_train, mat_class, i_k)
%fnKNN Summary of this function goes here
%   Detailed explanation goes here

    i_k=3;
    mat_test = [1,11;11,3;6,8;6,7;6,6];
% %     mat_point = [6,6];
    mat_train = [2,10;2,8;3,7;4,10;4,8;5,9;7,5;8,6;9,7;10,6;10,4;8,4];
    mat_class = [1,1,1,1,1,1,2,2,2,2,2,2]';
%     mat_class = mat_class*2;

    mat_temp = fnDist(mat_test, mat_train);
    mat_dist = mat_temp.^2;

    if(mod(i_k,2)==0)
        error(['Error : value of k = ', int2str(i_k), ' is not an odd value.'])
    end


%     %% Rearrange Test points along 3rd axis
%     mat_test = permute(mat_test, [3,2,1]);
%     % Replicate for size of points to whose distance you wish to calculate
%     % (For each test point)
%     mat_points = repmat(mat_test, [size(mat_train,1),1,1]);
%     
%     %% Get toal distance
%     mat_train = repmat(mat_train, [1,1,size(mat_points,3)]); 
%     mat_diff = mat_points-mat_train;
%     mat_dist = mat_diff.^2;
%     
%     %% Sum along all dimensions of each point
%     mat_dist = sum(mat_dist,2);
%     mat_dist = permute(mat_dist,[1,3,2]);

    i_num_test_points = size(mat_dist,2);
    
    mat_class=reshape(mat_class, [length(mat_class),1]);
    
    mat_index = fnSortedIndex(mat_dist);

    mat_classes = repmat(mat_class, [1, i_num_test_points]);
    mat_indices_of_closest = mat_index(1:i_k,:);
    
    %% Dimension the array
    mat_classes_of_closest = zeros(i_k, i_num_test_points);
    v_class = zeros(i_num_test_points,1);
    
    for i_col = 1:i_num_test_points
        v_indices = mat_indices_of_closest(:,i_col);
        v_classes = mat_classes(v_indices,i_col);
        mat_classes_of_closest(:,i_col) = v_classes;
        v_unique = unique(v_classes);
        
        %% creates an array where the classes are along duplicate rows
            %% Something like [1,1;1,1;2,2;2,2;1,1;2,2]'
        mat_classes_along_row = repmat(v_classes', [size(v_unique,1),1]);
        %% creates an array where the unique classes are along duplicate cols
            %% Something like [1,2;1,2;1,2;1,2;1,2;1,2;1,2;1,2];
        mat_uniques_along_col = repmat(v_unique, [1, size(v_classes,1)]);

        %% Get counts by summing indicator of where they are equal
        mat_equal = (mat_classes_along_row==mat_uniques_along_col);
        v_sum = sum(mat_equal,2);
        
        %% Create matrix containing counts of associated classifiers
        mat_sort = [v_sum';v_unique']';
        
        %% sort rows according to count
        mat_sort = sortrows(mat_sort);
        
        %% get row with highest count (occurs at end due to sort), and obtain class from secon col, attach to v_class for each test_point
        v_class(i_col) = mat_sort(size(mat_sort,1),2);
    end

end

