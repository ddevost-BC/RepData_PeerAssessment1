---
title: "Reproducible Research Peer Assessment 1"
author: "Donald S. Devost"
date: "Sunday, January 18, 2015"
output: html_document
---


##Assignment
###1. Loading and preprocessing the data
*Unzip the file and format the date column as date class*

```{r Load_Process_data}
unzip("C:/Users/ddevost/OneDrive for Business/activity.zip", exdir = "./data")
Existdata <- read.csv("./data/activity.csv")
#Convert Attributes to Proper Data Types
Existdata[,"date"] <- as.Date(Existdata[,"date"])
Existdata[,"steps"] <- as.numeric(Existdata[,"steps"])
Existdata[,"interval"] <- as.numeric(Existdata[,"interval"])
```

##2. What is mean total number of steps taken per day?
  *A) Make a histogram of the total number of steps taken each day*
  
```{r Histogram}
#Aggregate Total Steps by Date
ExistdataH <- aggregate(Existdata[,"steps"],by=list(Existdata[,"date"]),FUN="sum",na.rm=FALSE)
#Rename Columns in Aggregate Table
names(ExistdataH) <- c("date","totalsteps")
#Plot Histogram of Total Steps Per Day
hist(ExistdataH[,"totalsteps"],col="orange",main="Total Steps by day",xlab="Total Steps")
```

 *B) Calculate and report the mean and median total number of steps taken per day*
 
 Mean of Total Steps:
```{r}
 mean(ExistdataH[,"totalsteps"],na.rm=TRUE)
```
 Median of Total Steps:
```{r}
 median(ExistdataH[,"totalsteps"],na.rm=TRUE)
```

##3. What is the average daily activity pattern?
  *A) Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)*

```{r Time_Series_Plot}
#Aggregate Average Steps by Interval
ExistdataAvg <- aggregate(Existdata[,"steps"],by=list(Existdata[,"interval"]),FUN="mean",na.rm=TRUE)
#Rename Columns in Aggregate Table
names(ExistdataAvg) <- c("interval","averagesteps")
#Plot Time Series of Average Steps by Interval
plot(averagesteps ~ interval, ExistdataAvg, type = "l", col="red",main="Average Steps by Interval",xlab="Interval", ylab="Average Steps")
```

*B) Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?*

```{r Interval}
#Find the Index of the Max Average Steps
maxind <- which.max(ExistdataAvg[,"averagesteps"])
#Return Data for Max Average Steps Interval
ExistdataAvg[maxind,]
```

##4. Inputing missing values
  *A) Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)*

```{r Data_Copy}
#Create a Copy of the Existing data to Fill in NA Steps Values
Existdatacopy <- Existdata
#Find NA Values for Steps
NAind <- which(is.na(Existdatacopy[,"steps"]))
length(NAind)
```

*Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.*
  - Strategy: I will use the mean across all days for the 5-minute interval which the NA occurs.
  
```{r Fill_NA}
#Fill in NA Values for Steps with Average Steps by Interval
for(i in NAind){
  Existdatacopy["steps"][i,] <- ExistdataAvg[which(ExistdataAvg[,"interval"]==Existdatacopy[i,"interval"]),"averagesteps"]
  }
#Check to Ensure No NA Values in New Data Set
which(is.na(Existdatacopy[,"steps"]))
```

*B) Create a new dataset that is equal to the original dataset but with estimates for the missing data filled in.*

```{r New_Data_Set}
#Aggregate Total Steps by Date in New Data Set
NewData <- aggregate(Existdatacopy[,"steps"],by=list(Existdatacopy[,"date"]),FUN="sum",na.rm=FALSE)
#Rename Columns in Aggregate Table in New Data Set
names(NewData) <- c("date","totalsteps")
```

*C) Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.*

```{r New_Histogrtaph}
#Plot Histogram of Total Steps Per Day in New Data Set
hist(NewData[,"totalsteps"],col="brown",main="Total Steps by day(New Data Set)",xlab="Total Steps")
#Calculate the Mean Total Steps Per Day
mean(NewData[,"totalsteps"])
median(NewData[,"totalsteps"])
```
*Do these values differ from the estimates from the first part of the assignment?*

  - Answer: The mean remains the same and the median matches the mean at 10,766, which is indicative of replacing missing steps values has succeeded in removing outliers.

*What is the impact of inputing missing data on the estimates of the total daily number of steps?*

  - Answer: The histogram is more concentrated towards the mean due to a greater number of observations for the middle bar of the histogram.

##5. Are there differences in activity patterns between weekdays and weekends?
Answer: Yes. The average number of steps taken during the office hour (10:00AM - 05:00PM) is a lot higher on weekends than on weekdays. Also, the acitivity level before 8:00AM is a lot lower on weekends than on weekdays.

  *A) Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.*

```{r Weekday_Weekend_TS_Plot}
#Add New Factor Variable to New Data Set to Denote Weekend or Weekday Category
Existdatacopy[,"daycat"] <- ifelse(weekdays(Existdatacopy[,"date"]) %in% c("Saturday","Sunday"),"Weekend","Weekday")
#Aggregate Average Steps by Interval and Category of Weekend or Weekday
ExistdataAvgN <- aggregate(Existdatacopy[,"steps"],by=list(Existdatacopy[,"interval"],Existdatacopy[,"daycat"]),FUN="mean")
#Rename Columns in Aggregate Table
names(ExistdataAvgN) <- c("interval","daycat","averagesteps")
#Load Lattice Library
library(lattice)
#Plot Time Series of Average Steps by Interval
xyplot(averagesteps ~ interval|daycat,data=ExistdataAvgN,layout=c(1,2),type="l",main="Average Steps by Interval and Category of Day",xlab="Interval",ylab="Average Steps")
```
