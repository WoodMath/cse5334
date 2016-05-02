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
b_SVM = 1;                          % Cross validate on SVM? 1st column of results will be 0 otherwise.
b_KNN = 1;                          % Cross validate on KNN? 2nd column of results will be 0 otherwise.
i_k = 5;                            % If so what is K?
b_CM = 1;                           % Cross validate on CM? 3rd column of results will be 0 otherwise.
b_LR = 1;                           % Cross validate on LR? 4th column of results will be 0 otherwise
i_fold = 11;                        % Fixed to resolve issues discussed in class on 4/1/2016 
i_class_level = uint16(400);        % Number of classes Deep
i_class_step = 40;                   % Class Step
v_subimage_rows = [1:3];            % Sub image to display
v_subimage_cols = [1:3];            % Sub image to display
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
    v_model = [b_SVM, b_KNN, i_k, b_CM, b_LR];
elseif(i_dataset == 2)
    mat_raw = mat_raw_letters;
    v_class = v_class_letters';
    mat_train = mat_train_letters';         %% 1014x320
    v_size = v_size_letter;
    i_count_classes = 26;
    i_count_samples = 39;
    s_write = 'HandWrittenLetters.png';
    i_scalar = 255;
    v_model = [b_SVM, b_KNN, i_k, b_CM, b_LR];
end

mat_data = mat_train';                                  %% Put data in 
v_mean = mean(mat_data,2);                              %% Need mean
mat_mean = repmat(v_mean, [1, size(mat_data,2)]);       %% in order to
mat_data_less_mean = mat_data-mat_mean;                 %% center Data

mat_class_means = zeros(size(mat_data,1),i_count_classes);   %% Will be used for Sb
mat_point_data_less_class_mean = zeros(size(mat_data));
mat_Sw = zeros(size(mat_data,1),size(mat_data,1));
mat_Sb = zeros(size(mat_data,1),size(mat_data,1));

%% Get class means
for i_inc = 1:i_count_classes
   
    v_class_ind = v_class==i_inc;
    mat_class_data = mat_data(:,v_class_ind);
    v_class_mean = mean(mat_class_data,2);
    mat_class_mean = repmat(v_class_mean, [1,i_count_samples]);
    mat_class_data_less_class_mean = mat_class_data - mat_class_mean;

    %% Assign class mean to column
    mat_class_means(:,i_inc) = sum(mat_class_data_less_class_mean,2);

    i_point_start = i_count_samples*(i_inc - 1) + 1;
    i_point_stop = i_point_start + i_count_samples - 1;  
    mat_point_data_less_class_mean(:,i_point_start:i_point_stop) = mat_class_data_less_class_mean;

    
end

%% Populate Sw
for i_point = 1:(i_count_samples*i_count_classes)

    mat_Sw = mat_Sw + mat_point_data_less_class_mean(:,i_point)*mat_point_data_less_class_mean(:,i_point)';

end

%% Pouplate Sb
mat_class_means_less_mean = mat_class_means - repmat(v_mean, [1,size(mat_class_means,2)]);

for i_class = 1:i_count_classes
    
    mat_Sb = mat_Sb + mat_class_means_less_mean(:,i_class)*mat_class_means_less_mean(:,i_class)';
end

mat_eigen = (mat_Sw+0.0000005*eye(length(mat_Sw)))\mat_Sb;
[mat_eigen_V, mat_eigen_D] = eig(mat_eigen);
[mat_eigen_V_new, mat_eigen_D_new] = cdf2rdf(mat_eigen_V, mat_eigen_D);

v_S = zeros(1,length(mat_eigen));

for i_inc = 1:length(v_S)
    
    v_eigen = mat_eigen_V_new(:,i_inc);
    v_S(i_inc) = (v_eigen'*mat_Sb*v_eigen)/(v_eigen'*mat_Sw*v_eigen);
end


