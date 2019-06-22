

%%%------------------------SGD

T=2500000;
lambda=10^(-4);
gamma=0.1;
%x_0=rand(78,1);
%%%-------------------------------------------------
x_sgd=zeros(78,T+1);
x_sgd(:,1)=x_0;
residual_sgd=zeros(1,T);
residual_sgd(1)=norm(x_0-x_star)^2;
index_sgd=zeros(1,T+1);
Phi=zeros(78,50000);
value=zeros(1,50000);
Ave_sgd=[]
for t=1:10
for k=1:T
    i=randi(50000);
    x=x_sgd(:,k)-(gamma)*(exp(-b(i)*A(:,i)'*x_sgd(:,k))*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x_sgd(:,k)))+lambda*x_sgd(:,k));
    x_sgd(:,k+1)=x;
    residual_sgd(k+1)=norm(x-x_star)^2;
end
Ave_sgd=[Ave_sgd; residual_sgd];
end
residual_sgd=mean(Ave_sgd);
%plot(residual_sgd)
%x_sgd(:,T-10:T)
index_sgd=(25000:25000:T)/50000;
residual_sgd=residual_sgd(25000:25000:T);
index_sgd=[0,index_sgd];
residual_sgd=[norm(x_0-x_star)^2,residual_sgd];


plot(index_svrg(1:800),log(residual_svrg(1:800)), index_saga(1:2000),log(residual_saga(1:2000)),index_svrgi(1:855),log(residual_svrgi(1:855)),index_svrgri(1:2000),log(y(1:2000)),index_hsvrgri(1:2000),log(yy(1:2000)),index_sgd(1:80),log(residual_sgd(1:80)))
legend('svrg','saga','svrg increasing epochs','svrg random epochs','saga+svrg random','sgd')
xlabel('number of operator evaluations/n')
ylabel('log(|x_k-x* |^2)')
%xx_0=x_0;