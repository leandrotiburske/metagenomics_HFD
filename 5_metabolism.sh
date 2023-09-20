#!/bin/bash -l
#SBATCH -A naiss2023-22-882
#SBATCH -p core
#SBATCH -n 20
#SBATCH -J metabolism
#SBATCH -t 24:00:00
#SBATCH --open-mode=append
#SBATCH --mail-type=ALL
#SBATCH --mail-user=leati05@liu.se

# load modules (HUManN 3.6)
#module load conda
#mamba activate humann
module load bioinfo-tools
module load HUMAnN

mkdir -p humann_output
humann --version

for fastq in ./kneaddata_output/*
do

    cd ./kneaddata_output/$(basename "$fastq")/
    cat $(basename "$fastq")_1_kneaddata_paired_1.fastq \
    $(basename "$fastq")_1_kneaddata_paired_2.fastq \
    $(basename "$fastq")_1_kneaddata_unmatched_1.fastq \
    $(basename "$fastq")_1_kneaddata_unmatched_2.fastq > $(basename "$fastq")_humann_input.fastq

    humann \
    --input $(basename "$fastq")_humann_input.fastq \
    --input-format fastq \
    --taxonomic-profile ../../metaphlan_output/$(basename "$fastq")_profiled.txt \
    --search-mode uniref90 \
    --output ../../humann_output \
    --threads 8

    cd ../..
done

humann_join_tables \
    -i humann_output/ \
    -o humann_output/genefamilies.tsv \
    --file_name genefamilies

humann_renorm_table \
    -i humann_output/genefamilies.tsv \
    -o humann_output/genefamilies_cpm.tsv \
    --units cpm