function mse = evaluatemnist(x_valid,y_valid)
temp = sum(((real(x_valid)-real(y_valid)).^2+(imag(x_valid)-imag(y_valid)).^2));
mse = sum(sum(((real(x_valid)-real(y_valid)).^2+(imag(x_valid)-imag(y_valid)).^2)))/2/(64*4);
% mse = sum(((real(x_valid)-real(y_valid)).^2+(imag(x_valid)-imag(y_valid)).^2))/2/(64*4)
end

