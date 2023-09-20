#!/bin/bash -l
#SBATCH -A naiss2023-22-882
#SBATCH -p core
#SBATCH -n 8
#SBATCH -J composition
#SBATCH -t 04:00:00
#SBATCH --open-mode=append
#SBATCH --mail-type=ALL
#SBATCH --mail-user=leati05@liu.se

# load modules (Metaphlan 4.0.6)
module load conda
mamba activate mpa3.1

mkdir -p bowtie2out
mkdir -p metaphlan_output

metaphlan --version

for fastq in ./kneaddata_output/* 
do
    cd ./kneaddata_output/$(basename "$fastq")/
    metaphlan \
        $(basename "$fastq")_1_kneaddata_paired_1.fastq,$(basename "$fastq")_1_kneaddata_paired_2.fastq,$(basename "$fastq")_1_kneaddata_unmatched_1.fastq,$(basename "$fastq")_1_kneaddata_unmatched_2.fastq \
        --input_type fastq \
        -o ../../metaphlan_output/$(basename "$fastq")_profiled.txt \
        --index mpa_v30_CHOCOPhlAn_201901 \
        --bowtie2out ../../bowtie2out/$(basename "$fastq").bt2 \
        --bowtie2db ../../bowtie2db/ \
        --nproc 8
    cd ../..
done

merge_metaphlan_tables.py metaphlan_output/* > metaphlan_output/metaphlan_output.txt