% Version: 1.1.0
% Function: Dataset Generation
% Author: Wu Qidie
% Date: 2023-01-21

%%%%%%%%%%%%%%%%%%%%%%%%%  Notice  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "data_generator.m" is the function that aims to
% generate the needed datasets for later training.
%%%%%%%%%%%%%%%%%%%%%%%%%  Notice  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all;
close all;
%% parameters
Nframe = 1000;
Ns = 8;                 % the users antennas
M = 4;                  % the modulation scheme
Nt = 128;               % the transmitting antennas
Nr = Ns;
N_c = 16;               % the cluster number
N_ray = 4;
%% modulation
num = randi([0 M-1],Nframe,Ns);
y = qammod(num,M,'UnitAveragePower',true);

%% H generation
for seed = 1:1:100 
% generating 100 channels and data sets randomly
[H,AT,AR,aoa,aod] = channel_generation(Nt,Nr,seed,N_c,N_ray);

%% input data generation
x = y * H;              % since y is the constellation point, 
                        % thus the multiplication can be achieved by MUX
                        % wiht low-complexity as illustrated in Fig.10 of our paper.
training_data = x;
training_data_label = y;
filenm = ['InputData_',num2str(seed) ,'.mat'];
save(filenm,'training_data','training_data_label');
filenm = ['ChannelH_',num2str(seed) ,'.mat'];  
save(filenm,'H');


H_inv = pinv(H);
y_hat = x * H_inv;
energy = sum(sum(abs(H_inv)));
% save('H_inv.mat','H_inv');
filenm = ['ChannelInvH_',num2str(seed) ,'.mat'];
save(filenm,'H_inv');
end

%% function for channel generation in 3GPP standard
function [H,AT,AR,aoa,aod] = channel_generation(N_t,N_r,seed,N_c,N_ray)
%SCM channel£¬N_c*N_ray>modulation rank,rank>4£¬
rng(seed)                           % setting random seed
%-----------AOA
E_aoa = 2*pi* rand(N_c,1);          % the mean of cluster having uniform 
                                    % distribution within£¨0,2*pi£©
sigma_aoa = 10*pi/180;              % 10¡ãto rad£¬standard deviation
b = sigma_aoa/sqrt(2);                                    
a = rand(N_c,N_ray)-0.5;            % random series between(-0.5,0.5) having
                                    % uniform distribution
aoa = repmat(E_aoa,1,N_ray)-...
      b*sign(a).*log(1-2*abs(a));   % Generate a random sequence that conforms 
                                    % to the Laplacian distribution (each column 
                                    % represents the Angle of each cluster)  
aoa = sin(aoa);
%-----------AOD
E_aod = 2*pi* rand(N_c, 1);                               
sigma_aod = 10*pi/180;                                    
b = sigma_aod/sqrt(2);                                    
a = rand(N_c,N_ray)-0.5;                                 
aod = repmat(E_aod,1, N_ray)-b*sign(a).*log(1-2*abs(a));   
aod = sin(aod);

signature_t = [0:(N_t-1)]';
signature_t = 1i*pi* signature_t;    % prepare for the next signature
signature_r = [0:(N_r-1)]';
signature_r = 1i*pi* signature_r;                         

H_ray = zeros(N_r, N_t, N_c, N_ray);
H_cl = zeros(N_r, N_t, N_c);

for i= 1: N_c
    for m = 1: N_ray
        H_ray(:,:,i,m)=complex(randn(1),randn(1))...
            /sqrt(2)*exp((aoa(i,m)*signature_r))*...
            exp((aod(i,m)*signature_t))'/sqrt(N_t*N_r); 
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