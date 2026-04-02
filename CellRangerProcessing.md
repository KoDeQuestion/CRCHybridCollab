# Load CellRanger Module
```
module load cellranger\ 
````
Hit tab to continue
## Confirm that module is operational
```
module avail
```
## Confirm module is running correctly w/ dependencies
```
cellranger [hit enter]
```

# Cell-Type & Indices

* 1: MC38 RFP tumor parent passage 8
* 2: Macrophages (Y01 actin-GFP, 2 male mice DOB 7/2024) day 8 mCSF 25ng/ml treatment
* 3: MC38xY01 freshly fused hybrids (from tumor/mac parent lines above, day 4 co-culture)
* 4: MC38xY01 mature hybrids passage 6 post purity sort (from 7-1-22 exp, previously sequenced)
* 5: MC38xY01 hybrid clone 11 passage 9 (from MC38xY01 purity sort population sample 4 above)
* 6: MC38xY01 hybrid clone 7 passage 7 (from MC38xY01 purity sort population sample 4 above)
* 7: MC38xY01 hybrid clone 4 passage 9 (from MC38xY01 purity sort population sample 4 above)
* 8: MC38xY01 hybrid clone 3 passage 6 (from MC38xY01 purity sort population sample 4 above)


Barcodes:
* SI-TT-D2    TTAATACGCG  CACCTCGGGT  ACCCGAGGTG
* SI-TT-D3    CCTTCTAGAG  AATACAACGA  TCGTTGTATT
* SI-TT-D4    GCAGTATAGG  TTCCGTGCAC  GTGCACGGAA
* SI-TT-D5    TGGTTCGGGT  GTGGCAGGAG  CTCCTGCCAC
* SI-TT-D6    CCCAGCTTCT  GACACCAAAC  GTTTGGTGTC
* SI-TT-D7    CCTGTCAGGG  AGCCCGTAAC  GTTACGGGCT
* SI-TT-D8    CGCTGAAATC  AGGTGTCTGC  GCAGACACCT
* SI-TT-D9    TGGTCCCAAG  CCTCTGGCGT  ACGCCAGAGG

The Raw Files: /home/groups/ravnica/seq/obnix/241004_VH00711_165_2225LHHNX/Data/Intensities/BaseCalls/

module load bcl2fastq2\
module avail

cellranger mkfastq --id=241004_10xscRNA_HF \
            --run=/home/groups/ravnica/seq/obnix/241004_VH00711_165_2225LHHNX/ \
            --samplesheet=/home/groups/ravnica/projects/hybrid/241004_10xscRNA/sample_sheet.csv \
            --localcores=20 \
            --localmem=200 \ &


This is where the fastq files are:
/home/groups/ravnica/projects/hybrid/241004_10xscRNA/241004_10xscRNA_HF/outs/fastq_path/2225LHHNX/

Example that worked last time:

cellranger count --id=HF03 \
                   --transcriptome=/home/groups/ravnica/src/cellranger/cellranger-7.1.0-kq/refdata-gex-mm10-2020-A/ \
                   --fastqs=/home/groups/ravnica/projects/hybrid/241004_10xscRNA/241004_10xscRNA_HF/outs/fastq_path/2225LHHNX/ \
                   --sample=HF03 \
                   --feature-ref= \
                   --expect-cells=10000 \
                   --localcores=20 \
                   --localmem=200 \ &

cellranger count --id=HF03 --transcriptome=/home/groups/ravnica/src/cellranger/cellranger-7.1.0-kq/refdata-gex-mm10-2020-A/ --fastqs=/home/groups/ravnica/projects/hybrid/241004_10xscRNA/241004_10xscRNA_HF/outs/fastq_path/2225LHHNX/ --sample=HF03 --expect-cells=8000 --localcores=20 --localmem=200 &

cellranger count --id=HF04 --transcriptome=/home/groups/ravnica/src/cellranger/cellranger-7.1.0-kq/refdata-gex-mm10-2020-A/ --fastqs=/home/groups/ravnica/projects/hybrid/241004_10xscRNA/241004_10xscRNA_HF/outs/fastq_path/2225LHHNX/ --sample=HF04 --expect-cells=8000 --localcores=20 --localmem=200 &

cellranger count --id=HF07 --transcriptome=/home/groups/ravnica/src/cellranger/cellranger-7.1.0-kq/refdata-gex-mm10-2020-A/ --fastqs=/home/groups/ravnica/projects/hybrid/241004_10xscRNA/241004_10xscRNA_HF/outs/fastq_path/2225LHHNX/ --sample=HF07 --expect-cells=8000 --localcores=20 --localmem=200 &

#Potentially rerun samples HF04 and HF03 for 8000 cells!

cellranger count --id=HFF --transcriptome=/home/groups/ravnica/src/cellranger/cellranger-7.1.0-kq/refdata-gex-mm10-2020-A/ --fastqs=/home/groups/ravnica/projects/hybrid/241004_10xscRNA/241004_10xscRNA_HF/outs/fastq_path/2225LHHNX/ --sample=HFF --expect-cells=8000 --localcores=20 --localmem=200 &

cellranger count --id=HFP --transcriptome=/home/groups/ravnica/src/cellranger/cellranger-7.1.0-kq/refdata-gex-mm10-2020-A/ --fastqs=/home/groups/ravnica/projects/hybrid/241004_10xscRNA/241004_10xscRNA_HF/outs/fastq_path/2225LHHNX/ --sample=HFP --expect-cells=8000 --localcores=20 --localmem=200 &

cellranger count --id=HF11 --transcriptome=/home/groups/ravnica/src/cellranger/cellranger-7.1.0-kq/refdata-gex-mm10-2020-A/ --fastqs=/home/groups/ravnica/projects/hybrid/241004_10xscRNA/241004_10xscRNA_HF/outs/fastq_path/2225LHHNX/ --sample=HF11 --expect-cells=8000 --localcores=20 --localmem=200 &

---

cellranger count --id=Macrophage --transcriptome=/home/groups/ravnica/src/cellranger/cellranger-7.1.0-kq/refdata-gex-mm10-2020-A/ --fastqs=/home/groups/ravnica/projects/hybrid/241004_10xscRNA/241004_10xscRNA_HF/outs/fastq_path/2225LHHNX/ --sample=Macrophage --expect-cells=8000 --localcores=20 --localmem=200 &

cellranger count --id=MC38 --transcriptome=/home/groups/ravnica/src/cellranger/cellranger-7.1.0-kq/refdata-gex-mm10-2020-A/ --fastqs=/home/groups/ravnica/projects/hybrid/241004_10xscRNA/241004_10xscRNA_HF/outs/fastq_path/2225LHHNX/ --sample=MC38 --expect-cells=8000 --localcores=20 --localmem=200 &


____ 



scp queitsch@ajani:/home/groups/ravnica/projects/hybrid/241004_10xscRNA/HF03/outs/raw_feature_bc_matrix/matrix.mtx.gz /Users/queitsch/Documents/AdeyLab/1_Hybrid_Fusion/240918_10xscRNA_HF/HF03_raw/

scp queitsch@ajani:/home/groups/ravnica/projects/hybrid/241004_10xscRNA/HF03/outs/raw_feature_bc_matrix/features.tsv.gz /Users/queitsch/Documents/AdeyLab/1_Hybrid_Fusion/240918_10xscRNA_HF/HF03_raw/

scp queitsch@ajani:/home/groups/ravnica/projects/hybrid/241004_10xscRNA/HF03/outs/raw_feature_bc_matrix/barcodes.tsv.gz /Users/queitsch/Documents/AdeyLab/1_Hybrid_Fusion/240918_10xscRNA_HF/HF03_raw/



____________



scp queitsch@ajani:/home/groups/ravnica/projects/hybrid/241004_10xscRNA/241004_10xscRNA_HF/outs/fastq_path/Reports/html/index.html /Users/queitsch/Documents/AdeyLab/1_Hybrid_Fusion/240918_10xscRNA_HF/
