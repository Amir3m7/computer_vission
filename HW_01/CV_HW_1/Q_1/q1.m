clc; clear ; close all

img_ppm = read_image("./Q_1.ppm");

imshow(img_ppm,[]);

write_image("./my_image.ppm", img_ppm);

my_img_ppm = read_image("./my_image.ppm");

figure,imshow(my_img_ppm);
  
    
    file = fopen("./Q_1.ppm");
    file_content = fread(file);
    fclose(file);
    
    % get header values (considering comment and whitespaces)
    header_vals = strings(1, 4);
    white_space =  [32 10 13 9 11 12];
    i = 1;
    
    while i <= 4
        index = find(ismember(file_content, white_space), 1);
        token = char(strip(char(file_content(1:index - 1).')));
    
        if (~isempty(token) && token(1) == '#')
            index = find(file_content == 10);
            file_content = file_content(index + 1:end);
            continue
        end
        
        file_content = file_content(index + 1:end);
        
        if (~isempty(token))
            header_vals(i) = token;
            i = i + 1;
        end
    end
    

    if (header_vals(1) == "P6") % reqular ppm

        height = str2double(header_vals(3));
        width = str2double(header_vals(2));

        matrix = uint8(zeros(height, width, 3));

        z = 1;
        for k = 1 : height
            for m = 1 : width
                for d = 1 : 3
                    matrix(k, m, d) = file_content(z);
                    z = z + 1;
                end
            end
        end       
    else
        error(message(['Image format not supported. (only regular ppm ' ...
            'and pgm format are supported at the time).']));
    end
    
    img = matrix;
end

% function file_content = read_file(path)
%     arguments
%         path (1,1) {mustBeText}
%     end
%     file = fopen(path);
%     file_content = fread(file);
%     fclose(file);
% end


function [] = write_image(path, img)

    if(ndims(img) == 3)
        d = size(img);
        height = d(1);
        width = d(2);
        
        header = "P6" + " " + num2str(width) + " " + num2str(height) + " " + "255" + newline;

        img_vec = permute(img, [3 2 1]);
        img_vec = img_vec(:).';
    else
        error(message(['Image dimentions are not supported.' ...
            ' it should be 2 dimentional or 3 dimentional']));
    end

    header_vec = uint8(convertStringsToChars(header));

    file_content = [header_vec, img_vec].';

    file = fopen(path, 'w');
    fwrite(file, file_content, 'uint8');
    fclose(file);
end 

