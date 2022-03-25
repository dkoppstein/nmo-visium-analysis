import os
from os.path import join as pjoin

import pandas as pd
from snakemake.utils import validate, min_version
##### set minimum snakemake version #####
min_version("5.1.2")



##### load config and sample sheets #####

configfile: pjoin(workflow.basedir, "config.yaml")
#validate(config, schema="schemas/config.schema.yaml")

SNAKEMAKE_WRAPPER_VERSION = config["snakemake_wrapper_version"]
RUNS = config["runs"]


#samples = pd.read_table(config["samples"]).set_index("sample", drop=False)
#validate(samples, schema="schemas/samples.schema.yaml")

#units = pd.read_table(pjoin(workflow.basedir, config["units"]), dtype=str).set_index(["sample", "unit"], drop=False)
#units.index = units.index.set_levels([i.astype(str) for i in units.index.levels])  # enforce str in index
#print(units)

#polya_units = units[units["library_type"] == "polya"]
#clontech_units = units[units["library_type"] == "clontech"]
#validate(units, schema="schemas/units.schema.yaml")

##### target rules #####

#all_clontech_files = expand("small/{unit.sample}-{unit.unit}_mapped_to_GRCh38.sorted.bam.bai", unit=clontech_units.itertuples())

#rule all_clontech:
#    input: all_clontech_files

#rule all:
#    input:
#        expand("star/{unit.sample}-{unit.unit}/Aligned.out.sorted.bam.bai", unit=polya_units.itertuples()),
#        expand("star/{unit.sample}-{unit.unit}/Aligned.{strand}.bw", unit=polya_units.itertuples(), strand=["forward", "reverse"]),
         #"results/pca.svg",
        #"qc/multiqc_report.html",
#	expand("counts/{library_type}/all_counts_mapped_to_{gtf}.txt", library_type=["polya"], gtf=["gencode"])


rule demux:
    input:
        xml=lambda wc: pjoin(RUNS[wc.run], "RunParameters.xml"),
        samplesheet=pjoin(workflow.basedir, "samplesheets", "SampleSheet_{run}.csv")
    output: touch("demux/{run}/.snakefinished")
    conda: "envs/bcl2fastq.yaml"
    params:
        runfolder=lambda wc: RUNS[wc.run],
        outfolder="demux/{run}"
    threads: 16
    shell:
        "bcl2fastq -r {threads} "
        "-p {threads} "
        "-w {threads} "
        "-o {params.outfolder} "
        "-R {params.runfolder} "
        "--sample-sheet {input.samplesheet} "
        "--no-lane-splitting"


rule multiqc_bcl2fastq:
    input: rules.demux.output
    output:
        "qc/multiqc_bcl2fastq_{run}.html"
    params:
        ""  # Optional: extra parameters for multiqc.
    log:
        "logs/multiqc_bcl2fastq_{run}.log"
    wrapper:
        pjoin(SNAKEMAKE_WRAPPER_VERSION, "bio/multiqc")


rule mkfastq:
    

##### load rules #####

#include: "rules/common.smk"
#include: "rules/trim.smk"
#include: "rules/align.smk"
#include: "rules/diffexp.smk"
#include: "rules/qc.smk"
#include: "rules/custom.smk"
#include: "rules/small.smk"

#rule demux_all:
#    input: expand(str(rules.multiqc_bcl2fastq.output), run=RUNS.keys())

#rule small_qc:
#    input:
#        bowtie=expand("logs/bowtie/{unit.sample}-{unit.unit}_mapped_to_GRCh38.log", unit=small_units.itertuples()),
#    output:
#        "qc/multiqc_bcl2fastq_{run}.html"
#    params:
#        ""  # Optional: extra parameters for multiqc.
#    log:
#        "logs/multiqc_bcl2fastq_{run}.log"
#    wrapper:
#        pjoin(SNAKEMAKE_WRAPPER_VERSION, "bio/multiqc")
