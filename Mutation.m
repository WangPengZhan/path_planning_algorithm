function a = Mutation(A)
% ±äÒì
nnper = randperm(size(A,2));
index1 = nnper(1);
index2 = nnper(2);
temp = A(index1);
A(index1) = A(index2);
A(index2) = temp;
a = A;
