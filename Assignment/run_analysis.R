library(data.table)

##Getting files
URL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile="UCIHAR.zip", method="curl")
unzip("UCIHAR.zip")

xtest<-read.table("./UCI HAR Dataset/test/X_test.txt")

xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt")

ytest<-read.table("./UCI HAR Dataset/test/y_test.txt")

ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt")

subjecttest<-read.table("./UCI HAR Dataset/test/subject_test.txt")

subjecttrain<-read.table("./UCI HAR Dataset/train/subject_train.txt")

##Merging training & test sets observations

subject<-rbind(subjecttest, subjecttrain)
setnames(subject, "V1", "subject")

activity<-rbind(ytest, ytrain)
setnames(activity, "V1", "activity")

dataset<-rbind(xtest, xtrain)

##load reference information

featurenames<-read.table("/Users/Herodotus/JHUDataAnalysis/M3W4/UCI HAR Dataset/features.txt", col.names=c("FeatureID","Feature"))
activitynames<-read.table("/Users/Herodotus/JHUDataAnalysis/M3W4/UCI HAR Dataset/activity_labels.txt", col.names=c("ActivityID", "Activity"))

##extracts mean & std deviation measurements into a clean dataset, then labels columns

mean_std<-grep("mean\\(\\)|std\\(\\)",featurenames[,2])
cleandata<-dataset[,mean_std]
names(cleandata)<-featurenames[mean_std,2]

##substitute activity names
activity[,1]<-activitynames[activity[,1],2]

##merge columns

subject.activity<-cbind(subject, activity)
dataset<-cbind(subject.activity, cleandata)

## create second dataset with average for each subject & activity

tidydata<-data.table(dataset)
meltdata<-melt(tidydata, id=c("SubjectID","Activity"))
castdata<-dcast(meltdata, SubjectID+Activity~variable,mean)
write.table(castdata, file="tidy.csv", sep=",", row.names=FALSE)
