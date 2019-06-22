%%%sgd

times=10;
T=60000;
Ave_sgd=zeros(times,T+1);
theta_sgd=zeros(2,T+1);
omega_sgd=zeros(2,T+1);
residual_sgd=zeros(1,T+1);
gamma=1/10;

for time=1:times
    
 theta_sgd(:,1)=theta_0;
 omega_sgd(:,1)=omega_0;
 %%try 1/500;1/1500;1/2500;
 residual_sgd(1)=(norm(theta_0-theta_star)^2+norm(omega_0-omega_star)^2);
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
     d1=rho*theta_sgd(:,k)-A(:,:,i)'*omega_sgd(:,k);
     d2=omega_sgd(:,k)+A(:,:,i)*theta_sgd(:,k)-b(:,i);
     theta=theta_sgd(:,k)-gamma*d1;%%update points
     omega=omega_sgd(:,k)-gamma*d2;%%update points
     theta_sgd(:,k+1)=theta;
     omega_sgd(:,k+1)=omega;
    residual_sgd(k+1)=norm(theta-theta_star)^2+norm(omega-omega_star)^2;
 end
    
    Ave_sgd(time,:)=residual_sgd
    
    
end
Ave_sgd=mean(Ave_sgd);






 index_sgd=1000:1000:T;
 index_sgd=[0,index_sgd];

residual_pass_sgd=Ave_sgd(1000:1000:T);
residual_pass_sgd=[norm(theta_0-theta_star)^2+norm(omega_0-omega_star)^2,residual_pass_sgd]
index_sgd=index_sgd/2000;


plot(index_sgd,log(residual_pass_sgd))

%----------------------------------------------------------------------




plot(index_svrg(1:32),log(residual_pass_svrg(1:32)),index_saga,log(residual_pass_saga),index_svrg_i(1:18),log(residual_pass_svrg_i(1:18)),index_svrgr_i(1:41),log(y(1:41)),index_hsvrgr_i,log(yy),index_sgd(1:41),log(residual_pass_sgd(1:41)))
legend('SVRG','SAGA','SVRG++','SVRG-rand','SAGA+SVRG-rand','SG')
xlabel('number of operator evaluations/n')
ylabel('log(|x_k-x* |^2)')


theta_0=theta_sgd(:,2000);
omega_0=theta_sgd(:,2000);
