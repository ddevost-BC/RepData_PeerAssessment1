---
title: "Untitled"
author: "Donald S. Devost"
date: "Sunday, January 18, 2015"
output: html_document
---

###GLobal Setting
```{r}
echo = TRUE
```

###Loading and Processing the Data
####*Extract (unzip) activity set. This will create 'activity.csv' in the working directory.*

```{r}
unzip('activity.zip', overwrite=TRUE)
```

####Load the dataset into the program.

```{r}
data <- read.csv('activity.csv')
```

####What is mean total number of steps taken per day?
*Ignore the missing values:*

```{r}
noNAdata <- na.omit(data)
```

#####Sum the steps of each day:

```{r}
dframe<-aggregate(noNAdata$steps ~ noNAdata$date, FUN=sum, data=noNAdata)
names(dframe) <- c('date','steps')
```

####Make a histogram of the total number of steps taken each day

```{r}
hist(dframe$steps,main='Histogram of Daily Steps',xlab='Total steps each day',col='grey',breaks=15)
```