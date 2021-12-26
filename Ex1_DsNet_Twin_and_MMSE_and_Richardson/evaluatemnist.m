function mse = evaluatemnist(x_valid,y_valid,weight,nlayer)

num = length(y_valid);
a = x_valid;

w = weight{nlayer};
%b = bias{nlayer};
z = complex(real(a)*real(w)-imag(a)*imag(w),real(a)*imag(w)+imag(a)*real(w));

s = 0;

a_real = real(z);
a_imag = imag(z);
mse = sum(sum(((a_real-real(y_valid)).^2+(a_imag-imag(y_valid)).^2)/2))/10000;

end

