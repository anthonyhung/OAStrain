#!/bin/bash

conda activate ldsc

for chrom in {1..22}
do
echo ${chrom}

python /project2/gilad/anthonyhung/Projects/ldsc/make_annot.py \
		--gene-set-file /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/output/LDSC-SEG/DE_genes.GeneSet \
		--gene-coord-file /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/output/LDSC-SEG/gene_coord_file.txt \
		--windowsize 100000 \
		--bimfile /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/1000G_EUR_Phase3_plink/1000G.EUR.QC.${chrom}.bim \
		--annot-file /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/annot/DE_genes.${chrom}.annot.gz
		
python /project2/gilad/anthonyhung/Projects/ldsc/make_annot.py \
		--gene-set-file /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/output/LDSC-SEG/all_genes.GeneSet \
		--gene-coord-file /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/output/LDSC-SEG/gene_coord_file.txt \
		--windowsize 100000 \
		--bimfile /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/1000G_EUR_Phase3_plink/1000G.EUR.QC.${chrom}.bim \
		--annot-file /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/annot/all_genes.${chrom}.annot.gz
		
python /project2/gilad/anthonyhung/Projects/ldsc/ldsc.py \
          --l2 \
          --bfile /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/1000G_EUR_Phase3_plink/1000G.EUR.QC.${chrom} \
          --print-snps /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/listHM3.txt \
          --ld-wind-cm 1 \
          --annot /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/annot/DE_genes.${chrom}.annot.gz \
          --thin-annot \
          --out /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/annot/DE_genes.${chrom}
          
python /project2/gilad/anthonyhung/Projects/ldsc/ldsc.py \
          --l2 \
          --bfile /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/1000G_EUR_Phase3_plink/1000G.EUR.QC.${chrom} \
          --print-snps /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/listHM3.txt \
          --ld-wind-cm 1 \
          --annot /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/annot/all_genes.${chrom}.annot.gz \
          --thin-annot \
          --out /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/annot/all_genes.${chrom}
		
done


