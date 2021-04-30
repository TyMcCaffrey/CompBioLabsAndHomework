#This is the script I used to work with, and analyse the transmission.df.csv dataset for Compbio Assignment 9. I am leaving in, but commenting out some code that I ended up not using, but was indicative of the learning that when on as I worked on this project.
setwd("C:/Users/TyMcC/HonorsThesis")
fulldata <- read.csv("transmission.df.csv")
library(tidyverse)
library(lme4)
library(ggpubr)
library(DHARMa)
library(lmerTest)
library(ggeffects)
#cleaning the full dataset
ribdata <- select(fulldata, MTGY.SnailPrev, SnailDensity, Year, SiteCode,ImputedPerimeter_m,SnailSppCode,TotalSnailCount,SnailDissectN)%>%
  distinct()%>%#It looks like there were a ton of repeated observations in here
  filter(SnailSppCode == "HELI")


summary(ribdata)

# I think that I want to start by looking at the pond diameters through time to try to define drought, then I can decide weather to use drought as a categorical factor or a continuous variable
summary(ribdata$ImputedPerimeter_m)
#pondsizebyyear <- summarise( group_by(ribdata, ImputedPerimeter_m, Year),
                                    # Freq = n(),
                                    # .groups = "drop")
#pondsizebyyear<- data.frame("Pondsize" = ribdata2$ImputedPerimeter_m, "Year" = ribdata2$Year)
#That didnt work becuase it told me how many times each perimeter size occured, not each pond name


table(ribdata$SiteCode)# gives me a slightly better picture of how many times each site was sampled from

#str(ribdata$SiteYear)

#Grouping data by year so I can look at how averages change over time
rbyr <- group_by(ribdata, Year)
summarise(rbyr, pondmeans = mean(ImputedPerimeter_m))#Good, but shows me theres some NAs
impondsyrs <- summarise( filter( rbyr, !is.na(ImputedPerimeter_m)),pondmeans = mean(ImputedPerimeter_m))
impondsyrs
#I like this summary a lot, Im going to make a boxplot out of the perimeter sizes to try and see outliers, but I know that I need to parse this set into ponds that are common across all of or at least most years

#I want to know which years had significantly lower average pond perimeters so I can treat them as drought years
which(impondsyrs$pondmeans< (mean(impondsyrs$pondmeans - sd(impondsyrs$pondmeans)))) #Tells me 4 and 6

impondsyrs[4,]
impondsyrs[6,]
#Cool, so based on this we can see that 2014 and 2012s imputed pond perimeters were outliers in this dataset, which would be a good justified for labeling them as "drought years", however I want to visualize this before I move on

boxplot(impondsyrs$pondmeans, 
        main = "", 
        ylab = "Imputed pond perimeters")  #this plot isnt great for these purposes because we can't see each year

ggplot(impondsyrs, aes(Year, pondmeans))+
  geom_point()+
  geom_smooth()+
  ggtitle("Imputed Pond Perimeters by Year")+
  xlab("Year") + ylab("Imputed Pond Perimeter")
scale_x_continuous(name = "Year", breaks = impondsyrs$Year)

#This plot is what I was looking for, although it looks like 2015 head an average pond perimeter similar to that of 2012

which(impondsyrs$Year == 2015)
impondsyrs[7,]

#2015 average imputed pond perimeter is only 1 meter higher than 2012, and looks like it fits better with the drought years than the others, so I will include it as a drought year

#Now lets start looking at Rib infection (MTGY.SnailPrev)
summarise(rbyr, ribinfectmeans = mean (MTGY.SnailPrev))

summarise( filter( rbyr, !is.na(MTGY.SnailPrev)),ribmeans = mean(MTGY.SnailPrev))

#I need to figure out what to do about the different ponds sampled between years becuase they make it so my data isnt independent 

pondabundance <- summarise( group_by( ribdata2, SiteCode, Year), Count = n() )
summary(pondabundance)
# This is telling me how many times each pond was sampled each year, summary tells me the averages, the most a pond was ever sampled and the least. With different ponds sampled each year and the same ponds sampled multiple times, how can we insure that our data are independent?
unique(pondabundance$SiteCode)

which(pondabundance$SiteCode == "BEAVER")
which(pondabundance$Year == 2014)
which(pondabundance$Year == 2015)#I may work to subset this data so we only look at the same sites that are present in both are analysed, this would let me do a paired t-test between a drought year and a non drought year. For now im going to include all of the data and look at a linnear mixed effects model that would account for noise in sample sight.

#DensityColorplot <- ggplot(data      = ribdata,
           #               aes(x     = SnailDensity,
     #                         y     = MTGY.SnailPrev,
      #                        col   = Year,
      #                        group = Year))+ #to add the colors for different classes
 # geom_point(size     = 1.2,
 #            alpha    = .8,
  #           position = "jitter")+ #to add some random noise for plotting purposes
 # theme_minimal()+
 # theme(legend.position = "none")+
 # scale_color_gradientn(colours = rainbow(100))+
#  xlim(0,50)+
#  ylim(0, .50)+
 # geom_smooth(method = lm,
 #             se     = FALSE,
 #             size   = .5, 
 #             alpha  = .8)+ # to add regression line
  #labs(title    = "Snail Density vs. Parasite Prevelence",
  #     subtitle = "Grouped by year sampled in color",
  #     colour = "Year")
#plot(colorscatterplot)
#This is one of those plots you work on for a while, and then just doesnt really work in displaying what I was hoping it would

yearboxplots <- boxplot(MTGY.SnailPrev ~ Year, data = ribdata)#This plot is also not good, but it showed me that alot of the data was clustered at near zero which ended up being a big problem with normal distributions

(split_plot <- ggplot(aes(MTGY.SnailPrev, SnailDensity), data = ribdata) + 
    geom_point() + 
    facet_wrap(~ Year) + # create a facet for each mountain range
    xlab("Rib Pevelance") + 
    ylab("Snail Density"))
#Cool to see the relationships between year, but the data does not look normally distributed

#Now Im going to try and use a mixed effects linnear model that can controll for sitecode, given that different sites were sampled in different years

#I can use this for loop to code drought as binary, since it looks like 2014 is our only drought year, this makes 2014 <- 1 (Yes drought) and all the other years as 0 (no drought)
#for (i in 1:length(ribdata2$Year)) {
 # if(ribdata2$Year[i] == 2014){ribdata2$Year[i] <- 1}
 # else{ribdata2$Year[i] <- 0}
#}
#mixedeffects <- filter( rbyr, !is.na(MTGY.SnailPrev))%>%
  #mutate(Drought = for (i in 1:length(ribdata2$Year)) {
    #if(ribdata2$Year[i] == 2014){Drought[i] <- 1}
   # else{Drought[i] <- 0}
  #})
  #
  ##I realize that I can accomplish this exact for loop with mutate if else, so Im going to try that


mixedeffects <-select(ribdata, MTGY.SnailPrev, SnailDensity, Year, SiteCode,)%>%
  mutate( Drought = ifelse(Year == 2014 | Year == 2012 | Year == 2015, 1, 0))%>%
  filter( !is.na(MTGY.SnailPrev))#This pipeline puts together a really great tible for our mixed effect linnear model
 #This is my first attempt at the mixed effects model


DroughtModel <- lmer(MTGY.SnailPrev~Drought+SnailDensity+(1|SiteCode), data=mixedeffects)
summary(DroughtModel)

#Lets check if our data meets the assumptions of a linear model
plot(DroughtModel)# This qqplot shows unequal residual distribution, looks like it is heteroscedastic
hist(resid(DroughtModel))#Holy skew batman, Im going to try to try a log transformation to correct this 

LogDroughtModel2 <- lmer(log(MTGY.SnailPrev)~ImputedPerimeter_m+SnailDensity+(1|SiteCode), data=mixedeffects, REML=FALSE)#I wasnt able to do the transformation because you cant log 0

summary(DroughtModel2)
summary(mixedeffects$MTGY.SnailPrev)
#now im going to try to a paired t test

#First I want to figure out how restrict the data to only sites that repeat between 2014 and 2013

pairedtable <- select(ribdata, MTGY.SnailPrev, SnailDensity, Year, SiteCode)%>%
  filter(Year %in% c(2013, 2014))%>%#Gets only rows in 2013 or 2014
  group_by(SiteCode)%>%#groups by site code
  filter( !is.na(MTGY.SnailPrev))%>%#filters out NAs from MTGY 
  select( Year, SiteCode, MTGY.SnailPrev)%>% #Narrows down to columns we want for t test
  pivot_wider( names_from = Year, values_from = MTGY.SnailPrev)%>%#Pivots to separate years into rows, allows me to see which sites were sampled in both years
  drop_na()%>%#Drops rows containing NAs
  rename(twentythirteen = "2013")%>%#Renamed because R didnt like numbers as column names 
  rename(twentyfourteen = "2014")%>%
  mutate(differences = twentythirteen - twentyfourteen)#differences for shapiro wilk test
  #This pipeline gives me a table set up to run a paired T test between two years 2014&2013

shapiro.test(pairedtable$differences) 
  hist(pairedtable$differences)
 #this test returned a p value of 2.785e-11, which means it violates the assumption of normally distributed data
#I am thinking of removing all of the 0,0 rows from the dataframe to try to fix this distribution
pairedtable2 <- filter(pairedtable, !differences == 0)
shapiro.test(pairedtable2$differences) #helped, but p value still too low (I dont think there is enough observations)
hist(pairedtable2$differences)
hist(pairedtable$`twentythirteen`)
hist(pairedtable$`twentyfourteen`)
#These two tables show me that the the data is still very skewed

  #repeats<- select(pairedtable, Year, SiteCode, MTGY.SnailPrev)%>%
   # pivot_wider( names_from = Year, values_from = MTGY.SnailPrev)%>%
    #drop_na()

 
#Based off of the consistent problems with the distribution of my response variable, I have decided to go a different rout and use a binomial distribution with 0 representing uninfected and 1 representing infected


binomtable <-select(ribdata, MTGY.SnailPrev, SnailDensity, Year, SiteCode,SnailDissectN, ImputedPerimeter_m)%>% 
  mutate( Drought = ifelse(Year == 2014 | Year == 2012 | Year == 2015, 1, 0))%>%
  filter( !is.na(MTGY.SnailPrev))%>%
  mutate(N.Infected = MTGY.SnailPrev * SnailDissectN)%>%#Gives me a new row for number of infected snails in the sample
  mutate(N.Uninfected = SnailDissectN - N.Infected)#Gives me a new row for number of uninfected snails in the sample
#Together, these new columns will help me make my dependent vairiable binary for a binomial distribution

#cbind lets me use a matrix to say for each observation, theres this number of 1s and this number of 0s
binomialglm <- glm(cbind(N.Infected, N.Uninfected)~
                  Drought + SnailDensity + SiteCode,
                  family = binomial(link = logit),
                  data = binomtable)
plot(binomialglm)
summary(binomialglm)
#That summary doesnt work because we are now using binomial error distribution
simulation_output_binomialglm <- simulateResiduals(fittedModel = binomialglm, n = 711)
plot(simulation_output_binomialglm)
summary(simulation_output_binomialglm)
#Not bad, but this is telling me there is another variable not accounted for effecting the residuals, Im going to try a glmer becuase it will let me use sitecode as a random variable

mixedbinomglm <- glmer((cbind(N.Infected, N.Uninfected))~Drought+SnailDensity+ SnailDensity:Drought + (1|SiteCode),  family = binomial(link = logit),data=binomtable,)

simulation_output_mixedbinomglm <- simulateResiduals(fittedModel = mixedbinomglm, n = 711)
plot(simulation_output_mixedbinomglm)
summary(mixedbinomglm)#summary table giving me the output of the glmer, it looks like the relationships are significant
plot(mixedbinomglm)
plot(binomtablecbind(N.Infected, N.Uninfected), binomtable$Drought)
#Now that looks like a normal distribution!!
testOutliers(mixedbinomglm)
testDispersion(mixedbinomglm)

#Now Im going to try an effect plot to try and visualise this model
#Uses package
DroughtvDensityplot <-  ggpredict(mixedbinomglm, c("SnailDensity", "Drought"))%>%plot()
#I actually think that this is a terrific way of showing the glmer, gives me the negative relationships between the individual fixed effects, but shows the positive relationship when they interact!
#Throw it into ggplot to fix titles 
plot(DroughtvDensityplot)+
  labs(
    title = "Effect of Drought and Host Snail Density on R. ondatrae Prevelance",
    x = "Helisoma Density",
    y = "Percent of Infected Snails")
#I would say this satisfies my goal of the original project!
