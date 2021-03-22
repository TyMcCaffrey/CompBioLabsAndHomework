
## Lab08, Discrete-time Logistic Growth Model
This directory contains the following 

 - **The R code used to write a discrete-time logistic population growth model**	 `LogGrowth<- function(arg1, arg2, arg3, arg4) {
n <- seq(1,arg3)
n[1] <- arg4
for ( i in 2:arg3){
  n[i] <- n[i-1] + ( arg1 * n[i-1] * (arg2 - n[i-1]) / arg2 )
} 
return(n)
}`
This model was created using as a function called "LogGrowth" which takes four arguments being growth rate, carrying capacity, number of generations, and initial population size. The function then models the population size of a community given these inputs over the desired generations
 - **R code used to make a function that plots the population growth described above**
`LogGrowthPlot<- function(arg1, arg2, arg3, arg4) {
  n <- seq(1,arg3)
  n[1] <- arg4
  for ( i in 2:arg3){
    n[i] <- n[i-1] + ( arg1 * n[i-1] * (arg2 - n[i-1]) / arg2 )
  } 
pop.plot <- plot(seq(1,arg3),n,
                 xlab = "Generations",
                 ylab = "Population size")
return(pop.plot)
}`
 - **MyGrowthModel.csv** A csv file showing a population growth model created using the previous functions with a growth rate of .3, carrying capacity of 50000, starting population size of 2500, over 60 generations. 
 

> Written with [StackEdit](https://stackedit.io/).
