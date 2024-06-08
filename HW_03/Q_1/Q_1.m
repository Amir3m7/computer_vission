clc;
clear;

orginal_image=imread("Q_1/Baboon.bmp");


a=0;
b=0;




for i=0.30:0.20:0.90

percent_noise=i;





noisy_image=imnoise(orginal_image,"salt & pepper",percent_noise);
noisy=noisy_image;

if percent_noise==0.30 || percent_noise==0.50
    kernel_size=3;

elseif percent_noise==0.70 || percent_noise==0.90
       kernel_size=5;
end 






pad_size=floor(kernel_size/2);
noisy_image = padarray(noisy_image, [pad_size, pad_size], 0);

final_image=orginal_image;

for i=pad_size+1 : size(noisy_image,1)-kernel_size
    for j=pad_size+1 : size(noisy_image,2)-kernel_size

        kernel=noisy_image(i-pad_size :i+pad_size ,j-pad_size :j+pad_size);

        if noisy_image(i,j)~=255 && noisy_image(i,j)~=0
            denoise_pixel=noisy_image(i,j);

        elseif noisy_image(i,j)==255 || noisy_image(i,j)==0
             pixel_vector=kernel(kernel>0 & kernel<255);
             pixel_vector=pixel_vector(:);

             if isempty(pixel_vector)
                 denoise_pixel=mean(mean(kernel));
             else 
                 denoise_pixel=median(pixel_vector);
             end         
        end
        final_image(i-pad_size,j-pad_size)=denoise_pixel;
    end
end


final_image=uint8(final_image);
med=medfilt2(noisy,[kernel_size,kernel_size]);



median_filter=myPSNR(med,orginal_image);
my_filter=myPSNR(final_image,orginal_image);



disp(["psnr of median_filter with "+percent_noise+" percent noise: "+median_filter]);
disp(["psnr of my_denoiser with "+percent_noise+" percent noise: "+my_filter]);





a=a+median_filter;
b=b+my_filter;

end

a/4
b/4
