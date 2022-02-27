# starter_folder

This repository is organized as follows:

* Inputs (Folder): This contains the original .dta dataset and the exported and processed csv data file
* Scripts (Folder): This contains the script to load and process the original .dta file. Please make sure to run this script before running the markdown document to have access to the csv file.
* Outputs/Paper: This contains the R Markdown file (paper.rmd) that is used to build the paper. It also contains data analysis code and the references are listed in references.bib

To Start:

Please run the R Script in scripts/01-data_cleaning.R first. This will install and load necessary packages and will also load and export the original .dta data file into a csv file. The csv file will be stored in inputs/

Then, navigate to outputs/paper/paper.rmd to run the R code contained in it. This will build the data and tables that are needed in the final report.

Finally, knit the R Markdown file to obtain the final pdf paper.

Note that the seed has been set to 1234. If this is changed, some parts of the output may be influenced.

Also note that the original STATA code from the original paper is included in /outputs/paper/CEMENT_ReplicationAERPP.do. The original dataset is also included in /inputs/cement_update_2020.dta.