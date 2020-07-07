#!/bin/bash
set -x
# Declare alignment functions

aln_bwamem(){
BWA='../../software/bwa-0.7.13/bwa'
SAMTOOLS='../../software/samtools-1.3/samtools'
REF=../../genomes/hsapiens/bwa/Homo_sapiens.GRCh38.dna.primary_assembly.fa
FQ=$1
TMP=bwa-mem.benchmark.txt
sync; echo 3| sudo tee /proc/sys/vm/drop_caches > /dev/null
/usr/bin/time --format "%e\t%M\t%P" --output=tmp $BWA mem -t 30 $REF $FQ > /dev/null
cat tmp >> $TMP
}
export -f aln_bwamem


aln_bwaaln(){
BWA='../../software/bwa-0.7.13/bwa'
SAMTOOLS='../../software/samtools-1.3/samtools'
REF=../../genomes/hsapiens/bwa/Homo_sapiens.GRCh38.dna.primary_assembly.fa
FQ=$1
TMP=bwa-aln.benchmark.txt
sync; echo 3| sudo tee /proc/sys/vm/drop_caches > /dev/null
/usr/bin/time --format "%e\t%M\t%P" --output=tmp $BWA aln -t 30 $REF $FQ | $BWA samse $REF - $FQ > /dev/null
cat tmp >> $TMP
}
export -f aln_bwaaln

aln_bowtie2(){
BOWTIE2='../../software/bowtie2-2.2.8/bowtie2'
SAMTOOLS='../../software/samtools-1.3/samtools'
REF=../../genomes/hsapiens/bowtie2/Homo_sapiens.GRCh38.dna.primary_assembly.fa
FQ=$1
TMP=bt2.benchmark.txt
sync; echo 3| sudo tee /proc/sys/vm/drop_caches > /dev/null
/usr/bin/time --format "%e\t%M\t%P" --output=tmp $BOWTIE2 -p30 -x $REF -U $FQ > /dev/null
cat tmp >> $TMP
}
export -f aln_bowtie2

aln_soap(){
SOAP='../../software/soap2.21release/soap'
SOAP2SAM='../../software/soap2.21release/soap2sam.pl'
SAMTOOLS='../../software/samtools-1.3/samtools'
REF=../../genomes/hsapiens/soap/Homo_sapiens.GRCh38.dna.primary_assembly.fa.index
FQ=$1
TMP=soap.benchmark.txt
sync; echo 3| sudo tee /proc/sys/vm/drop_caches > /dev/null
/usr/bin/time --format "%e\t%M\t%P" --output=tmp $SOAP -p 30 -a $FQ -D $REF -o /dev/stdout | $SOAP2SAM -p - > /dev/null
cat tmp >> $TMP
}
export -f aln_soap

aln_subread(){
#SUBREAD='../../software/subread-1.5.0-p1-Linux-x86_64/bin/subread-align'
SUBREAD='../../software/subread-1.5.0-p1-source/bin/subread-align'
SAMTOOLS='../../software/samtools-1.3/samtools'
REF=/data/projects/mziemann/dna_aligners/genomes/hsapiens/subread/Homo_sapiens.GRCh38.dna.primary_assembly.fa
PWD=`pwd`
HEADER=header.txt
FQ=$1
TMP=sr.benchmark.txt
sync; echo 3| sudo tee /proc/sys/vm/drop_caches > /dev/null
/usr/bin/time --format "%e\t%M\t%P" --output=tmp $SUBREAD --SAMoutput -t 1 -T 30 -i $REF -r $FQ > /dev/null
cat tmp >> $TMP
}
export -f aln_subread

aln_star(){
set -x
STAR='../../software/STAR-master/bin/Linux_x86_64/STAR'
SAMTOOLS='../../software/samtools-1.3/samtools'
REF=../../genomes/hsapiens/STAR/
FQ=$1
TMP=star.benchmark.txt
sync; echo 3| sudo tee /proc/sys/vm/drop_caches > /dev/null
/usr/bin/time --format "%e\t%M\t%P" --output=tmp $STAR --readFilesIn $FQ \
--alignIntronMax 1 \
--genomeLoad LoadAndKeep \
--genomeDir $REF \
--runThreadN 30 \
--outStd SAM > /dev/null
cat tmp >> $TMP
}
export -f aln_star

# Run the alignments
for REP in {1..3} ; do
sync; echo 3| sudo tee /proc/sys/vm/drop_caches > /dev/null
SEQS=*fq
parallel -j1 aln_bwaaln ::: $SEQS
parallel -j1 aln_bwamem ::: $SEQS
parallel -j1 aln_bowtie2 ::: $SEQS
parallel -j1 aln_soap ::: $SEQS
parallel -j1 aln_star ::: $SEQS
parallel -j1 aln_subread ::: $SEQS
done
