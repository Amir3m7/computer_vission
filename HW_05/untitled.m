clc;clear;


I=imread("Cells.tif");
threshold = graythresh(I);
binaryImage = im2bw(I, threshold);

se = strel("disk", 1);  % Creates a 3x3 square structuring element

% figure,imshow(binaryImage);
binaryImage=imdilate(binaryImage,se);

% figure,imshow(binaryImage);

[labeledImage, numObjects] = myBwLabel(binaryImage);

% Display results
disp('Labeled Image:');
disp(labeledImage);
disp(['Number of objects: ', num2str(numObjects)]);
% Display each object separately
for k = 1:numObjects
    figure;
    imshow(labeledImage == k);
    title(['Object ', num2str(k)]);
end

% Display the main image with object 10 highlighted (if it exists)
objectNumber = 10;
if objectNumber <= numObjects
    highlightedImage = binaryImage;
    highlightedImage(labeledImage ~= objectNumber) = 0;
    figure;
    imshow(highlightedImage);
    title(['Object ', num2str(objectNumber)]);
else
    disp(['Object ', num2str(objectNumber), ' does not exist in the image.']);
end

function [labeledImage, numObjects] = myBwLabel(binaryImage)
    % Check if the input is a binary image
    if ~islogical(binaryImage)
        error('Input must be a binary image');
    end
    
    % Get the size of the input image
    [rows, cols] = size(binaryImage);
    
    % Initialize the labeled image and label counter
    labeledImage = zeros(rows, cols);
    currentLabel = 0;
    
    % Define the 8-connectivity (you can use 4-connectivity if needed)
    connectivity = [ -1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1 ];
    
    % Function to perform flood fill
    function floodFill(r, c, label)
        stack = [r, c];
        while ~isempty(stack)
            % Pop the last element
            pixel = stack(end, :);
            stack(end, :) = [];
            
            % Get row and column indices
            r = pixel(1);
            c = pixel(2);
            
            % Check bounds and if the pixel is already labeled
            if r >= 1 && r <= rows && c >= 1 && c <= cols && ...
               binaryImage(r, c) == 1 && labeledImage(r, c) == 0
                % Label the current pixel
                labeledImage(r, c) = label;
                
                % Add neighboring pixels to the stack
                for k = 1:size(connectivity, 1)
                    stack = [stack; r + connectivity(k, 1), c + connectivity(k, 2)];
                end
            end
        end
    end
    
    % Loop through each pixel in the binary image
    for r = 1:rows
        for c = 1:cols
            if binaryImage(r, c) == 1 && labeledImage(r, c) == 0
                % Found a new object
                currentLabel = currentLabel + 1;
                floodFill(r, c, currentLabel);
            end
        end
    end
    
    % Return the number of objects found
    numObjects = currentLabel;
end






