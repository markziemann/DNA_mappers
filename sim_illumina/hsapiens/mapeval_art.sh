#!/bin/bash
tags(){
FAZ=$1
SEQ_TYPE=`echo $FAZ | egrep -c '(fq|fastq)' | sed 's/^1$/FQ/' | sed 's/^0$/FA/'`
TAGFILE=`echo $FAZ | sed 's/.gz$/.tags/'`

echo $FAZ $SEQ_TYPE $TAGFILE

if [ "$SEQ_TYPE" == "FA" ] ; then
  if [ ! -r $TAGFILE ] ; then
    zcat $FAZ | grep -c '>' > $TAGFILE
  fi
elif [ "$SEQ_TYPE" == "FQ" ] ; then
  if [ ! -r $TAGFILE ] ; then
    zcat $FAZ | sed -n '2~4p' | wc -l > $TAGFILE
  fi
fi
}
export -f tags
#parallel -j20 tags ::: *gz

mapeval_art() {
#set -x
BAM=$1
TMP=${BAM}.tmp
FAZ=`echo $BAM | rev | cut -d '.' -f3- | rev | sed 's/$/.gz/'`
TAGFILE=`echo $BAM | rev | cut -d '.' -f3- | rev | sed 's/$/.tags/'`
TOTAL=`head -1 $TAGFILE`

#Identify samfile
ART=`echo $BAM | sed 's/.fq./\t/' | cut -f1 | sed 's/$/.bam/'`
ARTTMP=$ART.tmp

#Output joined bedfile. 500bp reads need special treatment due to pe merge
IS_500=`echo $BAM | grep -c 500`
if [ "$IS_500" -eq "1" ] ; then
  ARTCNT=`samtools view -c $ART | awk '{print $1/2}'`
  join -1 4 -2 4 \
  <(bamToBed -i $ART | paste - - | awk '{OFS="\t"} {print $1,$2,$9,$4}' | cut -d '/' -f1 | sed 's/$/\t99\t+/'| sort -k 4b,4) \
  <(bamToBed -i $BAM | awk '!arr[$4]++' | sed 's#/1\t#\t#' | sort -k 4b,4) \
  > $TMP
else
  ARTCNT=`samtools view -c $ART`
  join -1 4 -2 4 \
  <(bamToBed -i $ART | sort -k 4b,4) \
  <(bamToBed -i $BAM | awk '!arr[$4]++' | sed 's#/1\t#\t#' | sort -k 4b,4) \
  > $TMP
fi

#find best Q
echo BAM Q TOTAL CORRECT INCORRECT PRECISION RECALL F1 F25
for Q in 0 1 2 3 4 5 10 15 20 25 30 ; do
#Count correct reads
CORRECT=`awk -v q=$Q '$10>=q' $TMP | awk '$2==$7  && $3>($8-100) && $6<($9+100)' | wc -l `
#Count incorrect reads
INCORRECT=`awk -v q=$Q '$10>=q' $TMP | awk '$2!=$7 || $3<($8-100) || $6>($9+100)' | wc -l `
PRECISION=`echo $CORRECT $INCORRECT | awk '{print $1/($1+$2)}'`
RECALL=`echo $CORRECT $INCORRECT $TOTAL | awk '{print ($1+$2)/$3}'`
F1=`echo $PRECISION $RECALL | awk '{print ($1+$2)/2}'`
F25=`echo $PRECISION $RECALL | awk '{print (1+(0.25^2))*$1*$2/(((0.25^2)*$1)+$2)}'`
#osa$F25=(1+(0.25^2))*prec*recall/(((0.25^2)*prec)+recall)
echo $BAM $Q $TOTAL $CORRECT $INCORRECT $PRECISION $RECALL $F1 $F25
done
#rm $TMP
}
export -f mapeval_art
parallel -j30 mapeval_art ::: hsa_art_500.fq*bam | tee -a AlignmentResult1.txt
exit
