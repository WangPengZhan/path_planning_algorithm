function pop=initpop(popsize,chromlength)
%rand随机产生每个单元为{1,0}行数为popsize，列数为chromlength的矩阵，round进行圆整
pop = round(rand(popsize,chromlength));
