# K-mer-based Taxonomic Profiling of an Environmental Metagenome

[![hackmd-github-sync-badge](https://hackmd.io/0ErEGoopTHaSwyRVoDovdg/badge)](https://hackmd.io/0ErEGoopTHaSwyRVoDovdg)

---

## Setup

In this session, we'll use sourmash to analyze the composition of a metagenome, both genomically and taxonomically. We'll also use sourmash to classify some MAGs and integrate them into our analysis.

### Install sourmash

First, we need to install the software! We'll use conda/mamba to do this.

The below command installs [sourmash](http://sourmash.readthedocs.io/) and [GNU parallel](https://www.gnu.org/software/parallel/).

Run:
```
# create a new environment
mamba create -n smash -y -c conda-forge -c bioconda sourmash parallel
```
to install the software, and then run

```
conda activate smash
```
to activate the conda environment so you can run the software.

:::success
Victory conditions: 
- your prompt should start with `(smash)  `
- you should now be able to run `sourmash` and have it output usage information!!
:::

### Create a working subdirectory

Make a directory named `kmers` and change into it.

```
mkdir -p ~/kmers
cd ~/kmers
```

### Get the reference and metagenome data

:::info
**We've prepared your remote computers with all data so we can avoid issues with download time.** If you're using this tutorial outside of STAMPS, there is download information at the bottom of the tutorial.
:::
Copy the data to your `kmers` folder
```
cp -r /opt/shared/kmers/smash-data/* ./
```
> This will copy two folders:
> - `reference`
> - `metagenome`
> These contain the important files we'll be using for this tutorial.


### The Lemonade Metagenome Dataset

We're going to start by doing a reference-based _compositional analysis_ of a metagenome sample sequenced by the microbial diversity course.

Paper: [Microbial community dynamics and coexistence in a sulfide-driven phototrophic bloom](https://environmentalmicrobiome.biomedcentral.com/articles/10.1186/s40793-019-0348-0)

![](https://hackmd.io/_uploads/H1kvgHhq3.png)
> The samples come from the Trunk River lagoon in Falmouth (just a short ways up the road!) which has large amounts of biomass and which experiences periodic bright yellow microbial blooms, typically associated with disturbances to the ecosystem (source). These metagenomes were sampled from human-made disturbances that caused blooms. The accession numbers are SRR8859675 and SRR8859678.

We'll use sample SRR8859675 for today, and you can view sample info [here](https://www.ebi.ac.uk/ena/browser/view/SRR8859675?show=reads) on the ENA.

### Prepare sample reads

First, we're going to prepare the metagenome for use with sourmash by converting it into a _signature file_ containing _sketches_ of the k-mers in the metagenome. This is the step that "shreds" all of the reads into k-mers of size 31, and then does further data reduction by [sketching](https://en.wikipedia.org/wiki/Streaming_algorithm) the resulting k-mers.

To build a signature file, we run `sourmash sketch dna` like so:
```
sourmash sketch dna -p k=31,abund metagenome/SRR8859675*.gz \
    -o SRR8859675.sig.gz --name SRR8859675
```
Here we're telling sourmash to sketch at k=31, and to track k-mer multiplicity (with 'abund'). We sketch _both_ metagenome files together into a single signature named `SRR8859675` and stored in the file `SRR8859675.sig.gz`.

When we run this, we should see:

>`calculated 1 signature for 3452142 sequences taken from 2 files`

which tells you how many reads there are in these two files!

If you look at the resulting files,
```
ls -lh SRR8859675*
```
you'll see that the signature file is _much_ smaller (2.5mb) than the metagenome files (~600mb). This is because of the way sourmash uses a reduced representation of the data, and it's what makes sourmash fast. Please see the paper above for more info!


### Look at Reference Database

For this purpose, we're need a database of known genomes. We'll use the GTDB genomic representatives database, containing ~85,000 genomes - that's because it's smaller than the full GTDB database (~403,000) or Genbank (~1.3m), and hence faster. But you can download and use those on your own, if you like! You can see all sourmash prepared reference databases on [the sourmash prepared databases page](https://sourmash.readthedocs.io/en/latest/databases.html).

This file is 2.2 GB:
```
ls -lh reference/gtdb-rs214-reps.k31.zip
```
and you can examine the contents with sourmash `sig summarize`:
```
sourmash sig summarize reference/gtdb-rs214-reps.k31.zip
```

which will show you:

```
** loading from 'reference/gtdb-rs214-reps.k31.zip'
path filetype: ZipFileLinearIndex
location: /home/stamps/kmers/smash-data/reference/gtdb-rs214-reps.k31.zip
is database? yes
has manifest? yes
num signatures: 85205
** examining manifest...
total hashes: 271122208
summary of sketches:
   85205 sketches with DNA, k=31, scaled=1000         271122208 total hashes
```

There's a lot of things to digest in this output but the two main ones are:
* there are 85,205 genome sketches in this database, for a k-mer size of 31
* this database represents 271 *billion* k-mers (multiply number of hashes by the scaled number)

Note that the GTDB prepared database we downloaded above was built using the same `sourmash sketch dna` command we used above, but applied to 85,000 genomes and stored in a zip file.

The associated taxonomy spreadsheet contains information connecting Genbank Assembly dataset identifiers (e.g. GCA_000008085.1) to the GTDB taxonomy - take a look:
```
head -2 reference/gtdb-rs214.lineages.csv
```
will show you:
```
ident,gtdb_representative,superkingdom,phylum,class,order,family,genus,species
GCA_000008085.1,t,d__Archaea,p__Nanoarchaeota,c__Nanoarchaeia,o__Nanoarchaeales,f__Nanoarchaeaceae,g__Nanoarchaeum,s__Nanoarchaeum equitans
```
Let's prepare the taxonomy database for faster access:
```
sourmash tax prepare -t reference/gtdb-rs214.lineages.csv \
    -o gtdb-rs214.taxonomy.sqldb -F sql
```
This creates a file `gtdb-rs214.taxonomy.sqldb` that contains all the information in the CSV file, but which is faster to load than the CSV file.


## Find matching reference genomes with `sourmash gather`

At last, we have the ingredients we need to analyze the metagenome against GTDB!
* the software is installed
* the GTDB database is downloaded
* the metagenome is downloaded and sketched

Now, we'll run the [sourmash gather](https://sourmash.readthedocs.io/en/latest/command-line.html#sourmash-gather-find-metagenome-members) command to find matching genomes.

Run gather - this will take ~6 minutes:
```
sourmash gather SRR8859675.sig.gz reference/gtdb-rs214-reps.k31.zip --save-matches matches.zip
```
Here we are saving the matching genome sketches to `matches.zip` so we can rerun the analysis if we like.

The results will look like this:
```
Prefetch found 38 signatures with overlap >= 50.0 kbp.
Doing gather to generate minimum metagenome cover.

overlap     p_query p_match avg_abund
---------   ------- ------- ---------
2.0 Mbp        0.4%   31.8%       1.3    GCF_004138165.1 Candidatus Chloroploca sp. Khr17 strain=Khr17, ASM413816v1
1.9 Mbp        0.5%   66.9%       2.1    GCF_900101955.1 Desulfuromonas thiophila strain=DSM 8987, IMG-taxon 2602042025 annotated assembly
0.6 Mbp        0.3%   23.3%       3.2    GCA_016938795.1 Chromatiaceae bacterium, ASM1693879v1
0.6 Mbp        0.5%   27.3%       6.6    GCA_016931495.1 Chlorobiaceae bacterium, ASM1693149v1

found 24 matches total;
the recovered matches hit 5.3% of the abundance-weighted query.
the recovered matches hit 2.4% of the query k-mers (unweighted).
```
In this output:
* the last column is the name of the matching GTDB genome
* the first column is the estimated overlap between the metagenome and that genome, in base pairs (estimated from shared k-mers)
* the second column, `p_query` is the percentage of metagenome k-mers (weighted by multiplicity) that match to the genome; this will approximate the percentage of _metagenome reads_ that will map to this genome, if you map.
* the third column, `p_match`, is the percentage of the genome k-mers that are matched by the metagenome; this will approximate the percentage of _genome bases_ that will be covered by mapped reads;
* the fourth column is the estimated mean abundance of this genome in the metagenome.

The other interesting number is here:
>`the recovered matches hit 5.3% of the abundance-weighted query`

which tells you that you should expect about 5.3% of the metagenome reads to map to these 24 reference genomes.

:::info
## Weighted vs Unweighted

Let's look at the summary lines at the bottom of the `gather` results:
```
found 24 matches total;
the recovered matches hit 5.3% of the abundance-weighted query.
the recovered matches hit 2.4% of the query k-mers (unweighted).
```
The `5.3% (abundance-weighted)`  is the percentage of the metagenome k-mers that are matched by all reference genomes, meaning ~95% of the dataset does not match any reference.  

The `2.4% (unweighted)` represents the proportion of _unique_ kmers in the metagenome that are found in any genome. This will approximate the percentage of _genome bases_ that will be covered by mapped reads


The `unweighted` percent is (approximately) the following:
* suppose you assembled the entire metagenome perfectly into perfect contigs (**note, this is impossible, although you can get close with "unitigs"**);
* and then matched all the genomes to the contigs;
* approximately 2.5% of the bases in the contigs would have genomes that match to them.

Interestingly, this is the _only_ number in this entire tutorial that is essentially impossible to estimate any way other than with k-mers.

This number is also a big underestimate of the "true" number for the metagenome - we'll discuss more later :)
:::

## Build a taxonomic profile of the metagenome

We can use these matching genomes to build a taxonomic profile of the metagenome using [sourmash tax metagenome](https://sourmash.readthedocs.io/en/latest/command-line.html#sourmash-tax-subcommands-for-integrating-taxonomic-information-into-gather-results).

This method has been shown to perform quite well in benchmarking using mock metagenome datasets. Read more about it for short and long reads in [Portik et. al 2022](https://link.springer.com/article/10.1186/s12859-022-05103-0).

Let's re-run gather so we can save CSV output. This run will be much faster, because instead of using the entire database, we'll used our pre-saved 'matches.zip' which contains all 24 genomes with matches to the metagenome.
```
# run gather, save the results to a CSV
sourmash gather SRR8859675.sig.gz matches.zip -o SRR8859675.x.gtdb.csv

# use tax metagenome to classify the metagenome
sourmash tax metagenome -g SRR8859675.x.gtdb.csv \
    -t gtdb-rs214.taxonomy.sqldb -F human -r order
```
this shows you the rank, taxonomic lineage, and weighted fraction of the metagenome at the 'order' rank.


## Interlude: why reference-based analyses are problematic for environmental metagenomes

Reference-based metagenome classification is highly dependent on the organisms present in our reference databases. For well-studied environments, such as human-associated microbiomes, your classification percentage is likely to be quite high. In contrast, this is an environmental metagenome, and you can see that we're estimating only 5.3% of it will map to GTDB reference genomes!

Wow, that's **terrible**! Our taxonomic and/or functional analysis will be based on only 1/20th of the data!

What could we do to improve that?? There are two basic options -

(1) Use a more complete reference database, like the entire GTDB, or Genbank. This will only get you so far, unfortunately. (See exercises at end.)
(2) Assemble and bin the metagenome to produce new reference genomes!

There are other things you could think about doing here, too, but these are probably the "easiest" options. Last year at STAMPS we assembled these data into Metagenome-Assembled Genomes (MAGs) with ATLAS as part of [Taylor Reiter's STAMPS 2022 tutorial on assembly and binning](https://github.com/mblstamps/stamps2022/blob/main/assembly_and_binning/tutorial_assembly_and_binning.md). Let's add the MAGs generated there to our analysis.

We'll need to:

* sketch the MAGs with k=31;
* re-run sourmash gather with both GTDB _and_ the MAGs.

Let's do it!!

## Use MAGs as additional "reference" genomes
Three MAGs were assembled and binned from the metagenomes. Let's see if including data from these metagenome-assembled genomes improves the classifable fraction of the metagenome.

Let's sketch the MAGs:
```
sourmash sketch dna metagenome/MAG*.fasta --name-from-first
```
here, `--name-from-first` is a convenient way to give them distinguishing names based on the name of the first contig in the FASTA file; you can see the names of the signatures by doing:
```
sourmash sig describe MAG1.fasta.sig
```

Now, let's re-do the metagenome classification with the MAGs:
```
sourmash gather SRR8859675.sig.gz MAG*.sig matches.zip -o SRR8859675.x.gtdb+MAGS.csv
```

and look, we classify a lot more!
```
overlap     p_query p_match avg_abund
---------   ------- ------- ---------
2.3 Mbp       12.1%   99.9%      39.4    MAG2_1
2.2 Mbp       26.5%   99.9%      92.4    MAG3_1
2.0 Mbp        0.4%   31.8%       1.3    GCF_004138165.1 Candidatus Chloroploca sp. Khr17 strain=Khr17, ASM413816v1
1.9 Mbp        0.5%   66.9%       2.1    GCF_900101955.1 Desulfuromonas thiophila strain=DSM 8987, IMG-taxon 2602042025 annotated assembly
1.0 Mbp        2.7%  100.0%      20.3    MAG1_1
0.6 Mbp        0.3%   23.2%       3.1    GCA_016938795.1 Chromatiaceae bacterium, ASM1693879v1
0.6 Mbp        0.1%   24.5%       2.1    GCA_016931495.1 Chlorobiaceae bacterium, ASM1693149v1
...
found 26 matches total;
the recovered matches hit 43.5% of the abundance-weighted query.
the recovered matches hit 4.0% of the query k-mers (unweighted).
```

Here we see a few interesting things -

(1) The three MAG matches are all ~100% present in the metagenome.
(2) They are all at high abundance in the metagenome, because assembly needs genomes to be ~5x or more in abundance in order to work!
(3) Because they're at high abundance and 100% present, they account for _a lot_ of the metagenome!

What's the remaining 50%? There are several answers -

(1) most of the genomes actually the metagenome aren't in our reference database;
(2) not everything in the metagenome is high enough coverage to bin into MAGs;
(3) not everything in the metagenome is bacterial or archaeal, and we didn't do viral or eukaryotic binning;
(4) some of what's in the metagenome k-mers may simply be erroneous (although with abundance weighting, this is likely to be only a small chunk of things)

## Add taxonomic information from these MAGs.

We can infer taxonomic information for the MAGs in a similar way as we did for the metagenome, above. 

### Classify the MAGs
First, classify the genomes using GTDB; this will use trace overlaps between contigs in the MAGs and GTDB genomes to find the reference genome that is most similar to the entire "MAG" (assembled contig bin).
```
for i in MAG*.fasta.sig
do
    # get 'MAG' prefix. => NAME
    NAME=$(basename $i .fasta.sig)
    # search against GTDB
    echo sourmash gather $i reference/gtdb-rs214-reps.k31.zip \
        --threshold-bp=5000 \
        -o ${NAME}.x.gtdb.csv
done | parallel
```
(This will take about a minute.)

Here, we're using a for loop and [GNU parallel](https://www.gnu.org/software/parallel/) to classify the three genomes in parallel.

If you scan the results quickly, you'll see that one MAG has matches in genus Prosthecochloris, another MAG has matches to Chlorobaculum, and one has matches to Candidatus Moranbacteria.

Let's classify them "officially" using sourmash and an average nucleotide identity threshold of 0.8 -
```
sourmash tax genome -g MAG*.x.gtdb.csv \
    -t gtdb-rs214.taxonomy.sqldb -F human \
    --ani 0.8
```
This is an extremely liberal ANI threshold, incidentally; in reality you'd probably want to do something more stringent, as at least one of these is probably a new species.

You should see:
```
>sample name    proportion   lineage
>-----------    ----------   -------
>MAG3_1             5.3%     d__Bacteria;p__Bacteroidota;c__Chlorobia;o__Chlorobiales;f__Chlorobiaceae;g__Prosthecochloris;s__Prosthecochloris vibrioformis
>MAG2_1             5.0%     d__Bacteria;p__Bacteroidota;c__Chlorobia;o__Chlorobiales;f__Chlorobiaceae;g__Chlorobaculum;s__Chlorobaculum parvum_B
>MAG1_1             1.1%     d__Bacteria;p__Patescibacteria;c__Paceibacteria;o__Moranbacterales;f__UBA1568;g__JAAXTX01;s__JAAXTX01 sp013334245
```
The proportion here is the fraction of k-mers in the MAG that are annotated.

Now let's turn this into a lineage spreadsheet:
```
sourmash tax genome -g MAG*.x.gtdb.csv \
    -t gtdb-rs214.taxonomy.sqldb -F lineage_csv \
    --ani 0.8 -o MAGs
```
This will produce a file `MAGs.lineage.csv`; let's take a look:
```
cat MAGs.lineage.csv
```
You should see:
```
>ident,superkingdom,phylum,class,order,family,genus,species
>MAG1_1,d__Bacteria,p__Patescibacteria,c__Paceibacteria,o__Moranbacterales,f__UBA1
568,g__JAAXTX01,s__JAAXTX01 sp013334245
>MAG2_1,d__Bacteria,p__Bacteroidota,c__Chlorobia,o__Chlorobiales,f__Chlorobiaceae,
g__Chlorobaculum,s__Chlorobaculum parvum_B
>MAG3_1,d__Bacteria,p__Bacteroidota,c__Chlorobia,o__Chlorobiales,f__Chlorobiaceae,
g__Prosthecochloris,s__Prosthecochloris vibrioformis
```

## Now let's re-classify the metagenome

If we re-classify the metagenome using the combined "reference" of GTDB + MAGs, we see:
```
sourmash tax metagenome -g SRR8859675.x.gtdb+MAGS.csv \
    -t gtdb-rs214.taxonomy.sqldb MAGs.lineage.csv \
    -F human -r order
```
Now only 56.5% remains unclassified, which is much better than before!

For the classified fraction, we can visualize the distribution of taxa using [sourmashconsumr](https://github.com/Arcadia-Science/sourmashconsumr/):

![](https://hackmd.io/_uploads/ryx1O4T53.png)

:::spoiler
:::warning

To build this plot, run the following in your terminal:
```
sourmash tax annotate -g SRR8859675.x.gtdb+MAGS.csv -t gtdb-rs214.taxonomy.sqldb MAGs.lineage.csv 
```
This adds a 'lineages' column to the gather results without doing any taxonomic summarization.

**Then go into your R Console.**

Install sourmashconsumr (warning, takes several minutes)
```
install.packages("remotes")
remotes::install_github("Arcadia-Science/sourmashconsumr")
```
Load packages
```
library(sourmashconsumr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
```

Load the data
```
gather_csv <- '~/kmers/SRR8859675.x.gtdb+MAGS.with-lineages.csv'
inf = sourmashconsumr::read_taxonomy_annotate(gather_csv) %>%
  dplyr::mutate(query_name = basename(query_filename))
```

plot
```
plot_taxonomy_annotate_sankey(taxonomy_annotate_df = inf, tax_glom_level = "order")
```

:::




## Summary of Taxonomic Profiling

To recap, we've done the following:
* analyzed a metagenome's composition against 85,000 GTDB genomes, using 31-mers;
* found that a disappointingly small fraction of the metagenome can be identified this way.
* incorporated MAGs built from the metagenome into this analysis, bumping up the classification rate to ~45%;
* added taxonomic output to both sets of analyses.

ATLAS only bins bacterial and archaeal genomes, so we wouldn't expect much in the way of viral or eukaryotic genomes to be binned.

:::info
## Optional Exercise: Evaluating how much of the metagenome assembled

How much of our metagenome even _assembles_?

First, sketch the assembled contigs into a sourmash signature:
```
sourmash sketch dna metagenome/SRR8859675_contigs.fasta --name-from-first
```

Let's pick a few of the matching genomes out from GTDB and evaluate how many of the k-mers from that genome match to the unassembled metagenome, and then how many of them match to the assembled contigs.

Now, extract one of the top gather matches to use as a query; this is "Chromatiaceae bacterium":
```
sourmash sig cat matches.zip --include GCA_016938795.1 -o GCA_016938795.sig
```

### Evaluate containment of known genomes in reads vs assembly


Now do a containment search of this genome against both the unassembled metagenome and the assembled (but unbinned) contigs -
```
sourmash search --containment GCA_016938795.sig \
    SRR8859675*.sig* --threshold=0 --ignore-abund
```
We see:
```
similarity   match
----------   -----
 23.3%       SRR8859675
  4.7%       SRR8859675_0
```
where the first match (at 23.3% containment) is to the metagenome. (You'll note this matches the % in the gather output, too.)

The second match is to the assembled contigs, and it's 4.7%. That means ~19% of the k-mers that match to this GTDB genome are present in the unassembled metagenome, but are lost during the assembly process.

Why? 

Some thoughts and answers

It _could_ be that the GTDB genome is full of errors, and those errors are shared with the metagenome, and assembly is squashing those errors. Yay!

But this is extremely unlikely... This GTDB genome was built and validated entirely independently from this sample...

It's more likely that one of two things is happening:

(1) this sample is at low abundance in the metagenome, and assembly can only recover parts of it.
(2) this sample contains _several_ strain variants of this genome, and assembly is squashing the strain variation, because that's what assembly does.

Note, you can try the above with another one of the top gather matches and you'll see it's *entirely* lost in the process of assembly -
```
sourmash sig cat matches.zip --include GCF_004138165.1 -o GCF_004138165.sig
sourmash search --containment GCF_004138165.sig \
    SRR8859675*.sig* \
    --ignore-abund --threshold=0
```
:::
## Concluding thoughts

Above, we demonstrated a _reference-based_ analysis of shotgun metagenome data using sourmash.

We then _updated our references_ using the MAGs produced from assembly and binning tutorial, which increased our classification rate substantially.

Last but not least, we (optionally) looked at the loss of k-mer information due to metagenome assembly.

All of these results were based on 31-mer overlap and containment with k-mers!

A few points:

* We would have gotten slightly different results using k=21 or k=51; more of the metagenome would have been classified with k=21, while the classification results would have been more closely specific to genomes with k=51;
* sourmash is a nice multitool for doing this, but you could have gotten similar results with other methods.
* Next steps here could include mapping reads to the genomes we found, and/or doing functional analysis on the matching genes and genomes.
* You can do downstream analyses (e.g. diff abundance) with sourmash gather -> taxonomy results. Here's a tutorial for building a **phyloseq** object: [From raw metagenome reads to phyloseq taxonomy table using sourmash gather and sourmash taxonomy](https://taylorreiter.github.io/2022-07-28-From-raw-metagenome-reads-to-phyloseq-taxonomy-table-using-sourmash-gather-and-sourmash-taxonomy/).



## References and Further Links

- If you want to read more about how sourmash sketching and gather, please see [Lightweight compositional analysis of metagenomes with FracMinHash and minimum metagenome covers](https://www.biorxiv.org/content/10.1101/2022.01.11.475838v2), Irber et al., 2022.
- For more on sourmash taxonomic profiling, see our paper [here](https://link.springer.com/article/10.1186/s12859-022-05103-0).
- We have a prototype frontend for running `sourmash gather` against the GTDB representatives database, [https://greyhound.sourmash.bio/](https://greyhound.sourmash.bio/). Try it out! It may not work for very large files :).


## After STAMPS: downloading this test data
:::spoiler

### Reference
```
mkdir -p ~/kmers/smash-data/reference
cd ~/kmers/smash-data/reference
```
Download the reference database:
```
curl -JLO https://farm.cse.ucdavis.edu/~ctbrown/sourmash-db/gtdb-rs214/gtdb-rs214-reps.k31.zip
```
Download and uncompress the taxonomy spreadsheet:
```
curl -JLO https://farm.cse.ucdavis.edu/~ctbrown/sourmash-db/gtdb-rs214/gtdb-rs214.lineages.csv.gz
gunzip gtdb-rs214.lineages.csv.gz
```

```
mkdir -p ~/kmers/smash-data/metagenome
cd ~/kmers/smash-data/metagenome
```

### Metagenome Data

To download the metagenome from the ENA, run:
```
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR885/005/SRR8859675/SRR8859675_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR885/005/SRR8859675/SRR8859675_2.fastq.gz
```

Download 3 MAGs generated by ATLAS
```
curl -JLO https://osf.io/fejps/download
curl -JLO https://osf.io/jf65t/download
curl -JLO https://osf.io/2a4nk/download
```

We'll use sample SRR8859675 for today, and you can view sample info [here](https://www.ebi.ac.uk/ena/browser/view/SRR8859675?show=reads) on the ENA.

If you want to just start at the Optional Assembly Loss exercise, you can download the files needed for the below sourmash searches from [this link](https://github.com/mblstamps/stamps2022/raw/main/kmers_and_sourmash/assembly-loss-files.zip).
:::
