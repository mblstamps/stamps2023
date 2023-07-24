
[toc]

<!-- @ctb reset smash/etc environment? -->

# Assembly hands-on - STAMPS 2023 lecture

[![hackmd-github-sync-badge](https://hackmd.io/ySOr7OgWQ7WP5HawYOPzqA/badge)](https://hackmd.io/ySOr7OgWQ7WP5HawYOPzqA)

## Introduction to data and software

For practical purposes (time/memory), we will use resequencing data from the [*E. coli REL606* genome](), published by the Lenski Lab as part of the Long Term Evolution Experiment - specifically, short paired-end Illumina reads from this genome [SRR2584857](https://www.ebi.ac.uk/ena/browser/view/SRR2584857).

We will use the [megahit](https://github.com/voutcn/megahit) de novo assembler to assemble the genome, and summary statistics via [quast](https://quast.sourceforge.net/), k-mers via [sourmash](https://sourmash.readthedocs.io/), and read mapping via [minimap2](https://github.com/lh3/minimap2) to evaluate the assembly.

## Connect to your remote computer via RStudio

We'll need to use a remote computer to run the assembler. This is partly because the data is large, and partly because the software only works on Linux or Mac, and partly because it needs a lot of memory and compute and runs a lot faster on our 

Find your remote computer via the [list of computers for students](https://hackmd.io/oz5sTY9KRCqdHHkM9iNJyg?view), and open the
RStudio link. Log in to RStudio and then go
to the `Terminal` prompt.

(You can also ssh in to the remote computer or use JupyterLab.)

## Installing software

First, run the following command to create a conda environment named `assembly` that contains the necessary software:
```
mamba create -n assembly -c conda-forge -c bioconda \
    quast sourmash megahit samtools
```

This will take a minute to run.

Once it succeeds, activate the software environment:
```
conda activate assembly
```

(For more information on conda, see the conda chapter of [Introduction to Remote Computing](https://ngs-docs.github.io/2021-august-remote-computing/).)

## Make a subdirectory to work in

It's always nice to work in a project specific directory! Let's create one:

```
mkdir ~/assembly_work
cd ~/assembly_work
```

Your prompt should now look like this:
```
(assembly) stamps@149.165.175.0:~/assembly_work$ 
 ^^^^^^^^                       ^^^^^^^^^^^^^^^
 conda software env             working directory
```

## Linking in data

We have already downloaded the data for you and placed it in a shared space - you can copy it onto your remote computer like so:
```
cp /opt/shared/assembly/SRR2584857_* .
```

Look at it! Marvel at its size!
```
ls -lh
```
(You should see two files, each 180 MB in size.)

## Running the assembler

Now let's run an assembler to look for overlaps among the reads and generate contigs:
```
megahit -1 SRR2584857_1.fastq.gz -2 SRR2584857_2.fastq.gz \
    -o ecoli_rel606
```

This produce a directory `ecoli_rel606/` containing a bunch of files - we want the `final.contigs.fa` file:

```
cp ecoli_rel606/final.contigs.fa assembly.fa
```

## Generate summary statistics for the assembly

The [quast](https://quast.sourceforge.net/) program produces some nice summary statistics:
```
quast assembly.fa
cat quast_results/latest/report.txt
```

My results look like this:

```
All statistics are based on contigs of size >= 500 bp, unless otherwise noted (e.g., "# contigs (>= 0 bp)" and "Total length (>= 0 bp)" include all contigs).

Assembly                    assembly
# contigs (>= 0 bp)         126     
# contigs (>= 1000 bp)      92      
# contigs (>= 5000 bp)      68      
# contigs (>= 10000 bp)     65      
# contigs (>= 25000 bp)     52      
# contigs (>= 50000 bp)     33      
Total length (>= 0 bp)      4557069 
Total length (>= 1000 bp)   4542425 
Total length (>= 5000 bp)   4474835 
Total length (>= 10000 bp)  4451946 
Total length (>= 25000 bp)  4249832 
Total length (>= 50000 bp)  3540628 
# contigs                   103     
Largest contig              326752  
Total length                4549884 
GC (%)                      50.72   
N50                         98799   
N90                         30945   
auN                         113255.8
L50                         16      
L90                         47      
# N's per 100 kbp           0.00   
```

Questions:
* why so many contigs?
* why so many *short* contigs?
* is this a good assembly??

## Download reference genome

In this case we know what the reference genome is; let's download it [from NCBI!](https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=Info&id=413997). (Usually you don't have your reference genome! ;)
```
curl -JLO https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/017/985/GCA_000017985.1_ASM1798v1/GCA_000017985.1_ASM1798v1_genomic.fna.gz
```
This produces a file `GCA_000017985.1_ASM1798v1_genomic.fna.gz`

## Sketch everything into k-mer signatures

Now we're going to turn everything into short DNA works (k-mers), so that we can compare things without aligning anything. For this we are using [sourmash](https://sourmash.readthedocs.io/) to create k-mer signatures from each data set.

First, sketch the reads:
```
sourmash sketch dna SRR2584857_?.fastq.gz \
    --name reads -o reads.sig.gz -p abund
```

Second, sketch the assembly:
```
sourmash sketch dna assembly.fa \
    --name assembly -o assembly.sig.gz
```

And third, sketch the reference genome:
```
sourmash sketch dna GCA_000017985.1_ASM1798v1_genomic.fna.gz \
    --name reference -o ref.sig.gz
```

Q: Why does it take so much longer to sketch the reads than the assembly or the reference?

## Compare the k-mer signatures

Let's do a Jaccard comparison; this is a pairwise distance metric that measures the ratio of the number of shared k-mers over the number of total k-mers in two sets. See formula [here](https://sourmash.readthedocs.io/en/latest/kmers-and-minhash.html#Calculating-Jaccard-similarity-and-containment).

This produces a similarity matrix:
```
sourmash compare *.sig.gz -o ecoli

sourmash plot ecoli --labels
```
and you can look at the result in the file `ecoli.matrix.png` (go check it out in the file browser!)

Here's what you should see:

![](https://hackmd.io/_uploads/H1onPH25h.png)


What does this mean??

* the assembly and the reference are really similar!
* but the collection of reads ...is not similar to either. Why?

The short answer is that k-mers include all the sequencing errors, while assemblies (and reference genomes) do not! And if you look at the Jaccard similarity formula, you'll see that the fewer k-mers that are shared, the lower the similarity.

Let's look at it another way - let's ask how many of the k-mers in the _reference_ are contained in the _reads_:

```
sourmash search --containment ref.sig.gz reads.sig.gz 
```

and how many of the k-mers in the _reads_ are in the _reference_:

```
sourmash search --containment reads.sig.gz ref.sig.gz --ignore-abundance
```

You can get both by using `sourmash sig overlap`:
```
sourmash sig overlap reads.sig.gz ref.sig.gz
```
and you should get:
```
similarity:                  0.28671
first contained in second:   0.28684
second contained in first:   0.99842

number of hashes in first:   15406
number of hashes in second:  4426

number of hashes in common:  4419
only in first:               10987
only in second:              7
total (union):               15413
```

And here's a venn diagram of the overlap between the assembly and the reads:

![](https://hackmd.io/_uploads/H1rrEw2qh.png)

and the overlap between the reference and the reads:

![](https://hackmd.io/_uploads/r1AJ4P253.png)

## Looking at high abundance k-mers

You can also get rid of k-mers that show up fewer than 20 times; how does that change the numbers?

First filter the k-mers by abundance:
```
sourmash sig filter -m 20 reads.sig.gz -o reads-high-abund.sig.gz
```
Next, do the clustering:
```
sourmash compare *.sig.gz -o high-abund

sourmash plot high-abund --labels --vmin 0.85
```

and take a look at the result:

![](https://hackmd.io/_uploads/SkVf1Ih5n.png)

Now you can see that the high abundance k-mers are much more similar to the reference and assembly than all the reads were!

## Mapping reads vs k-mers

Let's compare these numbers to read mapping numbers: we can map all the reads to the assembly and assess how many match.
```
minimap2 -ax sr assembly.fa SRR2584857_1.fastq.gz SRR2584857_2.fastq.gz | samtools view -b -o reads.x.assembly.bam

samtools flagstat reads.x.assembly.bam
```

and I should see:

```
4197690 + 0 properly paired (98.55% : N/A)
```

Here what you're seeing is that read mapping is pretty good (98.55% of the data matches!) while k-mers and Jaccard similarity is _slightly_ more sensitive to mismatches. We'll maybe talk more about this tomorrow.

## Tentative conclusions

Running an assembler is ~easy! You get contigs!

Those contigs resemble the high coverage portions of the (meta)genome, as represented by the input reads.

With short reads, you rarely get a really _long_ assembly. Long reads are needed for that.

Binning those contigs into genomes is more challenging... I personally recommend [ATLAS](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-020-03585-4), and we ran a tutorial on this [last year at STAMPS 2023](https://github.com/mblstamps/stamps2022/blob/main/assembly_and_binning/tutorial_assembly_and_binning.md) if you're interested in seeing what is involved.

The key lessons are really the same as what was in our assembly exercise:

* small errors get corrected.
* repeat sequences are hard to assemble ad frequently "break" contigs.
* repetitive regions, highly strain variable regions, or low coverage regions are largely missed in short-read/Illumina assemblies.

We'll talk a bit more about actual _metagenome_ assembly tomorrow.