function output = dynamic_sequence_generator(x,xx,y,a,l,r)
[l1,r1] = size(a);
output = zeros(l,r);
%%Initialization
DSS_x = zeros(l,r);
DSS_x_sign = zeros(l,r);
DSS_xx = zeros(l,r);
DSS_xx_sign = zeros(l,r);
DSS_y = zeros(l,r);
DSS_y_sign = zeros(l,r);
a1 = zeros(l,r);
b1 = zeros(l,r);
a1_sign = zeros(l,r);
b1_sign = zeros(l,r);

%%random numbers
yy1 = 2*(rand(l,r)-0.5);
yy2 = yy1;
yy3 = yy1;


%% dynamic stochastic sequence generation
for i=1:l
    for j=1:r
       if x(i,j)>=0
          DSS_x_sign(i,j)=0;
          if x(i,j)>=yy1(i,j)
              DSS_x(i,j)=1;
          else 
              DSS_x(i,j)=0;
          end
       else
          DSS_x_sign(i,j)=1;
          if (-x(i,j))>=yy1(i,j)
              DSS_x(i,j)=1;
          else 
              DSS_x(i,j)=0;
          end
       end
       
       if xx(i,j)>=0
         DSS_xx_sign(i,j)=0;
         if xx(i,j)>=yy2(i,j)
              DSS_xx(i,j)=1;
         else 
              DSS_xx(i,j)=0;
         end
       else
          DSS_xx_sign(i,j)=1;
          if (-xx(i,j))>=yy2(i,j)
              DSS_xx(i,j)=1;
          else 
              DSS_xx(i,j)=0;
          end
       end
       
       if y(i,j)>=0
         DSS_y_sign(i,j)=0;
         if y(i,j)>=yy3(i,j)
              DSS_y(i,j)=1;
         else 
              DSS_y(i,j)=0;
         end
       else
           DSS_y_sign(i,j)=1;
           if (-y(i,j))>=yy3(i,j)
             DSS_y(i,j)=1;
           else 
              DSS_y(i,j)=0;
           end 
       end
       
       a1(i,j) = and_door(DSS_x(i,j),DSS_xx(i,j));
       b1(i,j) = and_door(DSS_y(i,j),DSS_xx(i,j));%stochastic multiplication
       a1_sign(i,j) = xor_door(DSS_x_sign(i,j),DSS_xx_sign(i,j));
       b1_sign(i,j) = xor_door(DSS_y_sign(i,j),DSS_xx_sign(i,j));
    end
end

%truth table
for i=1:l
    for j=1:r
       
        if a1_sign(i,j) == 0 && a1(i,j) ==0 && b1_sign(i,j) == 0 && b1(i,j) == 0 
            output(i,j) = 0;
        elseif a1_sign(i,j) == 0 && a1(i,j) ==0 && b1_sign(i,j) == 0 && b1(i,j) == 1 
            output(i,j) = -1;
        elseif a1_sign(i,j) == 0 && a1(i,j) ==0 && b1_sign(i,j) == 1 && b1(i,j) == 0 
            output(i,j) = 0;
        elseif a1_sign(i,j) == 0 && a1(i,j) ==0 && b1_sign(i,j) == 1 && b1(i,j) == 1 
            output(i,j) = 1;
        elseif a1_sign(i,j) == 0 && a1(i,j) ==1 && b1_sign(i,j) == 0 && b1(i,j) == 0 
            output(i,j) = 1;
        elseif a1_sign(i,j) == 0 && a1(i,j) ==1 && b1_sign(i,j) == 0 && b1(i,j) == 1 
            output(i,j) = 0;
        elseif a1_sign(i,j) == 0 && a1(i,j) ==1 && b1_sign(i,j) == 1 && b1(i,j) == 0 
            output(i,j) = 1;
        elseif a1_sign(i,j) == 0 && a1(i,j) ==1 && b1_sign(i,j) == 1 && b1(i,j) == 1 
            output(i,j) = 2;
        elseif a1_sign(i,j) == 1 && a1(i,j) ==0 && b1_sign(i,j) == 0 && b1(i,j) == 0 
            output(i,j) = 0;
        elseif a1_sign(i,j) == 1 && a1(i,j) ==0 && b1_sign(i,j) == 0 && b1(i,j) == 1 
            output(i,j) = -1;
        elseif a1_sign(i,j) == 1 && a1(i,j) ==0 && b1_sign(i,j) == 1 && b1(i,j) == 0 
            output(i,j) = 0;
        elseif a1_sign(i,j) == 1 && a1(i,j) ==0 && b1_sign(i,j) == 1 && b1(i,j) == 1 
            output(i,j) = 1;
        elseif a1_sign(i,j) == 1 && a1(i,j) ==1 && b1_sign(i,j) == 0 && b1(i,j) == 0 
            output(i,j) = -1;
        elseif a1_sign(i,j) == 1 && a1(i,j) ==1 && b1_sign(i,j) == 0 && b1(i,j) == 1 
            output(i,j) = -2;
        elseif a1_sign(i,j) == 1 && a1(i,j) ==1 && b1_sign(i,j) == 1 && b1(i,j) == 0 
            output(i,j) = -1;
        elseif a1_sign(i,j) == 1 && a1(i,j) ==1 && b1_sign(i,j) == 1 && b1(i,j) == 1 
            output(i,j) = 0;
        end
    end
end
end