function [ mat_subsets_numerical, mat_subsets_boolean ] = fnSubsetIndices(v_class, i_fold, i_count_classes, i_count_samples )
%fnSubsetsIndices Summary of this function goes here
%   Detailed explanation goes here


    
%     v_class = [1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6];
%     i_fold = 5;
%     i_count_classes = 6;
%     i_count_samples = 10;

    
    %% Should use indices, not actual class labels.
    v_index = 1:length(v_class);
    
    
    %% Example ' v_class = [1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6]
    %% Arrange each class in its own row
    
    
    mat_index = reshape(v_index, [i_count_samples, i_count_classes])';
    %% Example Classes after reshape
    %% [1,1,1,1,1,1,1,1,1,1;
    %%  2,2,2,2,2,2,2,2,2,2;
    %%  3,3,3,3,3,3,3,3,3,3;
    %%  4,4,4,4,4,4,4,4,4,4;
    %%  5,5,5,5,5,5,5,5,5,5;
    %%  6,6,6,6,6,6,6,6,6,6]

    
    i_subset_rows = i_fold ;                                                % 5
    i_subset_cols = i_count_samples * i_count_classes / i_fold ;            % 12
    
    i_temp_rows = i_count_classes ;                                         % 6
    i_temp_cols = i_count_samples / i_fold ;                                % 2

    
    mat_subsets = zeros(i_subset_rows,i_subset_cols);
    
    for i_inc = 1:i_fold
       v_temp_rows = [1:i_temp_rows]; 
       v_temp_cols = [((i_inc - 1)*i_temp_cols+1):((i_inc)*i_temp_cols)];

       mat_temp = mat_index(v_temp_rows,v_temp_cols);
       v_temp = reshape(mat_temp',[1,i_subset_cols]);
       

       
       mat_subsets(i_inc,:) = v_temp;
        
        
        
    end
    
    
    
    mat_subsets_numerical = mat_subsets;
    mat_subsets_boolean = zeros(size(mat_subsets,1), length(v_index), 'uint8');
    
    for inc = 1:size(mat_subsets,1)
        v_use = mat_subsets(inc,:)';
        mat_use = repmat(v_use, 1, length(v_index));
        mat_index = repmat(v_index, size(v_use,1), 1);
        mat_subsets_boolean(inc,:) = sum(mat_use==mat_index,1);
        
    end
    mat_subsets_boolean = logical(mat_subsets_boolean);
end

