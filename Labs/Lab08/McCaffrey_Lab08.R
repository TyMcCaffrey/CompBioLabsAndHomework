#Here is the discrete time logistic growth model from lab 4
K <- 10000  
n <- seq(1,12) 
n[1] <- 2500
r <- .8
for ( t in 2:12){
  n[t] <- n[t-1] + ( r * n[t-1] * (K - n[t-1]) / K )
}
print(n)

abundance <- n
time <- seq(1,12) 
pop.plot <- plot(time, abundance)

#Turning the above code into a function
LogGrowth<- function(arg1, arg2, arg3, arg4) {
n <- seq(1,arg3)
n[1] <- arg4
for ( i in 2:arg3){
  n[i] <- n[i-1] + ( arg1 * n[i-1] * (arg2 - n[i-1]) / arg2 )
} 
return(n)
}
LogGrowth(.3, 50000, 60, 2500)#cool this looked like it worked

#Same function with slight edit to make it return the plot of the pop model
LogGrowthPlot<- function(arg1, arg2, arg3, arg4) {
  n <- seq(1,arg3)
  n[1] <- arg4
  for ( i in 2:arg3){
    n[i] <- n[i-1] + ( arg1 * n[i-1] * (arg2 - n[i-1]) / arg2 )
  } 
pop.plot <- plot(seq(1,arg3),n,
                 xlab = "Generations",
                 ylab = "Population size")
return(pop.plot)
}

popvec <- LogGrowth(.3, 50000, 60, 2500)


MyGrowthModel <- data.frame("generations" = 1:60, "abundance" = popvec)
write.csv(MyGrowthModel, "C:/Users/TyMcC/Courses/CompBio/CompBioLabsAndHomework/Labs/Lab08//MyGrowthModel.csv", row.names = T)
