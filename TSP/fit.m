function fitness=fit(len,m,maxlen,minlen)
%锟斤拷应锟饺猴拷锟斤拷
fitness = len;
for i = 1:length(len)
    fitness(i,1) = (1-(len(i,1) - minlen)/(maxlen - minlen +0.0001)).^m;
end