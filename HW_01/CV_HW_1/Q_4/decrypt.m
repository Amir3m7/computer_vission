clc;clear;
stego=uint8(imread('stego.png'));

% Get the number of elements in the stego image
% Reshape the stego image into a vector
numElements_stego=numel(stego);
stego_vector=reshape(stego, numElements_stego, 1);


% Extract message height, width, and number of channels from the stego image
message_height=double( double( stego(1)*256)+double( stego(2)))+1;
message_width=double( double( stego(3)*256)+double( stego(4)))+1;
message_numChannel=stego(5);
% Calculate the total number of elements in the message
numElements_message=int64(int64(message_height) * int64(message_width) * int64(message_numChannel));

message_vector=uint8(zeros(numElements_message,1));

% Initialize variables for pixel and change_bit
pixel=6;
change_bit=8;


for i=1:numElements_message
    message_bit=int2bit(message_vector(i),8);

    % Extract the current bit of the message vector
    for k=1:8

        if(pixel==numElements_stego)
            pixel=6;
            change_bit=change_bit-1;
        end

        Stego_bit=int2bit(stego_vector(pixel),8);

        message_bit(k)=Stego_bit(change_bit); 

        % Convert the message bit back to integer if it's the last bit
        if k==8 
            message_bit=bit2int(message_bit,8);
            message_vector(i)=message_bit;
        end
        pixel=pixel+1;
    end
end

% Reshape the message vector into an image
message=reshape(message_vector,message_height, message_width, message_numChannel);
message_image=uint8(message);
imwrite(message_image,'message.png');
imshow('message.png');


message_picture=imread('message.png');
iut_picture=imread('IUT.jpg');
psnr_number=MY_PSNR(message_picture,iut_picture)
