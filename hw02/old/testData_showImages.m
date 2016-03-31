% % Based off of code from
% %   https://nirmalthapa.wordpress.com/2012/06/03/multiclass-svm/
% %   http://www.mathworks.com/help/stats/svmtrain.html
% %   http://www.mathworks.com/help/stats/svmclassify.html

s_datasets = {'ATNTFaceImages400','HandWrittenLetters'};
s_file_types = {'txt','csv'};
s_file_names = {'trainDataXY','testDataXY','testDataX'};

i_dataset = 1;


[mat_raw_faces, v_class_faces, mat_train_faces] = fnReadDat('ATNTFaceImages400.csv'); 
[mat_raw_letters, v_class_letters, mat_train_letters] = fnReadDat('HandWrittenLetters.csv'); 

v_size_face = double([28,23]);
v_size_letter = double([20,16]);

if(i_dataset == 1)
    mat_raw = mat_raw_faces;
    v_class = v_class_faces';
    mat_train = mat_train_faces';
    v_size = v_size_face;
    i_count_classes = 40;
    i_count_samples = 10;
    s_write = 'ATNTFaceImages400.png';
    i_scalar = 1;
elseif(i_dataset == 2)
    mat_raw = mat_raw_letters;
    v_class = v_class_letters';
    mat_train = mat_train_faces';
    v_size = v_size_letter;
    i_count_classes = 26;
    i_count_samples = 39;
    s_write = 'HandWrittenLetters.png';
    i_scalar = 255;
end
mat_images = zeros([v_size(1), v_size(2), length(v_class)], 'uint8');
v_tally_class = zeros(i_count_classes, 1, 'double');
mat_save = zeros(v_size(1)*i_count_classes, v_size(2)*i_count_samples, 'uint8');



parfor i_inc = 1:size(mat_raw, 2)
	mat_single = mat_raw(2:size(mat_raw, 1), i_inc);
	mat_store = reshape(mat_single, v_size);
	mat_images(:,:,i_inc) = i_scalar*mat_store;

end

for i_inc = 1:length(v_class)
    i_class = v_class(i_inc);
    i_row_offset = (i_class - 1)*v_size(1) + 1;
    i_col_offset = v_tally_class(i_class)*v_size(2) + 1;
    v_rows = double([i_row_offset:(i_row_offset+v_size(1)-1)]);
    v_cols = double([i_col_offset:(i_col_offset+v_size(2)-1)]);
    mat_save(v_rows, v_cols) = mat_images(:,:,i_inc);
    v_tally_class(i_class) = v_tally_class(i_class) + 1; 
    
end

imshow(mat_save);
imwrite(mat_save,s_write,'png');



% [v_class, v_count]  = fnSVM(mat_train_faces, mat_train_faces, v_class_faces);


% svm_train_letters = svmtrain(mat_train_letters, v_class_letters);

% % figure(1);
% % imshow(mat_image_faces(:,:,1));
% % figure(2);
% % imshow(mat_image_letters(:,:,1));

% % 
% % s_datasets = {'ATNT50','ATNT200'};
% % s_file_types = {'txt','csv'};
% % s_file_names = {'trainDataXY','testDataXY','testDataX'};
% % 
% % 
% % %% Control START %%
% % i_dataset = 1;          %% 1 is 50, 2 is 200
% % b_KNN = 1;
% % i_KNN_n = 35;           %% Max is 45 for 'i_dataset = 1;' and 179 for 'i_dataset = 2;'
% % b_CM = 1;
% % b_LR = 1;
% % %% Control STOP %%
% % 
% % s_dataset = s_datasets{i_dataset};      
% % s_file_type = s_file_types{1};
% % s_train_file_name = s_file_names{1};
% % s_test_file_name = s_file_names{2};
% % 
% % s_train_data_file = {'./', s_dataset, '/', s_train_file_name, '.', s_file_type};
% % c_train_data_file = strjoin(s_train_data_file,'');
% % s_test_data_file = {'./', s_dataset, '/', s_test_file_name, '.', s_file_type};
% % c_test_data_file = strjoin(s_test_data_file,'');
% % 
% % 
% % 
% % % s_train_data_file = strjoin()
% % % s_test_data_file = strjoin(['./' s_dataset '/' s_test_file_name '.' s_file_type])
% % 
% % %% Reads in 644-dimensional datapoints
% % [mat_raw, mat_class_train, mat_train]= fnReadDat(c_train_data_file);
% % % Puts the dimensions along the columns
% % v_class_train = mat_class_train';
% % mat_train = mat_train';
% % 
% % 
% % %% Reads in 644-dimensional datapoints
% % [mat_raw, mat_class_test, mat_test]= fnReadDat(c_test_data_file);
% % % Puts the dimensions along the columns
% % v_class_test = mat_class_test';               
% % mat_test = mat_test';
% % 
% % 
% % %%  Use compare 'v_class_test' to resulting classes from 'fnKNN', 'fnCentroidMethod', and 'fnLinearRegressio'
% % v_class = v_class_train;
% % if(b_KNN)
% %     v_class_knn = fnKNN(mat_test, mat_train, v_class, i_KNN_n);
% %     r_knn = sum(mat_class_test==v_class_knn')/length(mat_class_test);
% % end
% % 
% % if(b_CM)
% %     v_class_cm = fnCentroidMethod(mat_test,mat_train,v_class);
% %     r_cm = sum(mat_class_test==v_class_cm')/length(mat_class_test);
% % end
% % 
% % if(b_LR)
% %     v_class_lr = fnLinearRegression(mat_test,mat_train,v_class);
% %     r_lr = sum(mat_class_test==v_class_lr')/length(mat_class_test);
% % end
% % 
% % 
% % 
