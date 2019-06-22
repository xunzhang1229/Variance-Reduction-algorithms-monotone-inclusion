%%%%saga
%%%%%SAGA
%%%%saga
times=40;
T=40000;
Ave_saga=zeros(times,T+1);
theta_saga=zeros(2,T+1);
omega_saga=zeros(2,T+1);
residual_saga=zeros(1,T+1);
gamma=1/20;
for time=1:times
    
 theta_saga(:,1)=theta_0;
 omega_saga(:,1)=omega_0;
 %%try 1/500;1/1500;1/2500;
 residual_saga(1)=(norm(theta_0-theta_star)^2+norm(omega_0-omega_star)^2);
 %%%initial proxies value
Phi_1=zeros(2,2000);
Phi_2=zeros(2,2000);
%for i=1:2000
    %Phi_1(:,i)=rho*theta_0-A(:,:,i)'*omega_0;
    %Phi_2(:,i)=omega_0+A(:,:,i)*theta_0-b(:,i);
%end
%%%

 for k=1:T
     i=randi(2000);
     d1=rho*theta_saga(:,k)-A(:,:,i)'*omega_saga(:,k)-Phi_1(:,i)+mean(Phi_1,2);
     d2=omega_saga(:,k)+A(:,:,i)*theta_saga(:,k)-b(:,i)-Phi_2(:,i)+mean(Phi_2,2);
     theta=theta_saga(:,k)-gamma*d1;%%update points
     omega=omega_saga(:,k)-gamma*d2;%%update points
     theta_saga(:,k+1)=theta;
     omega_saga(:,k+1)=omega;
     Phi_1(:,i)=rho*theta-A(:,:,i)'*omega;%%%update proxies
     Phi_2(:,i)=omega+A(:,:,i)*theta-b(:,i);%%%update proxies
    residual_saga(k+1)=norm(theta-theta_star)^2+norm(omega-omega_star)^2;
 end
    
    Ave_saga(time,:)=residual_saga;
    
    
end
Ave_saga=mean(Ave_saga);






 index_saga=1000:1000:T;
 index_saga=[0,index_saga];

residual_pass_saga=Ave_saga(1000:1000:T);
residual_pass_saga=[norm(theta_0-theta_star)^2+norm(omega_0-omega_star)^2,residual_pass_saga]
index_saga=index_saga/2000;

plot(index_svrg,log(residual_pass_svrg),index_svrgr_i,log(y),index_svrg_i,log(residual_pass_svrg_i),index_saga,log(residual_pass_saga),index_hsvrgr_i,log(yy),index_sgd,log(residual_pass_sgd))
legend('z=svrg','svrgri','svrg i','saga','hsvrgr','sgd')
xlabel('number of full pass')
ylabel('log(|x_t-x* |^2)')


%----------------------------------------------------------------------



plot(index_svrg(1:32),log(residual_pass_svrg(1:32)),index_saga,log(residual_pass_saga),index_svrg_i(1:18),log(residual_pass_svrg_i(1:18)),index_svrgr_i(1:41),log(y(1:41)),index_hsvrgr_i,log(yy),index_sgd(1:41),log(residual_pass_sgd(1:41)))
legend('svrg','saga','svrg increasing epochs','svrg random epochs','saga+svrg random','sgd')
xlabel('number of operator evaluations/n')
ylabel('log(|x_k-x* |^2)')


