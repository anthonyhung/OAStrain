# Grades of Membership analysis with classtpx

library(classtpx)
library(Seurat)
library(ggplot2)
library("RColorBrewer")
library("scales")
library("cowplot")
library("CountClust")
library("maptpx")
library("MAST")
library("ggplot2")
library("ggfortify")
library("gplots")

Combined.common_noliver <- readRDS("/project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/data/Combined_singlecell_data_noliver.rds")
dim(Combined.common_noliver)

# specify the fixed loadings for certain cells (1 = iPSC, 2 = MSC, 3 = chondrocyte)
counts_allgenes <- as.matrix(Combined.common_noliver@assays$RNA@counts)
labels <- Combined.common_noliver@meta.data$Cell.Type

#labels for "known" clusters
idx.ips <- which(labels=="iPSC")
idx.msc <- which(labels=="MSC")
idx.cho <- which(grepl("Chondro ", labels))
kwn.smp <- c(idx.ips,idx.msc,idx.cho)

class.labs <- c(rep("iPSC", length(idx.ips)),
                rep("MSC", length(idx.msc)),
                rep("Chondrocyte", length(idx.cho)))

#Perform topic modeling k=3
#Save GoM data
k=3
print(k)
tpx.clust <- classtpx::class_topics(
     t(counts_allgenes),
     K=k,
     known_samples=kwn.smp,
     class_labs=class.labs,
     method="omega.fix",
     tol=1)
saveRDS(tpx.clust, file=paste0("/project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/data/gom_sup_",k,".rda"))


omega <- tpx.clust$omega
annotation <- data.frame(
     sample_id = paste0("X", c(1:NROW(omega))),
     tissue_label = as.factor(labels))
rownames(omega) <- annotation$sample_id
CountClust::StructureGGplot(omega = omega,
                            annotation = annotation,
                            palette = RColorBrewer::brewer.pal(8, "Accent"),
                            yaxis_label = "Tissue/Cell Type",
                            order_sample = TRUE,
                            axis_tick = list(axis_ticks_length = .1,
                                             axis_ticks_lwd_y = .1,
                                             axis_ticks_lwd_x = .1,
                                             axis_label_size = 7,
                                             axis_label_face = "bold")
)

ggsave("output/structureplot.png")

