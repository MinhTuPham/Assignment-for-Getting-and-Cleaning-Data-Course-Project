# Getting and Cleaning Data Course Project
# Peer-graded Assignment (week 4)
run_Analysis <- function(){

# ------------------------------------------------------------------------------------------
# 1. Merges the training and the test sets to create one data set.

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

# ------------------------------------------------------------------------------------------
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

        names(dataset) <- features[ ,2]
        mean_std <- dataset[ grepl("mean|std", names(dataset), ignore.case = TRUE)] 

# ------------------------------------------------------------------------------------------
# 3. Uses descriptive activity names to name the activities in the data set

        label <- merge(datalabel, activitieslabels, by.x = "V1", by.y = "V1")

# ------------------------------------------------------------------------------------------
# 4. Appropriately labels the data set with descriptive variable names.

        data <- cbind(datasubject , label[,2], dataset)
        names(data)[1:2] <- c("Subject", "Activities")

# ------------------------------------------------------------------------------------------
# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
        
        tidydata <- aggregate(. ~Subject + Activities, data, mean)
        tidydata <- tidydata[order(tidydata$Subject),]
        write.table(tidydata, file = "tidydata.txt", row.names = FALSE)
        
}        