function pop2=decodechrom(pop,spoint,length)
% �������Ʊ���ת����ʮ���ƣ������趨��ʼλ�úͳ��ȣ�
pop1 = pop(:,spoint:spoint + length - 1);
pop2 = decodebinary(pop1);
end