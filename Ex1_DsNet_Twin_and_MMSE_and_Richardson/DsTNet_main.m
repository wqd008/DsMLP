%%%%%%%%%%%%%%%%%%%%%%%%%  Notice  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%"DsTNet_main.m" is the second main function of our code, which aims to
%train the detection matrix with DsTNet algorithm and the generated
%datasets. The detection performance of DsTNet is compared with
%conventional matrix inversion algorithm MMSE and the Richardson iterative
%algorithm proposed in the paper "X. Gao, L. Dai, C. Yuen, and Y. Zhang, 
%¡°Low-complexity MMSE signal detection based on Richardson method for 
%large-scale MIMO systems,¡± in Proc. IEEE 80th Veh. Technol. Conf. 
%(IEEE VTC'14 Fall), Vancouver, Canada, Sep. 2014.".
%%%%%%%%%%%%%%%%%%%%%%%%%  Notice  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% clear for initialization %%
clc;
clear all;


%% choose the channel and generated signals %%
% sym is used to choose different generated channel matrix for testing. The
% generated datasets are obtained by the first main function
% "data_generator.m"
sym = 80;

%datasets input
filenm1 = ['./input/InputData_',num2str(sym) ,'.mat'];%generated data sets
filenm2 = ['./input/channel/ChannelH_',num2str(sym) ,'.mat'];%generated channel matrix
filenm3 = ['./input/inv/ChannelInvH_',num2str(sym) ,'.mat'];%corresponding inversion matrix
load(filenm1);
load(filenm2);
load(filenm3);
x_train = training_data;
y_train = training_data_label;
x_valid = x_train;
y_valid = y_train;
H_inv_fix = num2fixpt(H_inv, sfix(16), 2^-(9));%%% convert the floated result of MMSE to fixed-point for fairness



%% the parameters of neural network %%
ntrain = length(y_train);
arch = [32,4];
nlayer = length(arch);
mini_batch_size = 64;%% the minimum batchsize
max_iteration = 40;%% the maximum iteration numbers
n1 = 10;
lambda = 5;
rng(100);%% fixed random number for testing



%% Initialization for the parameters %%
weight = cell(1,nlayer);
nabla_weight = cell(1,nlayer);
a = cell(1,nlayer);
z = cell(1,nlayer);
rstep = 1;%% the steplength for illustrating the results
for in = 2:nlayer
    % "trandn_matrix" is the function used for initialization
    weight_real = trandn_matrix(arch(in-1),arch(in),-0.001,0.001);%% initializing the data with a minuscule number
    weight_imag = trandn_matrix(arch(in-1),arch(in),-0.001,0.001);
    weight{in} = complex(weight_real,weight_imag);
end
for in = 1:nlayer
    a{in} = zeros(mini_batch_size,arch(in));
    z{in} = zeros(mini_batch_size,arch(in));
end
accuracy = zeros(1,ceil(max_iteration/rstep));



%% start the trainning of DsTNet %%
iaa = 0;
for ip = 1:max_iteration
    % accelerating the convergence speed by increasing the steplength.
    % the "eta" should be changed when the channel is different.
    % the following setting for "eta" is found to be suitable for most
    % channels in debugging and testing.
    if ip<=5
        eta = 8;
    elseif ip>5&&ip<=10
        eta = 7;    
    elseif ip>10&&ip<=15
        eta = 6;
    elseif ip>15&&ip<=20
        eta = 5;
    elseif ip>20&&ip<=25
        eta = 5;
    elseif ip>25&&ip<=30
        eta = 5;
    elseif ip>30&&ip<=35
        eta = 5;
    elseif ip>35&&ip<=40
        eta = 3;
    elseif ip>40&&ip<=50
        eta = 3;
    elseif ip>50&&ip<=60
        eta = 3;
    else 
        eta = 1;
    end
    pos = randi(ntrain - mini_batch_size);
    
    % choose mini_bach_size datas randomly
    x = x_train( pos + 1 : pos + mini_batch_size , :);
    y = y_train( pos + 1 : pos + mini_batch_size , :);
    
    % feedforward module
    a{1} = x;
    [a,z]=feedforward(weight,nlayer,mini_batch_size,a,z);
    
    % stochastic gradient descent
    [weight,nabla_weight] = Stochastic_SGD(weight,...
        nabla_weight,nlayer,mini_batch_size,eta,a,z,y,lambda,ntrain,ip);
    
    % illustrating the MSE loss
    if mod(ip,rstep) == 0
        iaa = iaa+1;
        mseloss(iaa) = evaluatemnist(x_valid,y_valid,weight,nlayer); % "evaluatemnist" is the function to calculate the mseloss
        plot(mseloss,'-k^','linewidth',1.5);
        ylabel('MSE Loss');
        xlabel('Iteration');
        title(['Mseloss:',num2str(mseloss(iaa))]);
        getframe;
    end
end
%% plot the convergence pictures
xmse = 1:rstep:max_iteration;
figure(2);
plot(xmse,mseloss,'-bo','linewidth',2);
ylabel('MSE Loss');
xlabel('Iteration');
grid on;
legend('DsTNet for 32¡Á4 MIMO of 64-QAM');
set(gca,'FontSize',20);
set(gca,'FontName','Times New Roman');

%% store the trainning result
H_DSC1 = weight{2};
% filenm = 'H_DSC.mat';
% save(filenm,'H_DSC','-mat');
% H_DSC_inv = pinv(H_DSC);
% filenm = 'H_DSC_inv.mat';
% save(filenm,'H_DSC_inv','-mat');
% H_inv = pinv(H); 

%% testing the BER performance
%64-QAM
ber_list2 = ber_test(H, H_DSC1,64);
ber_list3 = ber_test(H, H_inv_fix,64);
%16-QAM
ber_list5 = ber_test(H, H_DSC1,16);
ber_list6 = ber_test(H, H_inv_fix,16);
%QPSK
ber_list8 = ber_test(H, H_DSC1,4);
ber_list9 = ber_test(H, H_inv_fix,4);
%Richardson method
ber_list10 = ber_test_Richard(H,4);
ber_list11 = ber_test_Richard(H,16);
ber_list12 = ber_test_Richard(H,64);

xxx = -5:1:20;% x label for diagram
figure(3);
plot(xxx,ber_list12,'-sb',xxx,ber_list2,'-^r',xxx,ber_list3,'-ok','linewidth',1.5);
hold on;
plot(xxx,ber_list11,'--sb',xxx,ber_list5,'--^r',xxx,ber_list6,'--ok','linewidth',1.5);
hold on;
plot(xxx,ber_list10,':sb',xxx,ber_list8,':^r',xxx,ber_list9,':ok','linewidth',1.5);
xlabel('SNR(dB)');
ylabel('BER(bit)');
grid on;
set(gca,'FontSize',14);
set(gca,'FontName','Times New Roman');
legend('Richardson of 64QAM [18],{\it{i}}=6','DsTNet of 64QAM','Fixed MMSE of 64QAM','Richardson of 16QAM [18],{\it{i}}=6','DsTNet of 16QAM','Fixed MMSE of 16QAM','Richardsonof QPSK [18],{\it{i}}=6','DsTNet of QPSK','Fixed MMSE of QPSK');


%% function for testing the BER
function ber_list = ber_test(h,h_inv,M)
    ber_list = [];
    global Ns Nt Nr N
    %M = 64;
    Ns = 4;
    Nt = 32;
    Nr = Ns;
    N = 10000;
    num = randi([0 1],N*log2(M)*Ns,1);
    x = qammod(num,M,'UnitAveragePower',true,'InputType','bit');
    %x = qammod(num,M,'InputType','bit');
    x = reshape(x,N,Ns);
    x_std = reshape(x,N*Ns,1);
    y = x*h*h_inv;% only for testing
    for snr = -5:1:20
        y = x*h;
        signal_power = sum(mean(abs(y).^2,1));
        y = awgn(y,snr,'measured');
        y = y * h_inv;
        y = reshape(y,N*Ns,1);
        x_hat = qamdemod(y,M,'UnitAveragePower',true,'OutputType','bit');
        num = qamdemod(x_std,M,'UnitAveragePower',true,'OutputType','bit');
        ber = biterr(num, x_hat)/length(num);
        ber_list = [ber_list,ber];
    end
end
%% the function for testing the performance of Richardson methods
function ber_list = ber_test_Richard(h,M)
    ber_list = [];
    global Ns Nt Nr N
    %M = 64;
    Ns = 4;
    Nt = 32;
    Nr = Ns;
    N = 10000;
    num = randi([0 1],N*log2(M)*Ns,1);
    x = qammod(num,M,'UnitAveragePower',true,'InputType','bit');
    x = reshape(x,N,Ns);
    x_std = reshape(x,N*Ns,1);
    %y = x*h*h_inv;% only for testing
    N_iter = 6;% the iteration number for Richardson, the cited paper only sets
               % the iter_N as 3 for low-complexity, in our experiment it is doubled for performance. 
    for snr = -5:1:20
        y = x*h;
        signal_power = sum(mean(abs(y).^2,1));
        y = awgn(y,snr,'measured');
        sigma2 = 2*Ns/Nt*10^(-snr/10);
        y1 = Richardson_decoder(y',h',sigma2,Nr,N_iter,N); % the Richardson decoder function
        y = reshape(y1',N*Ns,1);
        x_hat = qamdemod(y,M,'UnitAveragePower',true,'OutputType','bit');
        num = qamdemod(x_std,M,'UnitAveragePower',true,'OutputType','bit');
        ber = biterr(num, x_hat)/length(num);
        ber_list = [ber_list,ber];
    end
end  
    
