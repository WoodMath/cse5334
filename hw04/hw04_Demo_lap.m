% % Based off of code from
% %   https://nirmalthapa.wordpress.com/2012/06/03/multiclass-svm/
% %   http://www.mathworks.com/help/stats/svmtrain.html
% %   http://www.mathworks.com/help/stats/svmclassify.html

clear

s_train_datasets = {'ATNTFaceImages400','HandWrittenLetters'};
s_test_datasets = {'ATNT50','ATNT200'};
s_test_filenames = {'trainDataXY','testDataXY'};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cross Validation parameters  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Control everything from next 7 lines
i_dataset = 1;                      % 1 for Face Images, 2 for HandWritten Letters
i_test_dataset = 2;                 % 1 for 'ATNT50', 2 for 'ATNT200'
i_test_data_filename = 1;           % 1 for 'trainDataXY', 2 for 'testDataXY'
b_SVM = 0;                          % Cross validate on SVM? 1st column of results will be 0 otherwise.
b_KNN = 0;                          % Cross validate on KNN? 2nd column of results will be 0 otherwise.
i_k = 5;                            % If so what is K?
b_CM = 0;                           % Cross validate on CM? 3rd column of results will be 0 otherwise.
b_LR = 0;                           % Cross validate on LR? 4th column of results will be 0 otherwise
i_fold = 11;                        % Fixed to resolve issues discussed in class on 4/1/2016 
i_class_level = uint16(400);        % Number of classes Deep
i_class_step = 40;                   % Class Step
v_subimage_rows = [1:3];            % Sub image to display
v_subimage_cols = [1:3];            % Sub image to display

b_lap = 1;
l_knn = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load test file for face
s_test_dataset = s_test_datasets{i_test_dataset};      
s_test_filename = s_test_filenames{i_test_data_filename};

s_test_data_file = {'./', s_test_dataset, '/', s_test_filename, '.csv'};
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
    v_model = [b_SVM, b_KNN, i_k, b_CM, b_LR, b_lap];
elseif(i_dataset == 2)
    mat_raw = mat_raw_letters;
    v_class = v_class_letters';
    mat_train = mat_train_letters';         %% 1014x320
    v_size = v_size_letter;
    i_count_classes = 26;
    i_count_samples = 39;
    s_write = 'HandWrittenLetters.png';
    i_scalar = 255;
    v_model = [b_SVM, b_KNN, i_k, b_CM, b_LR, b_lap];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code to display actual faces
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Code for preallocation
mat_images = zeros([v_size(1), v_size(2), length(v_class)], 'uint8');
mat_images_by_class_sample = zeros([v_size(1), v_size(2), i_count_classes, i_count_samples], 'uint8');
mat_save = zeros(v_size(1)*i_count_classes, v_size(2)*i_count_samples, 'uint8');
v_dimension_test = zeros(0,0,'uint32');
v_num_correct = zeros(0,0,'uint32');
v_perc_correct = zeros(0,0,'double');

v_laplacian = fnLaplacianRun(mat_train,l_knn);
