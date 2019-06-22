%%%%%SAGA
Ave_saga=[];
T=2500000;
gamma=1/9;
x_saga=zeros(78,T+1);
%x_0=x_sgd(:,5000);
x_saga(:,1)=x_0;
residual_saga=zeros(1,T+1);
residual_saga(1)=norm(x_0-x_star)^2;
Phi=zeros(78,50000);
for i=1:50000
    Phi(:,i)=exp(-b(i)*A(:,i)'*x_0)*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x_0))+lambda*x_0;
end
v=mean(Phi,2);

for t=1:10%%%run 10times
for i=1:50000
  Phi(:,i)=exp(-b(i)*A(:,i)'*x_0)*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x_0))+lambda*x_0;
end
v=mean(Phi,2);
for k=1:T
    i=randi(50000);
    x=x_saga(:,k)-gamma*(exp(-b(i)*A(:,i)'*x_saga(:,k))*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x_saga(:,k)))+lambda*x_saga(:,k)-Phi(:,i)+v);
    x_saga(:,k+1)=x;
    u=exp(-b(i)*A(:,i)'*x)*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x))+lambda*x;
    delta=u-Phi(:,i);
    v=v+delta/50000; 
    Phi(:,i)=u;
    residual_saga(k+1)=norm(x-x_star)^2;
end
Ave_saga=[Ave_saga;residual_saga];
end

residual_saga=mean(Ave_saga)


 index_saga=0:2500000;
 index_saga=index_saga/50000;
 %plot(index_svrg,log(residual_svrg), index_saga,log(residual_saga),index_sgd,log(residual_sgd))
 
 
 %%%_---------------------------------
 
index_saga=index_saga(1000:1000:T);
index_saga=[0,index_saga];
residual_saga=residual_saga(1000:1000:T);
residual_saga=[norm(x_0-x_star)^2,residual_saga];
plot(index_svrg,log(residual_svrg),index_sgd(1:2000),log(residual_sgd(1:2000)),index_saga,log(residual_saga))