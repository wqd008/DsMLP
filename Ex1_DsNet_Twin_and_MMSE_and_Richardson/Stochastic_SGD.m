function [weight,nabla_weight] = Stochastic_SGD(weight,nabla_weight,nlayer,mini_batch_size,eta,a,z,y,lambda,n,ip)
%Stochastic Gradient Descent implemented by Dynamic Stochastic Computing
%MSE£ºerror=0.5*(a{nplayer}-y)^2
%derivation£º
%    derror/dwi=(a{nplayer}-y)*(da{nplayer}/dwi)¡ý
%delta = (a{nlayer} - y).*(z{nlayer});
%

%% initialization
n = 7;% the bit width for stochastic integrator
lr = eta * 1/(2^n); % since the eta is an integer close to 8, thus is multiplication can be processed using shifting.
nabla_weight = cell(1,2);
x = a{nlayer};%x is the output
[l,r] = size(x);
x_prime = ones(l,r);
Label_w = zeros(l,r);

%% the stochastic GD circuits
%"dynamic_sequnce_generator is the main module of DsTNet, which is
% illustrated in the Fig.10(c) of our paper.
Label_w = dynamic_sequence_generator(x,x_prime,y,a{end-1}',l,r);%1 means plus, -1 means substract
Label_w = (a{end-1}' * Label_w) / mini_batch_size;%%% since the "label_w" is comprised of {+2,+1,0,-1,-2}, thus the multiplication could be processed with low-complexity.
nabla_weight{2} = Label_w;
for in = 2:nlayer
   weight{in} =  weight{in} - lr*Label_w; %%% the lr is a 2-based exponential function, thus the multiplication can be implemented with low-complexity using shifting.
end


end