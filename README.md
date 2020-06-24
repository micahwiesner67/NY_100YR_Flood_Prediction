# Predicting 100-year flood volume in NY Rivers

## Introduction
A 100-year flood is defined as having a 1% chance of occurring in any given year. It is of utmost importance to be able to predict the volume of a 100-year flood (called Q100) as this is necessary for understanding the height of the river and in defining flood zones for municipal and insurance purposes. 

## Question
1. Given a dataset of NY rivers and using simple multiple linear regression and random forest decision trees can we make a model to accurately predict the discharge of a 100-year flood on said rivers. 
2. Which parameters will be eliminated using lasso and elastic net regression?

## Dataset
This data and similar data can be downloaded from https://waterdata.usgs.gov/nwis  
194 rivers in New York x 100 explanatory variables  
Some examples of explanatory variables are the area of the watershed going into the river, the peak elevation within the watershed, amount of precipitation for any given month, etc. The dependent variable is Q100 which has been calculated through empirical data. 

## Conclusions
1. Multiple linear regression model (using 10 variables) fits the data with R2 = 0.73
2. Lasso and elastic net regression eliminated all but four variables in our model (Watershed area, elevation, hydrologic disturbance, and flow years measured)

## Next Steps
This model needs to be run with more cross-validation to confirm the above conclusions/

### Note:
This analysis was done in the early stages of understanding R (Fall, 2018) and, thus, I use only base R. I also utilize for-loops and some if-statements (things that are generally ill-advised in R)





