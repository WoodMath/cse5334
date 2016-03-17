function [ mat_subsets ] = fnSubset( v_set, i_size, b_combin)
%fnSubset generates all subsets of 'v_set' of size 'i_size'
%   by recursively calling fnSubset( v_set(2:length(v_set)), i_size - 1 )



    
    v_set = reshape(v_set,length(v_set),1);
    v_set = sort(v_set);

    
    i_size_set = length(v_set);
    i_size_subset = i_size;
    
    if not(logical(strcmpi(b_combin,'True')))
        if mod(i_size_set, i_size_subset) == 0
            i_rows = round(i_size_set/i_size_subset);
            mat_subsets = zeros(i_rows, i_size_subset);
            v_row = double([1:i_rows]');
            i_size_subset = double(i_size_subset);
            v_start = (v_row-1)*i_size_subset+1;
            v_stop = (v_row)*i_size_subset;
            parfor i_row = v_row'
               v_subset = v_set(v_start(i_row):v_stop(i_row));
               mat_subsets(i_row,:) = reshape(v_subset, 1, i_size_subset);
            end
            return
            
        else
            error(' The dataset cannot be divided evenly by the size supplied ');
        end
        
        
    end

    
    mat_subsets = [];
    
    %% on invalid subset if set size smaller than subset size sought
    if i_size_set < i_size_subset
        return
    end
    
    %% Hit bottom of recursion if tree
    if i_size_subset == 1
        mat_subsets = v_set;
        return
    end

    
    %% Iterate through elements in list
    parfor i_inc = 1:i_size_set

        %% Get current element and element after
        v_set_prefix = v_set(i_inc);
        
        if(i_inc < i_size_set)
            v_new_set = v_set(i_inc+1:i_size_set);
        else
            v_new_set = [];
        end

        mat_new_set = fnSubset( v_new_set, i_size - 1, b_combin);
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

