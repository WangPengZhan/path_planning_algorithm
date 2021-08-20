function pop2=decodechrom(pop,spoint,length)
% 将二进制编码转化成十进制（可以设定起始位置和长度）
pop1 = pop(:,spoint:spoint + length - 1);
pop2 = decodebinary(pop1);
end