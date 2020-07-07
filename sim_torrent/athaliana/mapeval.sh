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
parallel -j20 tags ::: *gz

mapeval() {
BAM=$1
TMP=${BAM}.tmp

MAPPER=`echo $BAM | cut -d '.' -f6`

if [ "$MAPPER" == "bwaaln" ] ; then
  Q=10
elif [ "$MAPPER" == "bwamem" ] ; then
  Q=10
elif [ "$MAPPER" == "soap" ] ; then
  Q=10
elif [ "$MAPPER" == "star" ] ; then
  Q=10
elif [ "$MAPPER" == "sr" ] ; then
  Q=10
elif [ "$MAPPER" == "tmap" ] ; then
  Q=10
elif [ "$MAPPER" == "bt2" ] ; then
  Q=10
fi

FAZ=`echo $BAM | rev | cut -d '.' -f3- | rev | sed 's/$/.gz/'`
TAGFILE=`echo $BAM | rev | cut -d '.' -f3- | rev | sed 's/$/.tags/'`

TOTAL=`head -1 $TAGFILE`
RL=`zcat $FAZ | sed -n '2~4p' | head | awk '{print length($1)}' | numaverage -M`

#Output bedfile
bamToBed -i $BAM | awk -v q=$Q '$5>=q' \
| shuf | awk '!arr[$4]++' | sed 's/_/\t/;s/_/\t/' \
| awk -v r=$RL '{OFS="\t"} {print $1,$2,$3,$4,$5,$5+r}' > $TMP

#Count correct reads
CORRECT=`awk '$1==$4' $TMP | awk '$2>($5-100) && $3<($6+100)' | wc -l `

#Count incorrect reads
INCORRECT=`awk '$1!=$4 || $2<($5-100) || $3>($6+100)' $TMP | wc -l `

PRECISION=`echo $CORRECT $INCORRECT | awk '{print $1/($1+$2)}'`
RECALL=`echo $CORRECT $INCORRECT $TOTAL | awk '{print ($1+$2)/$3}'`
F1=`echo $PRECISION $RECALL | awk '{print 2*($1*$2)/($1+$2)}'`
F25=`echo $PRECISION $RECALL | awk '{print (1+(0.25^2))*(($1*$2)/(((0.25^2)*$1)+$2))}'`
#osa$F25=(1+(0.25^2))*prec*recall/(((0.25^2)*prec)+recall)
echo $BAM $Q $TOTAL $CORRECT $INCORRECT $PRECISION $RECALL $F1 $F25
#rm $TMP
}
export -f mapeval

parallel -j30 mapeval ::: torrent*bam ::: 10 | tee AlignmentResult.txt
