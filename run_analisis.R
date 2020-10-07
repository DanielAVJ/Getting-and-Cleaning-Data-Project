library(dplyr)

features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Sub <- rbind(subject_train, subject_test)
Data <- cbind(Sub, Y, X)

Data1 <- Data %>% select(subject, code, contains("mean"), contains("std"))

Data1$code <- activities[Data1$code, 2]

names(Data1)[2] = "activity"
names(Data1)<-gsub("Acc", "Accelerometer", names(Data1))
names(Data1)<-gsub("Gyro", "Gyroscope", names(Data1))
names(Data1)<-gsub("BodyBody", "Body", names(Data1))
names(Data1)<-gsub("Mag", "Magnitude", names(Data1))
names(Data1)<-gsub("^t", "Time", names(Data1))
names(Data1)<-gsub("^f", "Frequency", names(Data1))
names(Data1)<-gsub("tBody", "TimeBody", names(Data1))
names(Data1)<-gsub("-mean()", "Mean", names(Data1), ignore.case = TRUE)
names(Data1)<-gsub("-std()", "STD", names(Data1), ignore.case = TRUE)
names(Data1)<-gsub("-freq()", "Frequency", names(Data1), ignore.case = TRUE)
names(Data1)<-gsub("angle", "Angle", names(Data1))
names(Data1)<-gsub("gravity", "Gravity", names(Data1))

FinalDS <- Data1 %>%
  group_by(subject, activity) %>%
  summarise_all(mean)
write.table(FinalDS, "./Getting and Cleaning Data Proj/FinalData.txt", row.name=FALSE)
