function [ v_pixel_rows, v_pixel_cols ] = fnSubImagePixels( v_size, v_rows, v_cols )
%fnSubImagePixels returns pixels of tiled sub images
%   Detailed explanation goes here

    v_pixel_rows = repmat(zeros(1, v_size(1), 'uint32'), [1,length(v_rows)]);
    v_pixel_cols = repmat(zeros(1, v_size(2), 'uint32'), [1,length(v_cols)]);

    %% Rows
    i_offset = v_size(1);
    for i_inc = 1:length(v_rows)
        i_current = v_rows(i_inc);
        i_start = (i_current-1)*i_offset + 1;
        i_stop = (i_current)*i_offset;
        v_pixels = i_start:i_stop;        
        i_pixel_start = (i_inc-1)*i_offset + 1;
        i_pixel_stop = (i_inc)*i_offset;
        v_pixel_rows(i_pixel_start:i_pixel_stop) = v_pixels; 
    end

    %% Cols
    i_offset = v_size(2);
    for i_inc = 1:length(v_cols)
        i_current = v_cols(i_inc);
        i_start = (i_current-1)*i_offset + 1;
        i_stop = (i_current)*i_offset;
        v_pixels = i_start:i_stop;        
        i_pixel_start = (i_inc-1)*i_offset + 1;
        i_pixel_stop = (i_inc)*i_offset;
        v_pixel_cols(i_pixel_start:i_pixel_stop) = v_pixels; 
    end


end

