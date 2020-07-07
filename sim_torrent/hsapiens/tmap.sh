#!/bin/bash
#/data/projects/mziemann/dna_aligners/software/TMAP/tmap index -f  Homo_sapiens.GRCh38.dna.primary_assembly.fa
TMAP=/data/projects/mziemann/dna_aligners/software/TMAP/tmap
REF=/data/projects/mziemann/dna_aligners/genomes/hsapiens/tmap/Homo_sapiens.GRCh38.dna.primary_assembly.fa
for FQ in *fastq ; do
$TMAP map1 -f $REF -r $FQ -i fastq -s $FQ.sam
done
