library(ggplot2)
library(dplyr)
# FYI: there is one call to plyr::revalue() so plyr should be installed but not
# loaded

lotr_dat <- read.delim("lotr_clean.tsv")