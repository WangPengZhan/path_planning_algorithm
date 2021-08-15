function [x,y,Result] = POS_immu(func, N, c1, c2, w, MaxDT, D, eps, DS, replaceP,MinD, Psum)
% c1ѧϰ����
% c2ѧϰ����
% w����Ȩ��
% MaxDT����������
% D���ؿռ�ά��
% N��ʼ��Ⱥ�����
% eps����
% DSûѭ��DS�μ������Ƿ����
% replaceP���ӵĸ��ʴ���replaceP���������滻
% minD���Ӽ���С���
% Psum������Ѻ�
format long;

%%%%��ʼ����Ⱥ����%%%%
for i = 1:N
    for j = 1:D
        x(i,j) = -range + 2*range*rand; %�����ʼ��λ��
        v(i,j) = randn;                 %�����ʼ���ٶ�
    end
end

%%%%����������Ӧ�ȣ�����ʼ��pi��pg%%%%
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

%%%%��ѭ��������ʽ����ֱ�����㾫�Ȼ��ߴﵽ������%%%%
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
    if Foxhole(pg,D) < eps %������㾫�Ⱦ�����ѭ��
        break;
    end
    %%%%��ʼ����%%%%
    if t > DS
        %����DS��������Ⱥ����û�б仯��ʼ����
        if mod(t,DS) == 0 && (Pbest(t-DS+1) - PBest(t)) < 1e-020
            %�������Ų���ȫ��ȣ���С��һ����Χ����Ϊ���
            for i = 1:N     %�ȼ���������ź�
                Psum = Psum + p(i);
            end
            
            %%%%���߳���%%%%
            for i = 1:N
                
                %����ÿ�����������i�ľ���
                for j = i:N
                    distance(j) = abs(p(j) - p(i));
                end
                
                %���������i����С��minD�ĸ���
                num = 0;
                for j = 1:N
                    if distance(j) < minD
                        num = num + 1;
                    end
                end
                
                PF(i) = p(N-i+1)/Psum; %��Ӧ�ȸ���
                PD(i) = num/N;         %����Ũ��
                
                a = rand;              %�滻��������
                PR(i) = a*PF(i) + (1-a)*PD(i) %�滻����
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

%%%%��������%%%%
x=pg(1,1);
y=pg(1,2);
Result = faval(func,pg);
%%%%�㷨����%%%%

%%%%��Ӧ����%%%%
function probabolity(N,i)
PF = p(N-i)/Psum;     %��Ӧ�ȸ���
disp(PF);
for jj = 1:N
    if distance(ii) < minD
        num = num + 1;
    end
end
PD = num/N;           %����Ũ��
PR = a*PF + (1-a)*PD; %�滻����