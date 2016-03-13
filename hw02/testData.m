mat_faces = csvread('ATNTFaceImages400.csv');
mat_letters = csvread('HandWrittenLetters.csv');

v_size_face = [28,23];
v_size_letter = [20,16];

mat_test = mat_faces;
mat_test = mat_test(2:size(mat_test,1),3);

mat_test = reshape(mat_test, [28, 23]);
imshow(uint8(mat_test))

% % 
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
