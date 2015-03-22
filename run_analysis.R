#' Loading UCI data set function. It reads all the required
#' files and publishes a single data frame
#' 
#' @param [required] directory where the UCI data set resides
#' @return dataset with 563 variables and 10299 obs.
read.ucidataset <- function( dir, xfile = file.path("test","X_test.txt"), yfile = file.path("test","y_test.txt"), subject = file.path("test","subject_test.txt")) {
  # Reading measures labels
  xfile.data <- read.table(file.path(dir, xfile) )
  
  # Reading labels
  yfile.data <- read.table(file.path(dir,yfile))
  names(yfile.data) <- c("labels")
  
  # Reading subject who executed the test
  subject.data <- read.table(file.path(dir,subject))
  names(subject.data) <- "subject"
  
  # Combining all the data into a single table
  result <- cbind( xfile.data, yfile.data, subject.data)
  result
}

#' Assign the variable names based on a list of variable names
#' located in a file.
#' It also expands the names for getting a better understanding of the
#' variables meaning
#' 
#' @param .data data frame to change variable names
#' @return same data frame used as input with better variable names
publish.varnames <- function( .data, dir, features.file = "features.txt" ) {
  require("dplyr")
  
  # Assign the right names to variables
  var.names <- 
    read.table(file.path(dir,features.file)) %>% 
    rbind(data.frame("V1" = c(562, 563), "V2" = c("labels", "subject")))
  
  # Clean the names to be more descriptive
  names(.data) <- make.names(var.names[["V2"]], unique=TRUE) %>%
    gsub(pattern="\\.{3}", replacement=".") %>%
    gsub(pattern="\\.+$", replacement="") %>%
    sub(pattern="^t([A-Z])", replacement="time.\\1") %>%
    sub(pattern="^f([A-Z])", replacement="frequency.\\1") %>%
    sub(pattern="Mag", replacement="Magnitude") %>%
    sub(pattern="Acc", replacement="Acceleration") %>%
    sub(pattern="Gyro", replacement="Gyroscope")
    
  .data
}

#' Read the activity labels from a file and create a new column with a mapping
#' to the number specified in 'labels'
#' 
#' @param .data where to put the new column
#' @param dir where the file with activity labels is
#' @return same data frame used as input with a new column called 'activity.name'
add.activitylabels <- function( .data, dir, activitylabels.file = "activity_labels.txt" ) {
  require("dplyr")
  
  # Read the activity names
  activity.names <- read.table(file.path(dir,activitylabels.file))
  names(activity.names) <- c("labels", "activity.name")
  
  # Apply names to data
  .data %>%
    inner_join(activity.names, by="labels") 
}

#' Select relevant columns from the data set based on the exercise premise:
#'     2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#'     
#' @param .data from where the selection must be done
#' @param dir where the variable names are. This parameter is required due to the
#'      transformation the names receives when they are assigned as columns.
#' @return a narrower data frame with only the columns containing mean and std values
get.relevantcolumns <- function( .data, dir, features.file = "features.txt" ) {
  require("dplyr")
  
  # Since the search will be by mean() and std(), the original set of names is required
  filter.names <- read.table( file.path(dir,features.file)) %>%
    filter(grepl("(mean|std)\\(\\)",V2)) %>%
    rbind(data.frame(V1=c(563,564),V2=c("subject", "activity.name")))
  
  select(.data, filter.names[["V1"]])
}

#' Main function to make the UCI data set tidy. It performs the operations 
#' required by the exercise:
#'    1. Merges the training and the test sets to create one data set.
#'    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#'    3. Uses descriptive activity names to name the activities in the data set
#'    4. Appropriately labels the data set with descriptive variable names.
#'    
#' @param dir folder where the UCI data is located
#' @return Tidy data frame with UCI data loaded
tidy.ucidataset <- function( dir = "UCI HAR Dataset/") {
  require("dplyr")
  
  # Read full dataset
  complete.data <- rbind( read.ucidataset(dir), read.ucidataset(dir, file.path("train","X_train.txt"), file.path("train","y_train.txt"), file.path("train","subject_train.txt") ) )

  # Clean data names
  complete.data %>%
    publish.varnames(dir) %>%
    add.activitylabels(dir) %>%
    get.relevantcolumns(dir)

}

#' Once the data has been put in a tidy format, create the summarization based on:
#'    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#' 
#' @param .data data to be summarized
#' @return data frame with all the summarizations calculating the mean by subject and activity.name
summarize.ucidataset <- function( .data ) {
  require("data.table")
  
  # Summarizing all the data by subject and activity
  # summarise_each is another way of doing it, but since I found first this solution using data table
  # I preferred to keep it
  dt <- data.table(.data)
  dt[, lapply( .SD, mean ), by=c("subject","activity.name")]
}

#' Main function running points 1 to 5 for the Getting and Cleaning Data
#' from coursera (getdata-012)
#' 
#' @param dir where the data is
#' @return tidy dataset based on the excersice purpose 
getting.and.cleaning.data <- function( dir = "UCI HAR Dataset" ) {
  require('dplyr')
  tidy.ucidataset(dir) %>% summarize.ucidataset()
}