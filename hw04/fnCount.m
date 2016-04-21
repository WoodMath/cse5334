function [ v_counts ] = fnCount( v_integers )
%fnCount find counts of 'v_integers' and returns along the index of 'v_counts'
%   Detailed explanation goes here
    v_integers = reshape(v_integers,size(v_integers,1)*size(v_integers,2),1);
    v_unique = unique(sort(v_integers));
    i_max = max(v_unique);
    
    v_indexes = [1:i_max];
    
    
    mat_indexes = repmat(v_indexes', 1, length(v_integers));
    mat_integers = repmat(v_integers', i_max, 1);
    
    v_counts = sum(mat_indexes == mat_integers,2);


end

