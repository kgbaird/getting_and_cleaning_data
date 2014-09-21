## Getting and Cleaning Data - Course Project

Work for completing the Course Assignment for Coursera's Getting and Cleaning Data

### Source Data

The [Human Activity Recognition Using Smartphones Data Set ](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) was taken from the UCI Machine Learning Repository.

### Analysis Script

The `run_analysis.R` script contained in this repository will take the training/testing data, filter it to selected features (those containing mean and/or std), combine it with a few reference files (describing some of the data that has been encoded as IDs), and munge it into a "tidy" data set.  The final output will be a text file titled `tidy_data.txt`.  Details about this output file can be found in the `CodeBook.md` file found within this repository.
