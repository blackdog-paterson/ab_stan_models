library(tidyr)
library(dplyr)

run_binomial_analysis <- function(version_a_visits = 1,
                                  version_a_converted = 1,
                                  version_b_visits = 1,
                                  version_b_converted = 1) {
     stan_data <- list(
          N1 = version_a_visits,
          N2 = version_b_visits,
          y1 = version_a_converted,
          y2 = version_b_converted
     )

     fit <- sampling(
          stanmodels$binomial,
          data = stan_data,
          iter = 5000,
          thin = 1,
          chains = 4
     )

     samples <- rstan::extract(
          fit,
          permuted = TRUE,
          pars = c("lp__"),
          include = FALSE
     ) |>
          as_tibble() |>
          mutate(id = 1:n()) |>
          pivot_longer(cols = 1:4) |>
          mutate(name = case_when(
               name == "theta1" ~ "Version A conversion rate",
               name == "theta2" ~ "Version B conversion rate",
               name == "prob" ~ "Probability Version B > Version A",
               TRUE ~ "Difference in rates"
          ))

     return(samples)
}

run_multinomial_analysis <- function(

     version_a_visits = 10,
     version_a_choice1 = 1,
     version_a_choice2 = 1,
     version_a_choice3 = 1,

     version_b_visits = 50,
     version_b_choice1 = 5,
     version_b_choice2 = 5,
     version_b_choice3 = 5

) {


     dirichlet_prior.vec = c(1, 1, 1, 1)

     stan_data <- list(
          N1 = version_a_visits,
          K1 = 4,
          y1 = c(version_a_choice1, version_a_choice2, version_a_choice3, version_a_visits - (version_a_choice1 + version_a_choice2 + version_a_choice3)),
          alpha1 = dirichlet_prior.vec,

          N2 = version_b_visits,
          K2 = 4,
          y2 = c(version_b_choice1, version_b_choice2, version_b_choice3, version_b_visits - (version_b_choice1 + version_b_choice2 + version_b_choice3)),
          alpha2 = dirichlet_prior.vec
     )

     fit <- sampling(
          stanmodels$multinomial,
          data = stan_data,
          iter = 5000,
          thin = 1,
          chains = 4
     )

     samples <- rstan::extract(
          fit,
          permuted = TRUE,
          pars = c("lp__"),
          include = FALSE
     ) |>
          as.data.frame() |>
          mutate(id = 1:n()) |>

          pivot_longer(cols = 1:11) |>
          mutate(name = case_when(
               name == "theta1.1" ~ "Version A, first choice",
               name == "theta1.2" ~ "Version A, second choice",
               name == "theta1.3" ~ "Version A, third choice",

               name == "theta2.1" ~ "Version B, first choice",
               name == "theta2.2" ~ "Version B, second choice",
               name == "theta2.3" ~ "Version B, third choice",

               name == "diff_theta_1_2_1" ~ "Difference, first choice",
               name == "diff_theta_1_2_2" ~ "Difference, second choice",
               name == "diff_theta_1_2_3" ~ "Difference, third choice",

               TRUE ~ "Fuck off"
          )) |>
          filter(name != "Fuck off")

     return(samples)
}
