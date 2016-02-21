s_datasets = {'ATNT50','ATNT200'};
s_file_types = {'txt','csv'};
s_file_names = {'trainDataXY','testDataXY','testDataX'};

s_dataset = s_datasets{1};
s_file_type = s_file_types{1};
s_train_file_name = s_file_names{1};
s_test_file_name = s_file_names{2};

s_train_data_file = {'./', s_dataset, '/', s_train_file_name, '.', s_file_type};
c_train_data_file = strjoin(s_train_data_file,'');
s_test_data_file = {'./', s_dataset, '/', s_test_file_name, '.', s_file_type};
c_test_data_file = strjoin(s_test_data_file,'');


% s_train_data_file = strjoin()
% s_test_data_file = strjoin(['./' s_dataset '/' s_test_file_name '.' s_file_type])

%% Reads in 644-dimensional datapoints
[mat_raw, mat_class_train, mat_train]= fnReadDat(c_train_data_file);
% Puts the dimensions along the columns
v_class_train = mat_class_train';
mat_train = mat_train';


%% Reads in 644-dimensional datapoints
[mat_raw, mat_class_test, mat_test]= fnReadDat(c_test_data_file);
% Puts the dimensions along the columns
v_class_test = mat_class_test';               
mat_test = mat_test';


%%  Use compare 'v_class_test' to resulting classes from 'fnKNN', 'fnCentroidMethod', and 'fnLinearRegressio'
v_class = v_class_train;
v_test = fnKNN(mat_test, mat_train, v_class, i_k);
v_test = fnCentroidMethod(mat_test,mat_train,v_class);
v_test = fnLinearRegression(mat_test,mat_train,v_class);

