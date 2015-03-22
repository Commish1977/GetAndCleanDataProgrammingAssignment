## Getting and Cleaning Data Peer Assessment
##  2015.03.21


## Step 1. Read in then merges the training(X,Y,Subject), test(X,Y,Subject) sets to create one data set for each (X,Y,Subject).
##    Assumption working directory is R with training and test data in ./UCI_HAR_Dataset/ folder

	## Read in the Training data set, Training Labels, Training Subjects
	trainDataSet<-read.table("./UCI_HAR_Dataset/train/X_train.txt")
	trainLabelSet<-read.table("./UCI_HAR_Dataset/train/y_train.txt")
	trainSubjectDataSet<-read.table("./UCI_HAR_Dataset/train/subject_train.txt")

	## Read in the Test data set, Labels, Subjects
	testDataSet<-read.table("./UCI_HAR_Dataset/test/X_test.txt")
	testLabelSet<-read.table("./UCI_HAR_Dataset/test/y_test.txt") 
	testSubjectDataSet<-read.table("./UCI_HAR_Dataset/test/subject_test.txt")
	
	## Merge the Test and Training data set, Labels, Subjects
	mergeTrainAndTestData<-rbind(trainDataSet,testDataSet)
	mergeTrainAndTestLabel<-rbind(trainLabelSet, testLabelSet)
	mergeSubjectDataSet<-rbind(trainSubjectDataSet, testSubjectDataSet)


## Step2. Extracts only the measurements with the text mean or standard deviation(std) for each measurement. 
  ## read in the features.txt data set
	featureDataSet<-read.table("./UCI_HAR_Dataset/features.txt")
	## extract the indexes that either have 'mean' or 'std' in the 2nd column
	measurementIndexes <- grep("mean\\(\\)|std\\(\\)", featureDataSet[, 2])
	## those indexes align with the merged training and test data above
	mergeTrainAndTestData <- mergeTrainAndTestData[, measurementIndexes]
  ## name the columns, taking out extra characters
	names(mergeTrainAndTestData) <- gsub("\\(\\)", "", featureDataSet[measurementIndexes, 2])
	
# Step3. Uses descriptive activity names to name the activities in the data set
	## read in the activity data set labels text file
	activityDataSet<- read.table("./UCI_HAR_Dataset/activity_labels.txt",stringsAsFactors=FALSE)

# Step4. Appropriately labels the data set with descriptive activity names. 
	## matching corresponding activity labels in the master label data set
	activityLabelSet <- activityDataSet[mergeTrainAndTestLabel[, 1], 2]
	mergeTrainAndTestLabel[, 1] <- activityLabelSet
	## name the activity and subjects before column bind for step5 reference
	names(mergeTrainAndTestLabel) <- "activity"
	names(mergeSubjectDataSet) <- "subject"
	completedDataSet <- cbind(mergeSubjectDataSet, mergeTrainAndTestLabel, mergeTrainAndTestData)

# Step5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
	## create the resultDataSets matrix, need the sizes first to initialize
	numOfColumns <- dim(completedDataSet)[2]
	numOfActivities <- dim(activityDataSet)[1]
	numOfSubjects <- length(table(mergeSubjectDataSet))
	resultDataSet <- matrix(NA, nrow=numOfSubjects*numOfActivities, ncol=numOfColumns) 
	resultDataSet <- as.data.frame(resultDataSet)
	## copy over column names to the new data set
	colnames(resultDataSet) <- colnames(completedDataSet)
	## set my index for the row I will be saving too
	currentRow <- 1
	## loop through each subject
	for(sbj in 1:numOfSubjects) {
		## loop through each activity for the subject
		for(act in 1:numOfActivities) {
			resultDataSet[currentRow, 1] <- sort(unique(mergeSubjectDataSet)[, 1])[sbj]
			resultDataSet[currentRow, 2] <- activityDataSet[act, 2]
			subjectMatch <- sbj == completedDataSet$subject
			activityMatch <- activityDataSet[act, 2] == completedDataSet$activity
			## Perform column means where subject and activity match 
			resultDataSet[currentRow, 3:numOfColumns] <- colMeans(completedDataSet[subjectMatch&activityMatch, 3:numOfColumns])
			## increase row index after saving data
			currentRow <- currentRow + 1
		}
	}
	## write the tidy data set result for submission
	write.table(resultDataSet, "tidy_data_result_noName.txt",row.name=FALSE)
## END