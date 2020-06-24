#Micah Wiesner
#December 2018

#Packages
#### start ####
install.packages('glmnet')
library(glmnet)
#### end ####

peakflow_df <- read.csv("Peak_Flow.csv", sep = ",", header = T, na.strings = c("0", "NA"))

#This dataframe is 194x105 and contains information from NY state creeks and rivers
#Specifically, it has precipitation by month information, area of watershed, lat, long, and more data

View(peakflow_df)
dim(peakflow_df)
str(peakflow_df)

#Split data into training and testing set 
smp_size <- floor(0.75 * nrow(peakflow_df))

## set the seed to make your partition reproducible
set.seed(123)
train_ind <- sample(seq_len(nrow(peakflow_df)), size = smp_size)

train <- peakflow_df[train_ind, ]
test <- peakflow_df[-train_ind, ]

#Split data into numerics and target (dependent variable)
#The variable we want to predict is Q100. Q100 is the height of the river/stream in an extreme
#100 year flood

train_X <- data.frame(train[6:105])
train_Y <- unlist(train[5])

test_X <- data.frame(test[6:105])
test_Y <- unlist(test[5])

store_cor <- vector(mode = 'numeric', length(numeric_df))
name_var <- vector(mode = 'character', length(numeric_df))

for (i in 1:length(train_X)){
  store_cor[i] <- cor(target, train_X[i])^2
  name_var[i] <- colnames(train_X)[i]
  if (i == 100){
    cor_df <- data.frame(name_var, store_cor)
    cor_df <- cor_df[order(cor_df$store_cor, decreasing = T),]
  }
}

#Let's just store the most useful explanatory variables (we define this by higher r^2)
#Let's find the ~10 of the most useful explanatory variables
View(cor_df)

explanatory_variables <- head(cor_df, n = 10)

#We will utilize the the drainage area, max elevation of the basin, and a few other variables in our multiple linear regression

#Multiple Linear Regression with the 10 most predictive 
fit <- lm(Q100 ~ DRAIN_SQKM + ELEV_MAX_M_BASIN +
            ECO3_BAS_DOM + PET + 
            BFI_AVE + FST32F_BASIN + 
            ELEV_MEAN_M_BASIN + ELEV_MEDIAN_M_BASIN +
            LST32F_BASIN + FLOWYRS_1900_2009,
          data = train)

#Now create a function to extract regression coefficents to be able to use with 
#testing dataset

#sourced from 
#https://stackoverflow.com/questions/31770729/r-automate-extraction-of-linear-regression-equation-from-lm

regEq <- function(lmObj, dig) {
  paste0("y = ",
         paste0(
           c(round(lmObj$coef[1], dig), round(sign(lmObj$coef[-1])*lmObj$coef[-1], dig)),
           c("", rep("*", length(lmObj$coef)-1)),
           paste0(c("", names(lmObj$coef)[-1]), c(ifelse(sign(lmObj$coef)[-1]==1," + "," - "), "")),
           collapse=""
         )
  )
}

eq <- regEq(fit, 1)

#I was having trouble with the predict function and so I am just hard-coding the below equation
model_Y <- 286524.2 + 9.3*test_X$DRAIN_SQKM - 2.1*test_X$ELEV_MAX_M_BASIN - 
    290.1*test_X$ECO3_BAS_DOM - 30.4*test_X$PET - 448*test_X$BFI_AVE - 
    362.3*test_X$FST32F_BASIN + 192.7*test_X$ELEV_MEAN_M_BASIN - 
    165.6*test_X$ELEV_MEDIAN_M_BASIN - 1001.5*test_X$LST32F_BASIN + 116.3*test_X$FLOWYRS_1900_2009

xx <- yy <- seq(0,200000) 
cor_MLR <- round(cor(model_Y, test_Y)^2,2)

plot.new()
par(mfrow = c(1,2))
plot(model_Y, test_Y, main = 'MLR Comparison', 
     xlab = 'Model', ylab = 'Actual (Testing Set)',
     text(100000, 175000, paste('R2 =', cor_MLR)))
lines(xx, yy, lty = 2)

my_residuals <- model_Y - test_Y
RMS_MLR <- round(sum(abs(my_residuals)))

hist(my_residuals, main = 'Testing for Normalcy',
     xlab = 'Residuals', col = 'lavender')


