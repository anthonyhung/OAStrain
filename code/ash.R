library(tidyverse)
library(ashr)

setwd("/project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/")

n_sorted <- as_tibble(read.table("data/alasoo_etal/RNA_FastQTL_naive_500kb_pvalues.sorted.txt.gz"))
#n_permuted <- as_tibble(read.table("data/alasoo_etal/RNA_FastQTL_naive_500kb_permuted.txt.gz"))

sal_sorted <- as_tibble(read.table("data/alasoo_etal/RNA_FastQTL_SL1344_500kb_pvalues.sorted.txt.gz"))
#sal_permuted <- as_tibble(read.table("data/alasoo_etal/RNA_FastQTL_SL1344_500kb_permuted.txt.gz"))

IFN_sorted <- as_tibble(read.table("data/alasoo_etal/RNA_FastQTL_IFNg_500kb_pvalues.sorted.txt.gz"))
#IFN_permuted <- as_tibble(read.table("data/alasoo_etal/RNA_FastQTL_IFNg_500kb_permuted.txt.gz"))

salIFN_sorted <- as_tibble(read.table("data/alasoo_etal/RNA_FastQTL_IFNg_SL1344_500kb_pvalues.sorted.txt.gz"))
#salIFN_permuted <- as_tibble(read.table("data/alasoo_etal/RNA_FastQTL_IFNg_SL1344_500kb_permuted.txt.gz"))


n_sorted <- n_sorted %>% 
     filter(V6 != 1) %>% 
     mutate(zscore = if_else(V7 < 0, true = qnorm(V6/2), false = qnorm(1-V6/2))) %>% 
     mutate(SE = V7/zscore)
sal_sorted <- sal_sorted %>% 
     filter(V6 != 1) %>% 
     mutate(zscore = if_else(V7 < 0, true = qnorm(V6/2), false = qnorm(1-V6/2))) %>% 
     mutate(SE = V7/zscore)
IFN_sorted <- IFN_sorted %>% 
     filter(V6 != 1) %>% 
     mutate(zscore = if_else(V7 < 0, true = qnorm(V6/2), false = qnorm(1-V6/2))) %>% 
     mutate(SE = V7/zscore)
salIFN_sorted <- salIFN_sorted %>% 
     filter(V6 != 1) %>% 
     mutate(zscore = if_else(V7 < 0, true = qnorm(V6/2), false = qnorm(1-V6/2))) %>% 
     mutate(SE = V7/zscore)



IFN_sorted_ash_out <- ash(betahat = IFN_sorted$V7, sebetahat = IFN_sorted$SE)
saveRDS(IFN_sorted_ash_out, "output/ash_power_analysis/alasoo_IFN_ash_out.rds")

salIFN_sorted_ash_out <- ash(betahat = salIFN_sorted$V7, sebetahat = salIFN_sorted$SE)
saveRDS(salIFN_sorted_ash_out, "output/ash_power_analysis/alasoo_salIFN_ash_out.rds")

sal_sorted_ash_out <- ash(betahat = sal_sorted$V7, sebetahat = sal_sorted$SE)
saveRDS(sal_sorted_ash_out, "output/ash_power_analysis/alasoo_sal_ash_out.rds")

n_sorted_ash_out <- ash(betahat = n_sorted$V7, sebetahat = n_sorted$SE)
saveRDS(n_sorted_ash_out, "output/ash_power_analysis/alasoo_naive_ash_out.rds")

