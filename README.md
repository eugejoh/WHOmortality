
<!-- README.md is generated from README.Rmd. Please edit that file -->
WHOmortality
============

<!-- badges: start -->
<!-- badges: end -->
The `WHOmortality` R package provides tools to easily download, extract, and import the raw data files found in the World Health Organization's (WHO) Mortality Database. Only the dataset containing the [International Classification of Diease, 10th Revision (ICD-10)](https://icd.who.int/browse10/2016/en) codes.

Installation
------------

You can install the development version of `WHOmortality` from the GitHub repository [eugejoh/WHOmortality](https://github.com/eugejoh/WHOmortality) with:

``` r
# install.packages("devtools")
devtools::install_github("eugejoh/WHOmortality")
```

Downloading the Raw Files
-------------------------

The `download_who()` function allows the user to download select raw data files and documentation from the [WHO website](https://www.who.int/healthinfo/statistics/mortality_rawdata/en/).

``` r
library(WHOmortality)
dest_dir <- file.path(getwd(), "who_mort_data")
dir.create(dest_dir) #create new directory
download_who(dest_dir, data = "all")
list.files(dest_dir, full.names = TRUE) #see what file were downloaded
```

Extract Raw Files
-----------------

The `extract_who()` function allows the user to extract the downloaded zip files. This function also adds the `.csv` file extension for the appropriate files.

``` r
extract_who(dest_dir) #this extracts the zip file contents in the same directory
list.files(dest_dir, full.names = TRUE)
```

Import WHO Raw Files
--------------------

The `import_who()` allows the user to import select raw files into R. The example below imports the mortality and population data into R from the locally extracted files.

``` r
mort_df <- import_who(dest_dir, "mort")
pop_df <- import_who(dest_dir, "pop")
```

Data Dictionaries
-----------------

The data dictionaries for the mortality and population tables found in the contents of `documentation.zip` are tables contained with the `WHOmortality` package.

``` r
data(dd_mort) #load data dictionary for mortality table
data(dd_mort) #load data dictionary for population table
```
