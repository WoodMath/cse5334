function [mat_correct, i_correct, f_correct] = fnTrainTest(v_model, mat_train, v_class_train, mat_test, v_class_test)
%fnCrossValidate Summary of this function goes here
%   Parameters are same as before (with exception of 'v_class_test'
%       mat_train               - Training Data
%       v_class_train           - Ground truth of training data
%       mat_test                - Data to be classified
%       v_class_test            - Ground truth of testing data (used to
%                                 measure accuracy

    b_svm = v_model(1);
    b_knn = v_model(2);
    i_k = v_model(3);
    b_cm = v_model(4);
    b_lr = v_model(5);

    i_train_points_count = size(mat_train,1);    
    i_test_points_count = size(mat_test,1);    

    if(size(v_class_train,1)~=1 && size(v_class_train,2)~=1)
        error('The class list must be a 1-dimensional vector');
    end
    if(size(v_class_test,1)~=1 && size(v_class_test,2)~=1)
        error('The class list must be a 1-dimensional vector');
    end
    
    mat_correct = zeros(size(v_class_test,1), 4, 'uint32');
    %% Perform SVM test
    if logical(b_svm)
        [v_class_svm, cell_class, mat_results] = fnSVM( mat_test, mat_train, v_class_train );

        %% Extra code is for circumstances when binary classification is not unique (i.e. point is assigned to more than 1 class)
        
        %% For each row assign boolean indicators for classes (of column number) that row belongs to
        mat_class_test = (repmat(v_class_test, [1,size(mat_results,2)]) == repmat([1:size(mat_results,2)], [size(mat_results,1),1]));
        %% Only used elements in the row for which inclass are correctly classified (ie. 1==1) 
        %% and out of class are correctly classified (ie. 0==0)
        mat_equality = mat_results==double(mat_class_test);
        %% Treat each data point as only a single correct (i.e. divide the number of correct classifications by total number of classifications made)
        v_equality = sum(mat_equality,2)/size(mat_equality,2);
        mat_correct(:,1) = v_equality;
        
%         for j_inc = 1:length(v_test_class)
%             v_test = cell_class{j_inc,1};
%             if(length(v_test) == 1)
%                 v_class_svm(j_inc) = v_test;
%             else
%                 i_actual_class = v_test_class(j_inc);
%                 if size(find(v_test==i_actual_class), 2) > 0
%                     % Was correctly classified
%                     v_class_svm(j_inc) = i_actual_class;
%                 else
%                     % Was incorrectly classified
%                     v_class_svm(j_inc) = -1;
%                 end
%             end
%         end
    end

    if logical(b_knn)
       v_class_knn = fnKNN( mat_test, mat_train, v_class_train, i_k );
       mat_correct(:,2) = (v_class_knn == v_class_test);
    end

    if logical(b_cm)
        v_class_cm = fnCentroidMethod( mat_test, mat_train, v_class_train );
        mat_correct(:,3) = (v_class_cm == v_class_test);
    end

    if logical(b_lr)
        v_class_lr = fnLinearRegression( mat_test, mat_train, v_class_train );
        mat_correct(:,4) = (v_class_lr == v_class_test);
    end
        

    i_correct = sum(mat_correct);    
    f_correct = i_correct / i_test_points_count;
    
end