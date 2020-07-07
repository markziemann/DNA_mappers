#!/bin/bash
GENOME_FA_IN=../../genomes/athaliana/Arabidopsis_thaliana.TAIR10.30.dna.genome.fa
CHR=${GENOME_FA_IN}.g
GENOME_FA_FMT=`echo $GENOME_FA_IN | sed 's/.fa$/_fmt.fa/'`

sed '/\>/!s/[DKMRSWY]/N/g' $GENOME_FA_IN > $GENOME_FA_FMT
samtools faidx $GENOME_FA_FMT
cut -f-2 ${GENOME_FA_FMT}.fai > $CHR

READLENGTHRANGE='50 100 200 500'
STEP=10
PFX=ath_

for RDLEN in $READLENGTHRANGE
do
echo $RDLEN
bedtools makewindows -w $RDLEN -s $STEP -g $CHR \
| awk -v L=$RDLEN '($3-$2)==L' \
| bedtools getfasta -fi $GENOME_FA_FMT -bed - -fo /dev/stdout \
| tr ':' '-' | pigz > ${PFX}${RDLEN}bp.fasta.gz  &
done
wait
