#!/bin/bash
for FQZ in *.fasta.gz
do
 for COUNT in 1 2 4 8 16 32
 do

 BASE=`echo $FQZ | sed 's/.fasta.gz//'`

 pigz -dc ${FQZ} \
 | msbar -sequence /dev/stdin -count $COUNT \
 -point 4 -block 0 -codon 0 -outseq /dev/stdout 2>/dev/null \
 | sed -n '/^>/!{H;$!b};s/$/ /;x;1b;s/\n//g;p' \
 | sed 's/ /\n/' | pigz > ${BASE}_${COUNT}snp.fasta.gz &

 pigz -dc ${FQZ} \
 | msbar -sequence /dev/stdin -count $COUNT \
 -point 2 -block 0 -codon 0 -outseq /dev/stdout 2>/dev/null \
 | sed -n '/^>/!{H;$!b};s/$/ /;x;1b;s/\n//g;p' \
 | sed 's/ /\n/' | pigz > ${BASE}_${COUNT}ins.fasta.gz &

 pigz -dc ${FQZ} \
 | msbar -sequence /dev/stdin -point 3 -count $COUNT \
 -block 0 -codon 0 -outseq /dev/stdout 2>/dev/null \
 | sed -n '/^>/!{H;$!b};s/$/ /;x;1b;s/\n//g;p' \
 | sed 's/ /\n/' | pigz > ${BASE}_${COUNT}del.fasta.gz &

 wait
 done
done

