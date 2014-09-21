## run_analysis.r

## This script will perform the following steps on the UCI HAR Dataset downloaded from
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## install.packages("reshape2")
library("reshape2")
## install.packages("plyr")
library(plyr)

print(dir.data <- paste0(getwd(),"/UCI HAR Dataset/"))
print(file.output <- paste0(getwd(),"/tidy_data.txt"))

## Import Reference Files
### Activity
str(ref.activity <- read.table(
    paste0(dir.data,
        "activity_labels.txt"
        )
    ,col.names = c("activity_id", "activity_label")
    ))
## Strip down to just a factor - First column is just an auto-incrementing number
ref.activity <- ref.activity$activity_label

# Import the feature reference files
str(ref.features <- read.table(
    paste0(dir.data,
           "features.txt"
        )
    ,col.names = c("feature_id", "feature_name")
    ))
## Strip down to just a factor - First column is just an auto-incrementing number
ref.features <- ref.features$feature_name
    
## Create a logical vector identifying features to keep.
## This will be used to subset our train/test sets.
features.keep <- grepl("-(mean|std)\\(\\)-", ref.features)

## Scrub the testing data.
### Import X
str(x.test <- read.table(
    paste0(dir.data,
        "test/x_test.txt"
        )
    ))
### Limit to selected features 
names(x.test) <- ref.features
x.test <- x.test[,features.keep]

### Import Y
str(y.test <- read.table(
    paste0(dir.data,
           "test/y_test.txt"
        )
    ,col.names = "activity_id"
    ))
### Merge on the label
y.test$activity_label = ref.activity[y.test$activity_id]

### Import subjects
str(subject.test <- read.table(
    paste0(dir.data,
           "test/subject_test.txt"
        )
    ,col.names = "subject_id"
    ))

### Merge into one set
head(data.test <- cbind(
    subject.test
    ,y.test
    ,x.test
    ))

## Scrub the training data.
### Import X
str(x.train <- read.table(
    paste0(dir.data,
           "train/x_train.txt"
    )
))
names(x.train) <- ref.features
### Limit to selected features 
x.train <- x.train[,features.keep]

### Import Y
str(y.train <- read.table(
    paste0(dir.data,
           "train/y_train.txt"
    )
    ,col.names = "activity_id"
))
### Merge on the label
y.train$activity_label = ref.activity[y.train$activity_id]

### Import subjects
str(subject.train <- read.table(
    paste0(dir.data,
           "train/subject_train.txt"
        )
    ,col.names = "subject_id"
    ))

### Merge into one set
head(data.train <- cbind(
    subject.train
    ,y.train
    ,x.train
    ))

### Append training and testing sets
analysis.set <- rbind(data.train
    ,data.test
    )

## Split the variables into dimensions
## and measures so we can pass them to the "melt" function
print(id.labels <- c("subject_id", "activity_id", "activity_label"))
print(data.labels <- setdiff(colnames(analysis.set), id.labels))

## Melt the data so we can more easily aggregate
data.melt <- melt(
    analysis.set
    ,id = id.labels
    ,measure.vars = data.labels
    ,variable.name = "feature"
    )

## Aggregate the data to reduce its size
data.tidy <- ddply(
    data.melt
    ,c(id.labels,"feature")
    ,summarize
    ,avg=mean(value)
    )

## Output
write.table(data.tidy, file = file.output, row.names = FALSE)
