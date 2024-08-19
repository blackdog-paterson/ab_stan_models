data {
          int<lower=1> K1; // Number of categories
          int<lower=0> y1[K1]; // Observed counts
          vector<lower=0>[K1] alpha1; // Dirichlet prior hyperparameter

          int<lower=1> K2; // Number of categories
          int<lower=0> y2[K2]; // Observed counts
          vector<lower=0>[K2] alpha2; // Dirichlet prior hyperparameter

     }

     parameters {
          simplex[K1] theta1; // Multinomial probabilities
          simplex[K2] theta2; // Multinomial probabilities
     }

     model {
          theta1 ~ dirichlet(alpha1);
          theta2 ~ dirichlet(alpha2);


               y1 ~ multinomial(theta1);


               y2 ~ multinomial(theta2);

     }
generated quantities {
     real diff_theta_1_2_1 = theta2[1] - theta1[1];
     real diff_theta_1_2_2 = theta2[2] - theta1[2];
     real diff_theta_1_2_3 = theta2[3] - theta1[3];
}

