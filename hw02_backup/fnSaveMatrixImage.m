function [ mat_converted ] = fnSaveMatrixImage( mat_matrix, s_file, s_file_type )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    f_max = max(max(mat_matrix));
    
    mat_matrix = mat_matrix/f_max;
    
    if(f_max < 2^8)
        mat_converted = uint8(mat_matrix*double(intmax('uint8')));
    elseif(f_max < 2^16)
        mat_converted = uint16(mat_matrix*double(intmax('uint16')));
    elseif(f_max < 2^32)
        mat_converted = uint32(mat_matrix*double(intmax('uint32')));
    elseif(f_max < 2^64)
        mat_converted = uint64(mat_matrix*double(intmax('uint64')));
    else
        error(' Outside integer ranges ');
    end
    
    imwrite(mat_converted, s_file, s_file_type);

end

