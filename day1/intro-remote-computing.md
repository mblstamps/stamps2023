
[toc]

## Data types and data analysis

(whiteboarding)

### 16S

16s - deep profiling of communities; targeted
bacteria/archaea only (18S, ITS for euks)
cluster/group - OTUs and ASVs
interpret OTUs/ASVs against a reference database => taxonomy
look at time courses or sample contrasts
function is typically inferred based on known representatives of species
rarely can get to species level or below
get to comparisons, ordination plots, and correlations with metadata
fairly mature field; lots of really interesting questions like,
- how do I handle lots (100, 1000s) of samples
- accounting for uneven sampling
- "Titus thinks the big questions of how to analyze 16S are at least well understood"

### Shotgun sequencing

shotgun - shallower but broader profiling of communities; ~untargeted
"everything DNA is sampled" including arc/bac, viruses and phage, euks
typically much larger files than 16S or other targeted - explain
reference-based interpretation vs de novo, OR construct MAGs => reference based
can get to arbitrary detailed (whole genomes), but with limitations
function is typically inferred based on gene presence/absence/abundance, gene clusters
field is still maturing; lots of tech development forthcoming; data set volume is challenge/problem
- MAG catalogs - ~1.3 million genomes publicy available now
- strain specificity is still tricky but we think it is possible; linkage is a problem; questions remain :)
- euks, viruses are part of the next frontier
- "Here the questions themselves are less well understood and precise."

## Remote Computing

(slides/presentation!)

Discussion points

* we will be using a remote computer for many parts of this course. This is for several reasons!
    * "bigger" than your laptop - more disk space, more RAM, more CPUs.
    * software installation is more straightforward! and in particular we can pre-install the same software for everyone!
    * we can store and also share big files there!
    * this represents a very common approach in bioinformatics: "compute elsewhere"
* how do you connect to it?? a myriad of ways -
    * ssh gives you a "command line interface" to the remote computer, usually via a "shell"
    * RStudio Server and Jupyter Lab are friendlier alternatives that connect via the Web
    * (many) other approaches exist! But we will be focusing on RStudio Server for now.

Note that this evening session will introduce RStudio and R, in more detail. For now we will be using it to upload and download files, as well as access the remote shell, but we won't be using R.

And remember if you already know all of this, that's great! We're trying to provide an on ramp for everyone for the first few days!

## Connecting to your remote RStudio

Go find your name and the associated RStudio  link on [the list of student computers](https://hackmd.io/oz5sTY9KRCqdHHkM9iNJyg?view). That connects you to your own personal remote computer for this course!

Log in with the username/password we'll give you. (It's pinned in the #general channel on slack!)

Once you're at the RStudio front page, put your good stickies up (blue/green)! If you run into problems, put your red stickies up. If you're still working, chill.

Brief overview:

* File browser (lower right)
* R console and Terminal window (lower left)
* File editor

### Create a directory

Create a folder or directory called `session2-intro/`:

![](https://hackmd.io/_uploads/HycjpJwqh.png)

### Create a text file

Use the editor to create a text file named `intro.txt`.

### Select the file and go to the Tools menu


![](https://hackmd.io/_uploads/HkB6p1v5h.png)

### Download the text file to your local computer

![](https://hackmd.io/_uploads/HJNJAJDqn.png)

### Edit it and upload it again

![](https://hackmd.io/_uploads/B12ZR1P5h.png)

### Concluding thoughts

The remote computer is a different thing than your laptop ;). But we can work to make it easy to run things on the remote computer and communicate files and results back and forth.

## Working on remote computers at the shell

Tutorial: [Working on remote computers at the shell](https://hackmd.io/qtds9NkrTHSKnrrh2_I64Q?view)

## More tutorials and links

Mike Lee (@astrobiomike) has an amazing set of resources under Happy Belly Bioinformatics - see his [UNIX home](https://astrobiomike.github.io/unix/)! We plan go through some of these at an evening session - particularly, ["Six glorious commands"](https://astrobiomike.github.io/unix/six-glorious-commands).

Titus has a [set of long-form tutorials on remote computing](https://ngs-docs.github.io/2021-august-remote-computing/index.html) that come with videos. If you skim them and have questions, please ask them!
