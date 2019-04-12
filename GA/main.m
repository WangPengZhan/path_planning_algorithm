clear all
clc

popsize = 20;                             % Ⱥ���С
chromlength = 10;                         % �ַ�������
pc = 0.8;                                 % �������
pm = 0.005;                               % �������
pop = initpop(popsize,chromlength);       % ���������ʼȺ��

for i = 1:20                              % 20�ε���
    [objvalue] = calobjvalue(pop);        % ����Ŀ�꺯��
    fitvalue = calfitvalue(pop);          % ����ÿ���������Ӧ��
    [newpop] = selection(pop,fitvalue);   % ����
    [newpop] = crossover(pop,fitvalue);   % ����
    [newpop] = mutation(pop,pc);          % ����
    [bestindividual,bestfit] = best(pop,fitvalue);  % ���������Ӧ������ֵ�͸���
    y(i) = max(bestfit);                  % ��¼�����Ӧֵ
    n(i) = i;                             % ��¼��������
    pop5 = bestindividual;                % ��¼��Ӧ�����ĸ���
    x(i) = decodechrom(pop5,1,chromlength)*10/1023; % ����
    pop = newpop;
end

fplot(@(x)9*sin(5*x)+8*cos(4*x),[0 15]);
hold on
plot(x,y,'r*')
hold off