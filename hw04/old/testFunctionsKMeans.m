    mat_test = [1,11;11,3;6,8;6,7;6,6;12,14];
    
    v_r = 0:0.5:20;
    i_l = length(v_r);
    mat_rows = repmat(v_r, [i_l,1]);
    mat_cols = mat_rows';
    
    mat_test = cat(3, mat_rows, mat_cols);
    mat_test = reshape(mat_test, i_l*i_l, 2, 1);

    
    i_k = 3;
    mat_train = [2,10; 2,8; 3,7; 4,10; 4,8; 5,9; 7,5; 8,6; 9,7; 10,6; 10,4; 8,4; 12,16; 13,15; 13,14; 13,16; 12,17; 12,13; 12,15; 13,18];
    v_class = [1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,3,3]';
    v_class = v_class*2;

%     for i_inc = 1:length(v_class)
%         i_class = v_class(i_inc);
%         v_point = mat_train(i_inc,:);
%         if(i_class == 2)
%             v_point = v_point.*[3,1];
%         elseif(i_class == 3)
%             v_point = v_point.*[1,4];
%         end 
%     end
    
    
    %% Cross Validation and SVN testing
%     v_model = [1, 1, 3, 1, 1];
%     v_results_subset = fnTestSubset(mat_train, v_class, v_model, [1,2,3]);
%     mat_results = fnCrossValidate( mat_train, v_class, v_model, 5, 'False' );

    
    %% K-means clustering
    v_unique = v_class(unique(v_class));
    i_unique_count = max(v_unique);
    
    
    i_reps = 10;
    i_Ks = i_unique_count+2;
    v_x = [2:(i_Ks-1)]';
    mat_sum = zeros(i_Ks, i_reps);
    mat_diff = zeros(i_Ks-2, i_reps);
    
    for i_rep = 1:i_reps
        v_square_sum = zeros(1,i_Ks)';
       
        for i_inc = 1:i_Ks
            [v_indexes, mat_centers, v_dist] = kmeans(mat_train, i_inc);
            v_square_sum(i_inc) = sum(v_dist);
        end
        v_left = v_square_sum(1:(length(v_square_sum)-2));
        v_right = v_square_sum(3:length(v_square_sum));
        
        v_diff = -(v_right-v_left)/2;
        
%         plot(v_x,v_diff,'Color',k(i_rep,:));
        mat_sum(:,i_rep) = v_square_sum;
        mat_diff(:,i_rep) = v_diff;

    end
    
    figure(1);
%     colormap('default');
    hold all;
    plot([1:i_Ks],mat_sum);
    
    figure(2);
%     colormap('default');

    hold all;
    plot(v_x ,mat_diff);
    
    
        
    b_show_knn = 1;
    b_show_cm = 0;
    b_show_lr = 0;
    b_plot_test_lines = 0;
    
    i_dimensions_count = size(mat_train,2);
    i_test_points_count = size(mat_test,1);    
    i_train_points_count = size(mat_train,1);

    % Get information about unique classes
    v_unique = sort(unique(v_class))';
    i_classes_count = length(v_unique);
    mat_class = repmat(v_class,[1,i_classes_count]);
    mat_unique = repmat(v_unique, [i_train_points_count,1]);
    
    % unique classes along column axis
    mat_class_indicator = (mat_class==mat_unique);
    v_class = sum(mat_class_indicator.*mat_unique,2);

    % Gen index position of class
    % should be same as above if classes numbered 1,2,3,...
    v_index = 1:i_classes_count;
    mat_indexes = repmat(v_index, [i_train_points_count,1]);
    v_indexes = sum(mat_indexes.*mat_class_indicator,2);
    
    mat_center = zeros(i_classes_count, i_dimensions_count);
    mat_centers = zeros(i_train_points_count, i_dimensions_count);
    
    mat_lookup = [v_unique', v_index'];
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %% Routines to draw graphs
    
    v_types = ['o','+','*','.','x','s','d','^','v','<','>','p','h'];
    v_styles = ['-','--',':','-.'];
    v_colors = [1,0,0; 0,0,1; 0,1,0; 1,1,0];
    mat_colors = v_colors(v_indexes,:);
    mat_types = v_types(v_indexes);

    hFigure = figure(100);
    
    
    %% Draws training data with class center
    hAxes = axes('Parent', hFigure);
    xlim(hAxes,[0 20]);
    ylim(hAxes,[0 20]);
    hold(hAxes,'all');
    hold off;
    
    
    %% Draw training points
    f_train_width = 3;
    if(i_dimensions_count == 3)
        scatter3(mat_train(:,1), mat_train(:,2), mat_train(:,3), f_train_width, mat_colors);
    else
        scatter(mat_train(:,1), mat_train(:,2), f_train_width, mat_colors);        
    end
    
    %% Draw training lines
    for i_class = 1:i_classes_count
        v_indices_to_use = mat_class_indicator(:,i_class);
        mat_data = mat_train(v_indices_to_use, :);
        
        v_mean = fnPCA(mat_data);
        
        for i_point = 1:size(mat_data,1);
            v_use = mat_data(i_point,:);
            v_x = [v_use(1) v_mean(1)];
            v_y = [v_use(2) v_mean(2)];

            if (i_dimensions_count == 3)
                v_z = [v_use(3) v_mean(3)];
                line(v_x, v_y, v_z, 'Color', v_colors(i_class,:), 'LineWidth', f_train_width);
            else
                line(v_x, v_y, 'Color', v_colors(i_class,:), 'LineWidth', f_train_width);
            end
        end
        
        
        mat_center(i_class,:) = v_mean;  
    end

    
    mat_centers = mat_center(v_indexes,:);
    
    %% Begin drawing Test Points
    v_class_knn = fnKNN(mat_test, mat_train, v_class, i_k);
    v_class_cm = fnCentroidMethod(mat_test, mat_train, v_class);
    v_class_lr = fnLinearRegression(mat_test, mat_train, v_class);

    
%     mat_unique_test = repmat(v_unique, [i_test_points_count, 1]);
%     mat_class_knn = repmat(v_class_knn,[1,i_classes_count]);
%     mat_class_cm = repmat(v_class_cm,[1,i_classes_count]);
%     mat_class_lr = repmat(v_class_lr,[1,i_classes_count]);
% 
%     mat_ind_class_knn = sum((mat_unique_test==mat_class_knn).*mat_unique_test,2);
%     mat_ind_class_cm = sum((mat_unique_test==mat_class_cm).*mat_unique_test,2);
%     mat_ind_class_lr = sum((mat_unique_test==mat_class_lr).*mat_unique_test,2);
%     
    v_class_knn = class2index(v_unique,v_class_knn);
    v_class_cm = class2index(v_unique,v_class_cm);
    v_class_lr = class2index(v_unique,v_class_lr);
    
    mat_colors_knn = v_colors(v_class_knn,:);
    mat_colors_cm = v_colors(v_class_cm,:);
    mat_colors_lr = v_colors(v_class_lr,:);
    
    f_train_width = 3;
    hold on;
    if(b_show_knn)
        if(i_dimensions_count == 3)
            scatter3(mat_test(:,1), mat_test(:,2), mat_test(:,3), f_train_width, mat_colors_knn);            
        else
            scatter(mat_test(:,1), mat_test(:,2), f_train_width, mat_colors_knn);        
        end
    end
    if(b_show_cm)
        if(i_dimensions_count == 3)
            scatter3(mat_test(:,1), mat_test(:,2), mat_test(:,3), f_train_width, mat_colors_cm);
        else
            scatter(mat_test(:,1), mat_test(:,2), f_train_width, mat_colors_cm);        
        end
    end
    if(b_show_lr)
        if(i_dimensions_count == 3)
            scatter3(mat_test(:,1), mat_test(:,2), mat_test(:,3), f_train_width, mat_colors_lr);
        else
            scatter(mat_test(:,1), mat_test(:,2), f_train_width, mat_colors_lr);
        end
    end
    
    
    
    
% %     f_test_width=0.5;
% %     %% Draw test lines
% %     if(b_plot_test_lines)
% % 
% %         for i_test_point = 1:i_test_points_count
% %             v_use = mat_test(i_test_point,:); 
% %             v_mean_knn = mat_center(v_class_knn(i_test_point),:);
% %             v_mean_cm = mat_center(v_class_cm(i_test_point),:);
% %             v_mean_lr = mat_center(v_class_lr(i_test_point),:);
% %         
% % %             display([' v_use = ', num2str(v_use)]);
% % %             display([' KNN = ', num2str(v_unique(v_class_knn(i_test_point))), ...
% % %                      ' CM = ', num2str(v_unique(v_class_cm(i_test_point))), ...
% % %                      ' LR = ', num2str(v_unique(v_class_lr(i_test_point)))]);
% %         
% %             v_x_knn = [v_use(1) v_mean_knn(1)];
% %             v_x_cm = [v_use(1) v_mean_cm(1)];
% %             v_x_lr = [v_use(1) v_mean_lr(1)];
% % 
% %             v_y_knn = [v_use(2) v_mean_knn(2)];
% %             v_y_cm = [v_use(2) v_mean_cm(2)];
% %             v_y_lr = [v_use(2) v_mean_lr(2)];
% % 
% %             if (i_dimensions_count == 3)
% %                 v_z_knn = [v_use(3) v_mean_knn(3)];
% %                 v_z_cm = [v_use(3) v_mean_cm(3)];
% %                 v_z_lr = [v_use(3) v_mean_lr(3)];
% % 
% %                 if(b_show_knn)
% %                     line(v_x_knn, v_y_knn, v_z_knn, 'Color', v_colors(v_class_knn(i_test_point),:), 'LineStyle', v_styles(1), 'LineWidth', f_test_width);
% %                 end
% %                 if(b_show_cm)
% %                     line(v_x_cm, v_y_cm, v_z_cm, 'Color', v_colors(v_class_cm(i_test_point),:), 'LineStyle', v_styles(2), 'LineWidth', f_test_width);
% %                 end
% %                 if(b_show_lr)
% %                      line(v_x_lr, v_y_lr, v_z_lr, 'Color', v_colors(v_class_lr(i_test_point),:), 'LineStyle', v_styles(3), 'LineWidth', f_test_width);
% %                 end
% %             else
% %                 if(b_show_knn)
% %                     line(v_x_knn, v_y_knn, 'Color', v_colors(v_class_knn(i_test_point),:), 'LineStyle', v_styles(1), 'LineWidth', f_test_width);
% %                 end
% %                 if(b_show_cm)
% %                     line(v_x_cm, v_y_cm, 'Color', v_colors(v_class_cm(i_test_point),:), 'LineStyle', v_styles(2), 'LineWidth', f_test_width);
% %                 end
% %                 if(b_show_lr)
% %                     line(v_x_lr, v_y_lr, 'Color', v_colors(v_class_lr(i_test_point),:), 'LineStyle', v_styles(3), 'LineWidth', f_test_width);
% %                 end
% %             end        
% % 
% %         end
% %     end
% %     
% %     
% %     
% %     %% Draw user clicked test points
% %     
% %     b_continue = 1;
% %     key = '';
% %     
% %     hold on;
% %     f_test_width=2.5;
% %     while(b_continue)
% %         [x,y,button] = ginput(1);
% %         display([' x = ', num2str(x), ' ; y = ', num2str(y)]);
% %         key = get(hFigure, 'CurrentCharacter');
% % 
% %         if((button==1))
% %             b_continue = 1;
% %             v_use = [x y];
% %             i_class_knn = fnKNN(v_use, mat_train, v_class, i_k);
% %             i_class_cm = fnCentroidMethod(v_use, mat_train, v_class);
% %             i_class_lr = fnLinearRegression(v_use, mat_train, v_class);
% % 
% %             i_class_knn = class2index(v_unique, i_class_knn);
% %             i_class_cm = class2index(v_unique, i_class_cm);
% %             i_class_lr = class2index(v_unique, i_class_lr);
% %     
% % 
% %             v_mean_knn = mat_center(i_class_knn,:);
% %             v_mean_cm = mat_center(i_class_cm,:);
% %             v_mean_lr = mat_center(i_class_lr,:);
% % 
% %             display([' v_use = ', num2str(v_use)]);
% %             display([' KNN = ', num2str(v_unique(i_class_knn)), ...
% %                      ' CM = ', num2str(v_unique(i_class_cm)), ...
% %                      ' LR = ', num2str(v_unique(i_class_lr))]);
% % 
% %             v_x_knn = [v_use(1) v_mean_knn(1)];
% %             v_x_cm = [v_use(1) v_mean_cm(1)];
% %             v_x_lr = [v_use(1) v_mean_lr(1)];
% % 
% %             v_y_knn = [v_use(2) v_mean_knn(2)];
% %             v_y_cm = [v_use(2) v_mean_cm(2)];
% %             v_y_lr = [v_use(2) v_mean_lr(2)];
% % 
% %             if (i_dimensions_count == 3)
% %                 v_z_knn = [v_use(3) v_mean_knn(3)];
% %                 v_z_cm = [v_use(3) v_mean_cm(3)];
% %                 v_z_lr = [v_use(3) v_mean_lr(3)];
% % 
% %                 if(b_show_knn)
% %                     if(b_plot_test_lines)
% %                         line(v_x_knn, v_y_knn, v_z_knn, 'Color', v_colors(i_class_knn,:), 'LineStyle', v_styles(1), 'LineWidth', f_test_width);
% %                     else
% %                         plot3(v_use(1), v_use(2), v_use(3), 'Marker', 'o', 'LineWidth', f_test_width, 'MarkerSize', f_test_width,  'Color', v_colors(i_class_knn,:), 'MarkerFaceColor', v_colors(i_class_knn,:));
% %                     end
% %                 end
% %                 if(b_show_cm)
% %                     if(b_plot_test_lines)
% %                         line(v_x_cm, v_y_cm, v_z_cm, 'Color', v_colors(i_class_cm,:), 'LineStyle', v_styles(2), 'LineWidth', f_test_width);
% %                     else
% %                         plot3(v_use(1), v_use(2), v_use(3), 'Marker', 'o', 'LineWidth', f_test_width, 'MarkerSize', f_test_width, 'Color', v_colors(i_class_cm,:), 'MarkerFaceColor', v_colors(i_class_cm,:));                        
% %                     end
% %                 end
% %                 if(b_show_lr)
% %                     if(b_plot_test_lines)
% %                         line(v_x_lr, v_y_lr, v_z_lr, 'Color', v_colors(i_class_lr,:), 'LineStyle', v_styles(3), 'LineWidth', f_test_width);
% %                     else
% %                         plot3(v_use(1), v_use(2), v_use(3), 'Marker', 'o', 'LineWidth', f_test_width, 'MarkerSize', f_test_width, 'Color', v_colors(i_class_knn,:), 'MarkerFaceColor', v_colors(i_class_knn,:));
% %                     end
% %                 end
% %             else
% %                 if(b_show_knn)
% %                     if(b_plot_test_lines)
% %                         line(v_x_knn, v_y_knn, 'Color', v_colors(i_class_knn,:), 'LineStyle', v_styles(1), 'LineWidth', f_test_width);
% %                     else
% %                         plot(v_use(1), v_use(2), 'Marker', 'o', 'LineWidth', f_test_width, 'MarkerSize', f_test_width, 'Color', v_colors(i_class_knn,:), 'MarkerFaceColor', v_colors(i_class_knn,:));                        
% %                     end
% %                 end
% %                 if(b_show_cm)
% %                     if(b_plot_test_lines)
% %                         line(v_x_cm, v_y_cm, 'Color', v_colors(i_class_cm,:), 'LineStyle', v_styles(2), 'LineWidth', f_test_width);
% %                     else
% %                         plot(v_use(1), v_use(2), 'Marker', 'o', 'LineWidth', f_test_width, 'MarkerSize', f_test_width, 'Color', v_colors(i_class_cm,:), 'MarkerFaceColor', v_colors(i_class_cm,:));                                                
% %                     end
% %                 end
% %                 if(b_show_lr)
% %                     if(b_plot_test_lines)
% %                         line(v_x_lr, v_y_lr, 'Color', v_colors(i_class_lr,:), 'LineStyle', v_styles(3), 'LineWidth', f_test_width);
% %                     else
% %                         plot(v_use(1), v_use(2), 'Marker', 'o', 'LineWidth', f_test_width, 'MarkerSize', f_test_width, 'Color', v_colors(i_class_lr,:), 'MarkerFaceColor', v_colors(i_class_lr,:));                        
% %                     end
% %                 end
% %             end        
% % 
% %         else
% %             b_continue = 0;
% %         end
% %         
% %         
% %     
% %         
% %     end
% % 
