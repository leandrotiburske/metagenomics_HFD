library(tidyverse)
library(PlateLayout)

setwd("~/Downloads/")

set.seed(123)

designSheet <- readxl::read_xlsx("Samples_prepr_sequencing_231016.xlsx")

bColumns <- c("Experiment", "Section") 

plateLayout <- designSheet %>%
  randomizeSinglePlate(batchColumns = bColumns,
                       primaryGroup = "Group_Diet",
                       nIter = 1000) 

setwd("~/Documents/BEPE/")

pdf("Plate_Layout.5x3.pdf")

bColumns %>%  
  map(~plotPlate(plateLayout, plotCol = .x))
dev.off()

plateLayout %>%  
  select(-Group_Diet, -RowID) %>%  
  write_tsv("Plate_Layout.5x3.tsv")