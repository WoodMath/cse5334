function [ v_class_nearest ] = fnLinearRegression( mat_test, mat_train, v_class )
% fnLinearRegression Summary of this function goes here
%   Detailed explanation goes here

    if(size(mat_test,2) ~= size(mat_train,2))
        error(['Dimensions of points in test data (',size(mat_test,2),') is not same as those in training data (',size(mat_training,2),')']);
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

    
    
    %% Build Y and A matrices to Solve for X matrix where A'*(Y-AX)=0
    %% Make in Y indicator matrix where rows = number of training poings and cols = number of distince classes
    
    % Get information about unique classes
    v_unique = sort(unique(v_class))';
    i_classes_count = length(v_unique);
    mat_class = repmat(v_class,[1,i_classes_count]);
    mat_unique = repmat(v_unique, [i_train_points_count,1]);
    
    % unique classes along column axis
    mat_index = (mat_class==mat_unique);
    mat_train_Y = mat_index;
    
    mat_train_A = mat_train;
    mat_pseudo = mat_train_A'*mat_train_A;
    mat_pseudo_inv = eye(length(mat_pseudo))/mat_pseudo;
    
    mat_pinv = pinv(mat_train_A);

    
    mat_X = mat_pseudo_inv * mat_train_A' * mat_train_Y;

    mat_X = mat_pinv * mat_train_Y;
    
    mat_test_A = mat_test;
    
    mat_test_Y = mat_test_A * mat_X;
    
    
    
    mat_nearest_class = mat_test_Y;
    
    %% Find dimensional component closest to 1
    mat_less_one = mat_nearest_class - 1;
    mat_less_one_squared = mat_less_one.^2;
    mat_min = min(mat_less_one_squared,[],2);
    
    mat_pos = (repmat(mat_min, [1, i_classes_count])==mat_less_one_squared);
    v_nearest = sum(repmat(v_unique, [i_test_points_count,1]).*mat_pos,2);
end

