% % Based off of code from
% %   https://nirmalthapa.wordpress.com/2012/06/03/multiclass-svm/
% %   http://www.mathworks.com/help/stats/svmtrain.html
% %   http://www.mathworks.com/help/stats/svmclassify.html

clear

s_train_datasets = {'ATNTFaceImages400','HandWrittenLetters'};
s_test_datasets = {'ATNT50','ATNT200'};
s_test_file_names = {'trainDataXY','testDataXY','testDataX'};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cross Validation parameters  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Control everything from next 7 lines
i_dataset = 1;          % 1 for Face Images, 2 for HandWritten Letters
i_test_dataset = 1;     % 1 above is the dataset, choose the test dataset to use
b_SVM = 1;              % Cross validate on SVM? 1st column of results will be 0 otherwise.
b_KNN = 1;              % Cross validate on KNN? 2nd column of results will be 0 otherwise.
i_k = 5;                % If so what is K?
b_CM = 1;               % Cross validate on CM? 3rd column of results will be 0 otherwise.
b_LR = 1;               % Cross validate on LR? 4th column of results will be 0 otherwise
i_fold = 11;             % Fixed to resolve issues discussed in class on 4/1/2016 
i_class_level = uint16(400);
i_class_step = 10;
v_subimage_rows = [1:3];
v_subimage_cols = [1:3];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Load test file for face
s_test_dataset = s_test_datasets{i_test_dataset};      
s_test_file_name = s_test_file_names{i_test_dataset};

s_test_data_file = {'./', s_test_dataset, '/', s_test_file_name, '.csv'};
c_test_data_file = strjoin(s_test_data_file,'');
[mat_raw_test, v_class_test, mat_test]= fnReadDat(c_test_data_file);
v_class_test = v_class_test';
mat_test = mat_test'; 


%% Load training file
[mat_raw_faces, v_class_faces, mat_train_faces] = fnReadDat('ATNTFaceImages400.csv'); 
[mat_raw_letters, v_class_letters, mat_train_letters] = fnReadDat('HandWrittenLetters.csv'); 

v_size_face = [28,23];
v_size_letter = [20,16];

if(i_dataset == 1)
    mat_raw = mat_raw_faces;
    v_class = v_class_faces';
    mat_train = mat_train_faces';           %% 644x400
    v_size = v_size_face;
    i_count_classes = 40;
    i_count_samples = 10;
    s_write = 'ATNTFaceImages400.png';
    i_scalar = 1;
elseif(i_dataset == 2)
    mat_raw = mat_raw_letters;
    v_class = v_class_letters';
    mat_train = mat_train_letters';         %% 1014x320
    v_size = v_size_letter;
    i_count_classes = 26;
    i_count_samples = 39;
    s_write = 'HandWrittenLetters.png';
    i_scalar = 255;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code to display actual faces
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Code for preallocation
mat_images = zeros([v_size(1), v_size(2), length(v_class)], 'uint8');
mat_images_by_class_sample = zeros([v_size(1), v_size(2), i_count_classes, i_count_samples], 'uint8');
mat_save = zeros(v_size(1)*i_count_classes, v_size(2)*i_count_samples, 'uint8');
% 
% parfor i_inc = 1:size(mat_train, 1)
% 	mat_single = mat_train(i_inc,:);
% 	mat_store = reshape(mat_single, v_size);
% 	mat_images(:,:,i_inc) = i_scalar*mat_store;
% 
% end
% 
% for i_inc = 1:length(v_class)
%     i_current_class = v_class(i_inc);
%     i_current_sample = sum(v_class(1:i_inc) == i_current_class);
%     
%     i_row_offset = (i_current_class - 1)*v_size(1) + 1;
%     i_col_offset = (i_current_sample - 1)*v_size(2) + 1;
% %     v_rows = double([i_row_offset:(i_row_offset+v_size(1)-1)]);
% %     v_cols = double([i_col_offset:(i_col_offset+v_size(2)-1)]);
%     v_rows = [i_row_offset:(i_row_offset+v_size(1)-1)];
%     v_cols = [i_col_offset:(i_col_offset+v_size(2)-1)];
%     
%     mat_save(v_rows, v_cols) = mat_images(:,:,i_inc);
%     mat_images_by_class_sample(v_rows, v_cols, i_current_class, i_current_sample) = mat_images(:,:,i_inc);
%     
%     
% end
% 
% 

%% Matlab 'subplot' function sucks with images
%% This gives pixels to use as subsets. Ex:
%% for an arrangment of faces, with each face image being 100x100
%% To get the (pixel number of the) 1st and 2nd rows (of faces), and 3rd and 4th columns (of faces), 
%% the function would be called as
%% fnSubImagePixels([100,100, [1,2], [3,4]); and would return
%% [1:200] and [301:400]
[v_sub_pixels_r, v_sub_pixels_c] = fnSubImagePixels(v_size, v_subimage_rows, v_subimage_cols);

for i_inc = [i_count_classes*i_count_samples:-i_class_step:(i_count_classes*i_count_samples)-(i_class_level-1)]
% for i_inc = [1:i_class_step:i_class_level]

        mat_new = fnReduceDimensions(mat_train, i_inc);
        
        
        mat_new_reshaped = reshape(mat_new', v_size(1), v_size(2), i_count_samples, i_count_classes );
        mat_new_reshaped = permute(mat_new_reshaped, [1,2,4,3]);
        for j_inc = 1:length(v_class)
            i_current_class = v_class(j_inc);
            i_current_sample = sum(v_class(1:j_inc) == i_current_class);

            i_row_offset = (i_current_class - 1)*v_size(1) + 1;
            i_col_offset = (i_current_sample - 1)*v_size(2) + 1;
        %     v_rows = double([i_row_offset:(i_row_offset+v_size(1)-1)]);
        %     v_cols = double([i_col_offset:(i_col_offset+v_size(2)-1)]);
            v_rows = [i_row_offset:(i_row_offset+v_size(1)-1)];
            v_cols = [i_col_offset:(i_col_offset+v_size(2)-1)];

            mat_current = mat_new_reshaped(:,:,i_current_class,i_current_sample);
            mat_current = fnNormalize(mat_current);
            
%             figure(999);
%             imshow(mat_current);
            mat_save(v_rows, v_cols) = mat_current;
%             mat_images_by_class_sample(v_rows, v_cols, i_current_class, i_current_sample) = mat_images(:,:,j_inc);


        end
        
        [i_correct, f_correct] = fnTrainTest(v_model, mat_train, v_class,  mat_test, v_class_test);
        
        
        mat_show = fnImageExpand(mat_save(v_sub_pixels_r, v_sub_pixels_c),[5,5]);
        figure(i_inc);
        imshow(mat_show);
        
end

% mat_show = fnImageExpand(mat_save(v_sub_pixels_r, v_sub_pixels_c),[5,5]);
% figure(1);
% imshow(mat_show);
% % imshow(mat_save);
% imwrite(mat_save,s_write,'png');



















