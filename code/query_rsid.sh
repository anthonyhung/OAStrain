#!/bin/bash

cd /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/output

awk 'BEGIN {FS=":"; OFS=""} {print "select chrom,chromStart,name from snp132
where chrom = \"chr",$1,"\" and chromStart + 1 = ",$2,";"}' SNPlocs_OAGWAS.txt > snps_locs.sql

module load mysql

mysql -h genome-mysql.cse.ucsc.edu -u genome -A -D hg19 --skip-column-names < snps.sql