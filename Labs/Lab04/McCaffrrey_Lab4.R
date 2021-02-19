#For loop that prints "Hi" into the consol 10 times

for(i in 1:10){
  print ("Hi")
}

#Piggy Bank For loop
#Saving values for the loop
PiggyBank <- 10
allowance <- 5
gum <- 1.34
weeks <- 8
#The loop itself
for ( i in 1:weeks){
  PiggyBank <- (PiggyBank + allowance) - (gum*2)
  print(PiggyBank)
}

#Question 3 conservation biology problem 
#Assigning values
population <- 2000
years <- 7
#El loop
for ( i in 1: years){
  population <- population * .95
  print (population)
}
      
#Question 4, discrete- time logistic growth model
K <- 1000
r <- .8
n <- seq(1:12)
n[1] <- 2500

for ( t in 2:12){
  n[t] <- n[t-1] + ( r * n[t-1] * (K - n[t-1])/K )
  print(n)
}
#Based off of this loop, I predict the populaiton size at t[12] = 9999.985
# Part II
# 5a creating a vector of 18 zeros
newseq <- rep.int(0,18)


#5b For loop that stores 18 vectors that equal 3x the previous i (I just made it add three to each of the previous value because it would equal the same thing as the 3x the i value and was just more intuitive for me to do it this way)

newseq[1] <- 3
for (i in 2:18 ){
  newseq[i] <- newseq[i-1]+3
print(newseq)
}

#5c new vector of zeros with the first vector as 1
anotherseq <- rep(0,18)
#5d, a loop using this vector that makes each new i 2* the previous i plus 1
anotherseq[1] <- 1
for (i in 2:18){
  anotherseq[i] <- (2*anotherseq[i-1])+1
  print(anotherseq)
}
#6, creating the fibonacci sequence using a R for loop
n <- 20
fib <- numeric(n)
fib[1] <- 0
fib[2] <- 1
fib[3] <- 1
for ( i in 3 : n){ 
fib[i] <- fib[i-1] + fib[i-2]
print(fib)
}

#7 I saved all my data for question 4 under the vector of "n"
abundance <- n
time <- seq(1:12)
pop.plot <- plot(time, abundance)
