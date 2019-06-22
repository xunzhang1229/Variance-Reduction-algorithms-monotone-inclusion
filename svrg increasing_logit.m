
%increasing
Ave_svrgi=[];
T=1200000;
gamma=1/9;
x_svrgi=zeros(78,T+1);
x_svrgi(:,1)=x_0;
residual_svrgi=zeros(1,T+1);
residual_svrgi(1)=norm(x_0-x_star)^2;
index_svrgi=zeros(1,T+1);
Phi=zeros(78,50000);
for t=1:10
times_of_full=1;
for i=1:50000
    Phi(:,i)=exp(-b(i)*A(:,i)'*x_0)*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x_0))+lambda*x_0;
end
v=mean(Phi,2);
for k=1:T
    i=randi(50000);
    x=x_svrgi(:,k)-gamma*(exp(-b(i)*A(:,i)'*x_svrgi(:,k))*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x_svrgi(:,k)))+lambda*x_svrgi(:,k)-Phi(:,i)+v);
    x_svrgi(:,k+1)=x;
   if abs((k+1-(1/1)*50000*(2^(times_of_full)-1)))<0.5
        for j=1:50000
            Phi(:,j)=exp(-b(j)*A(:,j)'*x)*(-b(j)*A(:,j))/(1+exp(-b(j)*A(:,j)'*x))+lambda*x;
        end
         times_of_full=times_of_full+1
         k
         v=mean(Phi,2);
    end
    residual_svrgi(k+1)=norm(x-x_star)^2;
    index_svrgi(k+1)=2*k+(times_of_full)*50000;
end
Ave_svrgi=[Ave_svrgi;residual_svrgi];
end
residual_svrgi=mean(Ave_svrgi);
index_svrgi=index_svrgi/50000;


 
 
 
index_svrgi=index_svrgi(1000:1000:T);
index_svrgi=[0,index_svrgi];
residual_svrgi=residual_svrgi(1000:1000:T);
residual_svrgi=[norm(x_0-x_star)^2,residual_svrgi]; 

plot(index_svrg,log(residual_svrg), index_saga,log(residual_saga),index_svrgi,log(residual_svrgi),index_svrgri,log(y),index_sgd,log(residual_sgd))
 legend('svrg','saga','svrg increasing','svrg random epochs','sgd')