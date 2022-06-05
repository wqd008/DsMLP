function [weight,nabla_weight] = Stochastic_SGD(weight,nabla_weight,nlayer,mini_batch_size,eta,a,z,y,lambda,n,ip)
%SGD stochastic gradient descent
%MSE£ºerror=0.5*(a{nplayer}-y)^2
%derivation£º
%    derror/dwi=(a{nplayer}-y)*(da{nplayer}/dwi)¡ý
%delta = (a{nlayer} - y).*(z{nlayer});
%
%normalization
n = 7;
lr = eta*1/(2^n);
%transform from digital to stochastic
nabla_weight = cell(1,2);
x = a{nlayer};%x is the output
%error = sqrt(sum((a{nlayer}-y).^2)/1000);

[l,r] = size(x);
x_prime = ones(l,r);

Label_w = zeros(l,r);
Label_w_real = zeros(l,r);
Label_w_imag = zeros(l,r);
Label_w_real = dynamic_sequence_generator(real(x),x_prime,real(y),a{end-1}',l,r);
Label_w_imag = dynamic_sequence_generator(imag(x),x_prime,imag(y),a{end-1}',l,r);%1 means plus, -1 means substract
Label_w = complex(Label_w_real,Label_w_imag);
Label_w = (a{end-1}' * Label_w) / mini_batch_size;%%%
nabla_weight{2} = Label_w;
for in = 2:nlayer
   weight{in} =  weight{in} - lr*Label_w;
  
end


end