function [xm, fv] = PSO(fitness, N, c1, c2, w, M, D)
%%%%%%%%%%%%给定初始化条件%%%%%%%%
% c1学习因子1
% c2学习因子2
% w惯性权重
% M最大迭代次数
% D搜索空间维数
% N初始化群体的个体数目
% 编写与2019.4.6 
% 此为粒子群算法的模板
% matlab有内置的函数pso_Trelea_vectorized
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%初始化个体%%%%%%%%%%%%%
format long;              %保留有效数字16位
for i=1:N
    for j=1:D
        x(i,j) = randn;   %随机初始化位置
        v(i,j) = randn;   %随机初始化速度
    end
end

%%%%计算适应度，并初始化pi和pj%%%%
for i=1:N
    p(i) = fitness(x(i,:));
    y(i,:) = x(i,:);
end

pg=x(N,:);               %pg为全局最优
for i = i:(N-1)
    if fitness(x(i,:)) < fitness(pg)
        pg = x(i,:);
    end
end

%%%%进入主循环，按照公式依次迭代，直到满足精度要求%%%%
for t = 1:M
    for i = 1:N
        v(i,:) = w*v(i,:) + c1*rand*(y(i,:)-x(i,:)) + c2*rand*(pg - x(i,:));
        x(i,:) = x(i,:) + v(i,:);
        if fitness(x(i,:)) < p(i)
            pi = fitness(x(i,:));
            y(i,:) = x(i,:);
        end
        if p(i) < fitness(pg)
            pg = y(i,:);
        end
    end
    Pbest(t) = fitness(pg);
end

%%%%最后计算结果
disp( '******************************************')
disp( '目标函数取最小值的自变量 ')
xm = pg'
disp( ' 目标函数的最小值 ')
fv = fitness(pg)
disp( '******************************************')