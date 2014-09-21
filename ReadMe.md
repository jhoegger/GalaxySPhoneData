---
title: "ReadMe"
author: "JHoegger"
date: "Saturday, September 20, 2014"
---

###Part 1

The data sets that were available contain test and training data, this is made up of 3 files for test and 3 files for training

Each test file contains 2947 observations
Each file is read into separate data frames 

Each training file contains 7352 observations

There are also files for the column names and labels. I merged the rows 
of each data frame, one for test and one for train. Then added additional column
called observation type that contain "train" or "test", so they could be 
separated out at a later date if needed.

Then I merged all of the data together into a single data frame by binding 
the training rows the the end of the test rows 

At this point, the first 3 columns are:
Student_ID - values from 1-30
Activity_Type - values from 1-6 
ObservationType - either Test or Train

There are an additional 561 columns for the variables from the phone data

## Part 2

Next I create a binary vector of the columns that I need to keep for just Mean and STD
This is used to create a new smaller data frame of a subset of the data

## Part 3

This is followed by replacing the values 1-6 with the decriptive values for the
activity 

## Part 4

I also made the column names more descriptive by removing characters that 
were not needed, changing some of the words, etc.  

## Part 5

I selected to use SQL to query and group by the students and activities 

We then need to replace the new column names that SQL provides with the old
columns names we created earlier 

We write this all out to a txt file


