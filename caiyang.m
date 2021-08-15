N=50;M=3;
fo=0.042;
n=0:N-1;
m=0:N*M-1;
x=sin(2*pi*fo*m);
y=x([1:M:length(x)]);
subplot(2,1,1)
stem(n,x(1:N));
title('输入序列');
xlabel('时间/n');
ylabel('幅度');
subplot(2,1,2)
stem(n,y);
title(['输出序列,抽取因子为',num2str(M)]);
xlabel('时间/n'); ylabel('幅度');
