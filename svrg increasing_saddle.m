%%%%svrg increasing



T=40000;
Ave_svrg_i=zeros(times,T+1);
 theta_svrg_i=zeros(2,T+1);
omega_svrg_i=zeros(2,T+1);
residual_svrg_i=zeros(1,T+1);
gamma=1/20
%gamma=1/4000;
 index_svrg_i=zeros(1,T+1);
for time=1:10

  times_of_full=1;
 theta_svrg_i(:,1)=theta_0;
 omega_svrg_i(:,1)=omega_0;
%%try 1/500;1/1500;1/2500;
 residual_svrg_i(1)=(norm(theta_0-theta_star)^2+norm(omega_0-omega_star)^2);
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
     d1=rho*theta_svrg_i(:,k)-A(:,:,i)'*omega_svrg_i(:,k)-Phi_1(:,i)+mean(Phi_1,2);
     d2=omega_svrg_i(:,k)+A(:,:,i)*theta_svrg_i(:,k)-b(:,i)-Phi_2(:,i)+mean(Phi_2,2);
     theta=theta_svrg_i(:,k)-gamma*d1;%%update points
     omega=omega_svrg_i(:,k)-gamma*d2;%%update points
     theta_svrg_i(:,k+1)=theta;
     omega_svrg_i(:,k+1)=omega;
     if abs((k+1-(1/1)*4000*(2^(times_of_full)-1)))<0.5
         for j=1:2000
             Phi_1(:,j)=rho*theta-A(:,:,j)'*omega;%%%update proxies
             Phi_2(:,j)=omega+A(:,:,j)*theta-b(:,j);%%%update proxies
         end
         times_of_full=times_of_full+1;
         k
     end
     residual_svrg_i(k+1)=norm(theta-theta_star)^2+norm(omega-omega_star)^2;
     index_svrg_i(k)=2*k+(times_of_full-1)*2000+2000;
 end
    
    Ave_svrg_i(time,:)=residual_svrg_i
    
    
end
Ave_svrg_i=mean(Ave_svrg_i);

residual_pass_svrg_i=residual_svrg_i(1000:1000:T);
residual_pass_svrg_i=[norm(theta_0-theta_star)^2+norm(omega_0-omega_star)^2,residual_pass_svrg_i];
index_svrg_i=index_svrg_i(1000:1000:T)/2000;
index_svrg_i=[0,index_svrg_i]




plot(index_svrg,log(residual_pass_svrg),index_svrgr_i,log(y),index_svrg_i,log(residual_pass_svrg_i),index_saga,log(residual_pass_saga),index_hsvrgr_i,log(yy),index_sgd,log(residual_pass_sgd))
legend('z=svrg','svrgri','svrg i','saga','hsvrgr','sgd')
xlabel('number of full pass')
ylabel('log(|x_t-x* |^2)')

plot(index_svrg(1:32),log(residual_pass_svrg(1:32)),index_saga,log(residual_pass_saga),index_svrg_i(1:18),log(residual_pass_svrg_i(1:18)),index_svrgr_i(1:41),log(y(1:41)),index_hsvrgr_i,log(yy),index_sgd(1:41),log(residual_pass_sgd(1:41)))
legend('svrg','saga','svrg increasing epochs','svrg random epochs','saga+svrg random','sgd')
xlabel('number of operator evaluations/n')
ylabel('log(|x_k-x* |^2)')

