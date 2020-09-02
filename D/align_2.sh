 mkdir -p STAR_2nd

for i in `find . -name "*_R1.fq.gz" | sed 's/_R1.fq.gz//'`
	do
		echo ""
		echo ">>>>>>>>>>>>>>>>>>>> $i 2nd Pass Alignment begun <<<<<<<<<<<<<<<<<<<<"
		echo ""
		STAR --runThreadN 24 \
		--genomeDir /home/ap14958/STAR_Indexes/Homo_sapiens_GRCh38/ \
		--outFileNamePrefix STAR_2nd/`basename $i` \
		--readFilesIn $i\_R1.fq.gz $i\_R2.fq.gz \
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

for i in `ls *siP5*.out.sam | sed 's/Aligned.out.sam//'`
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
