# https://stephenslab.github.io/mashr/articles/eQTL_outline.html

library(dplyr)
library(mashr)
library(tidyverse)

setwd("/project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/")
set.seed(20200811)

#load eqtl results
# unstrain_eqtls <- read.csv("output/eQTL_output_unstrain.csv")
# strain_eqtls <- read.csv("output/eQTL_output_strain.csv")
# 
# #combine into one dataset
# strain_eqtls_join <- strain_eqtls %>%
#      mutate(test_number = paste0(snps, " ", gene)) %>%
#      dplyr::select(test_number, beta, beta_se)
# unstrain_eqtls_join <- unstrain_eqtls %>%
#      mutate(test_number = paste0(snps, " ", gene)) %>%
#      dplyr::select(test_number, beta, beta_se)
# 
# joined_data <- full_join(strain_eqtls_join, unstrain_eqtls_join, by = "test_number", suffix = c(".strain", ".unstrain"))
# joined_data <- joined_data %>%
#      remove_rownames() %>%
#      column_to_rownames(var = "test_number")
#  # load the matrices into a mash data set
# Bhat <- as.matrix(joined_data[,c(1,3)])
# colnames(Bhat) <- c("strain", "unstrain")
# #
# Shat <- as.matrix(joined_data[,c(2,4)])
# colnames(Shat) <- c("strain", "unstrain")
# #
# data <- mash_set_data(Bhat, Shat)
# saveRDS(data, "output/mash_full_data.rds")
data <- readRDS("output/mash_full_data.rds")
# 
# identify strong subset of tests
# m.1by1 <- mash_1by1(mash_set_data(data$Bhat,data$Shat))
# strong.subset <- get_significant_results(m.1by1,0.05)
# saveRDS(strong.subset, "output/strong_subset.rds")
# strong.subset<- readRDS("output/strong_subset.rds")
# 
# # identify a random subset of subset_num tests
# subset_num <- 5e5
# random.subset <- sample(1:nrow(data$Bhat), subset_num)
# 
# 
# # estimate correlation structure in null tests in random data
# data.temp <- mash_set_data(data$Bhat[random.subset,],data$Shat[random.subset,])
# Vhat <- estimate_null_correlation_simple(data.temp)
# rm(data.temp)
# 
# 
# # use the estimated correlation structure to adjust the random/strong subsets
# data.random <- mash_set_data(data$Bhat[random.subset,],data$Shat[random.subset,], V = Vhat)
# data.strong <- mash_set_data(data$Bhat[strong.subset,],data$Shat[strong.subset,], V = Vhat)
# 
# 
# 
# # generate cov matrices using data-driven and cannonical methods and compare
# # data-driven covariance matrix
# U.pca = cov_pca(data.strong,2)
# U.ed = cov_ed(data.strong, U.pca)
# 
# ## Also use cannonical cov method to generate cov matrix (to allow us to compare between the data-driven and cannonical cov to see which does better job)
# U.c <- cov_canonical(data.random)
# 
# # run mash
# m <- mash(data.random, Ulist = c(U.ed,U.c), outputlevel = 1)
# print(get_loglik(m),digits = 10)
# saveRDS(m, "output/mash_500k.rds")
m <- readRDS("output/mash_500k.rds")

subset_1 <- 1:1.5e5 #pending
subset_2 <- (1.5e5+1):3.5e5 #
subset_3 <- (3.5e5+1):5.5e5 #
subset_4 <- (5.5e5+1):7.5e5 #
subset_5 <- (7.5e5+1):9.5e5 #
subset_6 <- (9.5e5+1):11.5e5 #
subset_7 <- (11.5e5+1):13.5e5 #
subset_8 <- (13.5e5+1):1592240 #

data_subset <- data
data_subset$Bhat <- data$Bhat[subset_1,]
data_subset$Shat <- data$Shat[subset_1,]
data_subset$Shat_alpha <- data$Shat_alpha[subset_1,]

# compute posterior summaries (run on all tests)
m_all <- mash(data_subset, g=get_fitted_g(m), fixg=TRUE)
saveRDS(m_all, "output/mash_all_refit_500k_1.rds")
print("done!")


