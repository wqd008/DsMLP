clear all;
close all;
%% parameters setting
Nframe = 1000;
Ns = 4;% the users antennas
M = 4; % the modulation scheme
Nt = 32;% the transmitting antennas
Nr = Ns;
lamda_para = [0.8:0.1:0.9];%%the parameter \xi for the non optimal channel
seed = 80;
N_c = 32; % the cluster number
N_ray = 4;
detaH = (randn(Nr,Nt)+1j*randn(Nr,Nt))/sqrt(2); % the noise for non optimal channel
%% modulation for M-QAM
num = randi([0 M-1],Nframe,Ns);
y = qammod(num,M,'UnitAveragePower',true);

%% generating H
lamda = 2; % represents the hardness of noise
[H,AT,AR,aoa,aod] = channel_generation(Nt,Nr,seed,N_c,N_ray); % ideal channel generation in 3GPP
H_im = lamda_para(lamda)*H + sqrt(1-lamda_para(lamda)^2)*detaH; % H_im represents the imperfect channel

%% generating H_im_inv
H_inv = pinv(H);
H_im_inv = pinv(H_im);
filenm = ['ImChannel_',num2str(seed) ,'_',num2str(lamda),'.mat'];
save(filenm,'H_im');

%% function for SCM channel model
function [H,AT,AR,aoa,aod] = channel_generation(N_t,N_r,seed,N_c,N_ray)
rng(seed)                                                  % setting random seed
%-----------AOA
E_aoa = 2*pi* rand(N_c,1);                                %the mean of cluster haveing a uniform distribution within£¨0,2*pi£©
sigma_aoa = 10*pi/180;                                    %angle spread is 10¡ã£¬which is then transformed to radian as standard deviation
b = sigma_aoa/sqrt(2);                                    %calculate the b from deviation£¬which is scale parameter
a = rand(N_c,N_ray)-0.5;                                  %generating a random series having a uniform distribution within (-0.5,0.5)
aoa = repmat(E_aoa,1,N_ray)-b*sign(a).*log(1-2*abs(a));   %generating a random series having a Laplacian distribution
aoa = sin(aoa);
%-----------AOD
E_aod = 2*pi* rand(N_c, 1);                               %the mean of cluster haveing a uniform distribution within£¨0,2*pi£©
sigma_aod = 10*pi/180;                                    %angle spread is 10¡ã£¬which is then transformed to radian as standard deviation
b = sigma_aod/sqrt(2);                                    %calculate the b from deviation£¬which is scale parameter
a = rand(N_c,N_ray)-0.5;                                  %generating a random series having a uniform distribution within (-0.5,0.5)
aod = repmat(E_aod,1, N_ray)-b*sign(a).*log(1-2*abs(a));  %generating a random series having a Laplacian distribution
aod = sin(aod);

signature_t = [0:(N_t-1)]';
signature_t = 1i*pi* signature_t;                           %prepare for the next signature
signature_r = [0:(N_r-1)]';
signature_r = 1i*pi* signature_r;                           %prepare for the next signature

H_ray = zeros(N_r, N_t, N_c, N_ray);
H_cl = zeros(N_r, N_t, N_c);

for i= 1: N_c
    for m = 1: N_ray
        H_ray(:,:,i,m)=complex(randn(1),randn(1))/sqrt(2)*exp((aoa(i,m)*signature_r))*exp((aod(i,m)*signature_t))'/sqrt(N_t*N_r); 
    end
end  
    H_cl = sum(H_ray, 4);    

H_temp(:,:) = sqrt(N_t*N_r/N_c/N_ray)*sum(H_cl,3);   

aod = aod(:).';
aoa = aoa(:).';
A = kron(aod,signature_t);
AT = 1/sqrt(N_t)*exp(A);
A = kron(aoa,signature_r);
AR = 1/sqrt(N_r)*exp(A);
% noramlization 
H = sqrt(N_t*N_r).*(H_temp/norm(H_temp,'fro')); 

end