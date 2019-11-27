#!/bin/bash

#SBATCH --job-name=ANT1_count    # Job name
#SBATCH --output=jobname.%j.out # Stdout (%j expands to jobId)
#SBATCH --error=jobname.%j.err # Stderr (%j expands to jobId)
#SBATCH --time=10:00:00   # walltime
#SBATCH --partition=broadwl    # Partition
#SBATCH --account=pi-gilad    # Replace with your system
#SBATCH --mail-user=anthony.hung1234@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --mem=50gb                     # Job memory request
#SBATCH --ntasks=1                   # Run a single task
#SBATCH --cpus-per-task=20            # Number of CPU cores per task

cd /project2/gilad/anthonyhung/scPilot/

cellranger count --id=ANT1 --transcriptome=/project2/gilad/anthonyhung/refdata-cellranger-GRCh38-3.0.0/ --fastqs=fastq/ --sample=YG-AH-2S-ANT-1_S1_L008_R1_001 --localcores=20 --expect-cells=5000 --localmem=50
