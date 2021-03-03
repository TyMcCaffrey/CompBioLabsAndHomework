#Part 1 simple conditional practice
#Question 1, creating a if else statement that checks if an value is larger than 5
x <- 3
threshold <- 5
if (x > threshold){
  print("Value is greater thatn 5")
}else {print("value is less than 5")}

# Question 2

# Changing the imported data frame into a vector so its easier to work with
ExampleData <- read.csv("ExampleData.csv")
example.vec <- ExampleData[[1]]
str(example.vec)
#2a Write a for loop that changes each value that is negateive to NA in the example vector

for (i in 1:length(example.vec)){
  if(example.vec[i] < 0) {example.vec[i] = NA}
  else{example.vec[i] = example.vec[i]}
    
}
#2b now we want to make all of the NAs into Nan using some kind of logical indexing
#Trying to use a logical index to call all of the NA's
example.vec[is.na(example.vec)] <- NaN
#lets use is.nan for some known negative values from the dataset to make sure this has worked so far
is.nan(example.vec[9])
is.nan(example.vec[16])# 2 for 2 is good enough for me
#2c Use a which statement to change all of our NaN's into zeros, but not with a for loop
example.vec[which(is.nan(example.vec))] <- 0
#Im going to use a similar line of code to check and see if that worked
which(example.vec==0)#Huzzah it did
#2d get the number of values that range from 50-100
#2e ( I accidentally did this part before I did d, so it may have influenced the code above) Making a new vector that contians all of the data falling between 50-100
length(example.vec[which(example.vec > 50 & example.vec < 100)]) 
#first lets see if we can call the data that falls from 50-100
example.vec[which(example.vec > 50 & example.vec < 100)]#sweet, that worked
#Have FiftyToOneHundred call this previous line of code
FiftyToOneHundred <- example.vec[which(example.vec > 50 & example.vec < 100)]
#2f write a csv with this 50-100 vector
write.csv(x = FiftyToOneHundred, file = "FiftyToOneHundred.csv")
#3 read in the CO2 data from lab 4
CO2data <- read.csv("CO2_data_cut_paste.csv")
#3a What was the first year where gas emmissions were non zero
CO2data$Year[which(CO2data$Gas >0)]#This gives us all of the years that the CO2 gas emitions were greater than zero, I can see that the first one is 1885
#3b Which years were Total emissions between 200 and 300 tons
CO2data$Year[which(CO2data$Total > 200 & CO2data$Total < 300)]#The years where carbon emissions were between 200-300 were 1879 1880 1881 1882 1883 1884 1885 1886 1887

#Part II; Loops + conditionals + biology
#Setting up all of the parameters of the Lotka-Volterra model
totalGenerations <- 1000
initPrey <- 100 	# initial prey abundance at time t = 1
initPred <- 10		# initial predator abundance at time t = 1
a <- 0.01 		# attack rate
r <- 0.2 		# growth rate of prey
m <- 0.05 		# mortality rate of predators
k <- 0.1 		# conversion constant of prey into predators
time <- 1:totalGenerations #time vector, 1-totall generations
n <- rep(NA, totalGenerations) #empty vector to store values of n over time
p <- rep(NA, totalGenerations)#empty vector to store values of p over time
n[1] <- initPrey
p[1] <- initPred
for( t in 2:totalGenerations){
  (n[t] <- n[t-1] + (r * n[t-1]) - (a * n[t-1] * p[t-1]))
  (p[t] <- p[t-1] + (k * a * n[t-1] * p[t-1]) - (m * p[t-1]))
  if( n[t] < 0) {n[t] = 0}
  else{n[t] = n[t]}
  
}
#For the most part it looks like this code is working, except it is swithing to NaN's at t=600, which I have no idea why, but I think ill move on to come back to it
#Good news! Adding the portion of the code to make all negative population equal to zero solved the NaN problem, which makes sense because you could never have a negative population

#Cool beans, now its time to plot our predetor and prey populations over time
plot(time, n, type = "l", col= "red", ylab = 'Population', xlab = 'Generation', main = 'Predetor Prey Model')
     lines(time, p, col = 'blue')
     legend(600,400, legend = c("Predetor", "Prey"), col =c('red', 'blue'))
# I'd probably like to mess around with the way this graph looks, but it may depend on time. I ended up comming back and adding color, axis titles and a legend. Didnt quite figure out the legend function yet, but ces la vie.
#Creating a matrix of the results
col.names <- list("TimeStep","PreyAbundance","PredatorAbundance")
myResults <- matrix(data = c(time, n, p), nrow = totalGenerations, ncol = 3, dimnames = list(time , col.names)) #starting off with an empty matrix with the correct dimentions
#Went back and added my three vectors for each of the three columns of the matrix and huzzah, it worked
write.csv(x = myResults, file = "PredPreyResults.csv")
                    