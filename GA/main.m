clear all
clc

popsize = 20;                             % 群体大小
chromlength = 10;                         % 字符串长度
pc = 0.8;                                 % 交叉概率
pm = 0.005;                               % 变异概率
pop = initpop(popsize,chromlength);       % 随机产生初始群体

for i = 1:20                              % 20次迭代
    [objvalue] = calobjvalue(pop);        % 计算目标函数
    fitvalue = calfitvalue(pop);          % 计算每个个体的适应度
    [newpop] = selection(pop,fitvalue);   % 复制
    [newpop] = crossover(pop,fitvalue);   % 交叉
    [newpop] = mutation(pop,pc);          % 变异
    [bestindividual,bestfit] = best(pop,fitvalue);  % 求个体中适应度最大的值和个体
    y(i) = max(bestfit);                  % 记录最大适应值
    n(i) = i;                             % 记录迭代次数
    pop5 = bestindividual;                % 记录适应度最大的个体
    x(i) = decodechrom(pop5,1,chromlength)*10/1023; % 解码
    pop = newpop;
end

fplot(@(x)9*sin(5*x)+8*cos(4*x),[0 15]);
hold on
plot(x,y,'r*')
hold off