
library(tidyverse)
Acupuncture <- read_csv("acupuncture.csv")
#Generate summaries of the variables by treatment group and save results as baselines
baselines <- compareGroups(treatment.group ~ score.baseline + age + sex, data = Acupuncture)

#Use the createTable function to display the results saved in baselines
baseline.table <- createTable(baselines, show.ratio = FALSE, show.p.overall=FALSE)

#Display the created summary table
baseline.table


#Generate a variable for the change from baseline at 12 months
Acupuncture$diff.month12 <- Acupuncture$score.month12 - Acupuncture$score.baseline

#Use the NEW variable to generate the percentage change from baseline at 12 months
Acupuncture$pct.month12 <- Acupuncture$diff.month12/Acupuncture$score.baseline*100

#Generate a histogram for percentage change from baseline within each treatment group
ggplot(data=Acupuncture, aes(x=pct.month12)) + 
    geom_histogram(fill="white", color="black") + facet_wrap( ~ treatment.group) +
    xlab("Percentage Change from Baseline at Month 12")



Acupuncture %>% 
    # Filter for rows where pct.months12 is not missing
    filter(!is.na(pct.month12)) %>%
    # Generate a binary response variable as a factor
    mutate(
        resp35.month12 = factor(
            # Use the condition pct.month12 less than -35
            ifelse(pct.month12 < -35, "greater than 35%", "less than or eq to 35%")
        )
    ) %>%
    # Count the values of resp35.month12
    count(resp35.month12) %>%
    mutate(pct = 100 * n / sum(n)) 



Acupuncture <- Acupuncture %>% 
    mutate(
        # Dichotomize the variable for complementary therapist visits
        any.therap.visits = factor(
            # Check for zero visits
            ifelse(total.therap.visits == 0, "Did not visit CT", "Visited CT")
        ),
        # Generate a combined binary endpoint for having any professional visits
        combined = factor(
            ifelse(
                # Check for not visiting complementary therapist
                any.therap.visits == "Did not visit CT" & 
                    # ... and not visiting GP
                    any.gp.visits == "Did not visit GP" & 
                    # ... and not visiting specialist
                    any.spec.visits== "Did not visit specialist",
                "No visits", 
                "At least one visit"
            ),
            levels = c("No visits", "At least one visit")
        )
    )

data(package = "HSAUR")
# Tabulate the new composite endpoint
table(Acupuncture$combined,  useNA = "ifany")


##

#Perform the t-test, assuming the variances are equal in the treatment groups
t.test(pct.month12~ treatment.group, var.equal= TRUE, data = Acupuncture)



ggplot(data=Acupuncture, aes(x=treatment.group, y= total.days.sick)) + 
    geom_boxplot(fill="white", color="black") +
    ylab("Total days off sick") +  xlab("Treatment group")

#Use the Wilcoxon Rank Sum test to compare the two distributions.
wilcox.test(total.days.sick~ treatment.group, data= Acupuncture)

#Use the compareGroups function to save a summary of the results in pct.month12.test
pct.month12.test <- compareGroups(treatment.group ~ pct.month12 , data = Acupuncture)



###

#Perform the test of proportions on resp35.month12 by treatment.group.
prop.test(table(Acupuncture$treatment.group, Acupuncture$resp35.month12), correct=FALSE)

#Use the tidy function to store and display a summary of the test results.
resp35.month12.test <- tidy(prop.test(table(Acupuncture$treatment.group, Acupuncture$resp35.month12), correct=FALSE))
resp35.month12.test

#Calculate the treatment difference
resp35.month12.test$estimate1 - resp35.month12.test$estimate2





#Use the createTable function to summarize and store the results saved in pct.month12.test.
pct.month12.table <- createTable(pct.month12.test, show.ratio = FALSE, show.p.overall=TRUE)

#Display the results of pct.month12.table
pct.month12.table