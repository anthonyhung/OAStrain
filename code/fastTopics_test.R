devtools::install_github("stephenslab/fastTopics")
library(fastTopics)
set.seed(1)

#simulate data
counts <- simulate_count_data(80,100,k = 3)$X

#create initial fits (here, there is a uniform initial F and for L, 20 cells are assigned to have 100% membership in each of the three topics, with the remaining 20 cells kept without)
F_init <- matrix(0, nrow = ncol(counts), ncol = 3)
L_init <- cbind(c(rep(1, 20), rep(0, 60)),
                c(rep(0, 20), rep(1, 20), rep(0, 40)),
                c(rep(0, 40), rep(1, 20), rep(0, 20))
)

#vector (1 for update loadings after initial specifications, 0 for keep initial specifications fixed)
fixed_loadings <- 1 - rowSums(L_init)

fit_init <- init_poisson_nmf(X=counts, F=F_init, L=L_init) #specify the initial fit for the data using init_poisson_nmf
fit1 <- fit_poisson_nmf(X=counts, fit0=fit_init, numiter=15, method = "em", update.loadings=fixed_loadings) #after defining the initial fit, refit the model while fixing some rows of L
