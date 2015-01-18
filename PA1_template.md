# Reproducible Research Peer Assessment 1
Donald S. Devost  
Sunday, January 18, 2015  


##Assignment
###1. Loading and preprocessing the data
*Unzip the file and format the date column as date class*


```r
unzip("C:/Users/ddevost/OneDrive for Business/activity.zip", exdir = "./data")
data <- read.csv("./data/activity.csv")
data$date <- as.Date(data$date, "%Y-%m-%d")
```

##2. What is mean total number of steps taken per day?
  *A) Make a histogram of the total number of steps taken each day*


```r
dailystep <- tapply(data$steps, data$date, sum)
temp <- dailystep[!is.na(dailystep)]
hist(temp, breaks=seq(min(temp), max(temp), l = 8 ), 
     main="Histogram of the Total Number of Daily Steps Taken", xlab="Number of Daily Steps Taken", col="grey")
      abline(v=mean(temp), lty=3, col="blue")                   # draw a blue line thru the mean  
      abline(v=median(temp), lty=4, col="red")                  # draw a red line thru the median  
      text(mean(temp),18,labels="mean", pos=4, col="blue")      # label the mean  
      text(mean(temp),16,labels="median", pos=4, col="red")     # label the median  
      rug(temp, col="purple")                                   # place a rug underneath the histogram
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png) 

  *B) Calculate and report the mean and median total number of steps taken per day*


```r
mean(dailystep, na.rm=TRUE)
```

```
## [1] 10766.19
```

```r
median(dailystep, na.rm=TRUE)
```

```
## [1] 10765
```

##3. What is the average daily activity pattern?
  *A) Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)*


```r
interval <- tapply(data$steps, data$interval, mean, na.rm=TRUE)
plot(c(1:288), interval, type="l", main="Time Series Plot", xlab="Time Interval", ylab="Average Steps Taken Across All Days", xaxt = "n")
abline(v=which.max(interval), lty=6, col="blue")
text(which.max(interval),max(interval),                         # draw a red line thru the median 
     labels=paste("max = ",as.character(round(max(interval)))), 
     pos=4, col="blue") 
axis(side = 1, at=c(0,48,96,144,192,240, 288), labels=c("00:00","04:00","08:00","12:00","16:00","20:00","23:55"))      # label the max interval
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png) 

  *B) Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?*


```r
interval[match(max(interval),interval)]
```

```
##      835 
## 206.1698
```

##4. Inputing missing values
  *A) Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)*
  

```r
sum(is.na(data$step))
```

```
## [1] 2304
```

*Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.*
  - Strategy: I will use the mean across all days for the 5-minute interval which the NA occurs.
  *B) Create a new dataset that is equal to the original dataset but with estimates for the missing data filled in.*


```r
newdata <- data
newdata$steps[is.na(newdata$steps)] <- interval[match(newdata$interval, names(interval))]
```

```
## Warning in newdata$steps[is.na(newdata$steps)] <-
## interval[match(newdata$interval, : number of items to replace is not a
## multiple of replacement length
```

  *C) Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.*
  

```r
newdailystep <- tapply(newdata$steps, newdata$date, sum)
hist(newdailystep, breaks=seq(min(newdailystep), max(newdailystep), l = 8 ), 
     main="New Histogram of the Total Number of Daily Steps Taken", xlab="Number of Daily Steps Taken", col="grey")
      abline(v=mean(newdailystep), lty=3, col="blue")                   # draw a blue line thru the mean  
      abline(v=median(newdailystep), lty=4, col="red")                  # draw a red line thru the median  
      text(mean(newdailystep),26,labels="mean", pos=4, col="blue")      # label the mean  
      text(mean(newdailystep),24,labels="median", pos=4, col="red")     # label the median  
      rug(temp, col="purple")                                   # place a rug underneath the histogram
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png) 

```r
mean(newdailystep)
```

```
## [1] 10766.19
```

```r
median(newdailystep)
```

```
## [1] 10766.19
```

*Do these values differ from the estimates from the first part of the assignment?*
- Answer: The mean = 10,766 & median = ~ 10766 remain the same.

*What is the impact of inputing missing data on the estimates of the total daily number of steps?*
- Answer: The histogram is more concentrated towards the mean due to a greater number of observations for the middle bar of the histogram.

##5. Are there differences in activity patterns between weekdays and weekends?
Answer: Yes. The average number of steps taken during the office hour (10:00AM - 05:00PM) is a lot higher on weekends than on weekdays. Also, the acitivity level before 8:00AM is a lot lower on weekends than on weekdays.

  *A) Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.*
  
  ```r
  newdata$weekday <- "weekday"
  newdata$weekday[which(weekdays(newdata$date)== "Saturday" | weekdays(newdata$date) == "Sunday")] <- "weekend"
  newdata$weekday <- as.factor(newdata$weekday)
  ```
  *B) Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).*
  

```r
newinterval <- with(newdata, tapply(steps, list(interval, weekday), mean, na.rm=TRUE))
par(mfrow = c(2,1), mar = c(4,4,2,1))
plot(c(1:288), newinterval[,1], type="l", main="Time Series Plot - Weekday", xlab="Time Interval", ylab="Average Steps Taken", xaxt = "n", col="blue")
plot(c(1:288), newinterval[,2], type="l", main="Time Series Plot - Weekend", xlab="Time Interval", ylab="Average Steps Taken", xaxt = "n", col="blue")
axis(side = 1, at=c(0,48,96,144,192,240, 288), labels=c("00:00","04:00","08:00","12:00","16:00","20:00","23:55"))
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png) 