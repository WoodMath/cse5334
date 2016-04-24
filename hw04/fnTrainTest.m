function [i_correct, f_correct] = fnTrainTest(v_model, mat_train, v_class_train, mat_test, v_class_test)
%fnCrossValidate Summary of this function goes here
%   Detailed explanation goes here

    b_svm = v_model(1);
    b_knn = v_model(2);
    i_k = v_model(3);
    b_cm = v_model(4);
    b_lr = v_model(5);

    i_train_points_count = size(mat_train,1);    
    i_test_points_count = size(mat_test,1);    

    if(size(v_class,1)~=1 && size(v_class,2)~=1)
        error('The class list must be a 1-dimensional vector');
    end
    

        
    if logical(b_svm)
        [v_class_svm, cell_class] = fnSVM( mat_test, mat_train, v_class_train );
        for j_inc = 1:length(v_test_class)
            v_test = cell_class{j_inc,1};
            if(length(v_test) == 1)
                v_class_svm(j_inc) = v_test;
            else
                i_actual_class = v_test_class(j_inc);
                if size(find(v_test==i_actual_class), 2) > 0
                    % Was correctly classified
                    v_class_svm(j_inc) = i_actual_class;
                else
                    % Was incorrectly classified
                    v_class_svm(j_inc) = -1;
                end
            end
        end
    end

    if logical(b_knn)
       v_class_knn = fnKNN( mat_test, mat_train, v_class_train, i_k );
    end

    if logical(b_cm)
        v_class_cm = fnCentroidMethod( mat_test, mat_train, v_class_train );
    end

    if logical(b_lr)
        v_class_lr = fnLinearRegression( mat_test, mat_train, v_class_train );
    end
        

    i_svm_correct = sum(v_class_svm == v_class_test);
    i_knn_correct = sum(v_class_knn == v_class_test);
    i_cm_correct = sum(v_class_cm == v_class_test);
    i_lr_correct = sum(v_class_lr == v_class_test);

    
    i_correct = [i_svm_correct, i_knn_correct, i_cm_correct, i_lr_correct];
    f_correct = i_correct / i_test_points_count;
    
end