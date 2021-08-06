library(dplyr)

# read test  & train X data with column names and add activity col
trainX <- read.csv(file.path(getwd(), "UCI HAR Dataset/train/X_train.txt"), 
                  sep="", 
                  header = FALSE)  

testX <- read.csv(file.path(getwd(), "UCI HAR Dataset/test/X_test.txt"), 
                  sep="", 
                  header = FALSE)
                

# 1. Merges the training and the test sets to create one data set.
mergedX <- rbind(trainX, testX)

# extract features names from file
features <- 
    readLines(file.path(getwd(), "UCI HAR Dataset/features.txt")) %>%
    lapply(function(x) strsplit(x, split=" ")[[1]][[2]]) %>%
    unlist

# 2. extract only mean / std measurements
extractedX <- mergedX[, grep("-(std|mean)\\(\\)", features)]

# extract activity factors from file
activities <-  
    readLines(file.path(getwd(), "UCI HAR Dataset/activity_labels.txt")) %>%
    lapply(function(x) strsplit(x, split=" ")[[1]][[2]]) %>%
    unlist %>%
    factor

# 3. parse activity labels as factors
trainY <- readLines(file.path(getwd(), "UCI HAR Dataset/train/y_train.txt")) 
testY <- readLines(file.path(getwd(), "UCI HAR Dataset/test/y_test.txt")) 
mergedY <- c(trainY, testY) %>% sapply(function(x) activities[as.numeric(x)])

# parse subjects
trainSub <- readLines(file.path(getwd(), "UCI HAR Dataset/train/subject_train.txt")) 
testSub <- readLines(file.path(getwd(), "UCI HAR Dataset/test/subject_test.txt")) 
mergedSub <- as.numeric(c(trainSub, testSub))

# 4. set columns names for X with relevant features
names(extractedX) <- features[grep("-(std|mean)\\(\\)", features)]
summaryDF <- extractedX  %>% 
    mutate(activity=mergedY, subject=mergedSub, .before="tBodyAcc-mean()-X") %>%
    group_by(activity, subject) %>%
    summarise_all(mean)
   

