% % Based off of code from
% %   https://nirmalthapa.wordpress.com/2012/06/03/multiclass-svm/
% %   http://www.mathworks.com/help/stats/svmtrain.html
% %   http://www.mathworks.com/help/stats/svmclassify.html

clear all

s_datasets = {'ATNTFaceImages400','HandWrittenLetters'};



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cross Validation parameters  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Control everything from next 7 lines
i_dataset = 1;          % 1 for Face Images, 2 for HandWritten Letters
b_SVM = 1;              % Cross validate on SVM? 1st column of results will be 0 otherwise.
b_KNN = 1;              % Cross validate on KNN? 2nd column of results will be 0 otherwise.
i_k = 5;                % If so what is K?
b_CM = 1;               % Cross validate on CM? 3rd column of results will be 0 otherwise.
b_LR = 1;               % Cross validate on LR? 4th column of results will be 0 otherwise
i_fold = 11;             % Fixed to resolve issues discussed in class on 4/1/2016 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






[mat_raw_faces, v_class_faces, mat_train_faces] = fnReadDat('ATNTFaceImages400.csv'); 
[mat_raw_letters, v_class_letters, mat_train_letters] = fnReadDat('HandWrittenLetters.csv'); 

v_size_face = [28,23];
v_size_letter = [20,16];

if(i_dataset == 1) 
    v_class = v_class_faces';
    mat_train = mat_train_faces';           %% 644x400
    v_size = v_size_face;
    i_count_classes = 40;
    i_count_samples = 10;
elseif(i_dataset == 2)
    v_class = v_class_letters';
    mat_train = mat_train_letters';         %% 1014x320
    v_size = v_size_letter;
    i_count_classes = 26;
    i_count_samples = 39;
end




%% Make 644x400
mat_train = mat_train';


%% Using SVD
v_mean = mean(mat_train,1);
mat_mean = repmat(v_mean, [size(mat_train,1), 1]);
mat_train_less_mean = mat_train-mat_mean;

v_var = var(mat_train,1,1);
mat_var = repmat(v_var, [size(mat_train,1), 1]);
mat_stdev = mat_var.^0.5;


mat_X = mat_train_less_mean./mat_stdev;



[mat_U, mat_S, mat_V] = svd(mat_X,'econ');
%% Find mat_Xtlm_ito_eigU st it is 400x400
%% mat_train_less_mean = mat_U * mat_Xtlm_ito_eigU;
%% mat_U' * mat_train_less_mean = mat_U' * mat_U * mat_Xtlm_ito_eigU
%% inv(mat_U' * mat_U) * mat_U' * mat_train_less_mean = inv(mat_U' * mat_U) * (mat_U' * mat_U) * mat_Xtlm_ito_eigU
% pinv(mat_U') * mat_U' * mat_train_less_mean = inv(mat_U' * mat_U) * (mat_U' * mat_U) * mat_Xtlm_ito_eigU

mat_Xtlm_ito_eigU = inv(mat_U' * mat_U) * mat_U' *mat_train_less_mean;
mat_U_pinv = pinv(mat_U');
% mat_Xtlm_ito_eigU = pinv(mat_U') * mat_U' *mat_train_less_mean;

i_k = uint16(5);

mat_new = mat_U(:, [1:i_k]) * mat_Xtlm_ito_eigU([1:i_k], :);



if(logical(b_SVM))
    display([' Running SVM in Crosss Validation with i_fold = ', num2str(i_fold)]);
end
if(logical(b_KNN))
    display([' Running KNN in Crosss Validation with i_k = ', num2str(i_k), ' and i_fold = ', num2str(i_fold)]);
end
if(logical(b_CM))
    display([' Running CM in Crosss Validation with i_fold = ', num2str(i_fold)]);
end
if(logical(b_LR))
    display([' Running LR in Crosss Validation with i_fold = ', num2str(i_fold)]);
end