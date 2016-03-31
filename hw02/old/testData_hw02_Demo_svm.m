s_datasets = {'ATNT50','ATNT200'};
s_file_types = {'txt','csv'};
s_file_names = {'trainDataXY','testDataXY','testDataX'};


%% Control START %%
i_dataset = 1;          %% 1 is 50, 2 is 200
b_SVM = 1;
b_KNN = 1;
i_KNN_n = 5;           %% Max is 45 for 'i_dataset = 1;' and 179 for 'i_dataset = 2;'
b_CM = 1;
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


display([' Running dataset "', s_datasets{i_dataset}, '"\n']);

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
if(b_SVM)
    v_class = v_class_train;
    display(' ');
    display([' Running SVM ']);
    v_class_svm = fnSVM(mat_test, mat_train, v_class);
    i_svm = sum(mat_class_test==v_class_svm');
    f_svm = i_svm/length(mat_class_test);
    display([' Number correct = ',num2str(i_svm)]);
    display([' Percentage correct = ',num2str(f_svm)]);
end

if(b_KNN)
    v_class = v_class_train;
    display(' ');
    display([' Running KNN with K = ', num2str(i_KNN_n) ]);
    v_class_knn = fnKNN(mat_test, mat_train, v_class, i_KNN_n);
    i_knn = sum(mat_class_test==v_class_knn');
    f_knn = i_knn/length(mat_class_test);
    display([' Number correct = ',num2str(i_knn)]);
    display([' Percentage correct = ',num2str(f_knn)]);
end

if(b_CM)
    v_class = v_class_train;
    display(' ');
    display([' Running CM ']);
    v_class_cm = fnCentroidMethod(mat_test,mat_train,v_class);
    i_cm = sum(mat_class_test==v_class_cm');
    f_cm = i_cm/length(mat_class_test);
    display([' Number correct = ',num2str(i_cm)]);
    display([' Percentage correct = ',num2str(f_cm)]);
end

if(b_LR)
    v_class = v_class_train;
    display(' ');
    display([' Running LR ']);
    v_class_lr = fnLinearRegression(mat_test,mat_train,v_class);
    i_lr = sum(mat_class_test==v_class_lr');
    f_lr = i_lr/length(mat_class_test);
    display([' Number correct = ',num2str(i_lr)]);
    display([' Percentage correct = ',num2str(f_lr)]);
end



