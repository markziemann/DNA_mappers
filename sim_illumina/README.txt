The illumina-like sequence reads were simulated by ART (Huang et al, 2012) using the
Ensembl genome as template. "sim_art.sh" is the simulation script used. The fastq
files are provided.

The next step is to map the sequences to the genome. This was done with the "aln_art.sh"
script. The alignment files produced are in bam format.

The read mapping positions are evaluated using the "mapeval_art.sh" script that requires
the ART-generated alignments in bam format (ie. hsa_art_100.bam). The results are output 
to "AlignmentResult1.txt". 

The column headers are provided in the "AlignmentResult1.txt". Here is some further info:
Col1=bam file name
Col2=Map Q threshold used
Col3=Total reads
Col4=Correctly mapped reads
Col5=Incorrectly mapped reads
Col6=Precision
Col7=Recall
Col8=F1 measure
Col9=F0.25 measure

1)Huang W, Li L, Myers JR, Marth GT. ART: a next-generation sequencing read
simulator. Bioinformatics. 2012 Feb 15;28(4):593-4.


