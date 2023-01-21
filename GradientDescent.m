function W = GradientDescent(H,W, mod_scheme, batch, iter, num, N_r, N_t)
% mod_scheme={"QPSK""16QAM""32QAM""64QAM"}. mod_scheme denotes the
% modulation scheme of the generated datasets
% batch:16/32/64,iter:40

t_sets_temp0 = load("datasets/"+mod_scheme +"_"+...
               N_r+"_"+N_t+"/InputData_"+num+".mat"); % load the datasets
t_sets_temp = t_sets_temp0.training_data_label;
t_sets = t_sets_temp;               
rng1 = rand(1, 100000);  % random number
rng2 = rand(1, 100000);
% setting the learning rate
if (N_r == 128) && (N_t == 16)
    LR = [1 1 1 1 1 1 1 1];
elseif (N_r == 32) && (N_t == 4)
    LR = [8 4 4 2 2 2 1 1];
end

for epoch=1:iter
   if epoch <= 2
       eta = LR(1);
   elseif epoch>2&&epoch<=5
       eta = LR(2);
   elseif epoch>5&&epoch<=10
       eta = LR(3);
   elseif epoch>10&&epoch<=15
       eta = LR(4);
   elseif epoch>15&&epoch<=20
       eta = LR(5); 
   elseif epoch>20&&epoch<=25
       eta = LR(6);
   elseif epoch>25&&epoch<=30
       eta = LR(7);
   elseif epoch>35&&epoch<=40
       eta = LR(8);
   else
       eta = 0.5;
   end
   
   pos = randi(length(t_sets) - batch);      % random position

   % choose mini_bach_size datas randomly
   t = t_sets(pos + 1 : pos + batch, :);    
   rn1 = rng1(pos + 1 : pos + batch);
   rn2 = rng2(pos + 1 : pos + batch);

   x = t * H;     
   % forword
   % this part can be replaced by the stochastic computing for lower
   % complexity, if you truly require the stochastic computing version
   % for research, please contact me.
   y = x * W;
   
   % training
   % this part can be replaced by the stochastic computing for lower
   % complexity, if you truly require the stochastic computing version
   % for research, please contact me.
   delta_w = x' * (y - t)/batch;
   W = W -eta/(2^8)*delta_w; 
   
   % plot
   if mod(epoch,1) == 0
       iaa = epoch;
       mseloss(iaa) = evaluatemnist(t,y); 
       plot(mseloss,'-k^','linewidth',1.5);
       ylabel('MSE Loss');
       xlabel('Iteration');
       title(['Mseloss:',num2str(mseloss(iaa))]);
       getframe;
    end
    
end
end

