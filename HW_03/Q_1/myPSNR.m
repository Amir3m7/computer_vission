function psnrNumber = myPSNR(image_1, image_2)
    image_1 = im2double(image_1);image_2 = im2double(image_2);
    MSE = sum(sum((image_1 - image_2).^2))/(numel(image_1));

    psnrNumber = 10 * log10( 1 / MSE);
end
    