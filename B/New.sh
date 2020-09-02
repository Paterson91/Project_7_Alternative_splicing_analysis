#!/bin/bash

############################################################################
############################### Alignment ##################################


mkdir -p STAR_1st_IMR_120_new

		STAR --genomeDir /home/ap14958/STAR_Indexes/Homo_sapiens_GRCh38/ \
    		--runMode alignReads \
		--readFilesIn /mnt/Scratch/Alt_Splicing/B/RNAseq_IMR_120_GSK/IMR32-120H-Control-2/IMR_120_C2_R1.fq.gz /mnt/Scratch/Alt_Splicing/B/RNAseq_IMR_120_GSK/IMR32-120H-Control-2/IMR_120_C2_R2.fq.gz \
		--readFilesCommand zcat \
		--outFileNamePrefix STAR_1st_IMR_120_new/IMR_120_C2_Redo \
    --outSJfilterReads Unique \
		--outSAMtype BAM SortedByCoordinate --runThreadN 100
mkdir -p STAR_2nd_IMR_120_new

		STAR --runThreadN 24 \
		--genomeDir /home/ap14958/STAR_Indexes/Homo_sapiens_GRCh38/ \
		--outFileNamePrefix STAR_2nd_IMR_120_new/IMR_120_C2_Redo \
		--readFilesIn /mnt/Scratch/Alt_Splicing/B/RNAseq_IMR_120_GSK/IMR32-120H-Control-2/IMR_120_C2_R1.fq.gz /mnt/Scratch/Alt_Splicing/B/RNAseq_IMR_120_GSK/IMR32-120H-Control-2/IMR_120_C2_R2.fq.gz \
		--readFilesCommand zcat \
		--outSJfilterReads Unique \
		--outSAMstrandField intronMotif \
		--outFilterMultimapNmax 1 \
		-sjdbFileChrStartEnd STAR_1st_IMR_120_new/*.out.tab

cd STAR_2nd_IMR_120_new

for i in `ls *.out.sam | sed 's/Aligned.out.sam//'`
	do
		echo ""
		echo ">>>>>>>>>>>>>>>>>>>> $i Conversion begun <<<<<<<<<<<<<<<<<<<<"
		echo ""
		samtools view -bS $i\Aligned.out.sam > $i\Aligned.out.bam
		samtools sort -o $i\Aligned.out_sorted.bam -T $i\_temp $i\Aligned.out.bam
		samtools index $i\Aligned.out_sorted.bam
		rm *Aligned.out.bam
		echo ""
		echo ">>>>>>>>>>>>>>>>>>>> $i Conversion Complete <<<<<<<<<<<<<<<<<<<<"
		echo ""
	done


