machine-learning-with-caret-in-r
================
Mburu
3/23/2020

## In-sample RMSE for linear regression on diamonds

As you saw in the video, included in the course is the diamonds dataset,
which is a classic dataset from the ggplot2 package. The dataset
contains physical attributes of diamonds as well as the price they sold
for. One interesting modeling challenge is predicting diamond price
based on their attributes using something like a linear regression.
Recall that to fit a linear regression, you use the lm() function in the
following format: mod \<- lm(y \~ x, my\_data) To make predictions using
mod on the original data, you call the predict() function: pred \<-
predict(mod, my\_data)

``` r
library(tidyverse)
library(caret)
# Fit lm model: model

model <- lm(price ~., data = diamonds)
# Predict on full data: p

p <- predict(model, data = diamonds)
# Compute errors: error

error <- p - diamonds$price
# Calculate RMSE
sqrt(mean(error ^ 2))
```

    ## [1] 1129.843

``` r
plot(pressure)
```

![](machine_learning_with_caret_in_r_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->
