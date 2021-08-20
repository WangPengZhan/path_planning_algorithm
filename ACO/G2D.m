function D=G2D(G)
% 计算从一个方格到邻近方格的距离，此函数可以优化的
    l=size(G,1); 
    D=zeros(l*l,l*l); 
    for i=1:l 
        for j=1:l 
            if G(i,j)==0 
                for m=1:l 
                    for n=1:l 
                        if G(m,n)==0                                  % 选择可以到达的方格
                            im=abs(i-m);jn=abs(j-n); 
                            if im+jn==1||(im==1&&jn==1)               % 前表示相邻方格（上下左右） 后表示对角方格（左上，右上，左下，右下）
                                D((i-1)*l+j,(m-1)*l+n)=(im+jn)^0.5;   % 相邻方格距离为1，对角方格距离为2^0.5,这里是简化的
                            end                                       % 此时还利用了a*max+b来确定位置（a，b）的技巧
                        end                                           % 到其他方格的距离为零，方便操作
                    end 
                end 
            end 
        end 
    end