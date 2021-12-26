function X_hat=Richardson_decoder(Y,H,sigma2,Nt,N_iter,num)
H_real=[real(H) -imag(H);imag(H) real(H)];
Y_real=[real(Y);imag(Y)];
Y_MF=H_real'*Y_real;
Gram=H_real'*H_real;
A=Gram+sigma2*eye(2*Nt);
D=eig(A);
max_eig=max(D);
min_eig=min(D);
%w=0.00645;
w=2/(max_eig+min_eig);
%count the initial solution
s0=zeros(2*Nt,num);
P_temp=Y_MF-A*(4/sqrt(42))*ones(2*Nt,num);
N_temp=Y_MF+A*(4/sqrt(42))*ones(2*Nt,num);
for i=1:2*Nt
    if Y_MF(i)>0
        if P_temp(i)>0
           s0(i)=(6/sqrt(42));
        elseif P_temp(i)<0
           s0(i)=(2/sqrt(42));
        else
            s0(i)=(4/sqrt(42));
        end
    elseif Y_MF(i)<0
        if N_temp(i)>0
           s0(i)=(-2/sqrt(42));
        elseif N_temp(i)<0
           s0(i)=(-6/sqrt(42));
        else
            s0(i)=(-4/sqrt(42));
        end
    end
end
s=(eye(2*Nt)-w*A)*s0+w*Y_MF;
i_iter=1;
while (norm(s-s0)>1e-5 && i_iter<N_iter)
    s0=s;
    s=(eye(2*Nt)-w*A)*s0+w*Y_MF;
    i_iter=i_iter+1;
end
X_hat=s(1:Nt,:)+s(Nt+1:2*Nt,:)*1i;