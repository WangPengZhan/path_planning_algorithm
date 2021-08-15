function fitness=fit(len,m,maxlen,minlen)
%ÊÊÓ¦¶Èº¯Êı
fitness = len;
for i = 1:length(len)
    fitness(i,1) = (1-(len(i,1) - minlen)/(maxlen - minlen +0.0001)).^m;
end