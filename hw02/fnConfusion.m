function [ mat_confusion, mat_correct, f_correct ] = fnConfusion( mat_train, v_class, i_k )
%fnConfusion Summary of this function goes here
%   Detailed explanation goes here
    [v_index, mat_centers, v_dist] = kmeans(mat_train, i_k);
    
    
    v_class_index = fnOrderedIndex(v_class);
    
%     load v_class_index
    
    v_true = v_class_index;
    v_predicted = v_index;
    
    mat_confusion = zeros(i_k,i_k,'double');
    mat_edges = zeros(i_k*i_k,3,'double');
    

    for i_inc = 1:i_k
        for j_inc = 1:i_k
            mat_confusion(i_inc,j_inc) = sum((v_true==i_inc).*(v_predicted==j_inc));
            mat_edges((i_inc-1)*i_k + j_inc,:) = [i_inc, i_k+j_inc, mat_confusion(i_inc,j_inc)];
        end
    end

    %% Get permutations for correct ordering of confusion matrix
    [v_permute] = maxWeightMatching(mat_edges);
    
    %% Strip off first part of the array ang get mapping
    v_permute = v_permute(1:i_k)-i_k;
    
    %% Some will be valid mappings
    v_valid_mappings_ind = v_permute>=0;
    v_invalid_mappings_ind = not(v_valid_mappings_ind);
    
    v_valid_mappings = v_valid_mappings_ind.*(v_permute);
    v_valid_mappings_sorted = sortrows(horzcat(v_valid_mappings',[1:i_k]'));
    
    mat_ind = repmat((1:i_k)',1,i_k);
    mat_map = repmat(v_valid_mappings,i_k,1);
    
    %% Get indices of columns not mapped (any number that does not appear)
    v_invalid_mappings = not(sum(mat_ind==mat_map,2)').*[1:i_k];
    v_invalid_mappings = sort(v_invalid_mappings')';
    v_invalid_mappings = v_invalid_mappings(v_invalid_mappings>0);
    
    %% Put indices of columns not mapped backinto 0s spot
    v_valid_mappings_sorted(v_valid_mappings_sorted==0,1)=v_invalid_mappings';
    v_valid_mappings_unsorted = [v_valid_mappings_sorted(:,2), v_valid_mappings_sorted(:,1)];
    v_permutations = sortrows(v_valid_mappings_unsorted)';
    v_new_permute = v_permutations(2,:);
    
    mat_correct = mat_confusion(:,v_new_permute);
    
    
    %% Calculate percentage correct
    f_correct = trace(mat_correct)/size(mat_train,1);
    
end

