This dataset provides supporting data and code for manuscript titled:

"Accuracy, speed and error tolerance of short DNA sequence aligners"

By Mark Ziemann

mark.ziemann@gmail.com

Baker IDI Heart and Diabetes Institute, Melbourne, Victoria 3004


Abstract
Aligning short DNA sequence reads to the genome is an early step in the processing of many
types of genomics data, and impacts on the fidelity of downstream results. In this work,
the accuracy, speed and tolerance to errors are evaluated in read of varied length for six
commonly used mapping tools; BWA aln, BWA mem, Bowtie2, Soap2, Subread and STAR. The
accuracy evaluation using Illumina-like simulated reads showed that accuracy varies by read
length, but overall BWA aln was most accurate, followed by BWA mem and Bowtie2. BWA mem 
was most accurate with Ion Torrent-like read sets. STAR was at least 5 fold faster than 
Bowtie2 or BWA mem. BWA mem tolerated the highest density of mismatches and indels compared
to other mappers. These data provide important accuracy and speed benchmarks for commonly
used mapping software.


This data set contains all binaries, custom scripts, final data used in the paper.

Here is a description of the contents of this folder:

-genomes: Contains the genome fasta files used

-software: Contains the binaries and source code for external tools used in this work

-sim_illumina: Contains scripts and read sets used to generate data for figure 1.

-sim_torrent: Contains scripts and read sets used to generate data for figure 2.

-sim_mutation: Contains script used to genreate readssets and data for figures 3 and 4, as
the read sets are really large these weren't included in this repository but can be
regenerated with the provided scrpts.

-speed: Contains scripts and read sets used to generate data for figure 5.
