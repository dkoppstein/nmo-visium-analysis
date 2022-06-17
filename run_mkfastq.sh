#spaceranger mkfastq --id=vis010 --run=/data/rajewsky/sequencing/human/210709_A00643_0274_BHG3HHDRXY/210709_A00643_0274_BHG3HHDRXY --csv=samplesheets/simple_vis010.csv --delete-undetermined --output-dir=workspace/mkfastq/vis010 --localcores=16

source /data/rajewsky/home/dkoppst/src/10x/spaceranger-1.3.1/sourceme.bash
spaceranger mkfastq --id=vis010_rerun --run=/data/rajewsky/sequencing/human/210709_A00643_0274_BHG3HHDRXY/210709_A00643_0274_BHG3HHDRXY --csv=samplesheets/simple_vis010_rerun.csv --delete-undetermined --output-dir=workspace/mkfastq/vis010_rerun --localcores=16
