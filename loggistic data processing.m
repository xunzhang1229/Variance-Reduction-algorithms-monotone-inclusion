%%%logistic regression on real dataset
%%fi(x)=log(1+exp(-bi*ai'*x))
%%fi'(x)=exp(-b(i)*A(:,i)'*x)*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x))+lambda*x
%%%   min 1/n sum_{i=1}^n f_i(x)+\lambda/2 |x |^2
A=phytrain(:,3:80);
A=A';
b=phytrain(:,2);
b=b';
x_0=rand(78,1);
b=2*b-1;
%%%normalize

for i=1:50000
   A(:,i)=(A(:,i)-mean(A(:,i)))/(sqrt(var(A(:,i)))); 
end


%%5
numer=zeros(1,200000);
for i=1:200000
   j=randi(50000);
   k=randi(T);
  xxx=exp(-b(j)*A(:,j)'*x_0)*(-b(j)*A(:,j))/(1+exp(-b(j)*A(:,j)'*x_0))+lambda*x_0;
  tr=rand(78,1);
   yyy= exp(-b(j)*A(:,j)'*tr)*(-b(j)*A(:,j))/(1+exp(-b(j)*A(:,j)'*tr))+lambda*tr;
 
   number(i)= norm(xxx-yyy)/(norm(x_0-tr));
end
max(number)
%%%


norm(A(:,1))
















%%%------------------------SGD
x_0=rand(78,1);
T=2500000;
lambda=10^(-4);
gamma=1;
%%%-------------------------------------------------
x_sgd=zeros(78,T+1);
x_sgd(:,1)=x_0;
residual_sgd=zeros(1,T);
residual_sgd(1)=norm(x_0-x_star)^2;
index_sgd=zeros(1,T+1);
Phi=zeros(78,50000);
value=zeros(1,50000);

for k=1:T
    i=randi(50000);
    x=x_sgd(:,k)-(0.01)*(exp(-b(i)*A(:,i)'*x_sgd(:,k))*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x_sgd(:,k)))+lambda*x_sgd(:,k));
    x_sgd(:,k+1)=x;
    residual_sgd(k+1)=norm(x-x_star)^2;
end
%plot(residual_sgd)
%x_sgd(:,T-10:T)
index_sgd=(0:2500000)/50000;


plot(index_sgd,log(residual_sgd))