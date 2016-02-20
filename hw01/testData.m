    mat_test = [1,11;11,3;6,8;6,7;6,6];
%     mat_point = [6,6];
    mat_train = [2,10;2,8;3,7;4,10;4,8;5,9;7,5;8,6;9,7;10,6;10,4;8,4];
    v_class = [1,1,1,1,1,1,2,2,2,2,2,2]';
    v_class = v_class*2;
    
    
%     fnLinearRegression(mat_test, mat_train, v_class);