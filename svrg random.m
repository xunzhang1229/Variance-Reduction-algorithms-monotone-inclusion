%%%svrg random decreasing

times=1;
T=40000;
%Ave_svrgr_i=[];
theta_svrgr_i=zeros(2,T+1);
omega_svrgr_i=zeros(2,T+1);
residual_svrgr_i=zeros(1,T+1);
gamma=1/20;




for time=1:times
 index_svrgr_i=zeros(1,T+1);
 
 y=zeros(1,T/1000);
 time_when_full=0;
 theta_svrgr_i(:,1)=theta_0;
 omega_svrgr_i(:,1)=omega_0;
%%try 1/500;1/1500;1/2500;
 residual_svrgr_i(1)=(norm(theta_0-theta_star)^2+norm(omega_0-omega_star)^2);
 %%%initial proxies value
Phi_1=zeros(2,2000);
Phi_2=zeros(2,2000);
%for i=1:2000
 %   Phi_1(:,i)=rho*theta_0-A(:,:,i)'*omega_0;
  %  Phi_2(:,i)=omega_0+A(:,:,i)*theta_0-b(:,i);
%end
    
t=0;
tt=0;


 for k=1:T
     i=randi(2000);
     d1=rho*theta_svrgr_i(:,k)-A(:,:,i)'*omega_svrgr_i(:,k)-Phi_1(:,i)+mean(Phi_1,2);
     d2=omega_svrgr_i(:,k)+A(:,:,i)*theta_svrgr_i(:,k)-b(:,i)-Phi_2(:,i)+mean(Phi_2,2);
     theta=theta_svrgr_i(:,k)-gamma*d1;%%update points
     omega=omega_svrgr_i(:,k)-gamma*d2;%%update points
     theta_svrgr_i(:,k+1)=theta;
     omega_svrgr_i(:,k+1)=omega;
     u= rand(1);
     if  (((u<= (1/4000))*(T*0.1/(k+T*0.1))& k>4000) |k- time_when_full>16000| (u<1/T)&k<=2000)
         for j=1:2000
             Phi_1(:,j)=rho*theta-A(:,:,j)'*omega;%%%update proxies
             Phi_2(:,j)=omega+A(:,:,j)*theta-b(:,j);%%%update proxies
         end
         t=t+1;
         time_when_full=k
     end
    
     index_svrgr_i(:,k+1)=2*k+t*2000;
     residual_svrgr_i(:,k+1)=norm(theta-theta_star)^2+norm(omega-omega_star)^2;
 end
 
%plot( index_svrgr_i/2000,log(residual_svrgr_i))

for i=1000:1000:(T)
    j=find(index_svrgr_i>=i,1,'first');
    y(i/1000)=residual_svrgr_i(j);
end

%Ave_svrgr_i=[Ave_svrgr_i;y]


end


index_svrgr_i=1000:1000:(T);
%y=residual_svrgr_i(1000:1000:(T))
index_svrgr_i=[0,index_svrgr_i];
%y=median(Ave_svrgr_i);
index_svrgr_i=index_svrgr_i/2000;
y=[norm(theta_0-theta_star)^2+norm(omega_0-omega_star)^2,y];



plot(index_svrg,log(residual_pass_svrg),index_svrgr_i,log(y),index_svrg_i,log(residual_pass_svrg_i),index_saga,log(residual_pass_saga),index_hsvrgr_i,log(yy),index_sgd,log(residual_pass_sgd))
legend('z=svrg','svrgri','svrg i','saga','hsvrgr','sgd')
xlabel('number of full pass')
ylabel('log(|x_t-x* |^2)')


plot(index_svrg(1:32),log(residual_pass_svrg(1:32)),index_saga,log(residual_pass_saga),index_svrg_i(1:18),log(residual_pass_svrg_i(1:18)),index_svrgr_i(1:41),log(y(1:41)),index_hsvrgr_i,log(yy),index_sgd(1:41),log(residual_pass_sgd(1:41)))
legend('svrg','saga','svrg increasing epochs','svrg random epochs','saga+svrg random','sgd')
xlabel('number of operator evaluations/n')
ylabel('log(|x_k-x* |^2)')

%Ave_svrgr_i=[Ave_svrgr_i;y]
%y=median(Ave_svrgr_i)