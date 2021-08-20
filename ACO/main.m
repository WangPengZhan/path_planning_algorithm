function main()
G = [ 0  0  0  0  1  0  0  0  0  0  0  0  1  0  0  0  0  1  0  0;
      0  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0  0  0  0;
      0  0  0  0  1  1  1  0  0  0  1  1  0  0  0  0  0  1  0  0;
      0  0  0  1  0  0  0  1  0  0  0  0  0  1  0  0  0  0  0  0;
      0  0  0  0  0  0  0  0  1  1  1  1  0  0  0  1  1  0  0  1;
      0  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0  0  0;
      0  0  1  1  0  1  0  1  1  0  1  0  1  0  1  1  0  0  1  0;
      0  0  1  0  0  0  1  0  0  0  0  0  1  0  1  0  0  0  1  0;
      0  1  1  0  0  1  0  1  0  1  0  0  0  0  0  0  0  0  1  1;
      0  0  0  0  0  1  1  0  0  0  0  1  1  0  0  0  0  1  1  0;
      0  0  0  0  0  1  0  0  0  0  0  0  0  1  0  1  0  0  1  1;
      1  0  1  1  0  0  0  0  0  1  0  0  0  0  0  0  0  0  1  0;
      0  1  0  0  0  0  0  1  1  1  0  1  0  0  0  1  0  0  1  0;
      0  0  1  1  0  1  0  0  0  0  0  0  0  0  0  0  0  0  0  0;
      0  0  0  0  1  0  1  0  0  0  0  0  0  1  0  0  0  0  0  0;
      0  0  1  1  0  0  0  0  0  0  1  0  0  0  0  0  0  0  0  0;
      0  1  1  0  0  0  0  0  0  0  1  0  1  0  0  1  1  1  0  0;
      0  1  0  0  0  1  0  0  0  1  0  0  0  0  0  1  0  0  0  0;
      0  0  0  0  0  0  0  0  1  1  0  1  0  1  1  0  0  0  1  0;
      0  0  1  1  1  0  0  0  0  1  0  1  0  0  0  0  0  0  0  0;];
  
  MM = size(G,1);                    % G 地图
  Tau = ones(MM*MM,MM*MM);           % 初始信息素矩阵
  Tau = 8.*Tau;
  K = 100;                           % 迭代次数
  M = 50;                            % 蚂蚁个数
  S = 1;                             % 最短路径起点
  E = MM*MM;                         % 最短路径终点
  Alpha = 1;                         % 信息素重要度系数
  Beta = 7;                          % 启发因子重要度系数
  Rho = 0.3;                         % 信息素蒸发系数                     
  Q = 1;                             % 信息素增加强度系数
  minkl = inf;                       % 最短路径
  mink = 0;                          % 最短路径的迭代号
  minl = 0;                          % 最短路径的蚂蚁编号
  D = G2D(G);                        % 表示距离的矩阵，相邻的为1，对角为2^0.5,其余为0，详情请见G2D
  N = size(D,1);                     % 表示问题的规模 MM*MM
  a = 1;                             % 小方格像素边长
  Ex = a*(mod(E,MM) - 0.5);          % 终止点坐标（方格的中心位置表示）
  if Ex == -0.5
      Ex = MM - 0.5;
  end
  Ey = a*(MM + 0.5 - ceil(E/MM));    % mod求余数 ceil向正无穷取整
  
  %求启发式信息矩阵
  Eta = zeros(N);                    % 启发式信息，取到目标点的直线距离
  for i = 1:N
      ix = a*(mod(i,MM) - 0.5);
      if ix == -0.5                  %当i/MM可以整除时，即位于最后一列，ix应等于19.5而不是-0.5
          ix = MM - 0.5;
      end
      iy = a*(MM + 0.5 - ceil(i/MM));%从最后一行开始对应
      if i ~= E
          Eta(i) = 1/((ix -Ex)^2 + (iy - Ey)^2)^0.5; %初始化启发信息，离食物越近，启发信息浓度越高
      else
          Eta(i) = 100;                              %食物源启发信息浓度很大
      end
  end
  
  ROUTES = cell(K,M);                % 每一代每只蚂蚁的爬行路线
  PL = zeros(K,M);                   % 每一代每只蚂蚁爬行路线长度
  for k = 1:K                        % 开始爬行
      for m = 1:M
          %状态初始化
          W=S;                       % 起点                    
          Path = S;                  % 爬行路线
          PLkm = 0;                  % 爬行长度
          TABUkm = ones(N);          % 禁忌表初始化
          TABUkm(S) = 0;             % 排除起始点
          DD = D;                    % 邻接矩阵
          DW = DD(W,:);              % 下一步可以前往的节点
          DW1 = find(DW);            % 找到非零位置的索引
          for j = 1:length(DW1)
              if TABUkm(DW1(j)) == 0 % 如果这个位置在禁忌表里就让DW中这个位置为零
                  DW(DW1(j)) = 0;
              end
          end
          LJD = find(DW);            % 这个是真正下一步可以走的节点          
          Len_LJD = length(LJD);     % 可选节点的个数
          
          while (W ~= E) && (Len_LJD >= 1) %求每个蚂蚁爬行路径
              % 轮盘赌法选择下一步该怎么走
              PP = zeros(Len_LJD);
              for i = 1:Len_LJD
                  PP(i) = (Tau(W,LJD(i))^Alpha)*((Eta(LJD(i))^Beta));
              end
              
              % 建立概率分布
              sumpp = sum(PP);   
              PP = PP/sumpp;
              Pcum(1) = PP(1); 
              for i = 2:Len_LJD
                  Pcum(i) = Pcum(i-1) + PP(i); % 前n项和矩阵
              end
              Select = find(Pcum >= rand);      
              to_visit = LJD(Select(1));       % 随机选择下一格       
              
              %状态更新和记录
              Path = [Path,to_visit];          % 路径增加
              PLkm = PLkm + DD(W,to_visit);    % 路径长度增加
              W = to_visit;                    % 到下一节点
              for kk = 1:N                     % 通过禁忌表更新距离矩阵
                  if TABUkm(kk) == 0
                      DD(W,kk) = 0;
                      DD(kk,W) = 0;
                  end
              end
              TABUkm(W) = 0;                   % 已访问的从节点中删除
              DW = DD(W,:);                    % 更新可以访问的节点
              DW1 = find(DW);                  % 下一步可以前往节点的索引
              for j = 1:length(DW1)
                  if TABUkm(DW1(j)) == 0
                      DW(j) = 0;
                  end
              end
              LJD =find(DW);
              Len_LJD = length(LJD);           % 真正可选节点个数
          end
          
          %记录每一代每只蚂蚁的觅食路线和长度
          ROUTES{k,m} = Path;
          if Path(end) == E
              PL(k,m) = PLkm;                  % 爬行长度
              if PLkm < minkl                  % 更新最短路径状态
                  mink = k;                    % 记录迭代号
                  minl = m;                    % 记录蚂蚁的编号
                  minkl = PLkm;                % 记录最短路径的长度
              end
          else
              PL(k,m) = 0;
          end
      end
      
      %更新信息素
      Delta_Tau = zeros(N,N);
      for m = 1:M
          if PL(k,m)
              ROUT = ROUTES{k,m};
              TS = length(ROUT) - 1; % 移动次数
              PL_km = PL(k,m);       % 路径长度
              for s = 1:TS
                  x = ROUT(s);
                  y = ROUT(s+1);
                  Delta_Tau(x,y) = Delta_Tau(x,y) + Q/PL_km;
                  Delta_Tau(y,x) = Delta_Tau(y,x) + Q/PL_km;
              end
          end
      end
      Tau = (1-Rho).*Tau + Delta_Tau;
  end
  
  %绘图
  plotif = 1;
  if plotif == 1
      % 最短路径变化趋势图
      minPL = zeros(K);
      for i = 1:K
          PLK = PL(i,:);
          Nonzero = find(PLK);
          PLKPLK = PLK(Nonzero);
          minPL(i) = min(PLKPLK);       %找到最短路径
      end
      figure(1)
      plot(minPL);
      hold on;
      grid on;
      title('收敛曲线变化趋势');
      xlabel('迭代次数');
      ylabel('最小路径长度');
      
      % 最短路径行走图
      figure(2)
      % 绘制地图
      axis([0 MM 0 MM])
      for i = 1:MM
          for j = 1:MM
              if G(i,j) == 1     
                  x1 = j - 1;
                  y1 = MM - i;
                  x2 = j;
                  y2 = MM - i;
                  x3 = j;
                  y3 = MM - i + 1;
                  x4 = j - 1;
                  y4 = MM - i + 1;
                  fill([x1,x2,x3,x4],[y1,y2,y3,y4],[0.2,0.2,0.2]);
                  hold on;
              else
                  x1 = j - 1;
                  y1 = MM - i;
                  x2 = j;
                  y2 = MM - i;
                  x3 = j;
                  y3 = MM - i + 1;
                  x4 = j -1;
                  y4 = MM - i + 1;
                  fill([x1,x2,x3,x4],[y1,y2,y3,y4],[1,1,1]);
                  hold on;
              end
          end
      end
      hold on;
      title('机器人运行轨迹');
      xlabel('坐标x');
      ylabel('坐标y');
      
      % 绘制路径
      ROUT = ROUTES{mink,minl};
      LENROUT = length(ROUT);
      Rx = ROUT;
      Ry = ROUT;
      for ii = 1:LENROUT
          Rx(ii) = a*(mod(ROUT(ii),MM) - 0.5);
          if Rx(ii) == -0.5
              Rx(ii) = MM - 0.5;
          end
          Ry(ii) = a*(MM + 0.5 - ceil(ROUT(ii)/MM));
      end
      plot(Rx,Ry)
  end
  
  plotif2 = 1;
  if plotif2 == 1        % 各代蚂蚁爬行图
      figure(3);
      % 创建地图
      axis([0,MM,0,MM])
      for i = 1:MM
          for j = 1:MM
              if G(i,j) == 1
                  x1 = j - 1;
                  y1 = MM - i;
                  x2 = j;
                  y2 = MM - i;
                  x3 = j;
                  y3 = MM - i + 1;
                  x4 = j -1;
                  y4 = MM - i + 1;
                  fill([x1,x2,x3,x4],[y1,y2,y3,y4],[0.2,0.2,0.2]);
                  hold on;
              else
                  x1 = j - 1;
                  y1 = MM - i;
                  x2 = j;
                  y2 = MM - i;
                  x3 = j;
                  y3 = MM - i + 1;
                  x4 = j - 1;
                  y4 = MM - i + 1;
                  fill([x1,x2,x3,x4],[y1,y2,y3,y4],[1,1,1]);
                  hold on;
              end
          end
      end
      
      % 绘制各代蚂蚁爬行图
      for k = 1:K
          PLK = PL(k,:);
          minPLK = min(PLK);
          pos = find(PLK == minPLK);
          m = pos(1);
          ROUT = ROUTES{k,m};
          LENROUT = length(ROUT);
          Rx = ROUT;
          Ry = ROUT;
          for ii = 1:LENROUT
              Rx(ii) = a*(mod(ROUT(ii),MM) - 0.5);
              if Rx(ii) == -0.5 
                  Rx(ii) = MM - 0.5;
              end
              Ry(ii) = a*(MM + 0.5 - ceil(ROUT(ii)/MM));
          end
          plot(Rx,Ry);
          hold on;
      end
  end


      
 