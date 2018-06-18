# 1 - Downloadindg data to directory

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest <- "/Users/DEll/OneDrive/Coursera/DATA CLEANING/DATA CLEANING PROJECT/Dataset.zip"
download.file(fileUrl,destfile = "./DATA CLEANING/DATA CLEANING PROJECT/Dataset.zip", method = "curl")

# 2 - Checking for zip download

if(!file.exists("./DATA CLEANING PROJECT/Dataset.zip")){
        
        download.file(fileUrl, destfile = "./DATA CLEANING PROJECT/Dataset.zip" ,mode = "wb")
}

# 3 - Unzip file

unzip(zipfile = "./DATA CLEANING PROJECT/Dataset.zip", exdir = "./DATA CLEANING PROJECT")

# 4- Check unzipped file

if(!file.exists("./DATA CLEANING PROJECT/UCI HAR Dataset")){
        
        unzip(zipfile = "./DATA CLEANING PROJECT/Dataset.zip",exdir = "./DATA CLEANING PROJECT")
}

# 5 - Path & Files of UCI HAR Dataset folder

path <- file.path("./DATA CLEANING PROJECT" , "UCI HAR Dataset")

files<-list.files(path, recursive=TRUE)

# 6 - The list of Files used to load data:

test/subject_test.txt
test/X_test.txt
test/y_test.txt
train/subject_train.txt
train/X_train.txt
train/y_train.txt

# 7 - Reading Activity files

Test_Activity  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)

Train_Activity <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)

# 8 - Reading Subject files

Test_Subject  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)

Train_Subject <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)

# 9 - Reading Features files

Test_features  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)

Train_Features <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

# 10 - Merging Training and Test sets into one dataset

     # Step 1, Binding by rows

activity_data <- rbind(Train_Activity, Test_Activity)

subject_data <- rbind(Train_Subject , Test_Subject)

features_data <- rbind(Train_Features, Test_features)

    # Step 2, setting variable names

names(activity_data) <- c("activity")

names(subject_data) <-c("subject")

data_features_names <- read.table(file.path(path, "features.txt"),head=FALSE)

names(features_data)<- data_features_names$V2

 
    # Step 3, merge columns to get all data in one data frame ,Data

combine_data <- cbind(subject_data, activity_data)

Data <- cbind(features_data, combine_data)


# 11 - Extracting the mean and standard deviation on each measurment

    # Step 1 Subset Name of Features by measurements on the mean and standard deviation

subdata_features_names<-data_features_names$V2[grep("mean\\(\\)|std\\(\\)", data_features_names$V2)]


   # Step 2 Subset the data frame Data by selected names of Features

selected_names<-c(as.character(subdata_features_names), "subject", "activity")

Data<-subset(Data, select = selected_names)


# 12 - Using descriptive activity names to name the activities in the data set

  # Step 1 Reading descriptive activity names from "activity_labels.txt"

activity_labels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)


  # Step 2 Factorizing the  Variable activity in the data frame Data using descriptive activity names

Data$activity<-factor(Data$activity,labels = activity_labels[,2])


# 13 - Appropriately labeling the data set with descriptive variable names

names(Data)<-gsub("^t", "time", names(Data))

names(Data)<-gsub("^f", "frequency", names(Data))

names(Data)<-gsub("Acc", "Accelerometer", names(Data))

names(Data)<-gsub("Gyro", "Gyroscope", names(Data))

names(Data)<-gsub("Mag", "Magnitude", names(Data))

names(Data)<-gsub("BodyBody", "Body", names(Data))

# Print new names

names(Data)


# 14 - creating a second, independent tidy data set with the average of each variable for each activity and each subject

second_data<-aggregate(. ~subject + activity, Data, mean)

second_data<-second_data[order(second_data$subject,second_data$activity),]

write.table(second_data, file = "tidydata.txt",row.name=FALSE,quote = FALSE, sep = '\t')






