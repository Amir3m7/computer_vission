clc;clear;

kernel_size=[20,30,50,70];
path="Q_2/";
images=dir(fullfile(path,"*.png"));

for s=1:numel(images)

    image=imread(fullfile(path,images(s).name));
    
    blue_number=denoise_image(image,3);
    blue_number=full_number_image(blue_number);
    
    
    red_number=denoise_image(image,1);
    red_number=full_number_image(red_number);



    threshold=0.8;


    summation = 0;

    for z = 0 : 1

        if(z == 1)
           picture = blue_number;  
        else
            picture = red_number;
        end


        for x = 1 : 9
            for y = 1 : 4
            
                number=imread(["./template_number/"+x+".png"]);
                kernel=kernel_size(y);
                number=imresize(number,[kernel,kernel]);
                number=rgb2gray(number);

                templateHeight=size(number,1);
                templateWidth=size(number,2);

                smallSubImage = number;
                

                    

                    
                    correlationOutput = normxcorr2(smallSubImage(:,:), picture(:,:));                    
                    
                    [maxCorrValue, maxIndex] = max(abs(correlationOutput(:)));
                    
                    if(maxCorrValue >= threshold)
                        [xPeak , yPeak] = ind2sub(size(correlationOutput),maxIndex(1));
                        
                        picture(xPeak-kernel:xPeak+kernel ,yPeak-kernel : yPeak+kernel) = 255;


                        if(z == 0)
                            coe = 1;
                        else
                            coe = -1;
                        end
                        
                        summation = summation + coe * x;
                    end
                    

            end
        end
    end
                    name=images(s).name;
                    insert_text(image,summation,name);


    

end



function [out]=insert_text(image,number,file_name)
        height=750;
        x=350;
        
        text=num2str(number);
        cordination=[x,height];
        text_color=[0,100,0];
        out=insertText(image,cordination,text,'FontSize', 30, 'TextColor', text_color, 'BoxOpacity', 0);

        imwrite(out,"images/"+file_name);
        

end




function [inverted_image]=denoise_image(image,R_or_B)  

    image_1=image(:,:,R_or_B);
    
    image_2=image(:,:,2);
       
    i=(image_1)-(image_2);
    
    inverted_image = 255-i;

end





function [full_image] = full_number_image(inverted_image)

    kernel_sixe=3;
    full_image=inverted_image;
    for i=2:size(inverted_image,1)-1
    
        for j=2:size(inverted_image,2)-1
    
            change_pixel=inverted_image(i-1:i+1,j-1:j+1);
    
            if any(change_pixel(:)==0)
                full_image(i,j)=0;
            
            else
                full_image(i,j)=inverted_image(i,j);
            end 
        
        end
    end
end

