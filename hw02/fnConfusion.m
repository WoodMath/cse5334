function [ mat_confusion, mat_correct, v_index, mat_centers, v_dist ] = fnConfusion( mat_train, v_class, i_k )
%fnConfusion Summary of this function goes here
%   Detailed explanation goes here
    [v_index, mat_centers, v_dist] = kmeans(mat_train, i_k);
    
    
    v_class_index = fnOrderedIndex(v_class);
    

    
    v_true = v_class_index;
    v_predicted = v_index;
    
    mat_confusion = zeros(i_k,i_k,'double');
    
    for i_inc = 1:i_k
        for j_inc = 1:i_k
            mat_confusion(i_inc,j_inc) = sum((v_true==i_inc).*(v_predicted==j_inc));            
        end
    end
    
%     load mat_confusion
    i_k = size(mat_confusion,1);
    v_max = max(mat_confusion);
    v_ind = [1:i_k]';
    mat_ind = repmat(v_ind, 1, i_k);
    mat_max = repmat(v_max, i_k, 1);
    v_index_max = sum((mat_confusion==mat_max).*mat_ind);
    v_count = sum((mat_confusion==mat_max));
    v_sort = horzcat(v_index_max',[1:length(v_index_max)]');
    v_sorted = sortrows(v_sort);
%     v_permute = sum((mat_confusion==mat_max).*mat_ind,2);
    mat_correct = mat_confusion(:,v_sorted(:,2)');
    
end

