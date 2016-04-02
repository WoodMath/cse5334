% % Based off of code from
% %   https://nirmalthapa.wordpress.com/2012/06/03/multiclass-svm/
% %   http://www.mathworks.com/help/stats/svmtrain.html
% %   http://www.mathworks.com/help/stats/svmclassify.html

s_datasets = {'ATNTFaceImages400','HandWrittenLetters'};
s_file_types = {'txt','csv'};
s_file_names = {'trainDataXY', 'testDataXY', 'testDataX'};

i_dataset = 1;
%% [Perform SVM, Perform KNN, K in KNN, Perform CM, Perform LR];
v_cross_validate = [1, 1, 5, 1, 1];

[mat_raw_faces, v_class_faces, mat_train_faces] = fnReadDat('ATNTFaceImages400.csv'); 
[mat_raw_letters, v_class_letters, mat_train_letters] = fnReadDat('HandWrittenLetters.csv'); 

v_size_face = [28,23];
v_size_letter = [20,16];

if(i_dataset == 1) 
    v_class = v_class_faces';
    mat_train = mat_train_faces';
    v_size = v_size_face;
    i_count_classes = 40;
    i_count_samples = 10;
elseif(i_dataset == 2)
    v_class = v_class_letters';
    mat_train = mat_train_letters';
    v_size = v_size_letter;
    i_count_classes = 26;
    i_count_samples = 39;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Face Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% [Perform SVM, Perform KNN, K in KNN, Perform CM, Perform LR];
mat_correct_faces_400 = fnCrossValidate(mat_train, v_class, v_cross_validate, 400, 'False');       %% Results of size 1
save('mat_correct_faces_400.mat','mat_correct_faces_400')

mat_correct_faces_100 = fnCrossValidate(mat_train, v_class, v_cross_validate, 100, 'False');      %% Results of size 4
save('mat_correct_faces_100.mat','mat_correct_faces_100')

mat_correct_faces_080 = fnCrossValidate(mat_train, v_class, v_cross_validate, 80, 'False');       %% Results of size 5
save('mat_correct_faces_080.mat','mat_correct_faces_080')

[mat_confusion_faces, mat_correct_faces, f_correct_faces] = fnConfusion(mat_train, v_class, i_count_classes);

obj_faces.mat_confusion = mat_confusion_faces;
obj_faces.mat_correct = mat_correct_faces;
obj_faces.f_correct = f_correct_faces;
obj_faces.v_class = v_class;
obj_faces.mat_train = mat_train;
obj_faces.v_size = v_size;
obj_faces.i_count_classes = i_count_classes;
obj_faces.i_count_samples = i_count_samples;
save('obj_faces.mat','obj_faces');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Letter Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Switch to letters
i_dataset = 2;
if(i_dataset == 1) 
    v_class = v_class_faces';
    mat_train = mat_train_faces';
    v_size = v_size_face;
    i_count_classes = 40;
    i_count_samples = 10;
elseif(i_dataset == 2)
    v_class = v_class_letters';
    mat_train = mat_train_letters';
    v_size = v_size_letter;
    i_count_classes = 26;
    i_count_samples = 39;
end


mat_correct_letters_1014 = fnCrossValidate(mat_train, v_class, v_cross_validate, 1014, 'False');        %% Results of size 1
save('mat_correct_letters_1014.mat','mat_correct_letters_1014')

mat_correct_letters_0507 = fnCrossValidate(mat_train, v_class, v_cross_validate, 0507, 'False');        %% Results of size 2
save('mat_correct_letters_0507.mat','mat_correct_letters_0507')

mat_correct_letters_0338 = fnCrossValidate(mat_train, v_class, v_cross_validate, 0338, 'False');        %% Results of size 3
save('mat_correct_letters_0338.mat','mat_correct_letters_0338')

[mat_confusion_letters, mat_correct_letters, f_correct_letters] = fnConfusion(mat_train, v_class, i_count_classes);

obj_letters.mat_confusion = mat_confusion_letters;
obj_letters.mat_correct = mat_correct_letters;
obj_letters.f_correct = f_correct_letters;
obj_letters.v_class = v_class;
obj_letters.mat_train = mat_train;
obj_letters.v_size = v_size;
obj_letters.i_count_classes = i_count_classes;
obj_letters.i_count_samples = i_count_samples;
save('obj_letters.mat','obj_letters');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% End of Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     for i_rep = 1:i_reps
%         v_square_sum = zeros(1,i_Ks)';
%        
%         parfor i_inc = 1:i_Ks
%             [v_indexes, mat_centers, v_dist] = kmeans(mat_train, i_inc);
%             v_square_sum(i_inc) = sum(v_dist);
%         end
%         v_left = v_square_sum(1:(length(v_square_sum)-2));
%         v_right = v_square_sum(3:length(v_square_sum));
%         
%         v_diff = -(v_right-v_left)/2;
%         
% %         plot(v_x,v_diff,'Color',k(i_rep,:));
%         mat_sum(:,i_rep) = v_square_sum;
%         mat_diff(:,i_rep) = v_diff;
% 
%     end
%     
%     figure(1);
% %     colormap('default');
%     hold all;
%     plot([1:i_Ks],mat_sum);
%     
%     figure(2);
% %     colormap('default');
% 
%     hold all;
%     plot(v_x ,mat_diff);

% mat_image_faces = zeros(v_size_face(1), v_size_face(2), length(v_class_faces), 'uint8');
% mat_image_letters = zeros(v_size_letter(1), v_size_letter(2), length(v_class_letters), 'uint8');
% 
% parfor i_inc = 1:size(mat_raw_faces, 2)
% 	mat_face = mat_raw_faces(2:size(mat_raw_faces, 1), i_inc);
% 	mat_face = reshape(mat_face, v_size_face);
% 	mat_image_faces(:,:,i_inc) = mat_face;
% 
% end
% 
% parfor i_inc = 1:size(mat_raw_letters, 2)
% 	mat_letter = mat_raw_letters(2:size(mat_raw_letters, 1), i_inc);
% 	mat_letter = reshape(mat_letter, v_size_letter);
% 	mat_image_letters(:,:,i_inc) = 255*mat_letter;
% 
% end
% 
% %% 'svmtrain' requires observations along rows
% v_class_faces = v_class_faces';
% v_class_letters = v_class_letters';
% mat_train_faces = mat_train_faces';
% mat_train_letters = mat_train_letters';
% 
% i_class_count_faces = max(v_class_faces);
% i_class_count_letters = max(v_class_letters);


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
