# Assignment for Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Explanations of the scripts

> 1) Merges the training and the test sets to create one data set.

Using "read.csv" to load data from UCI HAR Dataset. sep = "" indidcates that the separator is ‘white space’, header = FALSE indicates that there is no headers in the data file.

The training and testing data sets are merged using "rbind" function.

        # Reading Features and Activity labels
        features <- read.csv("features.txt", sep = "", header = FALSE)
        activitieslabels <- read.csv("activity_labels.txt", sep = "", header = FALSE)
        
        # Reading and merging data sets
        trainset <- read.csv("train/X_train.txt", sep = "", header = FALSE)
        testset <- read.csv("test/X_test.txt", sep = "", header = FALSE)
        dataset <- rbind(trainset, testset)
        
        # Reading and merging data labels
        trainlabel <- read.csv("train/y_train.txt", sep = "", header = FALSE)
        testlabel <- read.csv("test/y_test.txt", sep = "", header = FALSE)
        datalabel <- rbind(trainlabel, testlabel)
        
        # Reading and merging subject ID
        trainsubject <- read.csv("train/subject_train.txt", sep = "", header = FALSE)
        testsubject <- read.csv("test/subject_test.txt", sep = "", header = FALSE)
        datasubject <- rbind(trainsubject, testsubject)

> 2) Extracts only the measurements on the mean and standard deviation for each measurement.

First, assign descriptive variable names to columns.
Then, to exact all the measurements on the mean and standart deviations (std), the function "grepl" is used. "grepl" allows for the search for matches to argument (mean or std) within each element of a character vector. ignore.case is set to TRUE indicated that case is ignored during matching.
        
        names(dataset) <- features[ ,2]
        mean_std <- dataset[ grepl("mean|std", names(dataset), ignore.case = TRUE)] 
        
 > 3) Uses descriptive activity names to name the activities in the data set
 
 Using "merge" function to assign descriptive names to the activites of the data set
 
        label <- merge(datalabel, activitieslabels, by.x = "V1", by.y = "V1")
        
> 4) Appropriately labels the data set with descriptive variable names.

Combining and changing the names

        data <- cbind(datasubject , label[,2], dataset)
        names(data)[1:2] <- c("Subject", "Activities")
        
> 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

First, creating the second tidy data set. Using "aggregate" to splits the data into subsets, computes summary statistics (mean) for each activity, and returns the result in a convenient form.
Rearrange the data according to the order of Subject to make the data clearer.
Finally, writing the tidy data in a txt file.

        tidydata <- aggregate(. ~Subject + Activities, data, mean)
        tidydata <- tidydata[order(tidydata$Subject),]
        write.table(tidydata, file = "tidydata.txt", row.names = FALSE)
                
