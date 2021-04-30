
# Effect of drought on California pond trematode disease systems

### Biological question
How does Drought impact parasite host dynamics between R. ondatrea and Helisoma snails?

### Context (introduction)
One of the most important, and often overlooked factors in a thriving ecosystem is disease. Diseases caused by parasitic infection play a massive role in promoting a healthy ecosystem, increasing ecological connectivity and promoting biodiversity (Hatcher2012). One of the reasons parasites such as Ribeiroia ondatrae play such crucial roles in the health of an ecosystem is the way they flow through multiple host species in through the course of a single life cycle, impacting the survival of several host species within one generation. Ribeiroria ondatrae (Rib for short) has a three-host life cycle, going from an intermediate snail host to an amphibian host, and finally to its definitive host, aquatic birds, and back to the beginning (Johnson2003).  Through this intricate life cycle, Rib holds an important key for ecologists to better understand and predict the health of the ecosystems where it is found.

Currently, there is a gap in the fields knowledge of how climate change will impact important disease dynamics such as those found between Rib, its hosts, and the rest of the ecosystem.  Due to climate change, ecosystems are experiencing a greater rate of disturbances such as extreme drought. Effects of disturbances on parasites are not well understood due to the complicated relationship between stress on host immune systems of the host organism, and effect of stress on the parasite itself. It is imperative that ecologists may be able to understand and predict how these events will impact disease dynamics and ecosystem health.

The purpose of this project, is to manipulate a dataset containing information on parasite prevalence, drought, and host species density into tables suitable to be able to perform an appropriate statistical tests in order to better understand the effects of environmental stress on host-parasite dynamics.

### Methods
##### The source of the data:
The data I will be working on for this project was collected by the Johnson Lab through CU in the field research facilities in California. I obtained this data by reaching out to my research advisor Dr. Peiter Johnson

The number of snails dissected from each sample site divided by the number of dipnets pulled from each pond was used to calculate snail density for each observation. Prevalence of Ribeiroia ondatrae (MTGY.Prev) was calculated by dividing the number of snails dissected that were infected with Rib, by the total number of snails dissected for each sample site. Sitecode (pond), year the sample was taken and pond perimeter in meters were recorded for each observation. Among observations, sitecodes were not consistent between years despite a good amount of overlap. This was probably the aspect of the data that caused me to struggle the most when trying to create tables that might be use full for statistical analysis. Understanding, visualizing, and manipulating the different ponds that were sampled through this dataset occupied a significance portion of this project.

The raw dataset was very large with 7680 observation and 1122056 bytes, which was quickly whittled down to much more manageable tables.

##### What the original authors did with the data:
This dataset was privately to me by an advisor, and as far as I know has not been included in any publications at this point.

##### What _YOU_ did with the data and how you did it:
After cleaning the data by parsing if of NAs and repeated observation, I began exploring the relationship between ImputedPerimeter_m (the perimeter of the pond each observation was taken from) and the year the observation was taken. I chose this starting point because I knew I wanted to look at some relationship between Drought and parasite prevalence. I found that the best way to explore this relationships in R was dyplr groupby() function, which allowed me to group pond perimeters by year, and find each years mean pond perimeter. I then graphed this, and could clearly see three years whos pond perimeters were significantly less than the others 2012, 2014, and 2015, which would become my drought years.

![A plot representing the difference of average pond perimeters for each year, with the lowest three representing our drought years, 2012, 2014, and 2015](![file:///C:/Users/TyMcC/HonorsThesis/PondPerimitersByYearPlot)]

From then, I moved to working to get my data in a form where I could attempt to run it through lmer, a statistical linear mixed effect modeling function. To accomplish this I set up a dplyr pipeline which selected only the columns that I was interested in, and then created a new column for called Drought, which coded a 1 for observations made in one of the three drought years mentioned above, and a 0 for any observation taken in a non drought year.

Unfortunately, this dataset violented the assumptions of this statistical model because its residuals were not normally distributed. So next I wanted to get the dataset into a table that would allow me to run a different statistical test, a paired t-test. This table was especially difficult to make, because I needed to only have observation that had the same Sitecode between two years. To create this paired t-test table, I first filtered out any observation that wasn't taken in 2014 or 2013 (the two years that I was comparing in the paired test), grouped the data by sitecode, and then pivoted the data so that the years were separated into distinct columns. Pivoting the table allowed me to see which Sitecodes were present for one year or both, and then by filtering out NAs, I was able to drop all of the sitecodes that were not present for both years, left with a table of paired observations across two years. This process resulted a new dataset with only 47 observations and 4 variables. Unfortunately, due to a large number of observations with no parasite prevelance, the dependent variable of MTGY.SnailPrev was still not normally distributed. I then attempted to filter out the observations which had 0 prevalence values for both years, which helped the distribution, but not enough to make the test valid.

Finally, I decided to try to use a generalized mixed effect model, which would allow me to use a binomial error distribution and hopefully fix the heteroscedastic residual problems I had been having before. But first, I needed to figure out how to change my continuous parasite prevalence variable into a binary dependent variable. The way I did this was by creating a new dataset based off of the one I had used for the lmer model before, but this time adding two new columns for the number of snails infected for each observation, and the number of snails uninfected for each observation. This was necessary because each single observation represents many different snails, each with its own infection status. Where in a typical generalized linear model, each row would be one host with a 1 or 0 for infection status, the cbind() function lets you work with data where each row represents a site, and cbind says: for a given site we have X number of 1s and X number of 0s.

Finally I plugged this into a generalized mixed effect model and use a binomial with the lme4() package (Bates, 2015) error distribution, and resulted in a model that did not violate any statistical assumptions. I then paired the model with a ggpredict() graph from the ggeffects package (Lüdecke, 2018) (Fairway, 2021), and was able to visualize the effects of drought, snail host density, and the interaction between the two on  R. ondatrea prevelance.  

### Results and conclusions
This generalized linear mixed effects model indicates that independently, both drought and host snail density, are negatively corelated with prevalence of the parasite R. ondatrea (Drought coefficient =   -0.632843, z value = -5.953, estimated p = 2.63e-09), (SnailDensity coefficient =   - -0.008189,  z value = - 0.003819, estimated p = 0.032).The model suggests that the interaction between these two factors, however, is positively correlated with R. ondatrea prevalence ( Drought:SnailDensity coefficient = 0.046865,  z value = 7.859, estimated p = 3.86e-15). All three of these fixed effects had estimated p-values that were statistically significant at alpha = .05. These were found using lmerTest() package (Kuznetsova, 2017)

![A plot showing the effects of drought and host snail density, as well as their interaction on R. ondatrea prevalence. Shows the negative relationship between infection prevalence and drought and host density independently, but a flipped positive relationship given the interaction of these effects. Used DHARMa package (Hartig,2021)  ](file:///C:/Users/TyMcC/HonorsThesis/DroughtInteractionPlot)

The biggest takeaway from this model that I see is that there is an inverse effect on R. ondatrae prevalence of Snail Density and Drought independently then when the two interact. Together, drought and high snail density have a positive impact of Rib prevalence. But in circumstances with high density and no drought, or drought and low density, we see that each variable has a negative relationship with Rib parasite prevalence. This indicates the complexity of parasite host relationships and how they are impacted by environmental stressors. There could be a number of reasons why this specific relationship was observed, but this model acts as further evidence as to why the effects of environmental stress caused by climate change need to be studied further.



Bibliography:
Faraway, Julian. Multiple Response Multilevel Models. Accessed April 30, 2021. https://people.bath.ac.uk/jjf23/mixchange/multiple.html.

Douglas Bates, and Martin Chler. "Fitting Linear Mixed-Effects Models Using {lme4}." Journal of Statistical Software, 2015, 133-99. doi:10.1007/0-387-22747-4_4.

Hartig, Florian. "Residual Diagnostics for Hierarchical (Multi-Level / Mixed) Regression Models [R Package DHARMa Version 0.4.1]." The Comprehensive R Archive Network. April 08, 2021. Accessed April 30, 2021. https://cran.r-project.org/package=DHARMa.

Hatcher, Melanie J., Jaimie Ta Dick, and Alison M. Dunn. "Diverse Effects of Parasites in Ecosystems: Linking Interdependent Processes." Frontiers in Ecology and the Environment 10, no. 4 (2012): 186-94. doi:10.1890/110016.

Johnson, P. "Amphibian Deformities and Ribeiroia Infection: An Emerging Helminthiasis." Trends in Parasitology 19, no. 8 (2003): 332-35. doi:10.1016/s1471-4922(03)00148-x.

Lüdecke, Daniel. "Ggeffects: Tidy Data Frames of Marginal Effects from Regression Models." Journal of Open Source Software 3, no. 26 (2018): 772. doi:10.21105/joss.00772.

Alexandra Kuznetsova. "Package: Tests in Linear Mixed Effects Models." Journal of Statistical Software 82 (2017).

Faraway, Julian. Multiple Response Multilevel Models. Accessed April 30, 2021. https://people.bath.ac.uk/jjf23/mixchange/multiple.html.
