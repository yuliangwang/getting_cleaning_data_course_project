##Description of processing steps
###Download and unzip data
###Separately read in train and test data (X, y, subject)
###Combine train and test data and add descriptive information
* Combine train and test X
* Combine train and test y
* Combine train and test subject
* Using features.txt, add descriptive names to columns in the combined X matrix
* As required, extract only features related to mean and standard deviation of variables (i.e., with "mean" or "std" in name)
* Create a single data set "combined.activity.data" where the extracted X matrix, y and subject IDs are combined together
* Replace activity code (1-6) with the corresponding descriptve labels (WALKING, SITTING, etc)
###Create a tidy data set with the average of each variable for each activity and each subject
* Split the data from the previous step by activity and subject
* Using sapply to calclutate the mean of each variable on the split data set
* To comply with tidy data principle, split the original row names (in the form of activity.subject) into two separate vectors and create two separate columns for them
* Write to text table
