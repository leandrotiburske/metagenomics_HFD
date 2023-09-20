#!/bin/bash -l
#SBATCH -A naiss2023-22-882
#SBATCH -p core
#SBATCH -n 8
#SBATCH -J quality_control
#SBATCH -t 03:00:00
#SBATCH --open-mode=append
#SBATCH --mail-type=ALL
#SBATCH --mail-user=leati05@liu.se

# load modules
module load bioinfo-tools
module load BioBakery

cd input

for fastq in ./* 
do
    kneaddata \
        --input $fastq/$(basename "$fastq")_1.fastq.gz --input $fastq/$(basename "$fastq")_2.fastq.gz \
        --output ../kneaddata_output/$fastq/ \
        -db ../ref_db/ \
        --run-trim-repetitive \
        --run-fastqc-start
done

cd ..