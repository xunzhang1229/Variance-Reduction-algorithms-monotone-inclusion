%%%svrg 

times=10;
T=30000;
Ave_svrg=zeros(times,T+1)
theta_svrg=zeros(2,T+1);
omega_svrg=zeros(2,T+1);
residual_svrg=zeros(1,T+1);
gamma=1/20;
for time=1:times
    
 theta_svrg(:,1)=theta_0;
 omega_svrg(:,1)=omega_0;
 %%try 1/500;1/1500;1/2500;
 residual_svrg(1)=(norm(theta_0-theta_star)^2+norm(omega_0-omega_star)^2);
 %%%initial proxies value
Phi_1=zeros(2,2000);
Phi_2=zeros(2,2000);
for i=1:2000
    Phi_1(:,i)=rho*theta_0-A(:,:,i)'*omega_0;
    Phi_2(:,i)=omega_0+A(:,:,i)*theta_0-b(:,i);
end
%%%

 for k=1:T
     i=randi(2000);
     d1=rho*theta_svrg(:,k)-A(:,:,i)'*omega_svrg(:,k)-Phi_1(:,i)+mean(Phi_1,2);
     d2=omega_svrg(:,k)+A(:,:,i)*theta_svrg(:,k)-b(:,i)-Phi_2(:,i)+mean(Phi_2,2);
     theta=theta_svrg(:,k)-gamma*d1;%%update points
     omega=omega_svrg(:,k)-gamma*d2;%%update points
     theta_svrg(:,k+1)=theta;
     omega_svrg(:,k+1)=omega;
     if mod(k+1,4000)==0
         for j=1:2000
             Phi_1(:,j)=rho*theta-A(:,:,j)'*omega;%%%update proxies
             Phi_2(:,j)=omega+A(:,:,j)*theta-b(:,j);%%%update proxies
         end
     end
     residual_svrg(k+1)=norm(theta-theta_star)^2+norm(omega-omega_star)^2;
 end
    
    Ave_svrg(time,:)=residual_svrg;
    
    
end
Ave_svrg=mean(Ave_svrg);






 index_svrg=[0];
for q=500:500:T
  index_svrg=[index_svrg,2*q+2000*floor(q/4000)+2000;];
    
end

residual_pass_svrg=Ave_svrg(500:500:T);
residual_pass_svrg=[norm(theta_0-theta_star)^2+norm(omega_0-omega_star)^2,residual_pass_svrg]
index_svrg=index_svrg/2000;



plot(index_svrg,log(residual_pass_svrg),index_svrgr_i,log(y),index_svrg_i,log(residual_pass_svrg_i),index_saga,log(residual_pass_saga),index_hsvrgr_i,log(yy),index_sgd,log(residual_pass_sgd))
legend('z=svrg','svrgri','svrg i','saga','hsvrgr','sgd')
xlabel('number of full pass')
ylabel('log(|x_t-x* |^2)')

plot(index_svrg(1:32),log(residual_pass_svrg(1:32)),index_saga,log(residual_pass_saga),index_svrg_i(1:18),log(residual_pass_svrg_i(1:18)),index_svrgr_i(1:41),log(y(1:41)),index_hsvrgr_i,log(yy),index_sgd(1:41),log(residual_pass_sgd(1:41)))
legend('svrg','saga','svrg increasing epochs','svrg random epochs','saga+svrg random','sgd')
xlabel('number of operator evaluations/n')
ylabel('log(|x_k-x* |^2)')
