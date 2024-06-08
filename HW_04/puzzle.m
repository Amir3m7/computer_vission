clc;clear;

path="/Users/amir/Desktop/HW_04_V2/Puzzle_3_640";
puzzles=dir(fullfile(path,"*.tif"));

patch_images={};

output_image=imread(fullfile(path,"Output.tif"));
imshow(fullfile(path,"Output.tif"))
for i=1:numel(puzzles)

    if lower(strncmp(puzzles(i).name, 'Patch', 5))
    image_data = imread(fullfile(path,  puzzles(i).name ));
    
    patch_images{end+1} = image_data;

    end
end

temp=patch_images;

patch_size=size(patch_images{1,1},1);

height_image=size(output_image,1);
width_image=size(output_image,2);



first_corner=[1 , 1];
second_corner=[1 , width_image-patch_size+1];
third_corner=[height_image-patch_size+1 , 1];
fourth_corner=[height_image-patch_size+1 , width_image-patch_size+1];

corner_cordination={first_corner,second_corner,third_corner,fourth_corner};

column=1;

max_psnr=0;

for i=1:patch_size:height_image
    for j=1:patch_size:width_image

        cor=[i,j];
        if ~(isequal(corner_cordination{1,1},cor) || isequal(corner_cordination{1,2},cor) || isequal(corner_cordination{1,3},cor) || isequal(corner_cordination{1,4},cor))
            

            if i==1
               max_psnr=0;
               main_pic_column=output_image(i:i+patch_size-1 , j-1:j-1, :);
                                                                                        
                for k=1:size(patch_images,2)

                    pic=patch_images{1,k};
                    
                    neighbor_column_pix=pic(1:patch_size , 1:1, :);

                    my_psnr=myPSNR(neighbor_column_pix,main_pic_column);

                    if max_psnr<my_psnr
                        index=k
                        max_psnr=my_psnr;
                    end
                end


            
            elseif j==1
                
                max_psnr=0;
                main_pic_row=output_image(i-1:i-1 , j:j+patch_size-1 , :);


                for k=1:size(patch_images,2)

                    pic=patch_images{1,k};

                    neighbor_row_pix=pic(1:1 , 1:patch_size, :);

                    my_row_psnr=myPSNR(neighbor_row_pix , main_pic_row);

                    my_psnr=my_row_psnr;

                    if max_psnr<my_psnr
                        index=k
                        max_psnr=my_psnr;
                    end
                end


            else
                
                max_psnr=0;
                main_pic_column=output_image(i:i+patch_size-1 , j-1:j-1 , :);
                main_pic_row=output_image(i-1:i-1 , j:j+patch_size-1 , :);

                for k=1:size(patch_images,2)

                    pic=patch_images{1,k};

                    neighbor_column_pix=pic(1:patch_size, 1:1, :);
                    neighbor_row_pix=pic(1:1 , 1:patch_size, :);



                    my_column_psnr=myPSNR(neighbor_column_pix,main_pic_column);
                    my_row_psnr=myPSNR(neighbor_row_pix,main_pic_row);

                    my_psnr=my_column_psnr+my_row_psnr;

                    if max_psnr<my_psnr
                        index=k
                        max_psnr=my_psnr;
                    end


                end


            end

            output_image(i:i+patch_size-1,j:j+patch_size-1,:)=patch_images{1,index};


        end

       imshow(output_image);

    end
end



orginal_image=imread(fullfile(path,"Original.tif"));
psnr_puzzle=myPSNR(orginal_image,output_image)









