## Getting & Cleaning Data - Johns Hopkins Data Science Coursera Sequence
## Final Project

## This is the run_analysis.R script which performs the following tasks:
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each
#     measurement.
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names.
# 5) From the data set in step 4, creates a second, independent tidy data set 
#     with the average of each variable for each activity and each subject.

################################################################
# 1) Merge the training and test sets to create one data set ###
################################################################

# call Libraries
library(dplyr)
library(data.table)
library(plyr)

## Read files based on having the UCI HAR dataset file in your working directory
urll<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#destination zip
destfile<-paste0(getwd(),"/","dataweek4.zip")

#download zip file
download.file(urll,destfile,method = curl)

#unzip file
unzip("dataweek4.zip",list = TRUE)

# Read files for test set
Xtest <- read.table(file = "./test/X_test.txt")
ytest <- read.table(file = "./test/y_test.txt")
subjecttest <- read.table(file = "./test/subject_test.txt")

# Read files for training set
Xtrain <- read.table(file = "./train/X_train.txt")
ytrain <- read.table(file = "./train/y_train.txt")
subjecttrain <- read.table(file = "./train/subject_train.txt")

# Read files for features and activity_labels
features <- read.table(file = "features.txt")
activitylabels <- read.table(file = "activity_labels.txt")

# The following three steps merge test and training sets by adding the rows
# Merge Xtest and Xtrain
X <- rbind(Xtest, Xtrain)

# Merge y_test and ytrain
y <- rbind(y_test, ytrain)

# Merge subject_test and subjecttrain
subject <- rbind(subjecttest, subjecttrain)


###############################################################################
# 2) Extracts only the measurements on the mean and standard deviation for each
#     measurement.
###############################################################################


# Find the indices of the elements of features that contain mean or std
msind <- grep("-(mean|std)\\(\\)", features[, 2])

# Use the indices to extract the relevant data entries from X
x <- X[,msind]


#############################################################################
# 3) Uses descriptive activity names to name the activities in the data set #
#############################################################################

# use y[,1] to rearrange the rows of activity labels based on the y variable
# and create a new variable ydescr = descriptive activity name
# basically ydescr has used the activity labels to match the activity numbers 
# and has kept only the labels
activities <- activitylabels[y[,1],2]


##########################################################################
# 4) Appropriately labels the data set with descriptive variable names. ##
##########################################################################

# name the columns of x
names(x) <- features[msind,2]

# name y
names(activities) <- "activity"

# name subject
names(subject) <- "subject"

#############################################
# Combine x y and subject into one dataset ##
#############################################

mydata <- cbind(activities, x, subject)


###############################################################################
# 5) From the data set in step 4, create a second, independent tidy data set  #
#     with the average of each variable for each activity and each subject.   #
###############################################################################

tidydata <- mydata %>% group_by(subject,activities) %>% summarise_all(mean)
write.table(tidydata, "TidyData.txt", row.name=FALSE)