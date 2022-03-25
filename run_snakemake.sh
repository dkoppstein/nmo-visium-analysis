# conda activate snakemake
snakemake --use-conda --reason --printshellcmds --keep-going -d workspace/ -j 16 -- qc/multiqc_bcl2fastq_vis010.html
