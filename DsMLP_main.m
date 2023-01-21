% Version: 1.1.0
% Algorithm: Conventional One Without Stochastic Computing
% Author: Wu Qidie, Kuang Jinsheng
% Date: 2023-01-21

%%%%%%%%%%%%%%%%%%%%%%%%%  Notice  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "DsMLP_main.m" is the main function of our code, which aims to
% train the detection matrix with DsMLP algorithm and the generated
% datasets. This version of DsMLP code didn't include the stochastic computing
% due to Project Confidentiality requirements. If you require the stochastic 
% computing version for research, please contact my email 
% wuqd22@mails.tsinghua.edu.cn.

% The detection performance of DsMLP is compared with conventional 
% matrix inversion algorithm MMSE and the Richardson iterative
% algorithm proposed in the paper "X. Gao, L. Dai, C. Yuen, and Y. Zhang, 
% ¡°Low-complexity MMSE signal detection based on Richardson method for 
% large-scale MIMO systems,¡± in Proc. IEEE 80th Veh. Technol. Conf. 
% (IEEE VTC'14 Fall), Vancouver, Canada, Sep. 2014.".
%%%%%%%%%%%%%%%%%%%%%%%%%  Notice  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% clear for initialization %%
clc;
clear all;
close all;

%% choose the channel and generated signals for test %%
% parameter setting
num = 50;               % num is used to choose different generated channel matrix
                        % for testing. The generated datasets are obtained by the 
                        % function "data_generator.m".
                        
rstep = 1;              % the step that will show the training process

N_t = 4;                % the transmitted antennas

N_r = 32;               % the received antennas

max_iteration = 40;     % the maximum number of iterations for low-complexity

rng(100);               % choose a fixed random seed for testing

%datasets input
filenm1 = ['./datasets/QPSK_',num2str(N_r),'_',num2str(N_t),...
           '/ChannelH_',num2str(num) ,'.mat'];      % generated channel matrix
filenm2 = ['./datasets/QPSK_',num2str(N_r),'_',num2str(N_t),...
           '/ChannelInvH_',num2str(num) ,'.mat'];   % corresponding inversion matrix
load(filenm1);
load(filenm2);

H_inv_fix = num2fixpt(H_inv, sfix(16), 2^-(9));     % convert the floated result of MMSE
                                                    % to fixed-point for fairness
% initial the weight matrix                                                     
weight_real = trandn_matrix(size(H_inv, 1),size(H_inv, 2),...
                            -0.001,0.001);          % initializing the data
                                                    % with a minuscule number
weight_imag = trandn_matrix(size(H_inv, 1),size(H_inv, 2),...
                            -0.001,0.001);
W_0 = complex(weight_real,weight_imag);
W_c = GradientDescent(H,W_0, "QPSK", 64, 40, num, N_r, N_t);


%% store the trainning result
H_DSC1 = W_c;
% filenm = 'H_DSC.mat';
% save(filenm,'H_DSC','-mat');
% H_DSC_inv = pinv(H_DSC);
% filenm = 'H_DSC_inv.mat';
% save(filenm,'H_DSC_inv','-mat');
% H_inv = pinv(H); 

%% testing the BER performance
% 64-QAM
ber_list2 = ber_test(H, H_DSC1,64, N_r, N_t);
ber_list3 = ber_test(H, H_inv_fix,64, N_r, N_t);
% 16-QAM
ber_list5 = ber_test(H, H_DSC1,16, N_r, N_t);
ber_list6 = ber_test(H, H_inv_fix,16, N_r, N_t);
% QPSK
ber_list8 = ber_test(H, H_DSC1,4, N_r, N_t);
ber_list9 = ber_test(H, H_inv_fix,4, N_r, N_t);
% Richardson method
ber_list10 = ber_test_Richard(H,4, N_r, N_t);
ber_list11 = ber_test_Richard(H,16, N_r, N_t);
ber_list12 = ber_test_Richard(H,64, N_r, N_t);
% plot
x_label = -5:1:20;% x label for diagram
figure(3);
semilogy(x_label,ber_list12,'-sb',x_label,ber_list2,...
        '-^r',x_label,ber_list3,'-ok','linewidth',1.5);
hold on;
semilogy(x_label,ber_list11,'--sb',x_label,ber_list5,...
        '--^r',x_label,ber_list6,'--ok','linewidth',1.5);
hold on;
semilogy(x_label,ber_list10,':sb',x_label,ber_list8,...
        ':^r',x_label,ber_list9,':ok','linewidth',1.5);
xlabel('SNR(dB)');
ylabel('BER');
grid on;
set(gca,'FontSize',14);
set(gca,'FontName','Times New Roman');
legend('Richardson of 64QAM [18],{\it{i}}=6','DsMLP of 64QAM','Fixed MMSE of 64QAM',...
       'Richardson of 16QAM [18],{\it{i}}=6','DsMLP of 16QAM','Fixed MMSE of 16QAM',...
       'Richardson of QPSK [18],{\it{i}}=6','DsMLP of QPSK','Fixed MMSE of QPSK');


%% function for testing the BER
function ber_list = ber_test(h,h_inv,M,Nt,Ns)
    ber_list = [];
    global Nr N
    Nr = Ns;
    N = 10000;
    num = randi([0 1],N*log2(M)*Ns,1);
    x = qammod(num,M,'UnitAveragePower',true,'InputType','bit');
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
function ber_list = ber_test_Richard(h,M,Nt,Ns)
    ber_list = [];
    global Nr N
    Nr = Ns;
    N = 10000;
    num = randi([0 1],N*log2(M)*Ns,1);
    x = qammod(num,M,'UnitAveragePower',true,'InputType','bit');
    x = reshape(x,N,Ns);
    x_std = reshape(x,N*Ns,1);
    N_iter = 6;% the iteration number for Richardson, the cited paper only sets
               % the iter_N as 3 for low-complexity, in our experiment it is 
               % doubled for performance. 
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
    
