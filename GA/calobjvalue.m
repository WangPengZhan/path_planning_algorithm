function [objvalue]=calobjvalue(pop)
% Ŀ�꺯��ֵ
[px,py] = size(pop);
temp1 = decodechrom(pop,1,py);
x = temp1*10/1023;
objvalue = 10*sin(5*x) + 7*cos(4*x);
end