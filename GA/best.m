function [bestindividual,bestfit] = best(pop,fitvalue)
%��ȡ��Ӧ�����ĸ������Ӧֵ
[px,py] = size(pop);
bestindividual = pop(1, :);
bestfit = fitvalue(1);
for i = 2:px
    if fitvalue(i) > bestfit
        bestindividual = pop(i,:); %����Ӧ�ĸ���
        bestfit = fitvalue(i);     %������Ӧֵ
    end
end