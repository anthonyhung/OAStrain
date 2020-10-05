args <- commandArgs(trailingOnly = TRUE)
dir_annot <- args[2]
chrom <- args[3]

name_annot <- "baseline_gene_MAF_LD"

library(data.table)

dir_baselineLD <- "/project2/gilad/anthonyhung/Projects/OAStrain_project/SLDSR-SEG/1000G_Phase3_baselineLD_v1.1_ldscores/baselineLD_v1.1"
annot <- read.table(paste0(dir_baselineLD, "/baselineLD.", chrom, ".annot.gz"), header = T, stringsAsFactors = F)

annot_list <- c("CHR", "BP", "SNP", "CM", "base",
                "Coding_UCSC", "Coding_UCSC.extend.500",
                "UTR_5_UCSC", "UTR_5_UCSC.extend.500",
                "UTR_3_UCSC", "UTR_3_UCSC.extend.500",
                "Intron_UCSC", "Intron_UCSC.extend.500",
                "Promoter_UCSC", "Promoter_UCSC.extend.500",
                paste0("MAFbin", 1:10),
                "MAF_Adj_Predicted_Allele_Age","MAF_Adj_LLD_AFR", "Recomb_Rate_10kb", "Nucleotide_Diversity_10kb", "Backgrd_Selection_Stat", "CpG_Content_50kb")
annot_included <- annot[, annot_list]

cat("Annotations included: \n")
print(annot_list)

dir.create(paste0(dir_annot, "/", name_annot), showWarnings = F, recursive = T)
write.table(annot_included, gzfile(paste0(dir_annot, "/", name_annot, "/", name_annot, ".", chrom, ".annot.gz")), sep = "\t", quote = F, col.names = T, row.names = F)
