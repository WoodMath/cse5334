function [ mat_subsets_numerical, mat_subsets_boolean ] = fnSubsetIndices( v_set, i_size, b_combin )
%fnSubsetsIndices Summary of this function goes here
%   Detailed explanation goes here

    mat_subsets = fnSubset(v_set, i_size, b_combin);
    
    mat_subsets_numerical = mat_subsets;
    mat_subsets_boolean = zeros(size(mat_subsets,1), length(v_set), 'uint8');
    
    parfor inc = 1:size(mat_subsets,1)
        v_use = mat_subsets(inc,:)';
        mat_use = repmat(v_use, 1, length(v_set));
        mat_index = repmat(v_set, size(v_use,1), 1);
        mat_subsets_boolean(inc,:) = sum(mat_use==mat_index,1);
        
    end
end

