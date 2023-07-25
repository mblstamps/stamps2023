SAMPLES = ['SRR8859675']
MAGS = ["MAG1", "MAG2", "MAG3"]


rule all:
    input:
        sankey=expand("{sample}.x.gtdbMAGS.sankey.png", sample=SAMPLES),

# Rule to download the reference files
rule download_and_prep_reference_files:
    output:
        zip = "reference/gtdb-rs214-reps.k31.zip",
        lineages = "gtdb-rs214.taxonomy.sqldb",
    params:
        lineages_zip = "reference/gtdb-rs214.lineages.csv.gz"
    shell:
        """
        curl -JL https://farm.cse.ucdavis.edu/~ctbrown/sourmash-db/gtdb-rs214/gtdb-rs214-reps.k31.zip -o {output.zip}
        curl -JL https://farm.cse.ucdavis.edu/~ctbrown/sourmash-db/gtdb-rs214/gtdb-rs214.lineages.csv.gz -o {params.lineages_zip}
        sourmash tax prepare -t {params.lineages_zip} \
                             -o {output.lineages} -F sql
        """

#####################################
##############  SETUP  ##############
#####################################

# Rule to download the metagenome files
rule download_metagenome_files:
    output:
        r1="metagenome/{sample}_1.fastq.gz",
        r2="metagenome/{sample}_2.fastq.gz",
    shell:
        """
        mkdir -p metagenome
        curl -JL ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR885/005/SRR8859675/SRR8859675_1.fastq.gz -o {output.r1}
        curl -JL ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR885/005/SRR8859675/SRR8859675_2.fastq.gz -o {output.r2}
        """

# Rule to download additional files
rule download_contigs_and_mags:
    output:
        mag1="metagenome/MAG1.fasta",
        mag2="metagenome/MAG2.fasta",
        mag3="metagenome/MAG3.fasta",
        contigs="metagenome/SRR8859675_contigs.fasta",
    shell:
        """
        curl -JL https://osf.io/jf65t/download -o {output.mag1}
        curl -JL https://osf.io/fejps/download -o {output.mag2} 
        curl -JL https://osf.io/2a4nk/download -o {output.mag3}
        curl -JL https://osf.io/jfuhy/download -o {output.contigs}
        """

rule sourmash_sketch_contigs_maps:
    input:
        mag1="metagenome/MAG1.fasta",
        mag2="metagenome/MAG2.fasta",
        mag3="metagenome/MAG3.fasta",
        contigs="metagenome/SRR8859675_contigs.fasta",
    output:
        mag1="MAG1.fasta.sig",
        mag2="MAG2.fasta.sig",
        mag3="MAG3.fasta.sig",
        contigs="SRR8859675_contigs.fasta.sig",
    shell:
        """
        sourmash sketch dna {input} --name-from-first
        """


#######################################
#### Classify MAGs using sourmash ####
#######################################

rule sourmash_gather_mags:
    input:
        mag="{mag}.fasta.sig",
        reference="reference/gtdb-rs214-reps.k31.zip",
    output:
        gather_csv="{mag}.x.gtdb.csv",
    shell:
        """
        sourmash gather {input.mag} {input.reference} \
                        --threshold-bp=5000 -o {output}
        """

rule sourmash_classify_mags:
    input:
        mag_gather=expand("{mag}.x.gtdb.csv", mag=MAGS),
        tax_db="gtdb-rs214.taxonomy.sqldb",
    output: 
        "MAGs.lineage.csv",
    shell:
        """
        sourmash tax genome -g {input.mag_gather} \
                            -t {input.tax_db} -F lineage_csv \
                            --ani 0.8 -o MAGs
        """

#######################################
# Match Metagenome to Database & MAGs #
#######################################

rule sourmash_sketch_metagenome:
    input:
        r1="metagenome/{sample}_1.fastq.gz",
        r2="metagenome/{sample}_2.fastq.gz",
    output:
        sig="{sample}.sig.gz"
    shell:
        """
        sourmash sketch dna -p k=31,abund {input} \
                            -o {output} --name {wildcards.sample}
        """

rule sourmash_gather_gtdb_mags:
    input:
        metagenome_sig="{sample}.sig.gz",
        mag1="MAG1.fasta.sig",
        mag2="MAG2.fasta.sig",
        mag3="MAG3.fasta.sig",
        reference="reference/gtdb-rs214-reps.k31.zip",
    output:
        matches_zip="{sample}.x.gtdbMAGs.matches.zip",
        gather_csv="{sample}.x.gtdbMAGS.csv",
    shell:
        """
        sourmash gather {input.metagenome_sig} {input.mag1} {input.mag2} \
                        {input.mag3} {input.reference} \
                        --save-matches {output.matches_zip} \
                         -o {output.gather_csv}

        """

rule sourmash_tax:
    input:
        mag_lineages = "MAGs.lineage.csv",
        db_lineages = "gtdb-rs214.taxonomy.sqldb",
        gather_csv = "{sample}.x.gtdbMAGS.csv",
    output:
        gather_with_tax = "{sample}.x.gtdbMAGS.with-lineages.csv"
    shell:
        """
        sourmash tax metagenome -g {input.gather_csv} \
                        -t {input.db_lineages} -t {input.mag_lineages} \
                        -r order

        sourmash tax annotate -g {input.gather_csv} \
                                -t {input.db_lineages} -t {input.mag_lineages} 
        """

rule sourmashconsumr_plot_sankey:
    message: "Plotting sankey taxonomy diagram via sourmashconsumr"
    input:
        gather_with_tax="{sample}.x.gtdbMAGS.with-lineages.csv",
    output:
        sankey="{sample}.x.gtdbMAGS.sankey.png"
    shell:
        """
        Rscript plot-sourmash-sankey.R {input} {output}
        """
