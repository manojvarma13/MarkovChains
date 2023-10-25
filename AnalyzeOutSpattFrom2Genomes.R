#!/usr/bin/env Rscript
# AnalyzeOutSpattFrom2Genomes.R
options("scipen" = 30)
#usage statement
usage <- "\nUsage: AnalyzeOutSpattFrom2Genomes.R <input file.txt>\n\n"
#specify arguments
args <- commandArgs(trailingOnly = TRUE)
#test the arguments
if(length(args) == 0) {
    cat(prompt=usage)
    q(save="no")
}
#generate data frame
spattMetrics <- read.table(args[1], sep="\t", header=FALSE)
#assign names of each column in the data frame
names(spattMetrics) <- c("kmer1","occurrence1","expected1", "pvalue1",
                         "kmer2","occurrence2","expected2", "pvalue2") # variable names

#Add new column to data frame, and give all 0
spattMetrics["probablity_occurrence"] <- 0
#fill the column
spattMetrics$probablity_occurrence <- (spattMetrics$expected1 / (spattMetrics$expected1 + spattMetrics$expected2))

spattMetrics["trials"] <- 0
spattMetrics$trials <-  spattMetrics$occurrence1 + spattMetrics$occurrence2

spattMetrics["binomial_upper_tail"] <- 0
spattMetrics$binomial_upper_tail <- pbinom(spattMetrics$occurrence1-1,
                                spattMetrics$trials,
                                spattMetrics$probablity_occurrence,
                                lower.tail=FALSE)

#output
write.table(spattMetrics, file="out.txt", sep="\t", row.names = FALSE)
