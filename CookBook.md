# UCI HAR Dataset Cookbook

This document describes the output of the script created for making the UCI HAR Dataset tidy.

The first topic worth to mention is the difference between variables and observations.

* Variables are all the calculated fields in addition to the grouping of the observations depending on changing factor for each observation. In this project, variables are described later in a separate section
* Observations are the values gotten while the controlled variables are fixed. 

According to tidy data definition:

1. Each variable forms a column.
1. Each observation forms a row.
1. Each type of observational unit forms a table

## Introduction

One of the most exciting areas in all of data science right now is wearable computing - see for example [this article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/). Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. This data represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, the data contains 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## Output

The output of this analysis is a data frame containing the mean of all the variables calculated based on the 3-axial gyroscope and accelerometer data captured by each of the volunteers doing a particular activity.

In a glimpse, the output is as follow:

   subject   |    activity.name| time.BodyAccelerometer.mean.X | time.BodyAccelerometer.mean.Y | ... 
-------------|-----------------|-------------------------------|-------------------------------|-----
       2     |      STANDING   |                  0.2779115    |               -0.01842083 | ... 
       2     |       SITTING   |                  0.2770874    |               -0.01568799 | ... 
       2     |        LAYING   |                  0.2813734    |               -0.01815874 | ... 
  ...        |       ...       |                 ...           |               ...         | ... 

where:

* `subject` contains volunteer's identification
* `activity.name` is the type of activity doing by the volunteer when the observation was taken
* the rest of the columns (like `time.BodyAccelerometer.mean.X` and `time.BodyAccelerometer.mean.Y`) are variables measured described in the section "Variables" below
* values of each variables' column are the average of all the observations for each of the variables by subject and activity.name. Note that there will be only one row per (subject,activity.name) pair of values.

## Considerations and changes to the data

The following is a list of considerations taken at the moment of script creation:

* The filtering of the columns based on mean and std was done using the pattern `mean()` and `std()`, excluding the meanFreq columns.
* Variable names were transformed according to accepted names for data frames columns as stated in R [manual](https://stat.ethz.ch/R-manual/R-devel/library/base/html/make.names.html) for `make.names`:

  > A syntactically valid name consists of letters, numbers and the dot or underline characters and starts with a letter or the dot not followed by a number. Names such as ".2way" are not valid, and neither are the reserved words.

* Column names were extended to provide better naming convention as:

  * preceding names with "t" was replaced to "time."
  * preceding names with "f" was replaced to "frequency"
  * Mag, Acc and Gyro abreviations were extended to "Magnitude", "Accelerometer" and "Gyroscope" respectively


## Variables

As for the units of the values, the README file states that all the values have been normalized to [-1,1], so my assumption is that it was made for comparison purposes. Units are not relevant more than for comparing between each group of values.

* Mean and Standard deviation for the time in Body Accelaration axis (XYZ)
  * `time.BodyAcceleration.mean.X`
  * `time.BodyAcceleration.mean.Y`
  * `time.BodyAcceleration.mean.Z`
  * `time.BodyAcceleration.std.X`
  * `time.BodyAcceleration.std.Y`
  * `time.BodyAcceleration.std.Z`
* Mean and Standard deviation for the time in Gravity Acceleration axis (XYZ)
  * `time.GravityAcceleration.mean.X`
  * `time.GravityAcceleration.mean.Y`
  * `time.GravityAcceleration.mean.Z`
  * `time.GravityAcceleration.std.X`
  * `time.GravityAcceleration.std.Y`
  * `time.GravityAcceleration.std.Z`
* Mean and Standard deviation for the time in body linear acceleration and angular velocity derived in time to obtain Jerk signals (all axis (XYZ))
  * `time.BodyAccelerationJerk.mean.X`
  * `time.BodyAccelerationJerk.mean.Y`
  * `time.BodyAccelerationJerk.mean.Z`
  * `time.BodyAccelerationJerk.std.X`
  * `time.BodyAccelerationJerk.std.Y`
  * `time.BodyAccelerationJerk.std.Z`
  * `time.BodyGyroscopeJerk.mean.X`
  * `time.BodyGyroscopeJerk.mean.Y`
  * `time.BodyGyroscopeJerk.mean.Z`
  * `time.BodyGyroscopeJerk.std.X`
  * `time.BodyGyroscopeJerk.std.Y`
  * `time.BodyGyroscopeJerk.std.Z`
* Mean and Standard deviation for the time in body gyroscope axis (XYZ)
  * `time.BodyGyroscope.mean.X`
  * `time.BodyGyroscope.mean.Y`
  * `time.BodyGyroscope.mean.Z`
  * `time.BodyGyroscope.std.X`
  * `time.BodyGyroscope.std.Y`
  * `time.BodyGyroscope.std.Z`
* Mean and Standard deviation for the time in Magnitude calculated using the Euclidean norm according to all the axis
  * `time.BodyAccelerationMagnitude.mean`
  * `time.BodyAccelerationMagnitude.std`
  * `time.GravityAccelerationMagnitude.mean`
  * `time.GravityAccelerationMagnitude.std`
  * `time.BodyAccelerationJerkMagnitude.mean`
  * `time.BodyAccelerationJerkMagnitude.std`
  * `time.BodyGyroscopeMagnitude.mean`
  * `time.BodyGyroscopeMagnitude.std`
  * `time.BodyGyroscopeJerkMagnitude.mean`
  * `time.BodyGyroscopeJerkMagnitude.std`
* Mean and Standard deviation for the frequency applied using Fast Fourier Transform (FFT) in Body Accelaration axis (XYZ)
  * `frequency.BodyAcceleration.mean.X`
  * `frequency.BodyAcceleration.mean.Y`
  * `frequency.BodyAcceleration.mean.Z`
  * `frequency.BodyAcceleration.std.X`
  * `frequency.BodyAcceleration.std.Y`
  * `frequency.BodyAcceleration.std.Z`
* Mean and Standar deviation for the frequency applied using Fast Fourier Transform (FFT) in Body Gyroscope axis (XYZ) 
  * `frequency.BodyGyroscope.mean.X`
  * `frequency.BodyGyroscope.mean.Y`
  * `frequency.BodyGyroscope.mean.Z`
  * `frequency.BodyGyroscope.std.X`
  * `frequency.BodyGyroscope.std.Y`
  * `frequency.BodyGyroscope.std.Z`
* Mean and Standard deviation for the frequency applied using Fast Fourier Transform (FFT) in Body Accelaration and angular velocity based on previous Jerk values
  * `frequency.BodyAccelerationJerk.mean.X`
  * `frequency.BodyAccelerationJerk.mean.Y`
  * `frequency.BodyAccelerationJerk.mean.Z`
  * `frequency.BodyAccelerationJerk.std.X`
  * `frequency.BodyAccelerationJerk.std.Y`
  * `frequency.BodyAccelerationJerk.std.Z`
* Mean and Standard deviation for Magnitude calculated using the Euclidean norm and using FFT frequency
  * `frequency.BodyAccelerationMagnitude.mean`
  * `frequency.BodyAccelerationMagnitude.std`
  * `frequency.BodyBodyAccelerationJerkMagnitude.mean`
  * `frequency.BodyBodyAccelerationJerkMagnitude.std`
  * `frequency.BodyBodyGyroscopeMagnitude.mean`
  * `frequency.BodyBodyGyroscopeMagnitude.std`
  * `frequency.BodyBodyGyroscopeJerkMagnitude.mean`
  * `frequency.BodyBodyGyroscopeJerkMagnitude.std`
