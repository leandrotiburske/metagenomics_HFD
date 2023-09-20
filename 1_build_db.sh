#!/bin/bash -l
#SBATCH -A naiss2023-22-882
#SBATCH -p core
#SBATCH -n 8
#SBATCH -J build_reference_db
#SBATCH -t 03:00:00
#SBATCH --open-mode=append
#SBATCH --mail-type=ALL
#SBATCH --mail-user=leati05@liu.se

# load modules
module load bioinfo-tools
module load BioBakery

# Concatenates mice and phi-X genomes to remove contaminant reads
cat \
    ./ref_db/GCF_000001635.27_GRCm39_genomic.fna \
    ./ref_db/NC_001422_1.fasta > ./ref_db/ref.fasta

cd ref_db

# Builds indexed contaminant database
bowtie2-build \
    ./ref.fasta \
    bowtie2_files

cd ..