## Coursera Getting and Cleaning Data
## by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD
## July 2015
## Course Project

## Install the following packages if you don't have them
# install.packages("data.table")
# install.packages("gdata")
library(data.table)
library(gdata)

dir.path <- file.path(getwd(), "UCI HAR Dataset")

# Organizing the data============================
        # All in data.frame formats==============

features.frame <- read.table(file.path(dir.path, "features.txt"), as.is = 2)[ ,2]

for(i in 1:561) {
        features.frame[i] <- paste(features.frame[i], ".Grand", sep = "")
}

X_test.frame <- read.table(file.path(dir.path, "test/X_test.txt"), 
                           colClasses = rep("numeric", 561),
                           col.names = features.frame, check.names = TRUE)
X_train.frame <- read.table(file.path(dir.path, "train/X_train.txt"), 
                           colClasses = rep("numeric", 561),
                           col.names = features.frame, check.names = TRUE)
subject_test.frame <- read.table(file.path(dir.path, "test", "subject_test.txt"),
                                 col.names = "subject", colClasses = "integer")
subject_train.frame <- read.table(file.path(dir.path, "train", "subject_train.txt"),
                                 col.names = "subject", colClasses = "integer")
y_test <- read.table(file.path(dir.path, "test", "y_test.txt"),
                     col.names = "activity_code", colClasses = "character")
y_train <- read.table(file.path(dir.path, "train", "y_train.txt"),
                     col.names = "activity_code", colClasses = "character")
activity_labels <- read.table(file.path(dir.path, "activity_labels.txt"),
                      col.names = c("activity_code", "activity_label"), 
                      colClasses = c("character", "character"))

        # Merging subject and activity columns to the X_test.frame
        # the expression [, c(562, 563, 1:561)] reorder the new columns, 
        # pushing them to the beginning of the dataset
X_test.frame <- cbind(X_test.frame, 
                      subject_test.frame, y_test)[, c(562, 563, 1:561)]
X_train.frame <- cbind(X_train.frame, 
                      subject_train.frame, y_train)[, c(562, 563, 1:561)]

        # The final data.frame data set is

X_testTrain.frame <- rbind(X_test.frame, X_train.frame)

# Converting to data.table=======================

X_testTrain.table <- data.table(X_testTrain.frame, key = c("subject",
                                                           "activity_code"))
activity_labels.table <- data.table(activity_labels, key = "activity_code")

# Manipulating the data.table====================

X_testTrain.table <- merge(X_testTrain.table, activity_labels.table)
keep(X_testTrain.table, sure = TRUE) # Cleaning the memory

        # Reordering the colunms=================

setcolorder(X_testTrain.table, 
            c("subject", "activity_label", "activity_code",
              setdiff(names(X_testTrain.table), c("subject", "activity_label",
                                                  "activity_code"))))

# Subseting only the columns related to mean and std=====

mean_std.vec <- grepl("mean|Mean|std|subject|activity", names(X_testTrain.table))

X_meanStd.table <- X_testTrain.table[, mean_std.vec, with = FALSE]
setkey(X_meanStd.table, "activity_label", "subject")
keep(X_meanStd.table, sure = TRUE) # Cleaning the memory

# Data output====================================

Out_mean.table <- X_meanStd.table[, !c("activity_code"), 
                                  with = FALSE][, lapply(.SD, mean), 
                                  keyby = .(subject, activity_label)]

write.table(Out_mean.table, "Out_mean.table.txt", row.names = FALSE)

