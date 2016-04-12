This repo demonstrates gathering, working with and cleaning a database. The working example given is a dataset from Samsung Galaxy S smartphone accelerometers obtained from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This will provide a dataset labelled "UCI HAR Dataset", comprising:
- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

-'train' and 'test' folders comprising data for 30 subjects in total, where each subject performed 6 activities. Subsequently, 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz readings were captured from the phone accelerometer.

run_analysis.R is a script written to analyse the unzipped data from the UCI HAR dataset.
#Packages required
data.table

#1. Load files:

xtest<-read.table("UCI HAR Dataset/test/X_test.txt")
xtrain<-read.table("UCI HAR Dataset/train/X_train.txt")
ytest<-read.table("UCI HAR Dataset/test/y_test.txt")
ytrain<-read.table("UCI HAR Dataset/train/y_train.txt")
subjecttest<-read.table("UCI HAR Dataset/test/subject_test.txt")
subjecttrain<-read.table("UCI HAR Dataset/train/subject_train.txt")

#2. Training and test observations are merged and labelled

subject<-rbind(subjecttest, subjecttrain)
setnames(subject, “V1”, “subject”)
activity<-rbind(ytest, ytrain)
setnames(activity, “V1”, “activity”)
dataset<-rbind(xtest, xtrain)

#3. Reference information loaded

featurenames<-read.table("UCI HAR Dataset/features.txt", col.names=c("FeatureID","Feature"))
activitynames<-read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("ActivityID", "Activity"))

#4. Extracts mean & std deviation measurements into a clean dataset, then labels columns

mean_std<-grep("mean\\(\\)|std\\(\\)",featurenames[,2])
cleandata<-dataset[,mean_std]
names(cleandata)<-featurenames[mean_std,2]

#5. Substitutes activity names
activity[,1]<-activitynames[activity[,1],2]

#6. Merges all columns into a single dataset

subject.activity<-cbind(subject, activity)
dataset<-cbind(subject.activity, cleandata)

#7. Creates tidy dataset with average for each subject & activity

tidydata<-data.table(dataset)
meltdata<-melt(tidydata, id=c("SubjectID","Activity"))
castdata<-dcast(meltdata, SubjectID+Activity~variable,mean)
write.table(castdata, file=”tidydata.txt”, sep=”,”, row.names=FALSE)

The final tidy dataset is available on this repo at /tidydata.csv
