#!/bin/bash
# downsample fastq files to sizes of 1M and 5M
for FQZ in *gz ; do
  for NUM in 1000000 5000000 ; do
    FQZOUT=`echo $FQZ | sed "s/.fq.gz/_${NUM}.fq.gz/"`
    zcat $FQZ \
    | paste - - - - \
    | shuf -n $NUM \
    | tr '\t' '\n' \
    | pigz > $FQZOUT &
  done
done

wait
