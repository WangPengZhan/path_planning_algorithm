function [xm, fv] = PSO(fitness, N, c1, c2, w, M, D)
%%%%%%%%%%%%������ʼ������%%%%%%%%
% c1ѧϰ����1
% c2ѧϰ����2
% w����Ȩ��
% M����������
% D�����ռ�ά��
% N��ʼ��Ⱥ��ĸ�����Ŀ
% ��д��2019.4.6 
% ��Ϊ����Ⱥ�㷨��ģ��
% matlab�����õĺ���pso_Trelea_vectorized
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%��ʼ������%%%%%%%%%%%%%
format long;              %������Ч����16λ
for i=1:N
    for j=1:D
        x(i,j) = randn;   %�����ʼ��λ��
        v(i,j) = randn;   %�����ʼ���ٶ�
    end
end

%%%%������Ӧ�ȣ�����ʼ��pi��pj%%%%
for i=1:N
    p(i) = fitness(x(i,:));
    y(i,:) = x(i,:);
end

pg=x(N,:);               %pgΪȫ������
for i = i:(N-1)
    if fitness(x(i,:)) < fitness(pg)
        pg = x(i,:);
    end
end

%%%%������ѭ�������չ�ʽ���ε�����ֱ�����㾫��Ҫ��%%%%
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

%%%%��������
disp( '******************************************')
disp( 'Ŀ�꺯��ȡ��Сֵ���Ա��� ')
xm = pg'
disp( ' Ŀ�꺯������Сֵ ')
fv = fitness(pg)
disp( '******************************************')