function [ output_args ] = fnCrossValidate( mat_test, mat_train, v_class, v_model, i_kfold )
%fnCrossValidate Summary of this function goes here
%   Detailed explanation goes here

    b_svm = v_model(1);
    b_knn = v_model(2);
    b_cm = v_model(3);
    b_lr = v_model(4);
    
end

