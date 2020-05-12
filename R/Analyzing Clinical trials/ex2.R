library(blockrand)

#Generate a vector to store treatment labels “A” and “B”
set.seed(123)
arm<-c("A","B")

#Randomly select treatment arm 14 times with the sample function and store in a vector
simple <- sample(arm, 14, replace=TRUE)

#Display the contents of the vector
simple

#Tabulate the numbers assigned to each treatment.
table(simple)


#Use the blockrand function for 14 patients, two arms and block size 2.
set.seed(123)
block2 <- blockrand(n=14, num.levels = 2,  block.prefix='B', block.sizes = c(1,1))

#Display the list.
block2

#Tabulate the numbers per treatment arm.
table(block2$treatment)



#Use block randomization to produce lists of length 100 and random block sizes between 2 and 8.
set.seed(123)
under55 <- blockrand(n= 100, num.levels = 2, block.sizes = c(1,2,3,4), id.prefix='U55', block.prefix='U55',stratum='<55y')
above55 <- blockrand(n= 100, num.levels = 2, block.sizes = c(1,2,3,4), id.prefix='A55', block.prefix='A55',stratum='>=55y')

#Explore the two lists 
head(under55 )
head(above55)

#Tabulate the numbers assigned to each treatment within each strata
table(under55$treatment)
table(above55$treatment)

library(epitools)

#Explore the fact.data using the head function.
head(fact.data)

#Display the numbers with and without infections by supplement combination.
fact.data %>% count(glutamine, selenium, infection)

#Display the numbers and proportions with/without infections for those given glutamine.
fact.data %>% group_by(infection) %>% filter(glutamine=="Yes") %>%
    summarize (n = n()) %>% mutate(prop = n / sum(n))

#Display the numbers and proportions with/without infections for those given selenium.
fact.data %>% group_by(infection) %>% filter(selenium=="Yes") %>%
    summarize (n = n()) %>% mutate(prop = n / sum(n))



#Calculate the effect of glutamine on infection
oddsratio.wald(fact.data$glutamine, fact.data$infection)

#Calculate the effect of selenium on infection
oddsratio.wald(fact.data$selenium, fact.data$infection)

#Equivalence Trials

#Use the head function to explore the relapse.trial dataset
head(relapse.trial)

#Calculate the number of percentages of relapse by treatment group
relapse.trial %>% group_by(Treatment, Relapse) %>% 
    summarize(n = n()) %>% mutate(pct = (n / sum(n))*100)

#Calculate the two-sided 90% confidence interval for the difference
prop.test(table(relapse.trial$Treatment, relapse.trial$Relapse), 
          alternative = "two.sided", conf.level=.9, correct=FALSE)


library(PKNCA)

#pharmacokinetic

#Display the dataset contents
head(PKData)

#Store a numeric version of the concentration variable in plasma.conc.n
PKData$plasma.conc.n <- as.numeric(PKData$plasma.conc)

#Use ggplot to plot the concentration levels against relative time
ggplot(data=PKData, aes(x=rel.time, y= plasma.conc.n)) + 
    geom_line() +
    geom_point() + ggtitle("Individual Concentration Profile") +
    xlab("Time Relative to First Dose, h") + ylab("Plasma Concentration, ng/mL")



#Explore the variable names using the str function
str(PKData)

#Use the summary function to find the max concentration level
summary(PKData$plasma.conc.n)

#Use pk.calc.tmax to find when Cmax occurred, specifying the concentration and time.
pk.calc.tmax(PKData$plasma.conc.n, PKData$rel.time)

#Use pk.calc.auc to estimate AUC between 0.25 and 12hrs.
pk.calc.auc(PKData$plasma.conc.n, PKData$rel.time, interval=c(0.25, 12), method="linear")


#Generate the sample size for delta of 1, with SD of 3 and 80% power.
ss1 <- power.t.test(delta=1, sd=3, power=.8)
ss1

#Round up and display the numbers needed per group
ceiling(ss1$n)

#Use the sample size from above to show that it provides 80% power
power.t.test(n= ceiling(ss1$n), delta=1, sd=3)



#Generate a vector containing values between 0.5 and 2.0, incrementing by 0.25
delta <- seq(0.5, 2.0, 0.25)
npergp <- NULL

#Specify the standard deviation and power
for(i in 1:length(delta)){
    npergp[i] <- ceiling(power.t.test(delta = delta[i], sd = 3, power = 0.8)$n)
}

#Create a data frame from the deltas and sample sizes
sample.sizes <- data.frame(delta, npergp)

#Plot the patients per group against the treatment differences
library(ggplot2)
ggplot(data=sample.sizes, aes(x=delta, y=npergp)) + geom_line() + geom_point() + 
    ggtitle("Sample Size Scenarios") + xlab("Treatment Difference") + ylab("Patients per Group")


#Use the power.prop.test to generate sample sizes for the proportions

"Use the power.prop.test() to calculate the sample size needed for a trial with a recovery 
percentage of 40% and 60% in the placebo and active treatment groups, respectively, and 80% power."


power.prop.test(p1 = 0.4, p2 = 0.6, power = 0.8)

#Find the minimum detectable percentage for the above using 150 patients per group.
power.prop.test(p1 = 0.4, power = 0.8, n = 150)$p2*100

library(samplesize)


