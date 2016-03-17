function [ output_args ] = fnCrossValidate( mat_train, v_class, v_model, i_kfold, b_combin )
%fnCrossValidate Summary of this function goes here
%   Detailed explanation goes here

    b_svm = v_model(1);
    b_knn = v_model(2);
    i_knn = v_model(3);
    b_cm = v_model(4);
    b_lr = v_model(5);

    i_train_points_count = size(mat_train,1);    
    if(size(v_class,1)~=1 && size(v_class,2)~=1)
        error('The class list must be a 1-dimensional vector');
    end
    
    v_train_points_count = double([1:i_train_points_count])*3+5;
    i_subset_size = double(round(i_train_points_count/i_kfold));
    

    [mat_subsets, mat_indices] = fnSubsetIndices(v_train_points_count, i_subset_size, b_combin); 
    
    if logical(b_svm)
         
    end
    
end

