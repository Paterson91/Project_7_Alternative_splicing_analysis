for i in `find . -name "*_R1.fq.gz" | sed 's/_R1.fq.gz//'`
	do
		echo ""
		echo ">>>>>>>>>>>>>>>>>>>> $i 1st Pass Alignment begun <<<<<<<<<<<<<<<<<<<<"
		echo ""
		STAR --genomeDir /home/ap14958/STAR_Indexes/Homo_sapiens_GRCh38/ \
    		--runMode alignReads \
		--readFilesIn $i\_R1.fq.gz $i\_R2.fq.gz \
		--readFilesCommand zcat \
		--outFileNamePrefix ../STAR_1st/`basename $i` \
    		--outSJfilterReads Unique \
		--outSAMtype BAM SortedByCoordinate --runThreadN 100
		echo ""
		echo ">>>>>>>>>>>>>>>>>>>> $i 1st Pass Alignment complete <<<<<<<<<<<<<<<<<<<<"
		echo ""
	done
