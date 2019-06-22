%%%hybrid algorithm
Ave_hsvrgr=[];

T=2500000;
gamma=1/9;
lambda=10^(-4);;

x_hsvrgri=zeros(78,T+1);
x_hsvrgri(:,1)=x_0;
residual_hsvrgri=zeros(1,T+1);
index_hsvrgri=zeros(1,T+1);


for t=1:10
yy=zeros(1,T/1000+1);
yy(1)=norm(x_0-x_star)^2;
time_when_full=0;
t=0;
tt=0;
Phi=zeros(78,50000);
%for i=1:2000
 %   Phi(:,i)=exp(-b(i)*A(:,i)'*x_0)*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x_0))+lambda*x_0;
%end
v=mean(Phi,2);
for k=1:T
    i=randi(50000);
    x=x_hsvrgri(:,k)-gamma*(exp(-b(i)*A(:,i)'*x_hsvrgri(:,k))*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x_hsvrgri(:,k)))+lambda*x_hsvrgri(:,k)-Phi(:,i)+v);
    x_hsvrgri(:,k+1)=x;
    u= rand(1);
    %if (u<= (1/100000)*(T*0.1/(k+T*0.1)))|(k-time_when_full>100000*1.2^t) 
    if (u<= (1/100000)*(T*0.4/(k+T*0.4)))
        for j=1:25000
            Phi(:,j)=exp(-b(j)*A(:,j)'*x)*(-b(j)*A(:,j))/(1+exp(-b(j)*A(:,j)'*x))+lambda*x;
        end
        t=t+1;
        time_when_full=k
        v=mean(Phi,2);
    end
    if i>25000
        u=exp(-b(i)*A(:,i)'*x)*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x))+lambda*x;
        delta=u-Phi(:,i);
        v=v+delta/50000; 
        Phi(:,i)=u;
        tt=tt+1;
    end
    residual_hsvrgri(k+1)=norm(x-x_star)^2;
    index_hsvrgri(k+1)=2*t+k-t+25000*t;

end
%plot(log(residual_hsvrgri))
    
 for i=1000:1000:(T)
   j=find(index_hsvrgri>=i,1,'first');
   yy(i/1000+1)=residual_hsvrgri(j);
 end

Ave_hsvrgr=[Ave_hsvrgr;yy]  ; 
end
yy=mean(Ave_hsvrgr);

yy_v=yy(2:2501)
yy=yy_v(25:25:2500)
yy=[norm(x_0-x_star)^2,yy]
index_hsvrgri=(25000:25000:T)/50000;
index_hsvrgri=[ 0,index_hsvrgri];
plot(index_svrg(1:800),log(residual_svrg(1:800)), index_saga(1:2000),log(residual_saga(1:2000)),index_svrgi(1:855),log(residual_svrgi(1:855)),index_svrgri(1:2000),log(y(1:2000)),index_hsvrgri(1:80),log(yy(1:80)),index_sgd(1:80),log(residual_sgd(1:80)))
legend('SVRG','SAGA','SVRG++','SVRG-rand','SAGA+SVRG-rand','SG')
xlabel('number of operator evaluations/n')
ylabel('log(|x_k-x* |^2)')