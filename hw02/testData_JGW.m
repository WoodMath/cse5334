s_datasets = {'ATNT50','ATNT200'};
s_file_types = {'txt','csv'};
s_file_names = {'trainDataXY','testDataXY','testDataX'};


%% Control START %%
i_dataset = 2;          %% 1 is 50, 2 is 200
b_KNN = 0;
i_KNN_n = 11;           %% This is the number of nearest neighbors; Max is 45 for 'i_dataset = 1;' and 179 for 'i_dataset = 2;'
b_CM = 0;
b_LR = 1;
%% Control STOP %%

if(i_dataset == 1)
    v_n = [3:2:45];
end

if(i_dataset == 2)
    v_n = [3:2:180];
end

v_index = [1:length(v_n)];
v_result = v_index;

s_dataset = s_datasets{i_dataset};      
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
if(b_KNN)
    v_class_knn = fnKNN(mat_test, mat_train, v_class, i_KNN_n);
    r_knn=sum(mat_class_test==v_class_knn')/length(mat_class_test);
end

if(b_CM)
    v_class_cm = fnCentroidMethod(mat_test,mat_train,v_class);
    r_cm=sum(mat_class_test==v_class_cm')/length(mat_class_test);
end

if(b_LR)
    v_class_lr = fnLinearRegression(mat_test,mat_train,v_class);
    r_lr = sum(mat_class_test==v_class_lr')/length(mat_class_test);
end


parfor i = v_index
    i_to_use = v_n(i);
    v_class_knn = fnKNN(mat_test, mat_train, v_class, i_to_use);
    r_knn = sum(mat_class_test==v_class_knn')/length(mat_class_test);
    v_result(i) = r_knn;
end
display('tested')
v_class_cm'
display('ground truth')
mat_class_test