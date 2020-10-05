#!/bin/sh

source activate ldsc

python /project2/gilad/anthonyhung/Projects/ldsc/munge_sumstats.py --sumstats /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/output/OA_summary_stats_for_munging.txt --merge-alleles /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/w_hm3.snplist --out /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/output/OA_summary_stats\ --a1-inc
