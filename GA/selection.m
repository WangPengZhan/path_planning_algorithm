function [newpop] = selection(pop,fitvalue)
% 选择复制
totalfit = sum(fitvalue);        % 求适应值之和
fitvalue = fitvalue/totalfit;    % 单个个体被选中的概率
fitvalue = cumsum(fitvalue);     % 求前n项和组成的数列
[px,py] = size(pop);
ms = sort( rand(px,1) );         % 从大到小排列
fitin=1;
newin=1;

while newin <= px                
    if (ms(newin)) < fitvalue(fitin) % 如果适应度大，则保留
        newpop(newin) = pop(fitin);
        newin = newin + 1;
    else                             % 否则淘汰
        fitin = fitin + 1;
    end
end