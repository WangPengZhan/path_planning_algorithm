function [newpop] = mutation(pop,pm)
% �������
[px,py] = size(pop);
newpop = ones(size(pop));
for i = 1:px
    if(rand < pm)    % �������죨С�ڱ�����ʣ���0��1,1��0
        % ���ȷ������λ��
        mpoint = round(rand*py);
        if mpoint <= 0
            mpoint = 1;
        end
        newpop(i) = pop(i);
        if any(newpop(i, mpoint)) == 0
            newpop(i, mpoint) = 1;
        else
            newpop(i, mpoint) = 0;
        end
    else            % �����죬ֱ�Ӹ���
        newpop(i) = pop(i);
    end
end