camData <- read.csv("Cusack_et_al_random_versus_trail_camera_trap_data_Ruaha_2013_14.csv", stringsAsFactors = F)
str(camData)
#Im going to install tidyverse and try working with lubridate
install.packages("tidyverse")
mdy_hms(camData$DateTime)#didnt expect this to work, but it was worth a shot
dates <- as.Date(camData$DateTime)
timeparts <- t(as.data.frame(strsplit(camData$DateTime,' '))) #this got the dates and times separated into two columns of a matrix

time <- chron( timeparts[,1],timeparts[,2])# I dont think that this is working because our time values are only hours and minutes, so I am going to see if I can figure out how to add a zero seconds to each time 

# I cant figure out how to to add 00 to the end of each individual datapoint in a dataset to act as seconds, and I feel like Im barking up the wrong tree so we're gonna stop trying there



camData$DateTime <- strptime(camData$DateTime, format = "%d/%m/%Y %H:%M", tz = "Africa/Dar_es_Salaam")
#strptime worked much better

#Trying to find the dates and times where the year is not represented with the century
camData$Station[]
