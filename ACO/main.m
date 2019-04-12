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
  
  MM = size(G,1);                    % G ��ͼ
  Tau = ones(MM*MM,MM*MM);           % ��ʼ��Ϣ�ؾ���
  Tau = 8.*Tau;
  K = 100;                           % ��������
  M = 50;                            % ���ϸ���
  S = 1;                             % ���·�����
  E = MM*MM;                         % ���·���յ�
  Alpha = 1;                         % ��Ϣ����Ҫ��ϵ��
  Beta = 7;                          % ����������Ҫ��ϵ��
  Rho = 0.3;                         % ��Ϣ������ϵ��                     
  Q = 1;                             % ��Ϣ������ǿ��ϵ��
  minkl = inf;                       % ���·��
  mink = 0;                          % ���·���ĵ�����
  minl = 0;                          % ���·�������ϱ��
  D = G2D(G);                        % ��ʾ����ľ������ڵ�Ϊ1���Խ�Ϊ2^0.5,����Ϊ0���������G2D
  N = size(D,1);                     % ��ʾ����Ĺ�ģ MM*MM
  a = 1;                             % С�������ر߳�
  Ex = a*(mod(E,MM) - 0.5);          % ��ֹ�����꣨���������λ�ñ�ʾ��
  if Ex == -0.5
      Ex = MM - 0.5;
  end
  Ey = a*(MM + 0.5 - ceil(E/MM));    % mod������ ceil��������ȡ��
  
  %������ʽ��Ϣ����
  Eta = zeros(N);                    % ����ʽ��Ϣ��ȡ��Ŀ����ֱ�߾���
  for i = 1:N
      ix = a*(mod(i,MM) - 0.5);
      if ix == -0.5                  %��i/MM��������ʱ����λ�����һ�У�ixӦ����19.5������-0.5
          ix = MM - 0.5;
      end
      iy = a*(MM + 0.5 - ceil(i/MM));%�����һ�п�ʼ��Ӧ
      if i ~= E
          Eta(i) = 1/((ix -Ex)^2 + (iy - Ey)^2)^0.5; %��ʼ��������Ϣ����ʳ��Խ����������ϢŨ��Խ��
      else
          Eta(i) = 100;                              %ʳ��Դ������ϢŨ�Ⱥܴ�
      end
  end
  
  ROUTES = cell(K,M);                % ÿһ��ÿֻ���ϵ�����·��
  PL = zeros(K,M);                   % ÿһ��ÿֻ��������·�߳���
  for k = 1:K                        % ��ʼ����
      for m = 1:M
          %״̬��ʼ��
          W=S;                       % ���                    
          Path = S;                  % ����·��
          PLkm = 0;                  % ���г���
          TABUkm = ones(N);          % ���ɱ��ʼ��
          TABUkm(S) = 0;             % �ų���ʼ��
          DD = D;                    % �ڽӾ���
          DW = DD(W,:);              % ��һ������ǰ���Ľڵ�
          DW1 = find(DW);            % �ҵ�����λ�õ�����
          for j = 1:length(DW1)
              if TABUkm(DW1(j)) == 0 % ������λ���ڽ��ɱ������DW�����λ��Ϊ��
                  DW(DW1(j)) = 0;
              end
          end
          LJD = find(DW);            % �����������һ�������ߵĽڵ�          
          Len_LJD = length(LJD);     % ��ѡ�ڵ�ĸ���
          
          while (W ~= E) && (Len_LJD >= 1) %��ÿ����������·��
              % ���̶ķ�ѡ����һ������ô��
              PP = zeros(Len_LJD);
              for i = 1:Len_LJD
                  PP(i) = (Tau(W,LJD(i))^Alpha)*((Eta(LJD(i))^Beta));
              end
              
              % �������ʷֲ�
              sumpp = sum(PP);   
              PP = PP/sumpp;
              Pcum(1) = PP(1); 
              for i = 2:Len_LJD
                  Pcum(i) = Pcum(i-1) + PP(i); % ǰn��;���
              end
              Select = find(Pcum >= rand);      
              to_visit = LJD(Select(1));       % ���ѡ����һ��       
              
              %״̬���ºͼ�¼
              Path = [Path,to_visit];          % ·������
              PLkm = PLkm + DD(W,to_visit);    % ·����������
              W = to_visit;                    % ����һ�ڵ�
              for kk = 1:N                     % ͨ�����ɱ���¾������
                  if TABUkm(kk) == 0
                      DD(W,kk) = 0;
                      DD(kk,W) = 0;
                  end
              end
              TABUkm(W) = 0;                   % �ѷ��ʵĴӽڵ���ɾ��
              DW = DD(W,:);                    % ���¿��Է��ʵĽڵ�
              DW1 = find(DW);                  % ��һ������ǰ���ڵ������
              for j = 1:length(DW1)
                  if TABUkm(DW1(j)) == 0
                      DW(j) = 0;
                  end
              end
              LJD =find(DW);
              Len_LJD = length(LJD);           % ������ѡ�ڵ����
          end
          
          %��¼ÿһ��ÿֻ���ϵ���ʳ·�ߺͳ���
          ROUTES{k,m} = Path;
          if Path(end) == E
              PL(k,m) = PLkm;                  % ���г���
              if PLkm < minkl                  % �������·��״̬
                  mink = k;                    % ��¼������
                  minl = m;                    % ��¼���ϵı��
                  minkl = PLkm;                % ��¼���·���ĳ���
              end
          else
              PL(k,m) = 0;
          end
      end
      
      %������Ϣ��
      Delta_Tau = zeros(N,N);
      for m = 1:M
          if PL(k,m)
              ROUT = ROUTES{k,m};
              TS = length(ROUT) - 1; % �ƶ�����
              PL_km = PL(k,m);       % ·������
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
  
  %��ͼ
  plotif = 1;
  if plotif == 1
      % ���·���仯����ͼ
      minPL = zeros(K);
      for i = 1:K
          PLK = PL(i,:);
          Nonzero = find(PLK);
          PLKPLK = PLK(Nonzero);
          minPL(i) = min(PLKPLK);       %�ҵ����·��
      end
      figure(1)
      plot(minPL);
      hold on;
      grid on;
      title('�������߱仯����');
      xlabel('��������');
      ylabel('��С·������');
      
      % ���·������ͼ
      figure(2)
      % ���Ƶ�ͼ
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
      title('���������й켣');
      xlabel('����x');
      ylabel('����y');
      
      % ����·��
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
  if plotif2 == 1        % ������������ͼ
      figure(3);
      % ������ͼ
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
      
      % ���Ƹ�����������ͼ
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


      
 