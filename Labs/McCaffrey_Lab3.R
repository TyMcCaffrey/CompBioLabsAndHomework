# Making variables for the number of guests and number of bags of chips
BagsofChips <- 5
NumberofGuests <- 8

# Lab step 5 Variable for the expected number of bags of chips eaten by each guest
Expected.Chips <- NumberofGuests*.4

#Lab step 6 leftover chips
BagsofChips - (Expected.Chips+.4)

# Four vectors for the representing the rankings of the Starwars movies (I-IX)

Self <- c(7,9,8,1,2,3,4,5,6)
Penny <- c(5,9,8,3,1,2,4,7,6)
Lenny <- c(6,5,4,9,8,7,3,2,1)
Stewie <-c(1,9,5,6,8,7,2,3,4)

#Penny's episode IV rank
PennyIV <- Penny[4]

#Combining all four rows into one object
Starwars.Rankings <-cbind(Self,Penny,Lenny,Stewie)
 
str(Starwars.Rankings)
str(Penny)
str(PennyIV)
# Objects Penny and Starwars.Ranking are similar because they have the same number of rows, while penny only has one collumn compared to four. Penny IV is the most different because it has a single vector

Starwars.Rankings.data.frame <- data.frame(Starwars.Rankings)
as.data.frame(Starwars.Rankings)
# The two appear to be very simillar with the names as the colum names, however the data frame has an advantege because I can easily look at all of the collums within my global environment.

# Vector of Roman numerals
Numerals <- c("I","II","III","IV","V","VI",'VII',"VIII",'IX')

#assigning numerals as the row names
rownames(Starwars.Rankings.data.frame) <- Numerals

Starwars.Rankings.data.frame[3,]
Starwars.Rankings.data.frame[,4]

#my episode 5 Ranking
Starwars.Rankings.data.frame[5,1]
#Penny's episode II
Starwars.Rankings.data.frame[2,2]
# Everyones IV-Vi
Starwars.Rankings.data.frame[4:6,]
Starwars.Rankings.data.frame[c(2,5,7),]
Starwars.Rankings.data.frame[c(4,6),c("Penny","Stewie")]

#Swapping Lennys 2nd and 5th
Starwars.Rankings.data.frame$Lenny <- c(6,8,4,9,5,7,3,2,1)

Starwars.Rankings.data.frame["II","Lenny"] <- 5
Starwars.Rankings.data.frame["V", "Lenny"] <- 8

Starwars.Rankings.data.frame$Lenny[2] <- 8
Starwars.Rankings.data.frame$Lenny[5] <- 5
