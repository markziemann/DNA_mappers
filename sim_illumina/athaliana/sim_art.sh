#!/bin/bash
REF=../../genomes/athaliana/Arabidopsis_thaliana.TAIR10.30.dna.genome_fmt.fa
PFX=ath_art
for LEN in 50 50 100 200 ; do
art_illumina -sam -i $REF -l $LEN -f 2 -o ath_art_${LEN}
done
art_illumina -sam -i $REF -p -m 480 -s 0 -l 250 -f 1 -o tmp
pear -v5 -j30 -f tmp1.fq -r tmp2.fq -o ath_art_500
