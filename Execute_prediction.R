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


