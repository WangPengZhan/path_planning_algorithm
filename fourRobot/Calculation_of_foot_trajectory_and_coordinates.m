%假设机器人沿y轴方向前进，则其悬空时一条腿的足端轨迹如下推导
%设置有速度分析和加速度分析，速度最大值和加速度最大值为vmax与amax

% 参数设置，长度单位统一为mm，时间单位统一为s；
T=1;%足端运行周期
Ts=0.5;%摆动周期
s0=100;%步长设置，初始设置可能需要返回修改
H0=25;%抬腿高度设置
d=100;%足端运动平面距离机器人行进中心的距离

% 初始化开始
t=0:0.01:T;
z1=zeros(size(t));
y1=zeros(size(t));
x1=zeros(size(t));
% 设置足端运行平面
for i=1:length(t)
    x1(i)=d;
end

% 运算绘图阶段
t1=figure('Name','轨迹落点仿真','NumberTitle','off');
figure(t1);
% 抬腿阶段
for i=1:length(t)
    if (t(i)>0)&(t(i)<(Ts/4))
         z1(i)=(H0./(4+pi)).*(((4*pi)/Ts)*(t(i))-sin((4*pi/Ts).*(t(i))));
         y1(i)=s0.*((t(i)-T)./Ts-(1/2/pi).*sin((2.*pi./Ts)*(t(i))))+2.*s0 ;
         plot3(x1(i),y1(i),z1(i),'o','MarkerSize',5);hold on;
    end
end
%空中纯摆动阶段
for i=1:length(t)
    if t(i)>=(Ts/4)&t(i)<(Ts*3/4)
        z1(i)=((4.*H0)./(4+pi)).*(sin((2*pi/Ts)*t(i)-pi/2)+pi/4);
         y1(i)=s0.*((t(i)-T)./Ts-(1/2/pi).*sin((2.*pi./Ts)*(t(i))))+2.*s0 ;
         plot3(x1(i),y1(i),z1(i),'x','MarkerSize',5);hold on;
    end
end
%落地阶段
for i=1:length(t)
    if t(i)>=(Ts*3/4)&t(i)<(Ts)
        z1(i)=((4.*pi.*H0)./(4+pi)).*((1-t(i)./Ts)-(1/(4*pi)).*sin(4.*pi.* (1-t(i)./Ts)));
        y1(i)=s0.*((t(i)-T)./Ts-(1/2/pi).*sin((2.*pi./Ts)*(t(i))))+2.*s0 ;
       plot3(x1(i),y1(i),z1(i),'v','MarkerSize',5);hold on;
    end
end
%地面支撑阶段
for i=1:length(t)
    if t(i)>=Ts&t(i)<T
         z1(i)=0;
         y1(i)=-s0.*(t(i)-Ts)./(T-Ts)+s0;
         plot3(x1(i),y1(i),z1(i),'d','MarkerSize',5);hold on;
     end
end
zlim([0 s0])
grid on


% 速度分析
%显示足端实时速度
t2=figure('Name','速度分析','NumberTitle','off');
figure(t2);
vz1=zeros(size(t));
vy1=zeros(size(t));
vx1=zeros(size(t));
v=zeros(size(t));
for i=2:length(t)
    %速度分量
    vz1(i)=z1(i)-z1(i-1);
    vy1(i)=y1(i)-y1(i-1);
    vx1(i)=x1(i)-x1(i-1);
    %速度求解
    v(i)=sqrt(vz1(i)*vz1(i)+vy1(i)*vy1(i)+vx1(i)*vx1(i));
end
vmax=max(v);
plot(t,v)


% 加速度分析
%显示足端实时加速度
t3=figure('Name','加速度分析','NumberTitle','off');
figure(t3);
a=zeros(size(t));
for i=2:length(t)
    a(i)=v(i)-v(i-1);
end
amax=max(a);
plot(t,a)
 
