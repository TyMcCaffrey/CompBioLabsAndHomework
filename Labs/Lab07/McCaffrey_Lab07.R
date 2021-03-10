#Ty McCaffrey
#March 5, 2021
#1: Write a function named triangleArea thta calculates and returens the area of a triangle when given two arguments (base and height).

triangleArea <- function(x, y) {
  area <- .5 * x * y 
  return(area)
}
#Saving imputs for the function
base <- 10
height <- 9
#trying out the function
triangleArea(base,height)
#cheers

# Problem 2 Creating a function that acts the same as R's abs function
myAbs <- function(x){
  newabs <- sqrt( x ^2)
  return(newabs)
}
nonabs <- c(1.1, 2, 0, -4.3, 9, -12)
x <- 2
myAbs(nonabs)
#This funciton looks like it already works for both vectors and scalors

#Problem 3
#pasting in my old fib for loop from lab 4
for ( i in 3 : n){ 
  fib[i] <- fib[i-1] + fib[i-2]
  print(fib)
}
#Lets write a function
fib <- numeric(n)
n <- 10
startpoint <- 0

Fibonacci <- function(arg1 = x , arg2 = y ){
  if(startpoint == 0){
    fib[1] <- 0
    fib[2] <- 1
    fib[3] <- 1
  }
  if(startpoint == 1){
    fib[1] <- 1
    fib[2] <- 1
    fib[3] <- 2
  }
  for ( i in 3 : length(fib)){ 
    fib[i] <- fib[i-1] + fib[i-2]
  }
  return(fib[n])
    }

Fibonacci(n, startpoint)
#This looks like it works, which im pretty stoked about because I didnt expect it to first try

#4 A function that returns the square difference of two imputs
sqdf <- function(x, y){
  squareDif <- ((x-y)^2)
  return(squareDif)
}
sqdf(3,5)
vecarg <- c( 2, 4, 6)
sqdf(vecarg, 4) #Cool beans both of those worked so we're happy there

#4b creating a function that replaces mean() by returning the average of a vector

Lab7vec <- DataForLab07$x #first we need to put the data into a vector

mymean <- function(x){
  average <- (sum(x))/length(x)
  return(average)
}
mymean(Lab7vec) #cheers, looks like thats working

#4c, sum of squares function contianing the previous two defined funcitons

sumofsq <- function(x){
  deviations <- numeric(length(x))
  for(i in 1:length(x)){
    deviations[i] <- sqdf(x[i],mymean(x))
    answer <- sum(deviations)
  }
  return(answer)
}
sumofsq(Lab7vec) # This was extreemly satisfying when it worked
