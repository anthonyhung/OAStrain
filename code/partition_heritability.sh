#!/bin/bash

conda activate ldsc

python /project2/gilad/anthonyhung/Projects/ldsc/ldsc.py \
  --h2 /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/output/LDSC-SEG/OA_summary_stats.sumstats.gz\
	--ref-ld-chr /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/annot/baseline_gene_MAF_LD/baseline_gene_MAF_LD.,/project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/annot/all_genes.,/project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/annot/DE_genes.\ 
	--w-ld-chr /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/weights_hm3_no_hla/weights.\
	--overlap-annot\
	--frqfile-chr /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/1000G_Phase3_frq/1000G.EUR.QC.\
	--out /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/output/LDSC-SEG/Partitioned_heritability/DE_all_baseline_partition
