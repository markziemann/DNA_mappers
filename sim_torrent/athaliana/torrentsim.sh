#!/bin/bash
DWGSIM=/data/projects/mziemann/dna_aligners/software/DWGSIM/dwgsim
REF=/data/projects/mziemann/dna_aligners/genomes/athaliana/Arabidopsis_thaliana.TAIR10.30.dna.genome.fa

$DWGSIM -1 50 -2 0 -c 2 -N 1000000 -B -f TACG $REF torrent_50.fq &
$DWGSIM -1 100 -2 0 -c 2 -N 1000000 -B -f TACG $REF torrent_100.fq &
$DWGSIM -1 200 -2 0 -c 2 -N 1000000 -B -f TACG $REF torrent_200.fq &
$DWGSIM -1 480 -2 0 -c 2 -N 1000000 -B -f TACG $REF torrent_480.fq &
wait


