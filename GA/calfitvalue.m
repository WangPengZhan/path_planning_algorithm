function fitvalue = calfitvalue(objvalue)
%����������Ӧֵ
global Cmin;
Cmin = 0;
[px,py] = size(objvalue);
%������ӦֵΪ
for i = 1:px
    if objvalue(i)+Cmin > 0
        temp = Cmin + objvalue(i);
    else
        temp = 0.0;
    end
    fitvalue(i) = temp;
end
fitvalue = fitvalue';