# GetAndCleanDataProgrammingAssignment
Getting and Cleaning Data Class, Programming Assignment week 3

Source data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
Stored Locally in a directory named UCI_HAR_Dataset

Part 1: Merges the training and the test sets to create one data set.
  Script will then read in as tables the training and test data.  
  3 files for training and test
    X_* - The data file
    y_* - the label file
    subject_* - The subject file
  Then merge each data, label, and subject file together

Part 2: Extracts only the measurements on the mean and standard deviation for each measurement.
  Script will read in the features.txt file, extract only those with a "mean" or "std" label
  Then merge those features into the mergest data file from Part 1
  Name the columns of the merged data from part 1

Part 3: Uses descriptive activity names to name the activities in the data set
  Load the activity_labels.txt data

Part 4: Appropriately labels the data set with descriptive variable names.
  With the activity labels, and merged label data set from Part 1, match the labels accordingly
  Prep the complete set
     name the column of the label data set as "activity"
     name the column of the subject data set as "subject"
     now merge all 3 using cbind(column 1 is the subject, column 2 is the activity, column 3 is the test&training data merges in Part 1
  Now we have a completedDataSet

Part 5:From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  
  Step 1: how big will this new data set be, take the dim and length sizes of data accordingly
  Step 2: copy over the column names
  Step 3: look through the subjects
    loop through the activities
      Calculate the mean for the matching subject and activity
  Step 4: Write the tidy data set with row.name=FALSE
