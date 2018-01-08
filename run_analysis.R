#getting and cleaning data course project

#1_Merges the training and the test sets to create one data set.
#2_Extracts only the measurements on the mean and standard deviation for each measurement.
#3_Uses descriptive activity names to name the activities in the data set
#4_Appropriately labels the data set with descriptive variable names.
#5_From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(data.table)
library(dplyr)

zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename<-"dataset.zip"

if(!file.exists(filename)){download.file(zipUrl,filename, method = "curl")}
if(!file.exists("UCI HAR Dataset")){unzip(filename)}

#excercise1,3,4:
#making test dataset set by merging the single components acticity, subject and the data 
test_set<- fread("UCI HAR Dataset/test//X_test.txt", header = FALSE, stringsAsFactors = FALSE)
test_activity_labels<-fread("UCI HAR Dataset/test/y_test.txt", header = FALSE, stringsAsFactors = FALSE)
test_subjects<- fread("UCI HAR Dataset//test/subject_test.txt", header = FALSE, stringsAsFactors = FALSE)
test_data<- cbind(test_subjects, test_activity_labels, test_set)

#same for training set train_data
train_set <- fread("UCI HAR Dataset/train/X_train.txt")
View(train_set)
train_activity_labels<-fread("UCI HAR Dataset/train/y_train.txt")
train_subjetcs<- fread("UCI HAR Dataset/train/subject_train.txt")
train_data<- cbind(train_subjetcs, train_activity_labels, train_set)

dim(train_data)

#merging the datasets to one big dataset
activity_data<- rbind(test_data, train_data)

#reading feature labels
features<- fread("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

#adding column names to the data
col_names<- c("subject", "activity", features[,2])
colnames(activity_data)<-unlist(col_names)
activity_data<-as.data.frame(activity_data)
str(activity_data)

#reading labels data
labels<- read.csv("UCI HAR Dataset/activity_labels.txt",sep = " ", header = FALSE, col.names = c("activity", "activity_name") )
labels$activity_name<-tolower(labels$activity_name)

#adding activity label to activity column
activity_data$activity<- factor(as.character(activity_data$activity), levels = labels[,1], labels = labels[,2])

#adding descriptive names to the dataset

#getting column names 
cn<-colnames(mean_st_activity_data)
#removing special characters
cn<- gsub("(-|_| |\\(|\\))","",cn) 
#changing variable abbreviations into descriptive variable names
cn<- gsub("^t","timedomain", cn)
cn<-gsub("^f", "frequencydomain", cn)
cn<-gsub("[Aa]cc","linearacceleration",cn)
cn<-gsub("[Jj]erk","jerksignal", cn)
cn<-gsub("[Gg]yro","angularvelocity",cn)
cn<-gsub("[Mm]ag","magnitude", cn)
cn<-gsub("[Ff]req", "frequency", cn)
cn<-gsub("[Mm]ean", "mean", cn)
cn<-gsub("[Ss]td","standarddeviation",cn)
#correcting the typo 
cn<-gsub("Bodybody", "body", ignore.case = TRUE,cn)

#implementing updated and descriptive column names
colnames(mean_st_activity_data)<-cn
#check result
View(mean_st_activity_data)
#2_Extracts only the measurements on the mean and standard deviation for each measurement.
mean_st_activity_data <- activity_data[,grepl("subject|activity|mean|std", colnames(activity_data))]

#5_From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
td<-as.data.table(mean_st_activity_data)
td<-td[,lapply(.SD, mean),by = .(subject,activity)]
View(td)
dim(td)

#or
ActivityMeans <- mean_st_activity_data %>% group_by(subject, activity) %>% summarise_each(funs(mean))

#write a tidy data table
write.table(td, file = "tidy_data.txt")

#check that file was saved the way I intended
read<-read.table("./tidy_data.txt")
#p.s. I tried opening it with fread, and it truncated the first line (with the column names, it says it has too few or too many items to be column names.. any idea how to disbale that)



