# Getting and Cleaning Data Project
#   
   
The "run_analysis.R" script takes supplied test and training data, and along with auxiliary files, 
creates a tidy data set containing the average of each mean and standard deviation variable 
for each activity and each subject.

The initial data consists of a total of 10,299 observations (rows) and 563 variables (columns).

The script extracts only those columns containing mean and standard deviation data.  
These columns are identified as those which have either the character sequence "mean()" or "std()" 
as part of their name.
For this particular data, there are 66 columns that satisfy this criteria.

The script changes the original column names into camelCase format and eliminates some redundancy.  
In particular:

- The character sequence "-mean()" is changed to "Mean"
- The character sequence "-std()" is changed to "Std"
- Occurrences of "-X", "-Y" and "-Z" are changed to to "X", "Y" and "Z"
- Occurrences of "BodyBody" are changed to "Body"

## Requirements

1. All supplied files should be unpacked from their .zip files and stored in the same directory 
as the script
2. The "dplyr" package should be installed (the script issues a "library(dplyr)" command)

## Processing sequence

1. Set-up step for extracting columns --
Get the column names from the "features.txt" file.  
Eventually, only the columns that have "mean()" or "std()" in their column names will be used, 
so use regular expression analysis to create a TRUE/FALSE vector that has an entry of TRUE 
for each column whose name has "mean()" or "std()" in it.  Then use this vector to create 
a vector of column numbers to be extracted from the test and train data.
2. Convert the column names to camelCase and eliminate redundancy, as detailed above. 
3. Read the test data from "Xtest.txt" and name the columns. 
Read in the subject ids from "subject_test.txt" and activity codes from "y_test.txt" 
and add them as columns to the test data.
4. Repeat the above step with the train data.
5. Combine the test and train data using just the columns containing
mean, standard deviation, subject id and activity code.  The desired
column numbers were determined in Step 1.
6. Create a tidy data set called summaryTable with the average of each 
variable for each activity and each subject.  Use the "group\_by" and "summarise\_each" 
functions from the "dplyr" package to first group the combined data by subject id 
and activity code and then to apply the "mean" function to each group.  Store the result
in a summary table.
Note: The "summarise\_each" function automatically makes the "group by" columns the leftmost 
columns of the summary table.
7. Insert activity names by first reading the file 
that cross references activity codes with descriptions and then creating a vector 
that has an activity description for each activity code in the summary table.  Add 
this vector as a column to the summary table.  Physically insert this column next to the 
column containing the activity codes to make it easier to view.
8. Write the summary table to disk as a text file called "summaryTabble.txt".

## The Tidy Data Set

The format of the tidy data set is as follows:

COLUMN 1: Subject Id (values are 1 - 30)     

COLUMN 2: Activity Id (values are 1 - 6)    

COLUMN 3: Activity Description    

COLUMNS 4-69: The average of each mean and standard deviation variable for each subject id and activity id pair

Each row of the tidy data set consists of data pertaining to a subject / activity pair.
There are 30 subjects and each subject participated in all 6 activities,
thereby resulting in 30 x 6 or 180 rows of data.
The data set is tidy because:

1. There is one observation per row where "observation" is all the means and standard deviations pertaining to a subject id / activity id pair
2. Each variable of the observation has its own column and there are no duplicate columns.