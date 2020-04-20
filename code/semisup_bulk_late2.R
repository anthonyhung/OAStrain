setwd("/project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain")

library("RColorBrewer")
library("scales")
library("cowplot")
library("CountClust")
library("maptpx")
library("MAST")
library("ggplot2")
library("ggfortify")
library("gplots")

# load gene annotations
gene_anno <- read.delim("data/gene-annotation.txt",
                        sep = "\t")

# Load colors 
colors <- colorRampPalette(c(brewer.pal(9, "Blues")[1],brewer.pal(9, "Blues")[9]))(100)
pal <- c(brewer.pal(9, "Set1"), brewer.pal(8, "Set2"), brewer.pal(12, "Set3"))

#load cell atlas data matrix
load("data/cell_atlas_ref_panel")
cell.line <- cell.line[,c(12:20,35,36,40,55:57)]

#load pilot data
raw_counts <- as.matrix(readRDS("data/raw_counts_relabeled.rds"))

# load gene annotations
gene_anno <- read.delim("data/gene-annotation.txt",
                        sep = "\t")

#relabel pilot data genes to symbols
pilot <- raw_counts
rownames(pilot) <- gene_anno$external_gene_name[match(unlist(rownames(pilot)), gene_anno$ensembl_gene_id)]

# load in counts
outside_data_counts <- read.table("/project2/gilad/anthonyhung/Projects/OAStrain_project/bulkRNAseq_outsideData/out/counts/counts.txt", header = T)

# assign row.names
row.names(outside_data_counts) <- outside_data_counts$Geneid

# exclude extra data columns
outside_data_counts <- outside_data_counts[, -c(1:6)]

names(outside_data_counts) <- c("MSC-Chond-d14_3", "iPSC-MSC5_2", "MSC-Chond-d3_3", "adMSC", "Heart_4",
                                "Chond_enc_2", "Lung_1", "Chond_SCM_P4_1", "bmMSC_2.2", "MSC-Chond-d21_1",
                                "Chond_TCP_P4_2", "MSC-Chond-d3_1", "Chond_SCM_P1_1", "bmMSC_1.2", "MSC-Chond-d0_2",
                                "Chond_TCP_P1_2", "MSC-Chond-d14_2", "iPSC-MSC9_1", "OA_dmg_2", "Chond_TCP_P1_3",
                                "Heart_2", "MSC-Chond-d14_1", "MSC-Chond-d1_3", "Chond_SCM_P4_3", "Kidney_2",
                                "OA_dmg_3", "Chond_SCM_P1_2", "Chond_TCP_P1_1", "MSC-Chond-d7_3", "Liver_3",
                                "Chond_SCM_P4_2", "OA_dmg_1", "MSC-Chond-d3_2", "bmMSC_2.1", "Kidney_4",
                                "bmMSC_1.1", "Lung_2", "MSC-Chond-d21_3", "Liver_2", "Chond_TCP_P4_1", 
                                "Heart_3", "Lung_4", "Heart_1", "Chond_SCM_P1_3", "Liver_4",
                                "OA_intact_2", "Liver_1", "MSC-Chond-d1_2", "Chond_enc_1", "iPSC_1",
                                "MSC-Chond-d1_1", "MSC-Chond-d21_2", "iPSC_2", "iPSC-MSC5_1", "Lung_3",
                                "iPSC-MSC9_2", "MSC-Chond-d7_1", "Kidney_1", "Chond_TCP_P4_3", "OA_intact_3",
                                "Kidney_3", "OA_intact_1", "bmMSC_1.3", "MSC-Chond-d0_1", "MSC-Chond-d0_3",
                                "MSC-Chond-d7_2")

#remove MSC-chond samples and OA samples
MSC_chond_samples <- which(grepl("MSC-Chond-", names(outside_data_counts)))
OA_samples <- which(grepl("OA_", names(outside_data_counts)))
Heart1 <- which(grepl("Heart_1", names(outside_data_counts))) #seems to cluster with liver rather than hearts!
outside_data_counts<- outside_data_counts[,-c(MSC_chond_samples, OA_samples, Heart1)]

#Combine all bulk data together
merged_raw_data <- merge(raw_counts, outside_data_counts, by = "row.names")
row.names(merged_raw_data) <- merged_raw_data$Row.names
merged_raw_data <- merged_raw_data[,-1]

#Remove rows with all 0s
dim(merged_raw_data)
merged_raw_data <- merged_raw_data[apply(merged_raw_data, 1, function(x) !all(x==0)),]
dim(merged_raw_data)

#indices for later
adMSC_index <- which(grepl("adMSC", names(merged_raw_data)))
bmMSC1_index <- which(grepl("bmMSC_1.", names(merged_raw_data)))
bmMSC2_index <- which(grepl("bmMSC_2.", names(merged_raw_data)))
early_chond <- which(grepl("Chond_SCM_P1|Chond_TCP_P1", names(merged_raw_data)))
late_chond <- which(grepl("Chond_SCM_P4|Chond_TCP_P4", names(merged_raw_data)))
chond_encode <- which(grepl("Chond_enc", names(merged_raw_data)))


library(edgeR)
merged_raw_data <- DGEList(merged_raw_data, group = colnames(merged_raw_data))
merged_raw_data_counts <- merged_raw_data$counts
labels <- sapply(strsplit(colnames(merged_raw_data),"_"), `[`, 1)

library("classtpx")



#Here I define the chond cluster based on only late passage chond
# labels for "known" clusters
index_heart <- which(labels=="Heart")
index_lung <- which(labels=="Lung")
index_liver <- which(labels=="Liver")
index_kidney <- which(labels=="Kidney")
index_iPSC <- which(labels=="iPSC")
index_chond <- late_chond
index_MSCs <- c(adMSC_index, bmMSC1_index, bmMSC2_index)

#Here I define a MSC cluster based on bmMSCs (from Aref et al 2020)
# labels for "known" clusters
index_MSCs <- bmMSC1_index

known_samples <- c(index_heart, index_lung, index_liver, index_kidney, index_iPSC, index_chond, index_MSCs)

class_labs <- c(rep("Heart", length(index_heart)),
                rep("Lung", length(index_lung)),
                rep("Liver", length(index_liver)),
                rep("Kidney", length(index_kidney)),
                rep("iPSC", length(index_iPSC)),
                rep("Chond", length(index_chond)),
                rep("MSC", length(index_MSCs))
                )

# Perform topic modeling k=7
if (file.exists("data/merged_topic_fit_7_classtpx_omega_fix_bmMSC1_lateChond.rda")){
     Topic_clus_7_bmMSC1_lateChond <- get(load(file="data/merged_topic_fit_7_classtpx_omega_fix_bmMSC1_lateChond.rda"))
} else {
Topic_clus_7_bmMSC1_lateChond <- classtpx::class_topics(
    t(merged_raw_data_counts),
    K=7,
    known_samples = known_samples,
    class_labs = class_labs,
    method="omega.fix",
    tol=0.01)
save(Topic_clus_7_bmMSC1_lateChond, file="data/merged_topic_fit_7_classtpx_omega_fix_bmMSC1_lateChond.rda")
}

# Perform topic modeling k=8
if (file.exists("data/merged_topic_fit_8_classtpx_omega_fix_bmMSC1_lateChond.rda")){
     Topic_clus_8_bmMSC1_lateChond <- get(load(file="data/merged_topic_fit_8_classtpx_omega_fix_bmMSC1_lateChond.rda"))
} else {
Topic_clus_8_bmMSC1_lateChond <- classtpx::class_topics(
    t(merged_raw_data_counts),
    K=8,
    known_samples = known_samples,
    class_labs = class_labs,
    method="omega.fix",
    tol=0.01)
save(Topic_clus_8_bmMSC1_lateChond, file="data/merged_topic_fit_8_classtpx_omega_fix_bmMSC1_lateChond.rda")
}

#Here I define a MSC cluster based on bmMSCs (from Carrow et al 2018)
# labels for "known" clusters
index_MSCs <- bmMSC2_index

known_samples <- c(index_heart, index_lung, index_liver, index_kidney, index_iPSC, index_chond, index_MSCs)

class_labs <- c(rep("Heart", length(index_heart)),
                rep("Lung", length(index_lung)),
                rep("Liver", length(index_liver)),
                rep("Kidney", length(index_kidney)),
                rep("iPSC", length(index_iPSC)),
                rep("Chond", length(index_chond)),
                rep("MSC", length(index_MSCs))
                )

# Perform topic modeling k=7
if (file.exists("data/merged_topic_fit_7_classtpx_omega_fix_bmMSC2_lateChond.rda")){
     Topic_clus_7_bmMSC2_lateChond <- get(load(file="data/merged_topic_fit_7_classtpx_omega_fix_bmMSC2_lateChond.rda"))
} else {
Topic_clus_7_bmMSC2_lateChond <- classtpx::class_topics(
    t(merged_raw_data_counts),
    K=7,
    known_samples = known_samples,
    class_labs = class_labs,
    method="omega.fix",
    tol=0.01)
save(Topic_clus_7_bmMSC2_lateChond, file="data/merged_topic_fit_7_classtpx_omega_fix_bmMSC2_lateChond.rda")
}

# Perform topic modeling k=8
if (file.exists("data/merged_topic_fit_8_classtpx_omega_fix_bmMSC2_lateChond.rda")){
     Topic_clus_8_bmMSC2_lateChond <- get(load(file="data/merged_topic_fit_8_classtpx_omega_fix_bmMSC2_lateChond.rda"))
} else {
Topic_clus_8_bmMSC2_lateChond <- classtpx::class_topics(
    t(merged_raw_data_counts),
    K=8,
    known_samples = known_samples,
    class_labs = class_labs,
    method="omega.fix",
    tol=0.01)
save(Topic_clus_8_bmMSC2_lateChond, file="data/merged_topic_fit_8_classtpx_omega_fix_bmMSC2_lateChond.rda")
}

