function price = predict(x, theta, mu, sigma)

data = [1, (x - mu) ./ sigma];
price = data * theta;

end