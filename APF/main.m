%%%%初始化车的参数%%%%
Xo = [0 0];                % 起点位置
k = 15;                    % 引力增益系数
K = 0;                     % 初始化
m = 5;                     % 斥力增益系数
Po = 2.5;                  % 障碍影响距离(当障碍和车的距离大于这个距离时，斥力为0，即不受该障碍的影响)
n = 7;                     % 障碍个数
a = 0.5;
l = 0.2;                   % 步长
J = 200;                   % 迭代次数
% 如果不能实现预期目标，可能也与初始的增益系数，Po设置的不合适有关。

%%%%给出障碍和目标信息%%%%
Xsum=[10 10;1 1.2;3 2.5;4 4.5;3 6;6 2;5.5 5.5;8 8.5];  % 障碍的坐标(n个),其中[10 10]是目标位置
Xj = Xo;                                               % j=1循环初始，将车的起始坐标赋给Xj

%%%%主体循环%%%%
for j = 1:J 
    Goal(j,1)=Xj(1);                                   % Goal是路径的坐标
    Goal(j,2)=Xj(2);
   
    %%%%计算角度%%%&
    Theta=compute_angle(Xj,Xsum,n);  % Theta是计算出来的车和障碍，和目标之间的与X轴之间的夹角，统一规定角度为逆时针方向

    %%%%调用计算引力模块%%%%
    Angle=Theta(1);                  % Theta（1）是车和目标之间的角度，目标对车是引力。
    angle_at=Theta(1);               % 为了后续计算斥力在引力方向的分量赋值给angle_at
    [Fatx,Faty]=compute_Attract(Xj,Xsum,k,Angle,0,Po,n); % 计算出目标对车的引力在x,y方向的两个分量值。
    for i=1:n
        angle_re(i)=Theta(i+1);      % 计算斥力用的角度，是个向量，因为有n个障碍，就有n个角度。
    end

    %计算斥力
    [Frerxx,Freryy,Fataxx,Fatayy]=compute_repulsion(Xj,Xsum,m,angle_at,angle_re,n,Po,a); % 计算出斥力在x,y方向的分量数组。
    %   计算合力和方向，这有问题，应该是数，每个j循环的时候合力的大小应该是一个唯一的数，不是数组。应该把斥力的所有分量相加，引力所有分量相加。
    Fsumyj=Faty+Freryy+Fatayy;%y方向的合力
    Fsumxj=Fatx+Frerxx+Fataxx;%x方向的合力
    Position_angle(j)=atan(Fsumyj/Fsumxj);%合力与x轴方向的夹角向量

    %计算车的下一步位置
    Xnext(1)=Xj(1)+l*cos(Position_angle(j));
    Xnext(2)=Xj(2)+l*sin(Position_angle(j));
    %保存车的每一个位置在向量中
    Xj=Xnext;
    %判断
    if ((Xj(1)-Xsum(1,1))>0)&((Xj(2)-Xsum(1,2))>0) % 是应该完全相等的时候算作到达，还是只是接近就可以？现在按完全相等的时候编程。
        K=j;                                       % 记录迭代到多少次，到达目标。
        break;
    end
end

K=j;
Goal(K,1)=Xsum(1,1);                               % 把路径向量的最后一个点赋值为目标
Goal(K,2)=Xsum(1,2);

%%%%画出障碍，起点，目标，路径点%%%%
%画出路径
X=Goal(:,1);
Y=Goal(:,2);
x=[1 3 4 3 6 5.5 8];         % 障碍的x坐标
y=[1.2 2.5 4.5 6 2 5.5 8.5];
plot(x,y,'o',10,10,'v',0,0,'ms',X,Y,'.r');