
setwd("C:/Projects/Coursera-DS/3.Data-week1/3.Data-CourseWork/UCI HAR Dataset")

#####################################################
#    1.Merges the training and the test sets to create one data set
#####################################################

# Read in all of the data from the files

# each in the label data for the datasets 
activityLabels <- read.table("./activity_labels.txt", col.names=c("id", "ActivityName"))
activityLabels <- as.vector(activity_labels$ActivityName)

features <- read.table("./features.txt", col.names=c("id", "FeatureName"))
features <- as.vector(features$FeatureName)

# each test file contains 2947 observations
# read them all into separate data frames 
testSubject <- read.table("./test/subject_test.txt", col.names="SubjectID")
testXData <- read.table("./test/X_test.txt")
testActivity <- read.table("./test/y_test.txt", col.names="Activity")

# each training file contains 7352 observations
# read them all into separate data frames 
trainSubject <- read.table("./train/subject_train.txt", col.names="SubjectID")
trainXData <- read.table("./train/X_train.txt")
trainActivity <- read.table("./train/y_train.txt", col.names="Activity")

# now merge all of the data together into a single data frame

#get the total number of observations from the test data and the train data
testObs <- nrow(testSubject)
trainObs <- nrow(trainSubject)

#create a vector with the value "Train" and "test with the same number 
#of observations as the data sets

#first bind all of the test data together
testData <- cbind(testSubject,testActivity)
ObservationType <- gl(1, testObs, labels = c("Test"))
testData <- cbind(testData,ObservationType)
testData <- cbind(testData,testXData)

#second bind all of the train data together
trainData <- cbind(trainSubject,trainActivity)
ObservationType <- gl(1, trainObs, labels = c("Train"))
trainData <- cbind(trainData,ObservationType)
trainData <- cbind(trainData,trainXData)

#third bind all of the test and train data together
fullDataSet <- rbind(testData,trainData)

##add the column names 
names(fullDataSet) <- c(names(fullDataSet[1:3]),features)

#####################################################
#  2.Extracts only the measurements on the mean and 
#  standard deviation for each measurement.
#####################################################

#get a vector of true or false for the colums that contain Mean or STD
#we need to ignore case because some gravity mean values are upper case 
columnsToKeep <- grepl("mean|std", names(fullDataSet) , ignore.case=TRUE)

#we also want the studentID, Activity and Observation Type, so we need
#to set them to be true
columnsToKeep[1:2] <- TRUE

meanStdDataSet <- fullDataSet[columnsToKeep]

#####################################################
#  3.Uses descriptive activity names to name the activities in the data set
#####################################################

for(i in 1:nrow(meanStdDataSet)) {
    activity <- activityLabels[as.integer(meanStdDataSet[i,2])]
    meanStdDataSet[i,2] <- activity
}

#####################################################
#  4.Appropriately labels the data set with descriptive variable names. 
#####################################################

#get the current set of column names
columnNames <- names(meanStdDataSet)

#the labels need to be more descriptive
#change t to be Time and f to Freqency
#change acc to acceleration, etc 
columnNames <- gsub("tBody","TimeBody", columnNames)
columnNames <- gsub("fBody","FreqencyBody", columnNames)
columnNames <- gsub("tGravity","TimeGravity", columnNames)
columnNames <- gsub("Acc-","Acceleration", columnNames)
columnNames <- gsub("Mag-","Magnitude", columnNames)
columnNames <- gsub("angle","Angle", columnNames, ignore.case = FALSE)
columnNames <- gsub("gravity","Gravity", columnNames, ignore.case = FALSE)
columnNames <- gsub("mean","Mean", columnNames, ignore.case = FALSE)
columnNames <- gsub("std","STD", columnNames, ignore.case = FALSE)


#Need to remove the invalid SQL characters
columnNames <- gsub("\\,", "", columnNames)
columnNames <- gsub("\\-", "", columnNames)
columnNames <- gsub("\\(", "", columnNames)
columnNames <- gsub("\\)", "", columnNames)

#replace the column names 
names(meanStdDataSet) <- columnNames

#####################################################
# 5.From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
#####################################################


#need to reset these variables, so that you can rerun the code
#as they both use paste and will keep adding to the string 
AveragePerColumn <-""
sQLSelectString <- ""

#build up the select average part of the SQL query 
phoneDataColumnNames <- columnNames[3:length(columnNames)]
newPhoneDataColumnNames <- c()
for (ColumnName in phoneDataColumnNames) {
    AveragePerColumn <- paste( ", AVG(",ColumnName,")", sep="") 
    sQLSelectString <- paste(sQLSelectString, AveragePerColumn, sep="" )
    newPhoneDataColumnNames <- c(newPhoneDataColumnNames, paste( "Average",ColumnName, sep="") ) 
}

# build a SQL query
groupByColumns <- " SubjectID, Activity"
sQLSelectString <- paste("Select ",groupByColumns, sQLSelectString)  
sQLSelectString <- paste(sQLSelectString, " From meanStdDataSet Group By ", groupByColumns)  


# create the tinyData data frame
averageDataSet <- sqldf(sQLSelectString)

#replace the names that SQL generated with friendly names 
names(averageDataSet) <- c("StudentID", "Activity", newPhoneDataColumnNames)

#write the average value data set out to a txt file
filePath = "./TidyAverageValueDataSet.txt"
write.table(averageDataSet, filePath, row.name=FALSE)

#read the file back in and make sure that it looks good
data <- read.table(filePath, header = TRUE) 
View(data)
