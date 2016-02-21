function [ v_output ] = class2index( v_unique, v_class )

    %% Works like 'find(X,n)' but where 'n' can be a vector and 'X' must be vector

    %% Takes a m-length vector 'v_unique', and n-length vector 'v_class'
    % return a n-length vector representing index of each element of
    % 'v_claass in 'v_unique'
    
    
    if(size(v_unique,1) ~= 1 && size(v_unique,2) ~= 1)
        error([' First supplied argument is not a row-vector or column vector ']);
    end
    if(size(v_class,1) ~= 1 && size(v_class,2) ~= 1)
        error([' Second supplied argument is not a row-vector or column vector ']);
    end
    
    v_class = reshape(v_class, [length(v_class),1]);
    v_unique = reshape(v_unique, [1, length(v_unique)]);
    
    mat_class = repmat(v_class, [1, length(v_unique)]);
    mat_unique = repmat(v_unique, [length(v_class), 1]);
    
    
    v_index = [1:length(v_unique)];
    mat_index = repmat(v_index, [length(v_class),1]);

    mat_indicator = (mat_class==mat_unique);
    v_output = sum(mat_index.*mat_indicator,2);
    
end

