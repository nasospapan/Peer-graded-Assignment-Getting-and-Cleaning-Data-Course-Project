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

# set the working directory for test set
setwd("C:/Users/nasos/Desktop/Projects/Coursera Getting & Cleaning Data Johns Hopkins/UCI HAR Dataset/test")

# Read files for test set
Xtest <- read.table(file = "X_test.txt")
ytest <- read.table(file = "y_test.txt")
subjecttest <- read.table(file = "subject_test.txt")

# set the working directory for training set
setwd("C:/Users/nasos/Desktop/Projects/Coursera Getting & Cleaning Data Johns Hopkins/UCI HAR Dataset/train")

# Read files for training set
Xtrain <- read.table(file = "X_train.txt")
ytrain <- read.table(file = "y_train.txt")
subjecttrain <- read.table(file = "subject_train.txt")

# set the working directory for UCI HAR dataset
setwd("C:/Users/nasos/Desktop/Projects/Coursera Getting & Cleaning Data Johns Hopkins/UCI HAR Dataset")

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
ydescr <- activitylabels[y[,1],2]


##########################################################################
# 4) Appropriately labels the data set with descriptive variable names. ##
##########################################################################

# name the columns of x
names(x) <- features[msind,2]

# name y
names(ydescr) <- "activity"

# name subject
names(subject) <- "subject"

#############################################
# Combine x y and subject into one dataset ##
#############################################

mydata <- cbind(ydescr, x, subject)


###############################################################################
# 5) From the data set in step 4, create a second, independent tidy data set  #
#     with the average of each variable for each activity and each subject.   #
###############################################################################

tidydata <- mydata %>% group_by(subject,ydescr) %>% summarise_all(mean)
write.table(tidydata, "TidyData.txt", row.name=FALSE)