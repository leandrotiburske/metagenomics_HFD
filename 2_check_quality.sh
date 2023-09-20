#!/bin/bash -l
#SBATCH -A naiss2023-22-882
#SBATCH -p core
#SBATCH -n 8
#SBATCH -J quality_check
#SBATCH -t 03:00:00
#SBATCH --open-mode=append
#SBATCH --mail-type=ALL
#SBATCH --mail-user=leati05@liu.se

# load modules
module load bioinfo-tools
module load FastQC/0.11.5
module load MultiQC/1.7

# Each sample (R1 and R2 files) must be within an individual directory inside "input"
# Note: Run code in the Analysis directory  
# Run fastqc and multiqc
mkdir -p fastqc_out

cd input/

# Performs FastQC separately for R1 and R2 files
for fastq in ./* 
do
    fastqc -o ../fastqc_out $fastq/$(basename "$fastq")_1.fastq.gz  
    fastqc -o ../fastqc_out $fastq/$(basename "$fastq")_2.fastq.gz
done

cd ../fastqc_out/

# Run MultiQC for R1 and R2 FastQC outputs separately
multiqc *_1_fastqc.zip -o forward_multiqc
multiqc *_2_fastqc.zip -o reverse_multiqc