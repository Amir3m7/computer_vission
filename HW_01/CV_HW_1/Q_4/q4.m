clc;clear;
message=uint8(imread('IUT.jpg'));
cover_image=uint8(imread('Cover_Image.png'));

% Get dimensions of image
[cover_height, cover_width, cover_numChannel] = size(cover_image);
[message_height, message_width, message_numChannel] = size(message);

% Convert message image dimensions to 16-bit binary representation for embedding
bit_height=int2bit(message_height,16);
bit_width=int2bit(message_width,16);
bit_channel=int2bit(message_numChannel,8);

% Convert both images into column vectors for easier processing
numElements_message = numel(message);
message_vector = reshape(message, numElements_message, 1);

numElements_cover = numel(cover_image);
cover_vector = reshape(cover_image, numElements_cover, 1);

%embed height and width and number of channels to the first 5 pixel of
%vector
cover_vector(1)=bit2int(bit_height(1:8),8);
cover_vector(2)=bit2int(bit_height(9:16),8);
cover_vector(3)=bit2int(bit_width(1:8),8);
cover_vector(4)=bit2int(bit_width(9:16),8);
cover_vector(5)=bit2int(bit_channel(1:8),8);

% Define starting pixel and bit position for embedding(i embed height,width,numofchannels
% to the first 5 pixel)
pixel=6;
change_bit=8;

% Loop through each element (pixel) of the message image
for i=1:numElements_message
    % Convert the current message pixel value to 8-bit binary representation
    message_bit=int2bit(message_vector(i),8);
    
    % Loop through each bit in the message pixel
    for k=1:8

        %i loop to each pixel of cover image and convert to the binary and 
        %then chang 8th bit of pixel with bits of message image if all of
        %the 8th bit of cover image changed we change 7th bit of each pxel 
        %with bits of message immage
        cover_bit=int2bit(cover_vector(pixel),8);
        cover_bit(change_bit)=message_bit(k);
        cover_bit=bit2int(cover_bit,8);
        
        cover_vector(pixel)=cover_bit;
        
        if(pixel==numElements_cover)
            pixel=6;
            change_bit=change_bit-1;
        end
        pixel=pixel+1;
    end 
end


% Reshape the modified cover vector back into a 3D image matrix
stego=reshape(cover_vector,[cover_height, cover_width, cover_numChannel]);
stego_uint=uint8(stego);
imwrite(stego_uint,'stego.png');
imshow('stego.png');


stego_picture=imread('stego.png');
cover_picture=imread('Cover_Image.png');
psnr_number=MY_PSNR(stego_picture,cover_picture)

