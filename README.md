# Coursera Getting and Cleaning Data 

This is a repo with the assignment project for coursera's getting and cleaning data,Data science Speciality offered by John Hopkins University. The analysis file`run_analysis.R` does the following:

1. check if the file already exists and if not, downloads and unzips the zipped dataset.
2. create complete test and training sets by joining data from subjects, activity type with activity data (acceleration/ velocity)
3. merge test and training set into one data file and column names 
4. add explicit activity labels 
5. correct column names and expand to descriptive column names explaining the variable in each column 
6. produces and writes a tidy dataset with with only mean and standard deviation of every measurement

