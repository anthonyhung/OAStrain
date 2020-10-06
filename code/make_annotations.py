

for chrom in {1..22}
do
echo ${chrom}

python /project2/gilad/anthonyhung/Projects/ldsc/make_annot.py \
		--gene-set-file /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/output/DE_genes.GeneSet \
		--gene-coord-file /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/output/gene_coord_file.txt \
		--windowsize 100000 \
		--bimfile /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/1000G_EUR_Phase3_plink/1000G.EUR.QC.${chrom}.bim \
		--annot-file /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/annot/DE_genes.${chrom}.annot.gz
		
python /project2/gilad/anthonyhung/Projects/ldsc/make_annot.py \
		--gene-set-file /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/output/all_genes.GeneSet \
		--gene-coord-file /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/output/gene_coord_file.txt \
		--windowsize 100000 \
		--bimfile /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/1000G_EUR_Phase3_plink/1000G.EUR.QC.${chrom}.bim \
		--annot-file /project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/annot/all_genes.${chrom}.annot.gz
		
done
