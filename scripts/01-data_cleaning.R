#### Preamble ####
# Purpose: Load data and normalize
# Author: Ray Wen
# Data: 6-Feb-2022
# Contact: ray.wen@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - Download the libraries needed


# Set seed for reproducibility
set.seed(1234)

# Install packages
install.packages("tidyverse")
install.packages("dplyr")
install.packages("kableExtra")
install.packages("labelled")
install.packages("readstata13")

library(tidyverse)
library(dplyr)
library(kableExtra)
library(readstata13)
library(labelled)
library(haven)

# Load data from dta file

cement <- read.dta13("inputs/cement_update2020.dta")

# Below is not necessary
# cement_update2020 <- read_dta("inputs/cement_update2020.dta")
# 
# cement_names <- tibble(variables = names(cement),
#                  full_names = var_label(cement_update2020))
# cement_names <- data.frame(lapply(cement_names, as.character), stringsAsFactors=FALSE)


         