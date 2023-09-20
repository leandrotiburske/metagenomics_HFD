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

# Each sample (R1 and R2 files) must be within an individual directory indise "input"
# Run code in the Analysis directory  
# run fastqc and multiqc
mkdir -p fastqc_out

cd input/

for fastq in ./* 
do
    fastqc -o ../fastqc_out $fastq/$(basename "$fastq")_1.fastq.gz  
    fastqc -o ../fastqc_out $fastq/$(basename "$fastq")_2.fastq.gz
done

cd ../fastqc_out/

multiqc *_1_fastqc.zip -o forward_multiqc
multiqc *_2_fastqc.zip -o reverse_multiqc