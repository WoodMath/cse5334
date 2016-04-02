function [ cell_subsets_numerical, cell_subsets_boolean ] = fnSubsetIndices(v_class, i_fold, i_count_classes, i_count_samples )
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
    
    
    mat_index = reshape(v_index, [i_count_samples, i_count_classes]);
    %% Example Classes after reshape
    %% [1,1,1,1,1,1,1,1,1,1;
    %%  2,2,2,2,2,2,2,2,2,2;
    %%  3,3,3,3,3,3,3,3,3,3;
    %%  4,4,4,4,4,4,4,4,4,4;
    %%  5,5,5,5,5,5,5,5,5,5;
    %%  6,6,6,6,6,6,6,6,6,6]

    
    i_buckets = i_fold ;                                                   % 5    
    cell_subsets_numerical = cell(i_fold,1);
    
    for i_inc = 1:i_count_samples
        i_bucket = mod(i_inc-1,i_fold)+1;
        % Take next sample from each class
        v_indexes_to_bucket = mat_index(i_inc,:);
        % Add it to appropriate bucket
        cell_subsets_numerical{i_bucket,1} = sort(horzcat(cell_subsets_numerical{i_bucket,1},v_indexes_to_bucket)')';
    end
    
    i_check_total=0;
    %% Convert to Boolean Indicators
    cell_subsets_boolean = cell(i_fold,1);
    
    for i_inc = 1:size(cell_subsets_boolean,1)
        %% v_index = [1, 2, 3, 4, 5, 6];
        v_use = cell_subsets_numerical{i_inc}';
        %% v_use = [1; 3; 5];
        mat_use = repmat(v_use, 1, length(v_index));
        %% mat_use = [1, 1, 1, 1, 1, 1; 3, 3, 3, 3, 3, 3; 5, 5, 5, 5, 5, 5];
        mat_index = repmat(v_index, size(v_use,1), 1);
        %% mat_index = [1, 2, 3, 4, 5, 6; 1, 2, 3, 4, 5, 6; 1, 2, 3, 4, 5, 6];
        v_boolean_indicator = logical(sum(mat_use==mat_index,1));
        i_check_total = i_check_total + sum(v_boolean_indicator);
        cell_subsets_boolean{i_inc,1} = v_boolean_indicator;
        %% (mat_use==mat_index) = [1, 0, 0, 0, 0, 0; 0, 0, 1, 0, 0, 0; 0, 0, 0, 0, 1, 0];

    end
    
    if(i_check_total ~= (i_count_classes * i_count_samples))
        error(' Number of data-points bucketed do not equal total number of data-points');
    end

end