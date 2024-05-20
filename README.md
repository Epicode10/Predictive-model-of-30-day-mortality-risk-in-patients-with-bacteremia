# Predictive model of 30-day mortality risk in patients with bacteremia
The model was conducted by random forest to predict 30-day mortality risk in patients with community-onset bacteremia. The performance of this model showed ROC AUC: 0.896; Brier score: 9.0; Accuracy: 0.883; Recall: 0.989; Precision: 0.886; F1 score: 0.934.
The manuscript has been submitted: "An interpretable machine learning approach to evaluate 30-day mortality risk in patients with community-onset bacteremia".

# Usage
See "Execute_prediction.R" for an example of how to run this model.
### Execute_prediction.R:
```diff
library(ranger)

################################
# folder
################################


folder_path <- "~/folder/"


################################
# import model
################################


load(paste(folder_path, "predictive_model(version 1).RData", sep = ""))
load(paste(folder_path, "predictive_prob_model(version 1).RData", sep = ""))


################################
# data format
################################

format_data <- read.csv(paste(folder_path, "format_data.csv", sep=""))
format_type <- read.csv(paste(folder_path, "format_type.csv", sep=""))

format_type <- format_type[format_type$var_columns != "X_30daymortality",]
factor_columns <- format_type[format_type$factor_columns==1, c("var_columns")]
num_columns <- format_type[format_type$factor_columns==0, c("var_columns")]

################################
# import testing data
################################

test_data <- read.csv(paste(folder_path, "test_data.csv", sep=""))

test_data$data <- 1
format_data$data <- 0

format_data <- rbind(format_data, test_data)

format_data[,factor_columns] <- lapply(format_data[,factor_columns], factor)
format_data[,num_columns] <- lapply(format_data[,num_columns], as.numeric)

test_data <- format_data[format_data$data==1,]
test_data$data <- NULL


################################
# prediction
################################

pred<- predict(model.fit, data = test_data, type = "response")
pred_class <- pred$predictions
pred_class <- as.character(pred_class)


pred <- predict(model.fit.prob, data = test_data, type = "response")
pred_prob <- pred$predictions



################################
# print 
################################

cat("", "\n")
cat("=========================================", "\n")
cat("", "\n")

if(pred_class == "0"){
  cat("Report     :", "Negative", "\n")
}else{
  cat("Report     : ", "Positive", "\n")
}

cat("Probability:", round(pred_prob[1,2],2))

cat("", "\n")

```

# Dependencies
R package: ranger >= 0.13.1
# Papers
Chien-Chou Su, Ju-Ling Chen, Tzu-Hao Shan, Ching-Chi Lee, Chun-Te Li, Wen-Liang Lin, Ching-Lan Cheng. *An interpretable machine learning approach to evaluate 30-day mortality risk in patients with community-onset bacteremia* (2024; submission)

