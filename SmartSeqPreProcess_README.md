# Processing iCell8 Smart-seq files

Processing from unidex fastq files to aligned, rmdup bam and then counts matrix

## Preparation of reference

This does not need to be redone unless you want to make a new reference

Go to references folder
```
cd /home/groups/ravnica/refs/mm10
```
Download reference genome and annotation. If you need a new one you just need a fasta file and a gtf or gff file. In this case I batch downloaded from NCBI
```
curl https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_000001635.27/download?include_annotation_type=GENOME_FASTA,GENOME_GFF > GCF_000001635.27.zip
```
Unzip
```
unzip GCF_000001635.27.zip
```
Move files and rename for convenience
```
mv ncbi_dataset/data/GCF_000001635.27/GCF_000001635.27_GRCm39_genomic.fna GCF_000001635.27_GRCm39_genomic.fasta
mv ncbi_dataset/data/GCF_000001635.27/genomic.gff GCF_000001635.27_GRCm39_genomic.gff
```
If STAR is not loaded, load the module
```
module load STAR/
```
Build STAR reference. Note the $(pwd) enters in the working directory - it is a shortcut to enter in the full current path. I also direct the output and error to a file for log purposes. The double '>>' means it will not overwrite the file, but instead add on the end of it.
```
STAR --runThreadN 36 \
	--runMode genomeGenerate \
	--genomeDir $(pwd)/GCF_000001635.27_GRCm39_genomic.STAR \
	--genomeFastaFiles $(pwd)/GCF_000001635.27_GRCm39_genomic.fasta \
	--sjdbGTFfile $(pwd)/GCF_000001635.27_GRCm39_genomic.gff \
	--sjdbOverhang 99 \
	>> $(pwd)/GCF_000001635.27_GRCm39_genomic.STAR.log \
	2>> $(pwd)/GCF_000001635.27_GRCm39_genomic.STAR.log &
```

## Aligning to the reference

These are steps you would do for any new dataset

First, navigate to the directory. I am making a new directory for the reworked analysis as well
```
cd /home/groups/ravnica/projects/hybrid/231201_ArtificialDoublets/
mkdir 240119_GCF_000001635.27
cd 240119_GCF_000001635.27
```
Run the alignment. Note, STAR likes ungzipped fastq files so I ungzip them first to my current directory
```
zcat ../fastq/smartseq_S1_L001_R1_001.fastq.gz > 231201_ArtificialDoublets.R1.fq &
zcat ../fastq/smartseq_S1_L001_R2_001.fastq.gz > 231201_ArtificialDoublets.R2.fq &
```
Then align
```
STAR --runThreadN 48 \
	--genomeDir /home/groups/ravnica/refs/mm10/GCF_000001635.27_GRCm39_genomic.STAR \
	--readFilesIn $(pwd)/231201_ArtificialDoublets.R1.fq $(pwd)/231201_ArtificialDoublets.R2.fq \
	>> 231201_ArtificialDoublets.STAR.log \
	2>> 231201_ArtificialDoublets.STAR.log &
```
Delete the uncompressed fastq files because they take up space
```
rm -f 231201_ArtificialDoublets.R1.fq 231201_ArtificialDoublets.R2.fq
```
Sort by read name and convert to bam using samtools, changing name to something meaningful
```
samtools sort -@ 16 -n Aligned.out.sam > 231201_ArtificialDoublets.nsrt.bam &
```
Make sure it worked by samtools view into less, then delete the sam file because it takes up a lot of space
```
samtools view 231201_ArtificialDoublets.nsrt.bam | less -S
```
```
rm -f Aligned.out.sam
```
Then use scitools to rmdup
```
scitools rmdup -t 12 -n 231201_ArtificialDoublets.nsrt.bam
```
And then plot complexity
```
scitools plot-complexity 231201_ArtificialDoublets.complexity.txt
```
If you have slack CLI enabled, you can post the complexity plot directly to slack (in this case my private notes channel). Unfortunately slack cli cannot be set up due to slack changes, at least not until I put in the time to make it work usign a bot (on the to-do list!)
```
slack -F 231201_ArtificialDoublets.complexity.png adey_private
```
And filter to indexes that are cell-containing using a read threshold based on the complexity, in this case I am going with 2000 reads
```
scitools filter-bam -C 231201_ArtificialDoublets.complexity.txt \
	-N 2000 \
	231201_ArtificialDoublets.bbrd.q10.bam &
```
Sometimes the filtering messes up the sorting, so re-coord sort to be sure it will run fine.
```
samtools sort -@ 16 231201_ArtificialDoublets.bbrd.q10.filt.bam > 231201_ArtificialDoublets.bbrd.q10.filt.srt.bam &
```

## Annotating with gene names and generating a counts matrix

I use a subread function for this, load the module if not yet loaded.
```
module load subread/
```
Then perform the annotation
```
featureCounts -a /home/groups/ravnica/refs/mm10/GCF_000001635.27_GRCm39_genomic.gff \
	-R BAM \
	-g gene \
	-T 24 \
	-s 0 \
	-p \
	-o 231201_ArtificialDoublets.txt \
	231201_ArtificialDoublets.bbrd.q10.filt.srt.bam >> featureCounts.log 2>> featureCounts.log &
```
Rename the files since the default naming of the featureCounts is not ideal
```
mv 231201_ArtificialDoublets.bbrd.q10.filt.srt.bam.featureCounts.bam 231201_ArtificialDoublets.bbrd.q10.filt.srt.annotated.bam
```
Look at the summary info to see number of reads assigned to genes
```
more 231201_ArtificialDoublets.txt.summary
```
And then use the script that is in this repo to quickly convert to a count matrix. (featureCounts will do this if the bam was in a different format, but this works too). This output tsv file can be directly loaded into Seurat.
```
perl ../bam2counts.pl 231201_ArtificialDoublets.bbrd.q10.filt.srt.annotated.bam 231201_ArtificialDoublets.bbrd.q10.filt.srt.counts.tsv &
```
Make sure the counts file looks good
```
less -S 231201_ArtificialDoublets.bbrd.q10.filt.srt.counts.tsv
```
Remove intermediate files that take up space and can be readily re-made
```
rm -f 231201_ArtificialDoublets.bbrd.q10.bam 231201_ArtificialDoublets.bbrd.q10.filt.srt.bam 231201_ArtificialDoublets.bbrd.q10.filt.bam 231201_ArtificialDoublets.nsrt.bam 231201_ArtificialDoublets.txt
```

## Finally a quick assessment in Seurat, loading the tsv file
All in Rstudio

Load Seurat
```{r}
library(Seurat)
```
Process through default steps
```{r}
counts<-read.delim(file="E://Data/Hybrid/ArtificialDoubletSmart/231201_ArtificialDoublets.bbrd.q10.filt.srt.counts.tsv")
data <- CreateSeuratObject(counts = counts, project = "artificial doublets", min.features = 500)
data <- NormalizeData(object = data)
data <- FindVariableFeatures(object = data)
data <- ScaleData(object = data)
data <- RunPCA(object = data)
data <- FindNeighbors(object = data, dims = 1:30)
data <- FindClusters(object = data)
data <- RunUMAP(object = data, dims = 1:30)
```
Plot UMAP
```{r}
DimPlot(data, reduction = "umap")
```
Plot metadata
```{r}
VlnPlot(data, features = c("nFeature_RNA","nCount_RNA"))
```
