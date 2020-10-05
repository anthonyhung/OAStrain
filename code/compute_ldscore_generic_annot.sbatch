#!/bin/bash

source activate ldsc

module load R/3.6.1

name_annot=baseline_gene_MAF_LD

dir_ldscore=/project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/annot/ldscores

mkdir -p ${dir_ldscore}/${name_annot}
cd ${dir_ldscore}/${name_annot}

echo "annot: ${dir_ldscore}/${name_annot}"

for chrom in {1..22}
do
echo ${chrom}

Rscript /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/code/extract_baselineLD_generic_annot.R ${name_annot} ${dir_ldscore} ${chrom}

zless ${dir_ldscore}/${name_annot}/${name_annot}.${chrom}.annot.gz | head -2

echo "Computing LD scores with the annot file ${name_annot}.${chrom}.annot.gz"
python2 /project2/gilad/anthonyhung/Projects/ldsc/ldsc.py \
--l2 \
--bfile /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/1000G_EUR_Phase3_plink/1000G.EUR.QC.${chrom} \
--print-snps /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/listHM3.txt \
--ld-wind-cm 1 \
--annot ${dir_ldscore}/${name_annot}/${name_annot}.${chrom}.annot.gz \
--out ${dir_ldscore}/${name_annot}/${name_annot}.${chrom}

done

