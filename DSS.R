getwd()

#导入处理好的数据
setwd("~/2021_xue_BS_seq/result/DDS_test/")
testmet_1 <- read.delim("~/2021_xue_BS_seq/result/DDS_test/testmet_1.txt") 
testmet_2 <- read.delim("~/2021_xue_BS_seq/result/DDS_test/testmet_2.txt")
testMOR7_1 <- read.delim("~/2021_xue_BS_seq/result/DDS_test/testMOR7_1.txt")
testMOR7_2 <- read.delim("~/2021_xue_BS_seq/result/DDS_test/testMOR7_2.txt")

#构建BSobj对象
BSobj = makeBSseqData( list(testmet_1, testmet_2, testMOR7_1, testMOR7_2),
                       c("met1","met2", "MOR7_1", "MOR7_2") )[1:1000,]
BSobj

#利用DMLtest函数call DML(甲基化差异位点)
#计算所有CpG位点的平均甲基化水平;
#计算每个CpG位点的分散度dispersions；
#进行沃尔德检验 conduct Wald test
dmlTest <- DMLtest(BSobj, group1=c("met1","met2"), group2=c("MOR7_1", "MOR7_2"))
head(dmlTest)
#可以选择是否smoothing处理甲基化水平。当测序结果中CpG 位点特别密集时（比如：whole-genome BS-seq得到的数据）
#smoothing处理可以以更简洁直接的方式帮助估算平均甲基化水平
dmlTest.sm <- DMLtest(BSobj, group1=c("met1","met2"), group2=c("MOR7_1", "MOR7_2"), smoothing=TRUE)
head(dmlTest.sm)

#利用callDML函数call DML(甲基化差异位点)
dmls <- callDML(dmlTest, p.threshold=0.001)
head(dmls)
dmls2 <- callDML(dmlTest, delta=0.1, p.threshold=0.001)
head(dmls2)

#利用callDMR函数Call DMR(甲基化差异区域)
dmrs <- callDMR(dmlTest)
head(dmrs)

#可视化数据
showOneDMR(dmrs[1,], BSobj)

