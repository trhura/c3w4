# Analysis for UCI smartphones data set

This repository contains R code to analyze [UCI smartphones data set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). 

## Processing steps

1. Merges the training and the test sets to create one data set.
```R
# read test  & train X data with column names and add activity col
trainX <- read.csv(file.path(getwd(), "UCI HAR Dataset/train/X_train.txt"), 
                  sep="", 
                  header = FALSE)  

testX <- read.csv(file.path(getwd(), "UCI HAR Dataset/test/X_test.txt"), 
                  sep="", 
                  header = FALSE)
                

# Merges the training and the test sets to create one data set.
mergedX <- rbind(trainX, testX)
```
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
```
# extract features names from file
features <- 
    readLines(file.path(getwd(), "UCI HAR Dataset/features.txt")) %>%
    lapply(function(x) strsplit(x, split=" ")[[1]][[2]]) %>%
    unlist

# extract only mean / std measurements
extractedX <- mergedX[, grep("-(std|mean)\\(\\)", features)]
```
3. Uses descriptive activity names to name the activities in the data set
```
# extract activity factors from file
activities <-  
    readLines(file.path(getwd(), "UCI HAR Dataset/activity_labels.txt")) %>%
    lapply(function(x) strsplit(x, split=" ")[[1]][[2]]) %>%
    unlist %>%
    factor
    
# parse activity labels as factors
trainY <- readLines(file.path(getwd(), "UCI HAR Dataset/train/y_train.txt")) 
testY <- readLines(file.path(getwd(), "UCI HAR Dataset/test/y_test.txt")) 
mergedY <- c(trainY, testY) %>% sapply(function(x) activities[as.numeric(x)])
    
```
4. Appropriately labels the data set with descriptive variable names. 
```
names(extractedX) <- features[grep("-(std|mean)\\(\\)", features)]
```
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```
extractedX  %>% 
    mutate(activity=mergedY, subject=mergedSub, .before="tBodyAcc-mean()-X") %>%
    group_by(activity, subject) %>%
    summarise_all(mean) %>%
    write.table(file.path(getwd(), "analysis-output.txt"), row.name = FALSE)
```
