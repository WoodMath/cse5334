function [ mat_indices ] = fnSortedIndex( mat_input )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    %% Should return [2, 1; 3, 3; 1, 2];
%    mat_input = [3, 4; 1, 6; 2, 5];
    
    %% Should return [2, 1; 1, 3; 1, 3; 4, 2];    
%     mat_input = [2, 4; 1, 6; 2, 5; 3, 5]; 


% %     %% Sort Arrays and Concat duplicate along 3rd dimension
% %     mat_sorted = sort(mat_input);
% %     mat_sorted = permute(mat_sorted, [3,2,1]);
% %     mat_sorted = repmat(mat_sorted, [size(mat_sorted,3),1,1]);
% % 
% % 
% %     %% Duplicate array for purpose of finding index
% % %     mat_unsorted = permute(mat_input, [3, 2, 1]);
% %     mat_unsorted = repmat(mat_input, [1,1,size(mat_input,1)]);
% %     
% %     
% %     %% Filter on entries, oridinal position will be index along Dimension 3 
% %     mat_equal = (mat_unsorted == mat_sorted);
% %     mat_count = sum(mat_equal,1);
% %     
% %     
% %     %% Create vector storing Ordinal Positions
% %     mat_number = [1:size(mat_equal,1)]';
% %     mat_number = repmat(mat_number, [1, size(mat_count,2), size(mat_count,3)]);
% % 
% %     %% Create a matrix containing indices and find minimum indice
% %     mat_product = mat_equal.*mat_number;
% %     mat_min=min((mat_product==0)*(999999999)+mat_product,[],1);
% % 
% %     mat_indices = permute(mat_min, [3, 2, 1]);



    %% Should return [2, 1; 3, 3; 1, 2];
%    mat_input = [2, 1; 3, 3; 1, 2];
    
    %% Should return [2, 1; 1, 3; 3, 4; 4, 2];    
%     mat_input = [2, 4; 1, 6; 2, 5; 3, 5]; 

    mat_indices = zeros(size(mat_input,1),size(mat_input,2));
    parfor i_col = 1:size(mat_input,2)
        mat_col = mat_input(:,i_col);
        mat_index = [1:size(mat_input,1)]';
        mat_sort = sortrows(cat(2,mat_col,mat_index));
        mat_indices(:,i_col) = mat_sort(:,2);
        
    end

end

