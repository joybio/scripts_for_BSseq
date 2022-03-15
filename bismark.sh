#!/bin/bash
trim_galore --paired --quality 20 --length 20 MORC_BSseq_1_1.fastq MORC_BSseq_1_2.fastq

fastqc -t 2 -o ./fastaqc/ MORC_BSseq_1_1.fastq.gz MORC_BSseq_1_2.fastq.gz
#index
#bismark_genome_preparation  bismark_index1

##比对
bismark --genome ../reference/bismark_index1 -1 MORC_BSseq_1_1_trimmed.fq -2 MORC_BSseq_1_2_trimmed.fq -p 2 -o bismark1
##删除重复数据
deduplicate_bismark --bam *.bam --output_dir bismark1/
#提取甲基化位点
bismark_methylation_extractor -p --gzip --bedGraph --buffer_size 10G --cytosine_report --comprehensive --genome_folder ../reference/bismark_index1 MORC_BSseq_1_1_bismark_bt2_pe.deduplicated.bam -o bismark1/
#Bismark HTML 报告
cd result/bismark1
bismark2report
#下游分析
gzip -d MORC_BSseq_1_1_bismark_bt2_pe.deduplicated.CpG_report.txt.gz

perl BismarkCX2methykit.pl MORC_BSseq_1_1_bismark_bt2_pe.deduplicated.CpG_report.txt
#获得了CG_methykit.txt个文件，可以放入R中进行MethylKit 的分析





