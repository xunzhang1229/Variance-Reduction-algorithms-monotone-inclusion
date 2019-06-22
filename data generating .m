%%%%Data generating 2
n=2000;
s=zeros(1,n+1);
s(1)=1;
r=zeros(1,n);
%r(1)=-3;

for i=2:n+1
    if(s(i-1)==101)
        s(i)=1;
        r(i-1)=0;
    elseif (s(i-1)==100)
        s(i)=101;
        r(i-1)=-2;
    else 
        s(i)=randsample([s(i-1)+1,s(i-1)+2],1,true,[0.5,0.5]);
        if (s(i)==101)
            r(i-1)=0;
        else
            r(i-1)=-3;
        end
    end
end
s
phi=[1,0];
for i=1:100
    phi=[phi;1-i/100,i/100];
end


 gamma=0.95;
 A=ones(2,2,n);
 b=ones(2,n);
 C=ones(2,2,n);
 for i=1:n
     if (s(i)==101)
         A(:,:,i)=phi(101,:)'*(phi(101,:)-gamma*phi(101,:));
         b(:,i)=r(i)*phi(101,:)';
         C(:,:,i)=phi(101,:)'*phi(101,:);
     else 
         A(:,:,i)=phi(s(i),:)'*(phi(s(i),:)-gamma*phi(s(i+1),:));
         b(:,i)=r(i)*phi(s(i),:)';
         C(:,:,i)=phi(s(i),:)'*phi(s(i),:);
     end
 end

 C_hat=mean(C,3)
 
 %compute optimal
b_hat=mean(b,2);
A_hat=mean(A,3);
rho=0.01;
theta_star=(A_hat'*A_hat+rho*eye(2))^(-1)*A_hat'*b_hat;
omega_star=-(A_hat*theta_star-b_hat);
% compute optimal

%%%%initial value of theta and omega
theta_0=rand(2,1);
omega_0=rand(2,1);


number=zeros(1,100000)
for i=1:10000
xx=0.1*rand(2,1);
yy=0.1*rand(2,1);
x=0.1*rand(2,1);
y=0.1*rand(2,1);
d1=rho*x-A_hat'*y;
d2=y+A_hat*x-b_hat;
d11=rho*xx-A_hat'*yy;
d22=yy+A_hat*xx-b_hat;
number(i)=(norm(d11-d1)^2+norm(d2-d22)^2)/(norm(xx-x)^2+norm(yy-y)^2);
end
max(number)
%%%L=1

 L=0;
 for i=1:n
  if max(eig(2*eye(2)+A(:,:,i)'*A(:,:,i)))>L
      L=max(eig(2*eye(2)+A(:,:,i)'*A(:,:,i)));
  end
 end
 L
 max(eig(A_hat'*C_hat^(-1)*A_hat))