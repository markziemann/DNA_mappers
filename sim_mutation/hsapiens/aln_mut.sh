#!/bin/bash
set -x
# Declare alignment functions

aln_bwamem(){
BWA='../../software/bwa-0.7.13/bwa'
SAMTOOLS='../../software/samtools-1.3/samtools'
REF=../../genomes/hsapiens/bwa/Homo_sapiens.GRCh38.dna.primary_assembly.fa
PWD=`pwd`
HEADER=header.txt
FQZ=$1
FQ=`echo $FQZ | sed 's/.gz$//'`
BASE=`echo $FQZ | sed 's/.gz$/.bwamem/'`
BAM=$BASE.bam
STATS=$BASE.stats
pigz -dc $FQZ | tee $BASE \
| $BWA mem -t 30 $REF - \
| $SAMTOOLS view -uSh - \
| $SAMTOOLS sort -@ 10 -T $BASE -o $BAM -
rm $BASE
$SAMTOOLS index $BAM
$SAMTOOLS flagstat $BAM > $STATS
$SAMTOOLS view -H $BAM > $HEADER
}
export -f aln_bwamem


aln_bwaaln(){
BWA='../../software/bwa-0.7.13/bwa'
SAMTOOLS='../../software/samtools-1.3/samtools'
REF=../../genomes/hsapiens/bwa/Homo_sapiens.GRCh38.dna.primary_assembly.fa
PWD=`pwd`
HEADER=header.txt
FQZ=$1
FQ=`echo $FQZ | sed 's/.gz$//'`
BASE=`echo $FQZ | sed 's/.gz$/.bwaaln/'`
BAM=$BASE.bam
STATS=$BASE.stats
pigz -dc $FQZ | tee $FQ \
| $BWA aln -t 30 $REF - \
| $BWA samse $REF - $FQ \
| $SAMTOOLS view -uSh - \
| $SAMTOOLS sort  -@ 10 -T $BASE -o $BAM -
rm $FQ
$SAMTOOLS index $BAM
$SAMTOOLS flagstat $BAM > $STATS
}
export -f aln_bwaaln

aln_bowtie2(){
BOWTIE2='../../software/bowtie2-2.2.8/bowtie2'
SAMTOOLS='../../software/samtools-1.3/samtools'
REF=../../genomes/hsapiens/bowtie2/Homo_sapiens.GRCh38.dna.primary_assembly.fa
PWD=`pwd`
HEADER=header.txt
FQZ=$1
FQ=`echo $FQZ | sed 's/.gz$//'`
BASE=`echo $FQZ | sed 's/.gz$/.bt2/'`
BAM=$BASE.bam
STATS=$BASE.stats
pigz -dc $FQZ \
| $BOWTIE2 -p30 -f -x $REF -U /dev/stdin -S $BASE.sam
$SAMTOOLS view -uSh $BASE.sam \
| $SAMTOOLS sort -@ 10 -T $BASE -o $BAM -
rm $BASE.sam
$SAMTOOLS index $BAM
$SAMTOOLS flagstat $BAM > $STATS
}
export -f aln_bowtie2

aln_soap(){
SOAP='../../software/soap2.21release/soap'
SOAP2SAM='../../software/soap2.21release/soap2sam.pl'
SAMTOOLS='../../software/samtools-1.3/samtools'
REF=../../genomes/hsapiens/soap/Homo_sapiens.GRCh38.dna.primary_assembly.fa.index
PWD=`pwd`
HEADER=header.txt
FQZ=$1
FQ=`echo $FQZ | sed 's/.gz$//'`
BASE=`echo $FQZ | sed 's/.gz$/.soap/'`
BAM=$BASE.bam
STATS=$BASE.stats
pigz -dc $FQZ > $FQ
#| perl /usr/local/bin/fasta_to_fastq.pl - - > $FQ.fq
$SOAP -p 30 -a $FQ -D $REF -o /dev/stdout \
| $SOAP2SAM -p - \
| cat $HEADER - \
| $SAMTOOLS view -uSh - \
| $SAMTOOLS sort -@ 10 -T $BASE -o $BAM -
$SAMTOOLS index $BAM
$SAMTOOLS flagstat $BAM > $STATS
}
export -f aln_soap

aln_subread(){
#SUBREAD='../../software/subread-1.5.0-p1-Linux-x86_64/bin/subread-align'
SUBREAD='../../software/subread-1.5.0-p1-source/bin/subread-align'
SAMTOOLS='../../software/samtools-1.3/samtools'
REF=/data/projects/mziemann/dna_aligners/genomes/hsapiens/subread/Homo_sapiens.GRCh38.dna.primary_assembly.fa
PWD=`pwd`
HEADER=header.txt
FQZ=$1
FQ=`echo $FQZ | sed 's/.gz$//'`
BASE=`echo $FQZ | sed 's/.gz$/.sr/'`
BAM=$BASE.bam
STATS=$BASE.stats
pigz -dc $FQZ > $FQ
$SUBREAD -t 1 -T 30 -i $REF \
-r $FQ -o $BASE.unsorted.bam
$SAMTOOLS sort -@ 10 -T $BASE -o $BAM $BASE.unsorted.bam
rm $BASE.unsorted.bam
$SAMTOOLS index $BAM
$SAMTOOLS flagstat $BAM > $STATS
}
export -f aln_subread

aln_star(){
set -x
STAR='../../software/STAR-master/bin/Linux_x86_64/STAR'
SAMTOOLS='../../software/samtools-1.3/samtools'
REF=../../genomes/hsapiens/STAR/
PWD=`pwd`
HEADER=header.txt
FQZ=$1
FQ=`echo $FQZ | sed 's/.gz$//'`
BASE=`echo $FQZ | sed 's/.gz$/.star/'`
BAM=$BASE.bam
STATS=$BASE.stats
pigz -dc $FQZ > $FQ
$STAR --readFilesIn $FQ \
--alignIntronMax 1 \
--genomeLoad LoadAndKeep \
--genomeDir $REF \
--runThreadN 30 \
--outSAMtype BAM SortedByCoordinate \
--limitBAMsortRAM 20000000000
mv Aligned.sortedByCoord.out.bam $BAM
rm $FQ
$SAMTOOLS index $BAM
$SAMTOOLS flagstat $BAM > $STATS
}
export -f aln_star

# Run the alignments
SEQS=../../simreads/hsapiens/hsa_art_500.fq.gz
parallel -j4 aln_bwaaln ::: $SEQS
parallel -j4 aln_bwamem ::: $SEQS
parallel -j4 aln_bowtie2 ::: $SEQS
parallel -j4 aln_soap ::: $SEQS
parallel -j1 aln_star ::: $SEQS
parallel -j4 aln_subread ::: $SEQS

