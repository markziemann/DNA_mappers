To determine mapper robustness to errors. First perfectly matching reads were simulated
using a custom script "simreads.sh" at a range of read lengths.

As these sequence files are very large and the script produces the same result each time,
the fasta sequnce files are not provided here, but can be regenrated using the scripts.

Then msbar was used to incorporate mismatches and indels at various frequencies in the
script "mut.sh". msbar is a part of the EMBOSS toolkit (Rice et al, 2000). 

The reads were mapped to the genome using the "aln_mut.sh" script.

Read mapping analysis was performed with "mapeval.sh" and the results are saved in the
"AlignmentResult.txt" file. Columns in the "AlignmentResult.txt" file are as follows:

Col1=bam file name
Col2=Map Q threshold used
Col3=total reads in fasta file
Col4=number correctly mapped reads
Col5=number incorrectly mapped reads
Col6=precision
Col7=recall
Col8=F1 measure
Col9=F0.25 measure

Rice P, Longden I, Bleasby A. EMBOSS: the European Molecular Biology Open
Software Suite. Trends Genet. 2000 Jun;16(6):276-7. PubMed PMID: 10827456.

