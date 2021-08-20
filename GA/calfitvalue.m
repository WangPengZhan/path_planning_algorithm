function fitvalue = calfitvalue(objvalue)
%计算个体的适应值
global Cmin;
Cmin = 0;
[px,py] = size(objvalue);
%个体适应值为
for i = 1:px
    if objvalue(i)+Cmin > 0
        temp = Cmin + objvalue(i);
    else
        temp = 0.0;
    end
    fitvalue(i) = temp;
end
fitvalue = fitvalue';