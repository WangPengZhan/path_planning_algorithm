function [newpop] = selection(pop,fitvalue)
% ѡ����
totalfit = sum(fitvalue);        % ����Ӧֵ֮��
fitvalue = fitvalue/totalfit;    % �������屻ѡ�еĸ���
fitvalue = cumsum(fitvalue);     % ��ǰn�����ɵ�����
[px,py] = size(pop);
ms = sort( rand(px,1) );         % �Ӵ�С����
fitin=1;
newin=1;

while newin <= px                
    if (ms(newin)) < fitvalue(fitin) % �����Ӧ�ȴ�����
        newpop(newin) = pop(fitin);
        newin = newin + 1;
    else                             % ������̭
        fitin = fitin + 1;
    end
end