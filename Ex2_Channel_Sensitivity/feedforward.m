function [a,z] = feedforward(weight,nlayer,mini_batch_size,a,z)

w = weight{2};
%b = bias{nlayer};% discarding the bias
ix = a{1};
%iiz = complex(real(ix)*real(w)-imag(ix)*imag(w),real(ix)*imag(w)+imag(ix)*real(w));
iz = ix * w;%% discarding the activation function
%% Notice %%
% since the stochastic integrator optimize the weight matrix by
% adding/subtracting 1 or 2, thus the feedforwarding module can be realized
% by MUX as illustrated in the Fig.10(b) of our paper, and no multiplier is
% needed.
%% Notice %%
a{nlayer} = iz;
z{nlayer} = iz;

end

