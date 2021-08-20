function y = Griewank(x)
% Griewank函数
% 输入x，给出相应的y值，在x=（0,0,0,...,0）有全局极小点0

[row,col] = size(x);
if row > 1
    error('输入的参数有误')
end

y1 = 1/4000*sum(x.^2);
y2 = 1;

for h = 1:col
    y2 = y2*cos(x(h) / sqrt(h));
end

y = y1 - y2 + 1;
y = -y;