function [bestindividual,bestfit] = best(pop,fitvalue)
%求取适应度最大的个体和适应值
[px,py] = size(pop);
bestindividual = pop(1, :);
bestfit = fitvalue(1);
for i = 2:px
    if fitvalue(i) > bestfit
        bestindividual = pop(i,:); %最适应的个体
        bestfit = fitvalue(i);     %最大的适应值
    end
end