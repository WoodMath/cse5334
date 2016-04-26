% % Based off of code from
% %   https://nirmalthapa.wordpress.com/2012/06/03/multiclass-svm/
% %   http://www.mathworks.com/help/stats/svmtrain.html
% %   http://www.mathworks.com/help/stats/svmclassify.html

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




v_cross_validate = [b_SVM, b_KNN, i_k, b_CM, b_LR];

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




%% [Perform SVM, Perform KNN, K in KNN, Perform CM, Perform LR];
% [mat_correct, i_correct, f_correct] = fnCrossValidate(mat_train, v_class, v_cross_validate, i_fold, i_count_classes, i_count_samples);       %% Results of size 1


% disp([' Dataset = "', s_datasets{i_dataset}, '"']);
% disp([' Class Count = ', num2str(i_count_classes)]);
% disp([' Samples per Class = ', num2str(i_count_samples)]);
% disp([' Total Images = Class Count * Samples per Class = ', num2str(i_count_classes*i_count_samples)]);
% disp([' Image size = [', num2str(v_size), ']'])
% disp([' Image width = ', num2str(v_size(2))])
% disp([' Image height = ', num2str(v_size(1))])
% disp([' Number Correct = [', num2str(i_correct), ']'])
% disp([' Percentage Correct = [', num2str(f_correct), ']'])

v_mean = mean(mat_train,1)';
v_var = var(mat_train,1);

mat_mean = reshape(v_mean, v_size);
% mat_mean = uint8(mat_mean/max(max(mat_mean))*255);
mat_mean = fnNormalize(mat_mean);
mat_mean = uint8(mat_mean*255);
mat_mean = fnImageExpand(mat_mean,10);
figure(1);
imshow(mat_mean);

mat_var = reshape(v_var, v_size);
% mat_var = uint8(mat_var/max(max(mat_var))*255);
mat_var = fnNormalize(mat_var);
mat_var = uint8(mat_var*255);
mat_var = fnImageExpand(mat_var,10);
figure(2);
imshow(mat_var);

mat_cov = cov(mat_train);
mat_norm = fnNormalize(mat_cov);
mat_norm = uint8(mat_norm*255);
figure(3);
imagesc(mat_cov);
figure(4);
imshow(mat_norm);

[mat_eig_vect, mat_eig_val] = eig(mat_cov);
% v_eig_val = sort(sum(mat_eig_val,2),'descend');

i_largest = 10;
v_test = [size(mat_eig_vect,2)-i_largest+1:size(mat_eig_vect,2)];
v_test = sort(v_test','descend')';

% v_test = 575:580;

for i_inc = v_test;
   figure(i_inc);
   v_temp = mat_eig_vect(:,i_inc);
   mat_temp = reshape(v_temp,v_size);
   mat_temp = fnNormalize(mat_temp);
   mat_temp = uint8(mat_temp*255);
   mat_temp = fnImageExpand(mat_temp,10);
   imshow(mat_temp);
    
end