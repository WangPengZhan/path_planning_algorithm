function [newpop] = crossover(pop,pc)
%�������
[px,py] = size(pop);
newpop = ones(size(pop));
for i = 1:2:px-1
    if (rand < pc)                  % С�ڽ�����ʣ�����������λ�õĲ���Ƭ��
        cpoint = round(rand*py);    % �����������Ƭ�ε�λ��
        newpop(i,:) = [pop(i,1:cpoint),pop(i+1,cpoint_1:py)];
        newpop(i+1,:) = [pop(i+1,1:cpoint),pop(i,cpoint+1:py)]
    else                            % ��������ֱ�Ӹ���
        newpop(i,:) = pop(i);
        newpop(i+1,:) = pop(i+1);
    end
end