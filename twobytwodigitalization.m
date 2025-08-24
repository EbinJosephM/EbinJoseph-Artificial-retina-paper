clc
%%close all
clear


debug=1

if debug==0

a=arduino('COM4','MKR1010')


 green=floor((readVoltage(a,'A0')/3.3)*2^8);
 purple=floor((readVoltage(a,'A1')/3.3)*2^8);
% 
 green1=floor((readVoltage(a,'A2')/3.3)*2^8);
 purple1=floor((readVoltage(a,'A3')/3.3)*2^8);

 volt_green=((readVoltage(a,'A0')))
 volt_purple=((readVoltage(a,'A1')))
 volt_green1=((readVoltage(a,'A2')))
 volt_purple1=((readVoltage(a,'A3')))

else

    green=0;
    purple=150;

    green1=0;
    purple1=200;

end


row=1080
column=1980/2

img_r(1:row,1:column)=0;
img_g(1:row,1:column)=0;
img_b(1:row,1:column)=0;

img_r1(1:row,1:column)=0;
img_g1(1:row,1:column)=0;
img_b1(1:row,1:column)=0;






 set(gcf, 'units','normalized','outerposition',[1 1 1 1], 'MenuBar', 'none', 'DockControls', 'off');




% img_r(1:row,1:column/2)=purple;
% img_g(1:row,column/2+1:column)=green;
% img_b(1:row,1:column/2)=purple;


img_r(1:row,1:column)=purple;
img_g(1:row,1:column)=green;
img_b(1:row,1:column)=purple;

img_r1(1:row,1:column)=purple1;
img_g1(1:row,1:column)=green1;
img_b1(1:row,1:column)=purple1;

img(:,:,1)=[img_r img_r1];
img(:,:,2)=[img_g img_g1];
img(:,:,3)=[img_b img_b1];

figure
imshow(uint8(img))

retinaimg=uint8(img);

imwrite(retinaimg,'retinaimg.jpeg','JPEG');