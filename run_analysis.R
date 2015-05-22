library(dplyr)

#download the archived data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile="./UCI-HAR-Dataset.zip")

#unzip the archive for easier access to files
unzipResult <- unzip("./UCI-HAR-Dataset.zip")

#read the features
featuresDT <- read.table("./UCI HAR Dataset\\features.txt")

#vector with col names
colnames <- c(as.character(featuresDT$V2), "subject")

#make a vector that contains only the features that are std dev and mean measurements
idx1 <- grep("mean()", as.character(featuresDT$V2), fixed=T)
idx2 <- grep("std()", as.character(featuresDT$V2), fixed=T)
idx <- c(idx1, idx2)
features <- c(as.character(featuresDT[idx,2]), "subject")

#read the training data
training <- read.table("./UCI HAR Dataset\\train\\X_train.txt")
training <- cbind(training, read.table("./UCI HAR Dataset\\train\\y_train.txt"))

#read the test data
test <- read.table("./UCI HAR Dataset\\test\\X_test.txt")
test <- cbind(test, read.table("./UCI HAR Dataset\\test\\y_test.txt"))

#combine the two data sets
data <- rbind(training, test)

#remove unused data frames
rm(list = c("training", "test"))

#rename the columns
colnames(data) <- colnames

#keep only mean and std columns
tidyData <- data[,features]

#make averages tidy data set
tidyDataAvgs <- tidyData %>% group_by(subject) %>% summarise_each(funs(mean))

#write the results
write.table(tidyDataAvgs, file="./tidyDataAvgs.txt", row.name=FALSE)