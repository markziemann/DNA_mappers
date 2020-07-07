#!/bin/bash
REF=Arabidopsis_thaliana.TAIR10.30.dna.genome_fmt.fa
#art_illumina -sam -i $REF -l 100 -f 10 -o ath_art_100 &
#art_illumina -sam -i $REF -l 200 -f 15 -o ath_art_200 &
art_illumina -sam -i $REF -p -m 480 -s 0 -l 250 -f 30 -o tmp
pear -v5 -j30 -f tmp1.fq -r tmp2.fq -o ath_art_500
rm tmp*
