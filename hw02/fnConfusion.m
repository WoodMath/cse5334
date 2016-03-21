function [ mat_confusion, mat_correct, v_index, mat_centers, v_dist ] = fnConfusion( mat_train, v_class, i_k )
%fnConfusion Summary of this function goes here
%   Detailed explanation goes here
    [v_index, mat_centers, v_dist] = kmeans(mat_train, i_k);
    
    
    v_class_index = fnOrderedIndex(v_class);
    
%     load v_class_index
    
    v_true = v_class_index;
    v_predicted = v_index;
    
    mat_confusion = zeros(i_k,i_k,'double');
    mat_edges = zeros(i_k*i_k,3,'double');
    
%     parfor inc = 1:(i_k*i_k)
    for i_inc = 1:i_k
        for j_inc = 1:i_k
%             j_inc = uint16(mod(inc-1,i_k)+1);
%             i_inc = uint16((inc-j_inc)/i_k+1);
            mat_confusion(i_inc,j_inc) = sum((v_true==i_inc).*(v_predicted==j_inc));
            mat_edges((i_inc-1)*i_k + j_inc,:) = [i_inc, i_k+j_inc, mat_confusion(i_inc,j_inc)];
        end
    end
    
    
    v_permute = maxWeightMatching(mat_edges);
    v_permute = v_permute([1:i_k])-i_k;
%     load mat_confusion
%     i_k = size(mat_confusion,1);
%     v_max = max(mat_confusion);
%     v_ind = [1:i_k]';
%     mat_ind = repmat(v_ind, 1, i_k);
%     mat_max = repmat(v_max, i_k, 1);
%     v_index_max = sum((mat_confusion==mat_max).*mat_ind);
%     v_count = sum((mat_confusion==mat_max));
%     v_sort = horzcat(v_index_max',[1:length(v_index_max)]');
%     v_sorted = sortrows(v_sort);
%     v_permute = sum((mat_confusion==mat_max).*mat_ind,2);
    mat_correct = mat_confusion(:,v_permute);
    
end

