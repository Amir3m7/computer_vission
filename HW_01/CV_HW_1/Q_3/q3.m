image=imread('test_1.ppm');

% Extract red, green, and blue channels
R=image(:,:,1);                                            
G=image(:,:,2);
B=image(:,:,3);

% Get image dimensions
[height, width, numberOfChannels] = size(image);

GrayScale=zeros(height,width);

% Convert color image to grayscale by minimizing color differences
%loop to each pixel
for i=1:height
    for j=1:width
        min=inf;
        sum=inf;

        %i find minimum pixel number that have minimum difrent with r,g,b
        for k=1:255
            sum =abs(int16(R(i,j))-k) + abs(int16(G(i,j))-k) + abs(int16(B(i,j))-k);
            
            if sum<min            
                min=sum;
                GrayScale(i,j)=k;
            end
        end
    end
end


grayscale_uint8=uint8(GrayScale);
imwrite(grayscale_uint8,'test_1.pgm');

gray_image=rgb2gray(image);
imwrite(gray_image,'test_1_rgb2gray.pgm');

rgb2_gray=imread("test_1_rgb2gray.pgm");

grayS=imread('test_1.pgm');
myPSNR(image,rgb2_gray)

% red_psnr=myPSNR(image(:,:,1),rgb2_gray);
% gren_psnr = myPSNR(image(:,:,2), rgb2_gray);
% blue_psnr = myPSNR(image(:,:,3), rgb2_gray);
% average_PSNR = double(red_psnr + gren_psnr + blue_psnr) / 3


function psnrNumber = myPSNR(pic1, pic2)
    pic1 = im2double(pic1);    pic2 = im2double(pic2);
    MSE = sum(sum((pic1 - pic2).^2))/(numel(pic1));
    maxPossibleValue = max(pic1(:));
    psnrNumber = 10 * log10( (maxPossibleValue^2) / MSE);
end

