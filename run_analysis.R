#Download file
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="UCI_HAR.zip",method="curl")
download.date<-date()
unzip("UCI_HAR.zip")

#Read in train and test data
trainX<-read.table("./UCI HAR Dataset/train/X_train.txt",header=F)
trainY<-read.table("./UCI HAR Dataset/train/y_train.txt",header=F)
trainSubj<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=F)
testX<-read.table("./UCI HAR Dataset/test/X_test.txt",header=F)
testY<-read.table("./UCI HAR Dataset/test/y_test.txt",header=F)
testSubj<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=F)

#Combine train and test data
combinedX<-rbind(trainX,testX)
combinedY<-rbind(trainY,testY)
combinedSubj<-rbind(trainSubj,testSubj)
#Add descriptive column variable names 
features<-read.table("./UCI HAR Dataset/features.txt",row.names=1,stringsAsFactors = F,header=F)
colnames(combinedX)<-features$V2
#Extract only the measurements on the mean and standard deviation for each measurement
ind_keep<-grep("mean|std",colnames(combinedX))
combinedX<-combinedX[,ind_keep]
#Add activity and subject and X together
combined.activity.data<-cbind(combinedY,combinedSubj,combinedX)
colnames(combined.activity.data)[1:2]<-c("activity","subjectID")
#Uses descriptive activity names to name the activities in the data set
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",header=F,stringsAsFactors = F)
for (i in 1:nrow(activity_labels)){
    combined.activity.data$activity[combined.activity.data$activity==activity_labels$V1[i]]<-activity_labels$V2[i]
}

#Split the data by activity and subject
data.by.act.subj<-split(combined.activity.data,list(combined.activity.data$activity,combined.activity.data$subjectID))
#Calculate the mean of variables by activity and subject
summarised.data<-sapply(data.by.act.subj,FUN = function(x) colMeans(x[,3:ncol(x)]))

#Manipulate the summarised data to create tidy data set with descriptive variable names
summarised.data<-t(summarised.data)
#Original output has activity labels and subject ID combined in one single column,
#which violates tidy data principle. Now split that into two separate columns
separate.labels<-strsplit(rownames(summarised.data),"\\.")
summarised.data<-cbind(sapply(separate.labels,function(x) x[[1]]),sapply(separate.labels,function(x) x[[2]]),summarised.data)
colnames(summarised.data)[1:2]<-c("activity","subject")

#Write to text table
write.table(summarised.data,file="UCI_HAR_data_summarized_by_activity_subject.txt",col.names=T,row.names=F,sep="\t",quote=F)
