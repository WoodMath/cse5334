% % Based off of code from
% %   https://nirmalthapa.wordpress.com/2012/06/03/multiclass-svm/
% %   http://www.mathworks.com/help/stats/svmtrain.html
% %   http://www.mathworks.com/help/stats/svmclassify.html

s_datasets = {'ATNTFaceImages400','HandWrittenLetters'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%        Dataset Choice        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Control Process from this one Line
i_dataset = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

disp([' Dataset = "', s_datasets{i_dataset}, '"']);
disp([' Class Count = ', num2str(i_count_classes)]);
disp([' Samples per Class = ', num2str(i_count_samples)]);
disp([' Total Images = Class Count * Samples per Class = ', num2str(i_count_classes*i_count_samples)]);
disp([' Image size = [', num2str(v_size), ']'])
disp([' Image width = ', num2str(v_size(2))])
disp([' Image height = ', num2str(v_size(1))])

[mat_confusion, mat_correct, i_correct, f_correct] = fnConfusion(mat_train, v_class, i_count_classes);
disp([' Number of ', num2str(i_count_classes*i_count_samples), ' classified correctly (Trace) = ', num2str(i_correct)])
disp([' Percentage of ', num2str(i_count_classes*i_count_samples), ' classified correctly = ', num2str(f_correct)])


mat_confusion_grayscale = fnSaveMatrixImage(mat_confusion,'confusion.png','png');
mat_correct_grayscale = fnSaveMatrixImage(mat_correct,'correct.png','png');


i_size = 10;

im_confusion_grayscale = fnImageExpand(mat_confusion_grayscale, i_size);
fnSaveMatrixImage(im_confusion_grayscale,'confusion.png','png');
figure(1);
imshow(im_confusion_grayscale);


im_correct_grayscale = fnImageExpand(mat_correct_grayscale, i_size);
fnSaveMatrixImage(im_correct_grayscale,'correct.png','png');
figure(2);
imshow(im_correct_grayscale);
