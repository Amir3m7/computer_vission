function psnrvalue = MY_PSNR(pic1, pic2)
        
    MSE = sum(sum(double(pic1) -double(pic2)).^2)/(numel(pic1));
    maxPossibleValue = max(pic1(:));
    psnrvalue = 10 * log10( (maxPossibleValue^2) / MSE);
end