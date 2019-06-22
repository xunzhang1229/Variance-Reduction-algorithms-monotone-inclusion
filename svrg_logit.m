Ave_svrg=[];
T=1000000;
gamma=1/9;
lambda=10^(-4);
%x_0=x_sgd(:,2000);
%%%-------------------------------------------------SVRG 
x_svrg=zeros(78,T+1);
x_svrg(:,1)=x_0;
residual_svrg=zeros(1,T+1);
residual_svrg(1)=norm(x_0-x_star)^2;
index_svrg=zeros(1,T+1);
Phi=zeros(78,50000);

for t=1:1
for i=1:50000
    Phi(:,i)=exp(-b(i)*A(:,i)'*x_0)*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x_0))+lambda*x_0;
end
v=mean(Phi,2);
for k=1:T
    i=randi(50000);
    x=x_svrg(:,k)-gamma*(exp(-b(i)*A(:,i)'*x_svrg(:,k))*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x_svrg(:,k)))+lambda*x_svrg(:,k)-Phi(:,i)+v);
    x_svrg(:,k+1)=x;
    if (mod(k+1,100000)==0)
        for j=1:50000
            Phi(:,j)=exp(-b(j)*A(:,j)'*x)*(-b(j)*A(:,j))/(1+exp(-b(j)*A(:,j)'*x))+lambda*x;
        end
        v=mean(Phi,2);
    end
    residual_svrg(k+1)=norm(x-x_star)^2;
    index_svrg(k+1)=50000+2*k+50000*floor(k/100000);
end
Ave_svrg=[Ave_svrg;residual_svrg];
end
%residual_svrg=mean(Ave_svrg);

index_svrg=index_svrg/50000;
index_svrg(1)=0;
plot(index_svrg,log(residual_svrg))
%x_star=x;
index_svrg=index_svrg(1000:1000:T);
index_svrg=[0,index_svrg];
residual_svrg=residual_svrg(1000:1000:T);
residual_svrg=[norm(x_0-x_star)^2,residual_svrg];
plot(index_svrg,log(residual_svrg),index_sgd,log(residual_sgd))
