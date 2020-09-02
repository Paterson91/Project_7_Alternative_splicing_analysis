#!/bin/bash
start='date *%s'
# Based on this site https://github.com/qqwang-berkeley/JUM/wiki/6.-Running-JUM-for-differential-AS-analysis-among-multiple-experimental-conditions-(multiple-tissues,-patients,-time-series-experiments-etc.)

#Rename to be consistent with vignette input
#for i in `ls *sortedByCoord.out.bam | sed 's/.sortedByCoord.out.bam//'`
#	do
#		echo ""
#		echo ">>>>>>>>>>>>>>>>>>>> $i Rename begun <<<<<<<<<<<<<<<<<<<<"
#		echo ""
#    cp $i\.sortedByCoord.out.bam $i\.out_sorted.bam
#		echo ""
#		echo ">>>>>>>>>>>>>>>>>>>> $i Rename complete <<<<<<<<<<<<<<<<<<<<"
#		echo ""
#	done

bash /usr/local/bin/JUM_2.0.2_multi/JUM_2-1.sh

if [ "$?" = "0" ]; then
        echo "JUM_2-1 Successful"
else
         echo "JUM_2-1 Unsuccessful" | mailx -s "Critical Failure" ap14958@bristol.ac.uk
        exit 1
fi

mkdir DMSO_RD11 DMSO_RD9 GSK_RD10 GSK_RD12

cp BE2C_DMSO_RD11*SJ.out.tab_strand_symbol_scaled DMSO_RD11
cp BE2C_DMSO_RD9*SJ.out.tab_strand_symbol_scaled DMSO_RD9
cp BE2C_GSK_RD10*SJ.out.tab_strand_symbol_scaled GSK_RD10
cp BE2C_GSK_RD12*SJ.out.tab_strand_symbol_scaled GSK_RD12

cp UNION_junc_coor_with_junction_ID.txt DMSO_RD11
cp UNION_junc_coor_with_junction_ID.txt DMSO_RD9
cp UNION_junc_coor_with_junction_ID.txt GSK_RD10
cp UNION_junc_coor_with_junction_ID.txt GSK_RD12

cd DMSO_RD11/
bash /usr/local/bin/JUM_2.0.2_multi/JUM_2-2.sh \
--Folder /usr/local/bin/JUM_2.0.2_multi \
--Condition BE2C_DMSO_RD11 \
--Filenum 3 \
--Threshold 10
cd ..

cd DMSO_RD9/
bash /usr/local/bin/JUM_2.0.2_multi/JUM_2-2.sh \
--Folder /usr/local/bin/JUM_2.0.2_multi \
--Condition BE2C_DMSO_RD9 \
--Filenum 3 \
--Threshold 10
cd ..

cd GSK_RD10/
bash /usr/local/bin/JUM_2.0.2_multi/JUM_2-2.sh \
--Folder /usr/local/bin/JUM_2.0.2_multi \
--Condition BE2C_GSK_RD10 \
--Filenum 3 \
--Threshold 10
cd ..

cd GSK_RD12/
bash /usr/local/bin/JUM_2.0.2_multi/JUM_2-2.sh \
--Folder /usr/local/bin/JUM_2.0.2_multi \
--Condition BE2C_GSK_RD12 \
--Filenum 3 \
--Threshold 10
cd ..

cp DMSO_RD11/*junction_counts.txt .
cp DMSO_RD9/*junction_counts.txt .
cp GSK_RD10/*junction_counts.txt .
cp GSK_RD12/*junction_counts.txt .
cp DMSO_RD11/*formatted.txt .
cp DMSO_RD9/*formatted.txt .
cp GSK_RD10/*formatted.txt .
cp GSK_RD12/*formatted.txt .

for i in `ls *bam | sed 's/.out_sorted.bam//'`
	do
		echo ""
		echo ">>>>>>>>>>>>>>>>>>>> $i Bam2Bed begun <<<<<<<<<<<<<<<<<<<<"
		echo ""
    bedtools bamtobed -i $i\.out_sorted.bam > $i\.out.bed
    sort -k1,1 -k2,2n $i\.out.bed > $i\.out.sorted.bed
		echo ""
		echo ">>>>>>>>>>>>>>>>>>>> $i Bam2Bed complete <<<<<<<<<<<<<<<<<<<<"
		echo ""
	done

  if [ "$?" = "0" ]; then
          printf "Bam2Bed Successful\n"
  else
           echo "Bam2Bed Unsuccessful" | mailx -s "Critical Failure" ap14958@bristol.ac.uk
          exit 1
  fi

bash /usr/local/bin/JUM_2.0.2_multi/JUM_A_multi_1.sh \
--Folder /usr/local/bin/JUM_2.0.2_multi \
--JuncThreshold 10 \
--fileNum_threshold 3 \
--IRthreshold 5 \
--Readlength 100 \
--Thread 24

if [ "$?" = "0" ]; then
        echo "JUM_A_multi_1.sh Successful"
else
         echo "JUM_A_multi_1.sh Unsuccessful" | mailx -s "Critical Failure" ap14958@bristol.ac.uk
        exit 1
fi

mkdir DMSO_RD11_IR DMSO_RD9_IR GSK_RD10_IR GSK_RD12_IR

cp *DMSO_RD11*junction_counts_combined_intron_retention_event_list.txt DMSO_RD11_IR/
cp *DMSO_RD9*junction_counts_combined_intron_retention_event_list.txt DMSO_RD9_IR/
cp *GSK_RD10*junction_counts_combined_intron_retention_event_list.txt GSK_RD10_IR/
cp *GSK_RD12*junction_counts_combined_intron_retention_event_list.txt GSK_RD12_IR/

cd DMSO_RD11_IR
perl /usr/local/bin/JUM_2.0.2_multi/Identify_intron_retention_event_exist_in_all_samples.pl *junction_counts_combined_intron_retention_event_list.txt DMSO_RD11_junction_counts_intron_retention_in_all_samples_list.txt 3
cd ..
cd DMSO_RD9_IR
perl /usr/local/bin/JUM_2.0.2_multi/Identify_intron_retention_event_exist_in_all_samples.pl *junction_counts_combined_intron_retention_event_list.txt DMSO_RD9_junction_counts_intron_retention_in_all_samples_list.txt 3
cd ..
cd GSK_RD10_IR
perl /usr/local/bin/JUM_2.0.2_multi/Identify_intron_retention_event_exist_in_all_samples.pl *junction_counts_combined_intron_retention_event_list.txt GSK_RD10_junction_counts_intron_retention_in_all_samples_list.txt 3
cd ..
cd GSK_RD12_IR
perl /usr/local/bin/JUM_2.0.2_multi/Identify_intron_retention_event_exist_in_all_samples.pl *junction_counts_combined_intron_retention_event_list.txt GSK_RD12_junction_counts_intron_retention_in_all_samples_list.txt 3
cd ..

cat DMSO_RD11_IR/DMSO_RD11_junction_counts_intron_retention_in_all_samples_list.txt DMSO_RD9_IR/DMSO_RD9_junction_counts_intron_retention_in_all_samples_list.txt GSK_RD10_IR/GSK_RD10_junction_counts_intron_retention_in_all_samples_list.txt GSK_RD12_IR/GSK_RD12_junction_counts_intron_retention_in_all_samples_list.txt | sort -u > All_junction_counts_intron_retention_in_all_samples_sorted_list.txt

bash /usr/local/bin/JUM_2.0.2_multi/JUM_A_multi_2.sh \
--Folder /usr/local/bin/JUM_2.0.2_multi \
--JuncThreshold 10 \
--fileNum_threshold 3 \
--IRthreshold 5 \
--Readlength 100 \
--Thread 12





cd JUM_diff/
mkdir DMSO_RD11_vs_DMSO_RD9
cp BE2C_DMSO_RD11* DMSO_RD11_vs_DMSO_RD9
cp BE2C_DMSO_RD9* DMSO_RD11_vs_DMSO_RD9

Rscript /usr/local/bin/JUM_2.0.2_multi/R_script_JUM.R experiment_design.txt > outputFile.Rout 2> errorFile.Rout

bash /usr/local/bin/JUM_2.0.2_multi/JUM_B.sh \
--Folder /usr/local/bin/JUM_2.0.2_multi/ \
--Test adjusted_pvalue \
--Cutoff 0.05 \
--TotalFileNum 6 \
--Condition1_fileNum_threshold 3 \
--Condition2_fileNum_threshold 3 \
--Condition1SampleName BE2C_DMSO_RD11_1,BE2C_DMSO_RD11_2,BE2C_DMSO_RD11_3 \
--Condition2SampleName BE2C_DMSO_RD9_1,BE2C_DMSO_RD9_2,BE2C_DMSO_RD9_3

end='date +%s'
runtime=$((end-start))
echo "Total Runtime = $runtime"
