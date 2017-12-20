function output = correctFisheye(vid)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

v = VideoReader(vid);
total_v = read(v);

[xx,yy,zz,aread] = size(total_v);
finished = cell(1,aread);
for pic = 1:aread
    fish = read(v,pic);

    fish = rgb2gray(fish);
    %fish = rgb2gray(imread('fisheye.png'));

    strength = 2.5;
    zoom = 1;

    [height, width] = size(fish);

    fixed = zeros(height,width);

    halfWidth = width/2;
    halfHeight = height/2;

    correctionRadius = sqrt(width^2 + height^2)/strength;

    for x = 1:width
        for y = 1:height
            newX = x - halfWidth;
            newY = y - halfHeight;

            distance = sqrt(newX^2 + newY^2);
            r = distance/correctionRadius;

            if r == 0
                theta = 1;
            else
                theta = atan(r)/r;
            end

            sourceX = halfWidth + theta * newX * zoom;
            sourceY = halfHeight + theta * newY * zoom;

            if sourceX > width
                sourceX = width;
            end

            if sourceY > height
                sourceY = height;
            end

            for i = 1:3
                fixed(y,x) = fish(round(sourceY),round(sourceX));
            end 
        end
    end
    finished{1,pic} = fixed;
end

new_vid = VideoWriter(vid);
open(new_vid);
for f = 1:aread
    writeVideo(new_vid,finished{1,f}/256);
end
end
        