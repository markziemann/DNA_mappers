#!/bin/bash
REF=../../genomes/hsapiens/Homo_sapiens.GRCh38.dna.primary_assembly_fmt.fa
PFX=hsa_art
for LEN in 50 50 100 200 ; do
art_illumina -sam -i $REF -l $LEN -f 2 -o ath_art_${LEN}
done
art_illumina -sam -i $REF -p -m 480 -s 0 -l 250 -f 1 -o tmp
pear -v5 -j30 -f tmp1.fq -r tmp2.fq -o ath_art_500

