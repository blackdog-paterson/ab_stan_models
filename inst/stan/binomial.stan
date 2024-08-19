data {
     int<lower=0> N1;
     int<lower=0> N2;
     int<lower=0, upper=N1> y1;
     int<lower=0, upper=N2> y2;
}
parameters {
     real<lower=0, upper=1> theta1;
     real<lower=0, upper=1> theta2;
}
model {
     y1 ~ binomial(N1, theta1);
     y2 ~ binomial(N2, theta2);
     theta1 ~ beta(1, 1); // Uninformative prior
     theta2 ~ beta(1, 1); // Uninformative prior
}
generated quantities {
     real lift = theta2 - theta1;
     real prob = theta2 > theta1;
}
