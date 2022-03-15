#!/bin/bash
#build index
cd ~/2021_xue_BS_seq/BatMeth
/pub/software/BatMeth2/bin/BatMeth2 index -g ～/2021_xue_BS_seq/reference/Arabidopsis_thaliana.TAIR10.dna.fa 


#piplne
nohup /pub/software/BatMeth2/bin/BatMeth2 pipel -1 MORC_BSseq_1_1.fastq -2 MORC_BSseq_1_2.fastq -g ~/2021_xue_BS_seq/reference/Arabidopsis_thaliana.TAIR10.dna.fa -o meth -p 6 --gff ~/2021_xue_BS_seq/reference/Arabidopsis_thaliana.TAIR10.52.gff3 &

#pipel (Contains: align, calmeth, annoation, methyPlot, mkreport
#创建bigwig file
#need .py
#chmod 777 /home/jianl/bio/BatMeth2-master/bin/batmeth2_to_bigwig.py
#conda install -c bioconda ucsc-bedgraphtobigwig

#buils index
samtools faidx Arabidopsis_thaliana.TAIR10.dna.fa
#
 /pub/software/BatMeth2/bin/batmeth2_to_bigwig.py -sort -strand ~/2021_xue_BS_seq/reference/Arabidopsis_thaliana.TAIR10.dna.fa.fai meth.methratio.txt
#获得四个bw file,用于后续作图

#画出全基因组gtf或者是指定bed区域的甲基化分布
 /pub/software/BatMeth2/bin/methyGff -B -o gene.meth -G ~/2021_xue_BS_seq/reference/Arabidopsis_thaliana.TAIR10.dna.fa -bed ~/2021_xue_BS_seq/reference/Arabidopsis_thaliana.TAIR10.52.gtf -m meth.methratio.txt
#获得 .meth.AverMethylevel.txt，.meth.Methylevel.txt，.meth.TSSprofile.txt，.meth.centerprofile.txt，

#构建矩阵
 /pub/software/BatMeth2/bin/methyGff -B -o expressed.gene.meth unexpressed.gene.meth -G ~/2021_xue_BS_seq/reference/Arabidopsis_thaliana.TAIR10.dna.fa -b downregulation.bed upregulation.bed -m meth.methratio.txt

#画图
python /pub/software/BatMeth2/scripts/bt2profile.py -f unexpressed.gene.meth.centerprofile.txt expressed.gene.meth.centerprofile.txt -l downregulation upregulation --outFileName up_down.output.meth.pdf -s 1 1 -xl up2k center down2k

python ~/bio/BatMeth2-master/scripts/bt2profile.py -f expressed.gene.meth.TSSprofile.txt unexpressed.gene.meth.TSSprofile.txt -l downregulation upregulation --outFileName transcriptionalTSS.output.meth.pdf -s 1 1 -xl up2k TSS down2k --context C



