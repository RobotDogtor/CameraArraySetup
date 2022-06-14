clear
clc
close all

%%


figure(1)
for i = 1:10*3
    pause(1/10)
%     imshow(rgb2gray(imread('http://10.19.2.200/cgi-bin/screenCap?')))
    x = rgb2gray(imread('http://10.19.2.200/cgi-bin/screenCap?'));
    imshow(x(1:10:end,1:10:end))
end
