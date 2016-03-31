function [ v_class_index ] = fnOrderedIndex( v_class )
%fnOrderedIndex Summary of this function goes here
%   [2,2,4,4,4,6,6] returns [1,1,2,2,2,3,3]
%

    v_unique_class = unique(sort(v_class));
    i_class_count = length(v_unique_class);
    v_unique_index = 1:i_class_count;
    v_class_index = v_class*0;
    
    j_inc = 0;
    v_unique = 1:i_class_count;
    parfor i_index = v_unique_index;
        i_class = v_unique_class(i_index);
        v_class_index = v_class_index + (i_class==v_class)*i_index;
    end

end

