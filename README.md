## Itroduction

In this repository you find the file **run_analysis.R**. This file contains the code used to generate the file **Out_mean.table.txt**.  

Both files form the final submission of the Peer Assessment of the course Getting and Cleaning Data Course Project, from the cohort of July 2015.

## Running the code in your machine

In order to the code *run_analysis.R* work properly, it is **fundamental** that your current working directory contains the **unziped** folder named *"UCI HAR Dataset"*.

The folder *"UCI HAR Dataset"* is the unziped file downloaded from the original source:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip )

The unziped file, resulting in the folder *"UCI HAR Dataset"*, shall not suffer any modification in its structure (e.g. subdirectorie names, file locations, file names).

## About the R code

The code used to generate the output dataset file may be divided in the following parts:

- **Organizing the data**: loads data sets in R environment as `data.frame` objects, combine columns to data sets and combine data sets to form a 10299 X 563 `data.frame` object.
- **Manipulating the data**: converts the `data.frame` object to a `data.table` object, performs the required subsetings using the functionalities of `data.table` package.
- **Data output**: calculates the mean of each measurement grouped by subject and activity, and generates the output file *Out_mean.table.txt*.  

