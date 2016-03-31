function [ mat_confusion, mat_correct, i_correct, f_correct ] = fnConfusion( mat_train, v_class, i_k )
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

    %% Hungarian Alorithm Minimizes cost but we need to maximize cost so transform to
    mat_use = max(max(mat_confusion)) - mat_confusion;
    v_permute = hungarian(mat_use);
    
    %% Calculate percentage correct
    mat_correct = mat_confusion(v_permute,:); 
    
    
    i_correct = trace(mat_correct);
    f_correct = i_correct/size(mat_train,1);
    return
    
    
end

