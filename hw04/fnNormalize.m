function [ mat_output ] = fnNormalize( mat_input )

    mat_output = uint8(mat_input);
    return
    
    mat_output = mat_input - min(min(mat_input));
    mat_output = mat_output / max(max(mat_output));
    mat_output = uint8(mat_output*255);

end

