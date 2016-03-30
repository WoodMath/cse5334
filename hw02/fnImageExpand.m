function [ mat_out ] = fnImageExpand( mat_image, v_scale )
%Exapands image by dimensions of 'v_scale'
%   Matlab performs interpolation which cannot be turned off

    if not(exist('mat_image'))
        error(' No image data provided ');
    end
    if not(exist('v_scale'))
        error(' No scale information provided');
    end
    
    if length(v_scale) == 0
        error(' Scale vector is 0-length');
    elseif length(v_scale) == 1
        v2_scale = [v_scale,v_scale];
    elseif length(v_scale) == 2
        v2_scale = v_scale;
    else
        error(' Scale vector is larger than 2 elements ');
    end
    
    mat_out = repmat(mat_image, v2_scale);
    
    i_rows = size(mat_image,1);
    i_cols = size(mat_image,2);
    i_lens = i_rows*i_cols;
    
    i_pixel_size = length(size(mat_image));
    i_max_num = max(i_rows,i_cols);

    i_size = 0;
    if(i_max_num < 2^8)
        i_size = 1; % uint8
    elseif(f_max < 2^16)
        i_size = 2; % uint16
    elseif(f_max < 2^32)
        i_size = 3; % uint32
    elseif(f_max < 2^64)
        i_size = 4; % uint64
    else
        error(' Outside integer ranges ');
    end
    
    for i_inc = [1:i_lens]
        
        i_row = mod(i_inc-1,i_rows)+1;
        i_col = (i_inc - i_row)/i_rows+1;
        
        switch i_size
            case 1
                i_row = uint8(i_row);
                i_col = uint8(i_col);
            case 2
                i_row = uint16(i_row);
                i_col = uint16(i_col);
            case 3
                i_row = uint32(i_row);
                i_col = uint32(i_col);
            case 4
                i_row = uint64(i_row);
                i_col = uint64(i_col);
            otherwise
                error(' Some other size detected ');
        end

        i_row_start = (i_row-1)*v2_scale(1)+1;
        i_row_stop = (i_row-1)*v2_scale(1)+v2_scale(1);
        i_col_start = (i_col-1)*v2_scale(2)+1;
        i_col_stop = (i_col-1)*v2_scale(2)+v2_scale(2);
        
% %         disp([' [i_inc, i_row, i_col] = [', num2str(i_inc), ', ' , num2str(i_row), ', ', num2str(i_col), ']']);
        if(i_pixel_size==2)
            v_pixel = mat_image(i_row,i_col);
            mat_pixel = repmat(v_pixel, [v2_scale(1),v2_scale(2)]);
            mat_out(i_row_start:i_row_stop,i_col_start:i_col_stop) = mat_pixel;
        elseif(i_pixel_size==3)
            v_pixel = mat_image(i_row,i_col,:);
            mat_pixel = repmat(v_pixel, [v2_scale(1),v2_scale(2),1]);
            mat_out(i_row_start:i_row_stop,i_col_start:i_col_stop,:) = mat_pixel;
        elseif(i_pixel_size==4)
            v_pixel = mat_image(i_row,i_col,:,:);
            mat_pixel = repmat(v_pixel, [v2_scale(1),v2_scale(2),1,1]);
            mat_out(i_row_start:i_row_stop,i_col_start:i_col_stop,:,:) = mat_pixel;
        elseif(i_pixel_size==5)
            v_pixel = mat_image(i_row,i_col,:,:,:);        
            mat_pixel = repmat(v_pixel, [v2_scale(1),v2_scale(2),1,1,1]);
            mat_out(i_row_start:i_row_stop,i_col_start:i_col_stop,:,:,:) = mat_pixel;
        else
            error(' Image dimensions exceed allowed bounds ');
        end
        

        
        
        
        
    end
    

end

