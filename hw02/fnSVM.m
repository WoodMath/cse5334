function [ v_nearest_class, v_count ] = fnSVM( mat_test, mat_train, v_class )
% fnSVM Summary of this function goes here
%   Detailed explanation goes here



    if(size(mat_test,2) ~= size(mat_train,2))
        error(['Dimensions of points in test data (',size(mat_test,2),') is not same as those in training data (',size(mat_train,2),')']);
    end
    i_dimensions_count = size(mat_test,2);
    if(size(mat_train,1) ~= size(v_class,1))
        error(['Number of points in training data (',size(mat_train,1),') does not equal the number of points for classes provided (',len(v_class),')']);
    end
    i_train_points_count = size(mat_train,1);    
    if(size(v_class,1)~=1 && size(v_class,2)~=1)
        error('The class list must be a 1-dimensional vector');
    end
    v_class = reshape(v_class, [length(v_class),1]);
    i_test_points_count = size(mat_test,1);
        
    % Get information about unique classes
    v_unique = sort(unique(v_class))';
    i_unique_classes_count = length(v_unique);
    i_classes_count = max(v_unique);

    
    mat_results = zeros(i_test_points_count, i_classes_count);
    
    for i_class = v_unique
        v_class_ind = (i_class == v_class);
        SVMStruct = svmtrain(mat_train, v_class_ind);
        svm_results = svmclassify(SVMStruct, mat_test);
        mat_results(:,i_class) = svm_results;
    end
    
    v_count = sum(mat_results, 2);
    mat_mult = repmat([1:i_classes_count], i_test_points_count, 1);
    v_nearest_class = sum(mat_mult.*mat_results, 2);
    
    
    
    
    
end

