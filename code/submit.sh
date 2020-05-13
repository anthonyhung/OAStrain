#!/bin/bash

#SBATCH --job-name=trim    # Job name
#SBATCH --output=jobname.%j.out # Stdout (%j expands to jobId)
#SBATCH --error=jobname.%j.err # Stderr (%j expands to jobId)
#SBATCH --time=10:00:00   # walltime
#SBATCH --partition=bigmem2    # Partition
#SBATCH --account=pi-gilad    # Replace with your system
#SBATCH --mail-user=anthony.hung1234@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --mem=100gb                     # Job memory request
#SBATCH --ntasks=1                   # Run a single task
#SBATCH --cpus-per-task=20            # Number of CPU cores per task

cd /project2/gilad/anthonyhung/Projects/OAStrain_project/OAStrain/

module load R/3.4.3
Rscript code/gom-semisup.R
