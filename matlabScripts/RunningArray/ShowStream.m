clear
clc
close all

%%


% figure(1)
% for i = 1:10*3
%     pause(1/10)
% %     imshow(rgb2gray(imread('http://10.19.2.200/cgi-bin/screenCap?')))
%     x = rgb2gray(imread('http://10.19.2.103/cgi-bin/screenCap?'));
%     imshow(x(1:10:end,1:10:end))
%     drawnow
% end

url = 'http://10.19.2.103:8080/shot.jpg';
url = ['http://10.19.2.103/cgi-bin/screenCap?' num2str(rand)] ;
ss  = imread(url);
fh = image(ss);
while(1)
    ss  = imread(url);
    set(fh,'CData',ss);
    drawnow;
end
