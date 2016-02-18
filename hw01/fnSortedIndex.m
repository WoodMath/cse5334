function [ mat_order ] = fnSortedIndex( mat_input )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    %% Should return [3, 1; 1, 3; 2, 2];
%    mat_input = [3, 4; 1, 6; 2, 5];
    
    %% Should return [2, 1; 1, 4; 2, 2; 4, 2];    
%     mat_input = [2, 4; 1, 6; 2, 5; 3, 5]; 

    %% Duplicate array for purpose of finding index
    mat_unsorted = permute(mat_input, [3, 2, 1]);
    mat_unsorted = repmat(mat_unsorted, [size(mat_unsorted,3),1,1]);
    
    %% Sort Arrays and Concat duplicate along 3rd dimension
    mat_sorted = sort(mat_input);
    mat_sorted = repmat(mat_sorted, [1,1,size(mat_sorted,1)]);

    %% Filter on entries, oridinal position will be index along Dimension 3 
    mat_equal = (mat_unsorted == mat_sorted);
    mat_count = sum(mat_equal,1);
    
    %% Create vector storing Ordinal Positions
    mat_number = [1:size(mat_equal,1)]';
    mat_number = repmat(mat_number, [1, size(mat_equal,2), size(mat_equal,3)]);
%     mat_number = permute(mat_number, [3, 2, 1])S
    mat_product = mat_equal.*mat_number;
    
    
    %% Code is used in case vector returns multiple has multiple elements with same value
    % wil return the minimum sorted consecutive index (ie [6,5,4,6] will
    % return [3,2,1,3] since since the minimum index (of the ordered array [4,5,6,6]) at which 6 occurs (1 and 4) is 4 
    mat_min=min((mat_product==0)*(999999999)+mat_product,[],1);     % Make 0 entries an obscenely large value
    mat_val=mat_equal.*repmat(mat_min,[size(mat_equal,1),1,1]);     % Make non-mi
    
    %% Makes sure that multiple indexes from previous section are not counted twice
    % Simply add the indexes (which are all the same due to min) and divide
    % by the counts
    mat_order = sum(mat_val,1)./mat_count;
     
    %% Rearrange in to a 2-d matrix
     mat_order = permute(mat_order, [3, 2, 1]);
end

