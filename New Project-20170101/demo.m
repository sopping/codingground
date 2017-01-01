clear;
clc;

%定义扫描范围是一个以450像素距离为半径的圆
l = 450;

%定义扫描精度，此处为一圈扫描360次，也就是精度为1°，可根据需要自行灵活设置
num = 360;

%生成一个用以暂存数据的数组，由于每个数据是一个0~255的整数，故用个相应维数的向量表示就可以了
output = 1 : num;

%读取图片数据，此处因为一个500*500的图片，且要显示的内容在一个以450像素距离为半径的圆内，可根据需要自行灵活设置
picture = uint8(255*ones(1000)) - imread('popo.bmp');

%以每1°为步进开始生成点阵数据
for m = 1 : num
%计算该时刻扫描线所处角度并计算x和y的变化量
a = (89 + m) * pi / 180; %前面加的89是为了重新设置起始扫描位置，以实现图片的显示方向，可根据需要自行灵活设置
    lx = l * cos(a);
    ly = l * sin(a);
    dx = lx / 31;
    dy = ly / 31;

    %确定扫描线的位置以后，以每个led为中心得到该处是否应该亮灯。值得注意的是，由于图片像素较高，需要一个范围内进行确认，此处是在一个5*5的巨星范围内确认
    for n = 0 : 31
        if (      picture(fix(500 - ly + n*dy),fix(500 + lx - n*dx))...
                & picture(fix(501 - ly + n*dy),fix(500 + lx - n*dx)) & picture(fix(499 - ly + n*dy),fix(500 + lx - n*dx))...
                & picture(fix(500 - ly + n*dy),fix(501 + lx - n*dx)) & picture(fix(500 - ly + n*dy),fix(499 + lx - n*dx))...
                & picture(fix(502 - ly + n*dy),fix(500 + lx - n*dx)) & picture(fix(498 - ly + n*dy),fix(500 + lx - n*dx))...
                & picture(fix(500 - ly + n*dy),fix(502 + lx - n*dx)) & picture(fix(500 - ly + n*dy),fix(498 + lx - n*dx))...
                & picture(fix(501 - ly + n*dy),fix(501 + lx - n*dx)) & picture(fix(501 - ly + n*dy),fix(499 + lx - n*dx))...
                & picture(fix(499 - ly + n*dy),fix(501 + lx - n*dx)) & picture(fix(499 - ly + n*dy),fix(499 + lx - n*dx))...
                & picture(fix(502 - ly + n*dy),fix(502 + lx - n*dx)) & picture(fix(502 - ly + n*dy),fix(498 + lx - n*dx))...
                & picture(fix(498 - ly + n*dy),fix(502 + lx - n*dx)) & picture(fix(498 - ly + n*dy),fix(498 + lx - n*dx)) )
%生成二进制数据
output(m) = bitor(output(m) , 2 ^ n);
        end
    end
end

%以十六进制的形式保存得到的点阵数据
fid=fopen('OUTPUT.txt','w');
fprintf(fid,'0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,\n',output);
fclose(fid);