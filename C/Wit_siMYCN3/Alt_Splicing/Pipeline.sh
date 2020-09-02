#!/bin/bash
set -e
start='date *%s'
# Based on this site https://github.com/qqwang-berkeley/JUM/wiki/3.1.-Manual-running-JUM-(v2.0.2-and-up)

#Rename to be consistent with vignette input
#for i in `ls *sortedByCoord.out.bam | sed 's/.sortedByCoord.out.bam//'`
#	do
#		echo ""
#		echo ">>>>>>>>>>>>>>>>>>>> $i Rename begun <<<<<<<<<<<<<<<<<<<<"
#		echo ""
#    mv $i\.sortedByCoord.out.bam $i\.out_sorted.bam
#		echo ""
#		echo ">>>>>>>>>>>>>>>>>>>> $i Rename complete <<<<<<<<<<<<<<<<<<<<"
#		echo ""
#	done

bash /usr/bin/JUM_2.0.2/JUM_A.sh \
--Folder /usr/bin/JUM_2.0.2 \
--JuncThreshold 10 \
--Condition1_fileNum_threshold 2 \
--Condition2_fileNum_threshold 2 \
--IRthreshold 5 \
--Readlength 100 \
--Thread 100 \
--Condition1SampleName Wit_siN_1,Wit_siN_2 \
--Condition2SampleName Wit_siM3_1,Wit_siM3_2

if [ "$?" = "0" ]; then
        echo "JUM_A Successful"
else
         echo "JUM_A Unsuccessful" | mailx -s "Critical Failure" ap14958@bristol.ac.uk
        exit 1
fi

cd JUM_diff/
Rscript /usr/bin/JUM_2.0.2/R_script_JUM.R ../experiment_design.txt > outputFile.Rout 2> errorFile.Rout

bash /usr/bin/JUM_2.0.2/JUM_B.sh \
--Folder /usr/bin/JUM_2.0.2 \
--Test pvalue \
--Cutoff 0.05 \
--TotalFileNum 4 \
--Condition1_fileNum_threshold 2 \
--Condition2_fileNum_threshold 2 \
--Condition1SampleName Wit_siN_1,Wit_siN_2 \
--Condition2SampleName Wit_siM3_1,Wit_siM3_2

cd FINAL_JUM_OUTPUT_$Test_$Cutoff

bash /usr/bin/JUM_2.0.2/JUM_C.sh \
--Folder /usr/bin/JUM_2.0.2 \
--Test pvalue \
--Cutoff 0.05 \
--TotalCondition1FileNum 2 \
--TotalCondition2FileNum 2 \
--REF /home/ap14958/GTF/Homo_sapiens/Homo_sapiens.GRCh38.98_refFlat.txt

end='date +%s'
runtime=$((end-start))
echo "Total Runtime = $runtime"
