function [ cell_subsets_numerical, cell_subsets_boolean ] = fnSubsetIndices(v_class, i_fold, i_count_classes, i_count_samples )
%fnSubsetsIndices Summary of this function goes here
%   Detailed explanation goes here


    
%     v_class = [1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6];
%     i_fold = 5;
%     i_count_classes = 6;
%     i_count_samples = 10;

    if(i_fold > i_count_samples)
        error(' You cannot have more folds than the number of datapoints in a class ');
    end
    
    %% Should use indices, not actual class labels.
    v_index = 1:length(v_class);

    i_buckets = i_fold ;                                                   % 5    
    cell_subsets_numerical = cell(i_fold,1);
    
    
    
    % Code below (Until return) is modification in case 'i_count_samples'
    % is not uniform across classes

     %% Vector to keep track of which fold each class is on
    v_current_fold_each_class = zeros(max(v_class),1);
   
    
    for i_inc = v_index
        % Class and Index of current datapoint
        i_current_datapoint_class = v_class(i_inc);
        i_current_datapoint_index = v_index(i_inc);
        
        % For the data-point's class: Increase current fold number by 1
        i_current_datapoint_fold = v_current_fold_each_class(i_current_datapoint_class) + 1;


        % Makes sure that because mod(j,i_fold) = [0,1,2,...,i_fold-1]
        % values of i_current_datapoint_fold go [1,2,3,...,i_fold]
        i_current_datapoint_fold = mod(i_current_datapoint_fold-1, i_fold)+1;
        
        if(or(i_current_datapoint_fold < 1, i_current_datapoint_fold > i_fold))
            error(' Problem with the Modulus in the fold calculation .');
        end
        
        % Assign it back to current fold
        v_current_fold_each_class(i_current_datapoint_class) = i_current_datapoint_fold;
        
        
        % for i_fold = 3: mod(1-1,3)+1=1, mod(2-1,3)+1=2, mod(3-1,3)+1=3, mod(4-1,3)+1=1   
        
        % Append indixe to cell array cof current fold
        cell_subsets_numerical{i_current_datapoint_fold,1} = horzcat(cell_subsets_numerical{i_current_datapoint_fold,1}, i_current_datapoint_index);
        
        

        
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
    
    
    
    
    
    
    
    return
    
    
    
    
    
    
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