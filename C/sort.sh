#!/bin/bash
parallel --gnu gunzip  ::: *gz

for i in `find . -name "*.fastq" ! -name "*sorted*" -prune | sed 's/_R..fastq//'`
	do
		echo ""
		echo ">>>>>>>>>>>>>>>>>>>> $i Sort begun <<<<<<<<<<<<<<<<<<<<"
		echo ""
    		cat $i\_R1.fastq | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" > $i\_R1_sorted.fastq
    		cat $i\_R2.fastq | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" > $i\_R2_sorted.fastq
    		echo ""
    		echo ">>>>>>>>>>>>>>>>>>>> $i Sort complete <<<<<<<<<<<<<<<<<<<<"
    		echo ""
done

pigz -v *_sorted.fastq
