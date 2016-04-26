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
i_fold = 10;             % Fixed to resolve issues discussed in class on 4/1/2016 
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

v_i_fold = [];
v_i_correct = [];
v_f_correct = [];
for i_fold = [2:i_count_samples]
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
    [mat_correct, i_correct, f_correct] = fnCrossValidate(mat_train, v_class, v_cross_validate, i_fold, i_count_classes, i_count_samples);       %% Results of size 1

    v_i_fold = vertcat(v_i_fold, i_fold);
    v_i_correct = vertcat(v_i_correct, i_correct);
    v_f_correct = vertcat(v_f_correct, f_correct);

    disp([' Dataset = "', s_datasets{i_dataset}, '"']);
    disp([' Class Count = ', num2str(i_count_classes)]);
    disp([' Samples per Class = ', num2str(i_count_samples)]);
    disp([' Total Images = Class Count * Samples per Class = ', num2str(i_count_classes*i_count_samples)]);
    disp([' Image size = [', num2str(v_size), ']'])
    disp([' Image width = ', num2str(v_size(2))])
    disp([' Image height = ', num2str(v_size(1))])
    disp([' Number Correct = [', num2str(i_correct), ']'])
    disp([' Percentage Correct = [', num2str(f_correct), ']'])
    
    disp(' v_i_fold = ')
    disp(num2str(v_i_fold))
    disp(' v_i_correct = ')
    disp(num2str(v_i_correct))
    disp(' v_f_correct = ')
    disp(num2str(v_f_correct))    

end

% disp([' Final Fold = [', num2str(v_i_fold), ']'])
% disp([' Final Number Correct = [', num2str(v_i_correct), ']'])
% disp([' Final Percentage Correct = [', num2str(v_f_correct), ']'])

disp(' v_i_fold = ')
disp(num2str(v_i_fold))
disp(' v_i_correct = ')
disp(num2str(v_i_correct))
disp(' v_f_correct = ')
disp(num2str(v_f_correct))

save('v_i_fold.mat','v_i_fold')
save('v_i_correct.mat','v_i_correct')
save('v_f_correct.mat','v_f_correct')

