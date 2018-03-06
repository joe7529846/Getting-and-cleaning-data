## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


library(data.table)

# Load test data
x_test <- read.table("./data/UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Load train data
x_train <- read.table("./data/UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")


## modify test data
# Load activity labels and column names
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./data/UCI HAR Dataset/features.txt")[,2]

names(x_test) = features

# Filter to only mean and std 
select <- grepl("mean|std", features)
x_test = x_test[,select]

# Change Test Labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "Subject"

# Bind data
testData <- cbind(as.data.table(subject_test), y_test, x_test)


## Modify train data
# Read in labels
names(x_train) = features

# Filter to only mean and std 
x_train = x_train[,select]

# Change Test Labels
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "Subject"

# Bind data
trainData <- cbind(as.data.table(subject_train), y_train, x_train)


## Merge 
data = rbind(testData, trainData)

idLabels = c("Subject", "Activity_ID", "Activity_Label")
dataLabels = setdiff(colnames(data), idLabels)
meltData = melt(data, id = idLabels, measure.vars = dataLabels)

# tidy data set with the mean of each variable for each activity and subject
tidy = dcast(meltData, Subject + Activity_Label ~ variable, mean)

write.table(tidy, file = "./tidy_data.txt")
