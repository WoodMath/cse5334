% % Based off of code from
% %   https://nirmalthapa.wordpress.com/2012/06/03/multiclass-svm/
% %   http://www.mathworks.com/help/stats/svmtrain.html
% %   http://www.mathworks.com/help/stats/svmclassify.html

s_datasets = {'ATNTFaceImages400','HandWrittenLetters'};
s_file_types = {'txt','csv'};
s_file_names = {'trainDataXY', 'testDataXY', 'testDataX'};

i_dataset = 2;
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


[mat_confusion, mat_correct, i_correct, f_correct] = fnConfusion(mat_train, v_class, i_count_classes);
mat_confusion_grayscale = fnSaveMatrixImage(mat_confusion,'confusion.png','png');
mat_correct_grayscale = fnSaveMatrixImage(mat_correct,'correct.png','png');

disp([' dataset = "', s_datasets{i_dataset}, '"']);
disp([' Class Count = ', num2str(i_count_classes)]);
disp([' Samples per Class = ', num2str(i_count_samples)]);
disp([' Total Images = Class Count * Samples per Class = ', num2str(i_count_classes*i_count_samples)]);
disp([' Image size = [', num2str(v_size), ']'])
disp([' Image width = ', num2str(v_size(2))])
disp([' Image height = ', num2str(v_size(1))])
disp([' Number of ', num2str(i_count_classes*i_count_samples), ' classified correctly (Trace) = ', num2str(i_correct)])
disp([' Percentage of ', num2str(i_count_classes*i_count_samples), ' classified correctly = ', num2str(f_correct)])

i_size = 10;

im_confusion_grayscale = imresize(mat_confusion_grayscale, size(mat_confusion_grayscale)*i_size,'Antialiasing',0);
fnSaveMatrixImage(im_confusion_grayscale,'confusion.png','png');
figure(1);
imshow(im_confusion_grayscale);


im_correct_grayscale = imresize(mat_correct_grayscale, size(mat_correct_grayscale)*i_size,'Antialiasing',0);
fnSaveMatrixImage(im_correct_grayscale,'correct.png','png');
figure(2);
imshow(im_correct_grayscale);


% obj_demo.mat_confusion = mat_confusion;
% obj_demo.mat_correct = mat_correct;
% obj_demo.i_correct = i_correct;
% obj_demo.f_correct = f_correct;
% obj_demo.v_class = v_class;
% obj_demo.mat_train = mat_train;
% obj_demo.v_size = v_size;
% obj_demo.i_count_classes = i_count_classes;
% obj_demo.i_count_samples = i_count_samples;
% obj_demo.mat_confusion_grayscale = mat_confusion_grayscale;
% obj_demo.mat_correct_grayscale = mat_confusion_grayscale;
% 
% save('obj_demo.mat','obj_demo');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Letter Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% mat_correct_letters_1014 = fnCrossValidate(mat_train, v_class, v_cross_validate, 1014, 'False');        %% Results of size 1
% save('mat_correct_letters_1014.mat','mat_correct_letters_1014')
% 
% mat_correct_letters_0507 = fnCrossValidate(mat_train, v_class, v_cross_validate, 0507, 'False');        %% Results of size 2
% save('mat_correct_letters_0507.mat','mat_correct_letters_0507')
% 
% mat_correct_letters_0338 = fnCrossValidate(mat_train, v_class, v_cross_validate, 0338, 'False');        %% Results of size 3
% save('mat_correct_letters_0338.mat','mat_correct_letters_0338')



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
