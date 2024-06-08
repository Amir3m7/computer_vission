clc;clear;
inputImage=im2double(imread("LR_Cameraman.png")) ;
I=im2double(imread("Cameraman.png"));
tic
M=my_imresize1(inputImage);
toc
PSNR(M,I)

function [output_Image]=my_imresize1(inputImage)

%i calculate new height and width for my resized image 
    resizedFactor=2;
    [height,width,NumChannel]=size(inputImage);

    Output_height=round(height*resizedFactor);
    Output_width=round(width*resizedFactor);
    
    output_Image=zeros(Output_height,Output_width,NumChannel);

    %pixels that have odd row and colomn in the resized picture 
    %we make their value equle to the pixel of the original photo
    for i=1:height
        for j=1:width
            output_Image((i-1)*2+1,(j-1)*2+1,:)=inputImage(i,j,:);
        end
    end


    %We get the amount of pixels in this pixel by taking the average of the 4 pixels that
    % we took from the previous pixel of orginal picture, so that the sum is the average of the 4 pixels that are close to it.
    for i=2:2:Output_height
        for j=2:2:Output_width-1
            if (j+1<Output_width && i+1<Output_height)
                output_Image(i,j,:)=(output_Image(i-1,j-1,:)+output_Image(i-1,j+1,:)+output_Image(i+1,j-1,:)+output_Image(i+1,j+1,:))/4;
            elseif(j+1>Output_width && i+1<Output_height)
                output_Image(i,j,:)=(output_Image(i-1,j-1,:)+output_Image(i-1,j+1,:))/2;
            elseif(j+1>Output_width && i+1>Output_height)
                output_Image(i,j,:)=output_Image(i-1,j-1,:);
            end

        end
    end

    %We get the amount of pixels that are between our two columns 
    % and their rows are the same by averaging their values. 
    for i=1:2:Output_height
        for j=2:2:Output_width
            if (j+1<Output_width && i+1<Output_height)
                output_Image(i,j,:)=(output_Image(i,j-1,:)+output_Image(i,j+1,:))/2;
            else 
                output_Image(i,j,:)=output_Image(i,j-1,:);
            end

        end
    end



    %We get the amount of pixels that are between our two rows 
    % and their column are the same by averaging their values.
    for i=2:2:Output_height-1
        for j=1:2:Output_width
            if (j+1<Output_width)
                output_Image(i,j,:)=(output_Image(i-1,j,:)+output_Image(i+1,j,:))/2;
            else 
                output_Image(i,j,:)=output_Image(i,j-1,:);
            end

        end
    end



end