clc;clear;
inputImage=im2double(imread("LR_Peppers.png")) ;
I=im2double(imread("Peppers.png"));
resizedFactor=2;

%i=inputImage(1:2:end,1:2:end);
B=imresize(inputImage,2,"bicubic");
PSNR(B,I)

S=block_city(inputImage,2);
PSNR(S,I)

C=chessBoard(inputImage,2);
PSNR(C,I)





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output_Image]=Nearest_Neighbor(inputImage,resizedFactor)

[height,width,NumChannel]=size(inputImage);

Output_height=round(height*resizedFactor);
Output_width=round(width*resizedFactor);

output_Image=zeros(Output_height,Output_width,NumChannel);

[col_index,row_index] = meshgrid(1:Output_width,1:Output_height);
x_index=min(max(round(row_index/resizedFactor),1),height);
y_index=min(max(round(col_index/resizedFactor),1),width);

for k=1:NumChannel
    for i=1:Output_height
        for j=1:Output_width
            x=x_index(i,j);
            y=y_index(i,j);
            output_Image(i,j,k)=inputImage(x,y,k);
        end
    end
end
    figure,imshow(output_Image,[])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [output_Image]=bilinear(inputImage,resizedFactor)
    [height,width,NumChannel]=size(inputImage);

    Output_height=round(height*resizedFactor);
    Output_width=round(width*resizedFactor);
    
    output_Image=zeros(Output_height,Output_width,NumChannel);
    

    for k=1:NumChannel
        for i=1:Output_height
            for j=1:Output_width
                x1=min(max(round(i/resizedFactor),1),height);
                y1=min(max(round(j/resizedFactor),1),width);
                p1=inputImage(x1,y1,k);

                x2=min(max(round(i/resizedFactor),1),height);
                y2=min(max(round(j/resizedFactor)+1,1),width);
                p2=inputImage(x2,y2,k);

                x3=min(max(round(i/resizedFactor)+1,1),height);
                y3=min(max(round(j/resizedFactor),1),width);
                p3=inputImage(x3,y3,k);

                x4=min(max(round(i/resizedFactor)+1,1),height);
                y4=min(max(round(j/resizedFactor)+1,1),width);
                p4=inputImage(x4,y4,k);

                x = rem(i/resizedFactor, 1);
                y = rem(j/resizedFactor, 1);

                output_Image(i, j,k) = p1 + (p2 - p1) * x + (p3 - p1) * y + (p1 - p2 - p3 + p4) * x * y;
            end
        end
    end

figure,imshow(output_Image);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [output_Image]=Euclidean(inputImage,resizedFactor)
    [height,width,NumChannel]=size(inputImage);


    Output_height=round(height*resizedFactor);
    Output_width=round(width*resizedFactor);
    

    output_Image=zeros(Output_height,Output_width,NumChannel);
    

    for k=1:NumChannel
        for i=1:Output_height
            for j=1:Output_width
                x1=min(max(round(i/resizedFactor),1),height);
                y1=min(max(round(j/resizedFactor),1),width);
                p1=inputImage(x1,y1,k);

                x2=min(max(round(i/resizedFactor),1),height);
                y2=min(max(round(j/resizedFactor)+1,1),width);
                p2=inputImage(x2,y2,k);

                x3=min(max(round(i/resizedFactor)+1,1),height);
                y3=min(max(round(j/resizedFactor),1),width);
                p3=inputImage(x3,y3,k);

                x4=min(max(round(i/resizedFactor)+1,1),height);
                y4=min(max(round(j/resizedFactor)+1,1),width);
                p4=inputImage(x4,y4,k);

                x = rem(i/resizedFactor, 1);
                y = rem(j/resizedFactor, 1);
                    
                d1=sqrt((0-x)^2+(0-y)^2);
                d2=sqrt((0-x)^2+(1-y)^2);
                d3=sqrt((1-x)^2+(0-y)^2);
                d4=sqrt((1-x)^2+(1-y)^2);

                dt=d1+d2+d3+d4;

             
                output_Image(i, j,k) = (p1*(d1/dt)+p2*(d2/dt)+p3*(d3/dt)+p4*(d4/dt));
            end
        end
    end

figure,imshow(output_Image);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output_Image]=block_city(inputImage,resizedFactor)
    [height,width,NumChannel]=size(inputImage);

    Output_height=round(height*resizedFactor);
    Output_width=round(width*resizedFactor);
    
    output_Image=zeros(Output_height,Output_width,NumChannel);
    

    for k=1:NumChannel
        for i=1:Output_height
            for j=1:Output_width
                x1=min(max(round(i/resizedFactor),1),height);
                y1=min(max(round(j/resizedFactor),1),width);
                p1=inputImage(x1,y1,k);

                x2=min(max(round(i/resizedFactor),1),height);
                y2=min(max(round(j/resizedFactor)+1,1),width);
                p2=inputImage(x2,y2,k);

                x3=min(max(round(i/resizedFactor)+1,1),height);
                y3=min(max(round(j/resizedFactor),1),width);
                p3=inputImage(x3,y3,k);

                x4=min(max(round(i/resizedFactor)+1,1),height);
                y4=min(max(round(j/resizedFactor)+1,1),width);
                p4=inputImage(x4,y4,k);

                x = rem(i/resizedFactor, 1);
                y = rem(j/resizedFactor, 1);
                    
                d1=abs(0-x)+abs(0-y);
                d2=abs(0-x)+abs(1-y);
                d3=abs(1-x)+abs(0-y);
                d4=abs(1-x)+abs(1-y);

                dt=d1+d2+d3+d4;

             
                output_Image(i, j,k) = (p1*(d1/dt)+p2*(d2/dt)+p3*(d3/dt)+p4*(d4/dt));
            end
        end
    end

figure,imshow(output_Image);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output_Image]=chessBoard(inputImage,resizedFactor)
    [height,width,NumChannel]=size(inputImage);

    Output_height=round(height*resizedFactor);
    Output_width=round(width*resizedFactor);
    
    output_Image=zeros(Output_height,Output_width,NumChannel);
    

    for k=1:NumChannel
        for i=1:Output_height
            for j=1:Output_width
                x1=min(max(round(i/resizedFactor),1),height);
                y1=min(max(round(j/resizedFactor),1),width);
                p1=inputImage(x1,y1,k);

                x2=min(max(round(i/resizedFactor),1),height);
                y2=min(max(round(j/resizedFactor)+1,1),width);
                p2=inputImage(x2,y2,k);

                x3=min(max(round(i/resizedFactor)+1,1),height);
                y3=min(max(round(j/resizedFactor),1),width);
                p3=inputImage(x3,y3,k);

                x4=min(max(round(i/resizedFactor)+1,1),height);
                y4=min(max(round(j/resizedFactor)+1,1),width);
                p4=inputImage(x4,y4,k);

                x = rem(i/resizedFactor, 1);
                y = rem(j/resizedFactor, 1);
                    
                d1=max((0-x),(0-y));
                d2=max((0-x),(1-y));
                d3=max((1-x),(0-y));
                d4=max((1-x),(1-y));

                dt=d1+d2+d3+d4;

             
                output_Image(i, j,k) = (p1*(d1/dt)+p2*(d2/dt)+p3*(d3/dt)+p4*(d4/dt));
            end
        end
    end

end
