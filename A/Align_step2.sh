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
