#Micah Wiesner
#Dec 2018

#Here I will be using elastic net, ridge, and lasso regression to improve upon the Multiple Linear Regression model

#Fit a lasso model
set.seed(123)
lasso_model <- cv.glmnet(as.matrix(train_X), train_Y, lambda = 10^seq(4,-1,-.1), alpha = 1)

best_lambda <- lasso_model$lambda.1se
lasso_coeff <- lasso_model$glmnet.fit$beta[, lasso_model$glmnet.fit$lambda == best_lambda]
#alpha sets degree of mixing between the two models
#alpha = 1 is lasso, alpha = 0 is ridge, alpha in between is elastic net

#Meanwhile, 𝜆 is the shrinkage parameter: when 𝜆=0, no shrinkage is performed
#and as 𝜆 increases, the coefficients are shrunk ever more strongly.
#This happens regardless of the value of 𝛼.

#Fit elastic net model
set.seed(123)
elastic_net_model <- cv.glmnet(as.matrix(train_X), train_Y, lambda = 10^seq(4,-1,-.1), alpha = 0.5)

best_lambda <- elastic_net_model$lambda.1se
elastic_net_coeff <- elastic_net_model$glmnet.fit$beta[, elastic_net_model$glmnet.fit$lambda == best_lambda]

#Fit Ridge Regression model
set.seed(123)
ridge_model <- cv.glmnet(as.matrix(train_X), train_Y, lambda = 10^seq(4,-1,-.1), alpha = 0)

best_lambda <- ridge_model$lambda.1se
ridge_coeff <- ridge_model$glmnet.fit$beta[, ridge_model$glmnet.fit$lambda == best_lambda]

#Plot and compare
plot.new()
par(mfrow = c(3,1))
plot(elastic_net_model, main = 'Lasso regression')
plot(lasso_model, main = 'Elastic net regression')
plot(ridge_model, main = 'Ridge regression')

coef <- data.frame(
  lasso = lasso_coeff,
  elastic_net = elastic_net_coeff,
  ridge = ridge_coeff)

lasso_vars <- lasso_coeff[lasso_coeff > 0]
elastic_net_vars <- elastic_net_coeff[lasso_coeff > 0]

#Cross Validation
#The resampling method: "boot", "boot632", "optimism_boot", "boot_all", "cv", "repeatedcv", "LOOCV", "LGOCV" (for repeated training/test splits), 
#"none" (only fits one model to the entire training set), 
#"oob" (only for random forest, bagged trees, bagged earth, bagged flexible discriminant analysis, or conditional tree forest models), timeslice, 
#"adaptive_cv", "adaptive_boot" or "adaptive_LGOCV"

#Predict each model
lasso_pred <- as.matrix(cbind(const = 1, test_X)) %*% coef(lasso_model)
ridge_pred <- as.matrix(cbind(const = 1, test_X)) %*% coef(ridge_model)
elastic_net_pred <- as.matrix(cbind(const = 1, test_X)) %*% coef(elastic_net_model)

#%*% matrix multiplication in R
lasso_cor <- cor(test_Y, lasso_pred[,1])^2
ridge_cor <- cor(test_Y, ridge_pred[,1])^2
elastic_net_cor <- cor(test_Y, elastic_net_pred[,1] )^2

plot.new()
par(mfrow = c(1,1))
plot(test_Y, model_Y, main = 'Model Comparison', 
     xlab = 'Actual (Testing Set)', ylab = 'Model') 
lines(xx, yy, lty = 2)
points(test_Y, lasso_pred[,1], col = 'black', pch = 21, bg = 'darkgreen')
points(test_Y, ridge_pred[,1], col = 'black', pch = 21, bg = 'darkred')
points(test_Y, elastic_net_pred[,1], col = 'black', pch = 21, bg = 'blue')
legend(25000, 200000, legend = c("Lasso", "Ridge", "Elastic Net", "Simple"),
      col = c("black"), pch = 21,
      pt.bg = c("darkgreen","darkred", 'blue', 'white'))

RMS_Lasso <- round(sum(abs(test_Y - lasso_pred[,1])))
RMS_Ridge <- round(sum(abs(test_Y - ridge_pred[,1])))
RMS_EN <- round(sum(abs(test_Y - elastic_net_pred[,1])))
