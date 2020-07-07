The Ion Torrent like reads were simulated using DWGSIM tool with the "torrentsim.sh" script.
DWGSIM was written by Nils Homer (https://github.com/nh13/DWGSIM).

The reads were mapped using the "aln_torrent.sh" and "tmap.sh" scripts.

The alignment files were analysed using the "mapeval.sh" script. The final results are found
in the "AlignmentResult.txt" file. Columns if the "AlignmentResult.txt" file as as follows:
Col1=bam file name
Col2=Map Q threshold used
Col3=Total reads
Col4=Correctly mapped reads
Col5=Incorrectly mapped reads
Col6=Precision
Col7=Recall
Col8=F1 measure
Col9=F0.25 measure

