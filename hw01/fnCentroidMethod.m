function [ v_nearest_class ] = fnCentroidMethod( mat_test, mat_train, v_class )
% fnCentroidMethod Summary of this function goes here
%   Detailed explanation goes here

% %     mat_test = [1,11;11,3;6,8;6,7;6,6];
% % %     mat_point = [6,6];
% %     mat_train = [2,10;2,8;3,7;4,10;4,8;5,9;7,5;8,6;9,7;10,6;10,4;8,4];
% %     v_class = [1,1,1,1,1,1,2,2,2,2,2,2]';
% %     v_class = v_class*2;


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
    
    
    % Get information about unique classes
    v_unique = sort(unique(v_class))';
    i_classes_count = length(v_unique);
    mat_class = repmat(v_class,[1,i_classes_count]);
    mat_unique = repmat(v_unique, [i_train_points_count,1]);
    
    % unique classes along column axis
    mat_index = (mat_class==mat_unique);
    
    % Initialize arrays containing means
    mat_centers = zeros(i_classes_count,i_dimensions_count);
    
    parfor i_class = 1:i_classes_count
        mat_train_points_class = mat_train(mat_index(:,i_class),:);
    
        v_mean = fnPCA(mat_train_points_class);
        mat_centers(i_class,:) = v_mean;
        
    end
    
    
    v_nearest_class = zeros(i_test_points_count,1);
    for i_test = 1:i_test_points_count

        v_dist=fnDist(mat_test(i_test,:),mat_centers);
        
        % sort by distances
        mat_sort = [v_dist,v_unique'];
        mat_sort = sortrows(mat_sort);
        
        % Use class associated with top row
        v_nearest_class(i_test) = mat_sort(1,2);
        
    end
    
    
    
    
end

