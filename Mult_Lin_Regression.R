#Micah Wiesner
#December 2018

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

numeric_df <- data.frame(train[6:105])
target <- unlist(train[5])

store_cor <- vector(mode = 'numeric', length(numeric_df))
name_var <- vector(mode = 'character', length(numeric_df))

for (i in 1:length(numeric_df)){
  store_cor[i] <- cor(target, numeric_df[i])^2
  name_var[i] <- colnames(numeric_df)[i]
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
keep_cols <- explanatory_variables$name_var
  
explan_vars_df <- data.frame(numeric_df[ , keep_cols])
final_df <- data.frame(target, explan_vars_df)

fit <- lm(target ~ explan_vars_df$DRAIN_SQKM + explan_vars_df$ELEV_MAX_M_BASIN +
     explan_vars_df$ECO3_BAS_DOM + explan_vars_df$PET + 
     explan_vars_df$BFI_AVE + explan_vars_df$FST32F_BASIN + 
     explan_vars_df$ELEV_MEAN_M_BASIN + explan_vars_df$ELEV_MEDIAN_M_BASIN +
     explan_vars_df$LST32F_BASIN + explan_vars_df$FLOWYRS_1900_2009
     )

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

explan_vars_df <- test 

model_results <- eval(formula(regEq(fit,1)))
actual_results <- test$Q100

xx <- yy <- seq(0,200000) 
summary(fit)

plot.new()
par(mfrow = c(1,2))
plot(model_results, actual_results, main = 'Model Comparison', 
     xlab = 'Model', ylab = 'Actual (Testing Set)',
     text(100000, 175000, 'R2 = 0.597'))
lines(xx, yy, lty = 2)

my_residuals <- model_results - actual_results
hist(my_residuals, main = 'Testing for Normalcy',
     xlab = 'Residuals', col = 'lavender')
