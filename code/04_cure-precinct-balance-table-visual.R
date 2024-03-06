library(tidyverse)
library(gt)

balance_table <- read.csv("data/output/cure_balance_table.csv") 

# Create a gt table 
table <- balance_table %>%
  gt() %>%
  cols_label(
    X = "Cure Precinct",
    t.stat = 't-stat',
    p.value = 'p-value'
  ) 

table

gtsave(table, 'visuals/cure_balance_table.html')

