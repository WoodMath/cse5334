

%% Test points
mat_test = [1,11;11,3;6,8;6,7;6,6;12,14];


%% Training points
mat_train = [2,10; 2,8; 3,7; 4,10; 4,8; 5,9; 7,5; 8,6; 9,7; 10,6; 10,4; 8,4; 12,16; 13,15; 13,14; 13,16; 12,17; 12,13];

%% Training class
v_class = [1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3]';


%% Version of function that takes binary SVM results and assigns a class
% [v_nearest, cell_class, mat_results] = fnSVM(mat_test, mat_train, v_class);

% v_class_indicator = zeros(0,0,'logical');
% mat_result = logical(zeros(size(mat_test,1), max(v_class));
mat_result = zeros(size(mat_test,1), max(v_class));

for i_class = 1:max(v_class)
    %% Make vector of indicators for class labels of current class
    v_class_ind = (i_class == v_class);
    svm_model = svmtrain(mat_train, v_class_ind);
    svm_results = svmclassify(svm_model, mat_test);
    mat_results(:,i_class) = svm_results;
    
    
end

i_show = 4;
display(['Look at line 4 of ']);
display(mat_results);
display(['The point mat_test(4,:) = [', num2str(mat_test(i_show,1)), ',',  num2str(mat_test(i_show,2)), '] is classified as both Class 1 and Class 2']);
display([' '])
display([' When this happens in cross validation, and the ground truth is Class 1, is point 4 considered Right or Wrong? '])


%% Comment out 'return' to see error saying that SVM train is binary
return


svm_model = svmtrain(mat_train, v_class);
svm_results = svmclassify(svm_model, mat_test);

