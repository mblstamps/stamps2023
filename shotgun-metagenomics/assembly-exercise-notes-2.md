# An Assembly Exercise NOTES / July 24 / STAMPS 2023

[![hackmd-github-sync-badge](https://hackmd.io/5VATp0dUTBuTiG1HYUzxRQ/badge)](https://hackmd.io/5VATp0dUTBuTiG1HYUzxRQ)

Working individually or in groups, please reconstruct the original text for the handouts I've given you. You may use the computer as you wish, but I suggest you avoid any attempts at programming... and **DO NOT GOOGLE THE DATA PLEASE :).**

You have 30 minutes.

Specific questions:

* what techniques or tactics are you using?
* suppose you had to do this with lots more data; how would you do it?
* what advantages do you have in this exercise (English) over DNA?
* what are the pluses and minuses of the two different datatypes?
* Does the order or organization of reads matter?
* if you get to use a reference, how do you know it’s the right reference?
    * (and what strategies might you use to validate your assembly?)
* what strategy would you use if I told you you could employ as many undergrads as you wanted to do this?

---

answers assembly exercise

**3 strategies typically observed:**
1. Alignment of common words/letters/phrases
    - seeded overlap/layout/consensus
    - attempt to find sections that align and extend outwards
    - OLC assembly
    - complicated by severity of errors
2. Extension from common words/letters/phrases
    - start with one word, expand outwards from that word
    - De Bruijn graph assembly
    - K-mers
    - the worst with severe errors; extension will be halted by areas with low reads/high error
    - this approach will store more words, so it will need more memory with more data (?)
3. Greedy
    - greedy assembly

**The best strategy for teams:** have every member of a group come up with their own conclusion, then compare and correct
This prevents people from building on each other's mistakes

**This exercise is easier** than real genomic analysis: the language is known, the word boundaries are maintained, the error rate is low, there are no reverse complement reads

**Multiple flavors of scale challenges**
- size of genome
    - bacterial vs. human, for example
- depth of sequencing
    - number of reads to align
    - throwing away reads that have already been resolved accelerates the process by reducing the overall load

**Long vs. short reads**
- Long reads critical to overcoming repetition
- Short reads have better fidelity
- Most approaches combine long and short reads
- Currently, only way to rely on long reads to generate a high-quality genome is PacBio
    - Nanopore can't
    - And PacBio is v expensive


* what strategies?
    * greedy
    * overlap-layout-consensus
    * word-based "pivot"
* _average_ coverage vs _actual_ coverage
* it helps that we know the language - imagine doing this in a language you didn't know!
* more data is not *necessarily* helpful without a good strategy... welcome to bioinformatics!
    * how do you deal with data with different errors, biases, etc?
* what strategies do you have for validation?
    * words? (k-mers)
    * sentences? (mapping)
    * "does it make sense" -> is that a good strategy?
    * (what kinds of errors might you expect?)
        * errors vs variants
        * how do you deal with repeats?
    * do you use all the data?
        * internal validation vs external validation
        * same samples / technical
        * different samples / biological

## Data type musings

More fundamental q: is there sufficient information to reconstruct the true text?

* Types of samples and assumptions
    * genomics: ~single genome
    * rnaseq: ~single genome, multiple splice variants
    * metagenomics: ~multiple genomes, multiple strain variants
* assumptions of clonality
* Types of data / information content
    * short reads
    * long reads
    * 10x
    * long range scaffolding
    * hi-c / contacts
* Errors and types of errors in data and effects
* Types of errors in assemble

## Data uses in bioinfo

this is shotgun sequencing: assumption of even sampling of nucleotide content.

fundamentally, three strategies for making use of shotgun sequencing:

* assembly
    * construct new sequence!
    * assumption of ~little strain variation
* mapping
    * reference dependent / biased
* quantification
    * assumptions about coverage/sampling rate

