function [x,y,Result] = POS_immu(func, N, c1, c2, w, MaxDT, D, eps, DS, replaceP,MinD, Psum)
% c1学习因子
% c2学习因子
% w惯性权重
% MaxDT最大迭代次数
% D搜素空间维数
% N初始化群体个数
% eps精度
% DS没循环DS次检查个体是否变优
% replaceP粒子的概率大于replaceP将被免疫替换
% minD粒子间最小间距
% Psum个体最佳和
format long;

%%%%初始化种群个体%%%%
for i = 1:N
    for j = 1:D
        x(i,j) = -range + 2*range*rand; %随机初始化位置
        v(i,j) = randn;                 %随机初始化速度
    end
end

%%%%计算粒子适应度，并初始化pi和pg%%%%
for i = 1:N
    p(i) = feval(func, x(i,:) );
    y(i,:) = x(i,:);
end

pg = x(i,:);

for i = 2:N
    if feval( func, x(i,:)) < feval(func, pg)
        pg = x(i,:);
    end
end

%%%%主循环，按公式迭代直到满足精度或者达到最大次数%%%%
for t = 1:MaxTD
    for i = 1:N
        v(i,:) = w*v(i,:) + c1*rand*(y(i,:)-x(i,:)) + c2*rand*(pg - x(i,:));
        x(i,:) = x(i,:) + v(i,:);
        
        if feval( func, x(i,:)) < p(i) %
            p(i) = feval(func, x(i,:));
            y(i,:) = x(i,:);
        end
        
        if p(i) < feval(func,pg)
            pg = y(i,:);
            subplot(1,2,1);
            bar(pg, 0.25);
            axis([0 30 -40 40])
            title( ['Iteration ',num2str(t)]);
            pause(0.1);
            subplot(1,2,2);
            plot(pg(1,1),pg(1,2),'rs','MarkerFacwColor','r', 'MarkerSize',8)
            hold on;
            plot(x(:,1),x(:,2),'k.');
            set(gca, 'color', 'g');
            hold off;
            grid on;
            axis([-100 100 -100 100])
            title([ 'Global Min = ', num2str(pg(1,1)), ' Min_y= ', num2str(pg(1,2))]);
        end
    end
    
    Pbest(t) = feval(func,pg);
    if Foxhole(pg,D) < eps %如果满足精度就跳出循环
        break;
    end
    %%%%开始免疫%%%%
    if t > DS
        %连续DS代数，种群最优没有变化开始免疫
        if mod(t,DS) == 0 && (Pbest(t-DS+1) - PBest(t)) < 1e-020
            %个体最优不完全相等，但小于一定范围就认为相等
            for i = 1:N     %先计算个体最优和
                Psum = Psum + p(i);
            end
            
            %%%%免疫程序%%%%
            for i = 1:N
                
                %计算每个个体与个体i的距离
                for j = i:N
                    distance(j) = abs(p(j) - p(i));
                end
                
                %计算与个体i距离小于minD的个数
                num = 0;
                for j = 1:N
                    if distance(j) < minD
                        num = num + 1;
                    end
                end
                
                PF(i) = p(N-i+1)/Psum; %适应度概率
                PD(i) = num/N;         %个体浓度
                
                a = rand;              %替换概率因子
                PR(i) = a*PF(i) + (1-a)*PD(i) %替换概率
            end
            
            for i =1:N
                if PR(i) > replaceP
                    x(i,:) =  -range + 2*range*rand(1,D);
                    cnt = cnt + 1;
                end
            end
        end
    end
end

%%%%最后计算结果%%%%
x=pg(1,1);
y=pg(1,2);
Result = faval(func,pg);
%%%%算法结束%%%%

%%%%适应函数%%%%
function probabolity(N,i)
PF = p(N-i)/Psum;     %适应度概率
disp(PF);
for jj = 1:N
    if distance(ii) < minD
        num = num + 1;
    end
end
PD = num/N;           %个体浓度
PR = a*PF + (1-a)*PD; %替换概率