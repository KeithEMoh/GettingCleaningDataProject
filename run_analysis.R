## Set-up step for Part 2 of Project
## Get the column names from the "features.txt" file.  Eventually only the
## columns that have "mean()" or "std()" in their column names will be used,
## so use regular expression analysis to create a TRUE/FALSE vector
## that has an entry of TRUE for each column whose name has "mean()" or
## "std()" in it.  Then use this vector to create a vector of column numbers
## to be extracted from the test and train data.

columnNames      <- read.table("features.txt")
ix <- grepl("mean\\(\\)", columnNames[ ,2]) | 
      grepl("std\\(\\)", columnNames[ ,2])
colsToExtract <- c(c(1:nrow(columnNames))[ix], 
                    (nrow(columnNames)+1), (nrow(columnNames)+2))

# Set-up step for Part 3 of Project
# change column names to camelCase format by changing "-mean()" and "-std()" to
# "Mean" and "Std" and by changing occurrences of "-X", "-Y" and "-Z" to "X", "Y"
# and "Z".  Change occurences of "BodyBody" to "Body"

columnNames[ ,2] <- gsub("-mean\\(\\)", "Mean", columnNames[ ,2])
columnNames[ ,2] <- gsub("-std\\(\\)", "Std", columnNames[ ,2])
columnNames[ ,2] <- gsub("-X", "X", columnNames[ ,2])
columnNames[ ,2] <- gsub("-Y", "Y", columnNames[ ,2])
columnNames[ ,2] <- gsub("-Z", "Z", columnNames[ ,2])
columnNames[ ,2] <- gsub("BodyBody", "Body", columnNames[ ,2])

# Parts 2 and 3 of Project
# Read the test data and name the columns. 
# Read in the subject ids and activity codes, and add them as
# columns to the test data.

testData              <- read.table("X_test.txt")
colnames(testData)    <- columnNames[ ,2]
testSubject           <- read.table("subject_test.txt")
testLabels            <- read.table("y_test.txt")
testData$subjectId    <- testSubject[ ,1]
testData$activityCode <- testLabels[ ,1]

# Do the same thing as above, but to the train data.

trainData              <- read.table("X_train.txt")
colnames(trainData)    <- columnNames[ ,2]
trainSubject           <- read.table("subject_train.txt")
trainLabels            <- read.table("y_train.txt")
trainData$subjectId    <- trainSubject[ ,1]          
trainData$activityCode <- trainLabels[ ,1]

# Part 1 of Project -- Merge the training and test data sets
# Combine the test and train data, using just the columns containing
# mean, standard deviation, subject id, and activity code.  The desired
# column numbers were determined at the beginning of this script.

comboData <- rbind(testData, trainData)[ , colsToExtract]

# Part 5 of Project -- create tidy dataset called summaryTable with the 
#                    average of each variable for each activity and each subject
# Use the "group_by" and "summarise_each" functions from the "dplyr" package
# to first group the combined data by subject id and activity code
# and then to apply the "mean" function to each group.  Store the result
# in a summary table.
# Note: The "summarise_each" function automatically makes the "group by" columns
#       the leftmost columns of the summary table.

library(dplyr)
summaryTable <- comboData %>% 
                group_by(subjectId, activityCode) %>%
                summarise_each(funs(mean))

# Part 3 of Project -- insert activity names (I didn't see the point of
#                      doing this with the large merged data set) 
# Read the file that cross references activity codes with descriptions
# and create a vector that has an activity description for each activity code
# in the summary table.  Then, add this vector as a column to the summary
# table.  Physically insert this column next to the column containing the
# activity codes to make it easier to view.

act <- read.table("activity_labels.txt")
summaryTable$activityDescrip <- act$V2[match(summaryTable$activityCode, act$V1)]
summaryTable <- summaryTable[ , c(1, 2, 
                                  ncol(summaryTable), 
                                  c(3:(ncol(summaryTable)-1)))]

# Write the summary table to disk as a text file.

write.table(summaryTable, file="summaryTable.txt", row.names = FALSE)

# And that's it for the Getting and Cleaning Data course project!