#script to install all required packages at once

package_list <- c(
  "devtools",
  "shiny",
  "lme4",
  "lmerTest",
  "tidyverse",
  "DT",
  "shinythemes",
  "shinyjs",
  "sortable"
)

install.packages(package_list)
devtools::install_github("ucsf-ferguson-lab/blotRig")

rm(package_list)
gc()