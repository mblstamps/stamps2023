## Download and run a workflow

I've added all of the code we ran from this morning's [k-mer genome-resolved taxonomy tutorial](https://hackmd.io/0ErEGoopTHaSwyRVoDovdg?view) into a workflow file. Let's download a couple files:

```
cd ~/kmers
curl -JLO https://raw.githubusercontent.com/mblstamps/stamps2023/main/workflows/Snakefile
curl -JLO https://raw.githubusercontent.com/mblstamps/stamps2023/main/workflows/plot-sourmash-sankey.R
```

Let's activate our `smash` environment from earlier and install one more bit of software we need:
```
conda activate smash
mamba install -c conda-forge -c bioconda snakemake-minimal
```

First, let's see what steps will be run:
```
snakemake -p -n
```

Now, let's run these steps:
```
snakemake -p --cores 4
```


## What are we even running?

We're running a snakemake workflow!

[intro to snakemake](https://ngs-docs.github.io/2023-snakemake-book-draft/chapter_0.html)

We've given snakemake all of the steps we need to run, and told it how they interact.


## Workflow systems, in general

![](https://hackmd.io/_uploads/r1KDljT52.png)

From: [Streamlining data-intensive biology with workflow systems](https://academic.oup.com/gigascience/article/10/1/giaa140/6092773)



## Resources

- Paper: [Streamlining data-intenstive biology with workflow systems](https://academic.oup.com/gigascience/article/10/1/giaa140/6092773)
- [ANGUS 2019 lesson on GitHub](https://angus.readthedocs.io/en/2019/github.html)
- Snakemake Resources
    - Titus is writing a snakemake book!
        - [intro blog post](http://ivory.idyll.org/blog/2023-snakemake-slithering-section-1.html)
        - [draft book](https://ngs-docs.github.io/2023-snakemake-book-draft/)
    - [Anvi'o snakemake workflows](https://merenlab.org/2018/07/09/anvio-snakemake-workflows/)