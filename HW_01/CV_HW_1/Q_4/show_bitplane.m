image=imread('stego.png');

for bp = 0 : 7
  % Extract the bit plane image using bpget().
  bitPlaneImage =double(bitget(image, bp+1));  
  % Display it as pure black and white (not gray scale).
  imshow(bitPlaneImage, []);
  name =  sprintf('BitPlane_%d.bmp', bp);
  imwrite(bitPlaneImage,name);
end