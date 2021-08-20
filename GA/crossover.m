function [newpop] = crossover(pop,pc)
%交叉操作
[px,py] = size(pop);
newpop = ones(size(pop));
for i = 1:2:px-1
    if (rand < pc)                  % 小于交叉概率，交换相邻两位置的部分片段
        cpoint = round(rand*py);    % 随机决定交换片段的位置
        newpop(i,:) = [pop(i,1:cpoint),pop(i+1,cpoint_1:py)];
        newpop(i+1,:) = [pop(i+1,1:cpoint),pop(i,cpoint+1:py)]
    else                            % 不交换，直接复制
        newpop(i,:) = pop(i);
        newpop(i+1,:) = pop(i+1);
    end
end