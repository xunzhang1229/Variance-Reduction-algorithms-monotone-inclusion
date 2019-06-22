%%%svrg random decreasing pk
Ave_svrgri=[];

for times=1:10

T=1200000;
gamma=1/9;
lambda=10^(-4);;
x_svrgri=zeros(78,T+1);
x_svrgri(:,1)=x_0;
residual_svrgri=zeros(1,T+1);
index_svrgri=zeros(1,T+1);
 %Ave_svrgri=[]

time_when_full=0;
t=0;
y=zeros(1,T/500+1);
y(1)=norm(x_0-x_star)^2;
Phi=zeros(78,50000);
%for i=1:2000
 %   Phi(:,i)=exp(-b(i)*A(:,i)'*x_0)*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x_0))+lambda*x_0;
%end
v=mean(Phi,2);
for k=1:T
    i=randi(50000);
    x=x_svrgri(:,k)-gamma*(exp(-b(i)*A(:,i)'*x_svrgri(:,k))*(-b(i)*A(:,i))/(1+exp(-b(i)*A(:,i)'*x_svrgri(:,k)))+lambda*x_svrgri(:,k)-Phi(:,i)+v);
    x_svrgri(:,k+1)=x;
    u= rand(1);
    if ((u<= (1/100000)*(T*0.1/(k+T*0.1)) & k>=50000)|(k-time_when_full>100000*3) | u<=1/T & k<=50000)
    %if (u<= (1/100000)*(T*0.5/(k+T*0.5)))
        for j=1:50000
            Phi(:,j)=exp(-b(j)*A(:,j)'*x)*(-b(j)*A(:,j))/(1+exp(-b(j)*A(:,j)'*x))+lambda*x;
        end
        t=t+1;
        time_when_full=k
        v=mean(Phi,2);
    end
    residual_svrgri(k+1)=norm(x-x_star)^2;
    index_svrgri(k+1)=2*k+50000*t;

end

    
   for i=1000:1000:(2*T)
    j=find(index_svrgri>=i,1,'first');
    y(i/1000+1)=residual_svrgri(j);
   end
   
   
  Ave_svrgri=[ Ave_svrgri;y]
  
  
end
 y=mean(Ave_svrgri)
 index_svrgri=(1000:1000:(2*T))/50000;
 index_svrgri=[ 0,index_svrgri];
   
   
 plot(index_svrg,log(residual_svrg), index_saga,log(residual_saga),index_svrgi,log(residual_svrgi),index_svrgri,log(y))
 legend('svrg','saga','svrg increasing','svrgr')
 

 
 
 
 