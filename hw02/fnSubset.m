function [ mat_subsets ] = fnSubset( v_set, i_size)
%fnSubset generates all subsets of 'v_set' of size 'i_size'
%   by recursively calling fnSubset( v_set(2:length(v_set)), i_size - 1 )


    
    v_set = reshape(v_set,length(v_set),1);
    v_set = sort(v_set);

    
    i_size_set = length(v_set);
    i_size_subset = i_size;
    

    mat_subsets = [];
    
    %% on invalid subset if set size smaller than subset size sought
    if i_size_set < i_size_subset
        return
    end
    
    %% Hit bottom of recursion if th
    if i_size_subset == 1
        mat_subsets = v_set;
        return
    end

    
    %% Iterate through elements in list
    for i_inc = 1:i_size_set

        %% Get current element and element after
        v_set_prefix = v_set(i_inc);
        
        if(i_inc < i_size_set)
            v_new_set = v_set(i_inc+1:i_size_set);
        else
            v_new_set = [];
        end

        mat_new_set = fnSubset( v_new_set, i_size - 1);
        if logical(size(mat_new_set,1))
            v_set_prefix = repmat(v_set_prefix, size(mat_new_set,1), 1);
            mat_new_set = horzcat(v_set_prefix, mat_new_set);
        end
        
        %% Only append new subset if desired size
        if size(mat_new_set,2) == i_size_subset
            mat_subsets = vertcat(mat_subsets, mat_new_set);
        end

    end

    
end

