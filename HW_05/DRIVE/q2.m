clc;clear;
close all;

path_images="/Users/amir/Desktop/HW_05/DRIVE/Training/images";
images=dir(fullfile(path_images,"*.tif"));

path_mask="/Users/amir/Desktop/HW_05/DRIVE/Training/mask";
masks=dir(fullfile(path_mask,"*.gif"));


    pic=im2double( imread(fullfile(path_images,images(1).name)));
    mask=im2double( imread(fullfile(path_mask,masks(1).name)));

    green=pic(:,:,2);
    green=adapthisteq(green);


    med_green=medfilt2(green);


    my_image=green.*(mask);
    med_my_images=med_green.*(mask);

    imshow(med_my_images);

    i=my_image-med_my_images;
    imshow(i,[]);

    




% for i=1:20
% 
%     pic=imread(fullfile(path,images(i).name));
% 
%     g=rgb2gray(pic);
%     R=pic(:,:,1);
%     G=pic(:,:,2);
%     B=pic(:,:,3);
% 
% figure;
%     subplot(2, 2, 1);
%     imshow(R);
%     title('Image 1');
% 
%     subplot(2, 2, 2);
%     imshow(G);
%     title('Image 2');
% 
%     subplot(2, 2, 3);
%     imshow(B);
%     title('Image 3');
% 
%     subplot(2, 2, 4);
%     imshow(g);
%     title('Image 4');    
% end 










