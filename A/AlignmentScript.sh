#!/bin/bash

############################################################################
############################### Alignment ##################################


mkdir STAR_1st

for i in `ls *_1.fq.gz | sed 's/_1.fq.gz//'`
	do
		echo ""
		echo ">>>>>>>>>>>>>>>>>>>> $i 1st Pass Alignment begun <<<<<<<<<<<<<<<<<<<<"
		echo ""
		STAR --genomeDir /home/data/STAR/H_Sapiens/ \
    --runMode alignReads \
		--readFilesIn $i\_1.fq.gz $i\_2.fq.gz \
		--readFilesCommand zcat \
		--outFileNamePrefix STAR_1st/$i \
    --outSJfilterReads Unique \
		--outSAMtype BAM SortedByCoordinate --runThreadN 24
		echo ""
		echo ">>>>>>>>>>>>>>>>>>>> $i 1st Pass Alignment complete <<<<<<<<<<<<<<<<<<<<"
		echo ""
	done

command; cat STAR_1st/*final* | grep -i Unique | mail -s "1st Pass Alignments Complete" a.paterson@bristol.ac.uk

mkdir STAR_2nd

for i in `ls *_1.fq.gz | sed 's/_1.fq.gz//'`
	do
		echo ""
		echo ">>>>>>>>>>>>>>>>>>>> $i 2nd Pass Alignment begun <<<<<<<<<<<<<<<<<<<<"
		echo ""
		STAR --runThreadN 24 \
		--genomeDir /home/data/STAR/H_Sapiens/ \
		--outFileNamePrefix STAR_2nd/$i \
		--readFilesIn $i\_1.fq.gz $i\_2.fq.gz \
		--readFilesCommand zcat \
		--outSJfilterReads Unique \
		--outSAMstrandField intronMotif \
		--outFilterMultimapNmax 1 \
		-sjdbFileChrStartEnd STAR_1st/*.out.tab
		echo ""
		echo ">>>>>>>>>>>>>>>>>>>> $i 2nd Pass Alignment Complete <<<<<<<<<<<<<<<<<<<<"
		echo ""
	done

command; cat STAR_2nd/*final* | grep -i unique | mail -s "2nd Pass Alignments Complete" a.paterson@bristol.ac.uk

cd STAR_2nd

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

command; echo "Done!" | mail -s "Conversion Complete" a.paterson@bristol.ac.uk
