function [newpop] = mutation(pop,pm)
% 变异操作
[px,py] = size(pop);
newpop = ones(size(pop));
for i = 1:px
    if(rand < pm)    % 发生变异（小于变异概率），0变1,1变0
        % 随机确定变异位置
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
    else            % 不变异，直接复制
        newpop(i) = pop(i);
    end
end