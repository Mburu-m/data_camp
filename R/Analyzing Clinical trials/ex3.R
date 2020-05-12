

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
#Re-familiarize yourself with the powerTOSTtwo.prop() function
?powerTOSTtwo.prop()

#Find the sample size  per group for expected rates of 60%, 4% delta, 90% power and 5% significance level.
powerTOSTtwo.prop(alpha = .05, statistical_power = .9, prop1 = .6, prop2 = .6, low_eqbound_prop = -0.04, high_eqbound_prop = 0.04)

#Find the power if the above trial is limited to 2500 per group
powerTOSTtwo.prop(alpha = .05, N=2500, prop1 =.6, prop2 =.6, low_eqbound_prop = -0.04, high_eqbound_prop = 0.04)

#Find the sample size for a standard deviation of 10, delta of 2, 80% power and 5% significance level.
powerTOSTtwo.raw(alpha=0.05, statistical_power= .80, sdpooled=10, low_eqbound=-2, high_eqbound=2)

#Find the sample sizes based on standard deviations between 7 and 13.
stdev <- seq(7, 13, 1)
npergp <- NULL
for(i in 1:length(stdev)){
    npergp[i] <- ceiling(powerTOSTtwo.raw(alpha=0.05, statistical_power=.80, sdpooled=stdev[i], low_eqbound=-2, high_eqbound=2))
}
sample.sizes <- data.frame(stdev, npergp)

#Plot npergp against stdev
ggplot(data=sample.sizes, aes(x=stdev, y=npergp)) +   geom_line()+
    geom_point()+ ggtitle("Equivalence Sample Size Scenarios") +
    xlab("Standard Deviation") + ylab("Patients per Group")


#Tabulate the age group variable to view the categories
table(Acupuncture$age.group)

#Display the adjusted significance level
0.05/4

#Run the Wilcoxon Rank Sum test in each of the age subgroups
age <- c("18-34", "35-44", "45-54", "55-65")
for(group in age){
    subgroup <- tidy(wilcox.test(total.days.sick ~ treatment.group, 
                                 data = subset(Acupuncture, age.group==group), 
                                 exact=FALSE))
    print(group)
    print(subgroup)
}