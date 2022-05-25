clear all;
close all;

% Main program
[filename,filepath] = uigetfile({'*.jpg;*.tif;*.png;*.gif'}, 'Select File to Open');
if ischar(filepath)
    fullname = [filepath, filename];
end
img = imread(fullname);
figure; imshow(img), title('Original image');
numColors = 4;

[labeled, pixelLabels] = KmeansClustering(img, numColors);
palette = CreatePalette(img, pixelLabels, numColors);
disp(palette);

function palette = CreatePalette(img, pixelLabels, numColors)
% Create color palette with numColors colors
% Return RGB code triplet for each color
    palette = {};
    [row, col, idx] = size(img);
    cluster = zeros(row, col);
    for i = 1:numColors
        mask = pixelLabels == i;
        cluster = img.*uint8(mask);
        mRed = FindMean(cluster, row, col, 1);
        mGreen = FindMean(cluster, row, col, 2);
        mBlue = FindMean(cluster, row, col, 3);
        triple = [mRed mGreen mBlue];
        palette = [palette, triple];

        x = [0 1 1 0] ; y = [0 0 1 1] ;
        figure;
        fill(x,y,triple/255);
    end
end

function num = FindMean(img, row, col, idx)
% Find "mean" color in every cluster
    n = 0;
    sum = 0;
    for i = 1:row
        for j = 1:col
            if (img(i,j,idx) ~= 0)
               sum = sum + double(img(i,j,idx));
               n = n + 1;
            end
        end
    end
    num = floor(sum./n);
end

function [labeled, pixelLabels] = KmeansClustering(img, numColors)
% Classify Colors in RBG Color Space Using K-Means Clustering
    pixelLabels = imsegkmeans(img,numColors);
    % Display the label image as an overlay on the original image
    labeled = labeloverlay(img,pixelLabels);
    figure; imshow(labeled);
    title("Labeled Image RGB");
end