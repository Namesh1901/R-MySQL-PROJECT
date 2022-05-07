#LINEAR REGRESSION MODEL
#reading data and preprocessing
tab<-read.csv(file="FINAL_DATSET.csv",sep=",",stringsAsFactors = TRUE)
remove<-c(20,21)
tab<-tab[,-remove]
sample_index<-sample(1:nrow(tab),round(0.75*nrow(tab)))

#spliting data for linear regression
train_dat<-tab[sample_index,]
test_dat<-tab[-sample_index,]
model1<-lm(PRECIPITATION~Brazilian_regions,data=test_dat)
summary(model)

#fitting regression model
model<-lm(PRECIPITATION~Atmospheric_pressure_station+
          Maximum_air_pressure+
          Minimum_air_pressure+Solar_radiation+Air_temperature+ Dew_poin_temperature+Maximum_temperature_las_hou + 
          Minimum_temperature_las_hou + 
          Maximum_dew_poin_temperature + 
          Minimum_dew_poin_temperature+ 
          Maximum_relative_humid_temp_las_hou+ 
          Minimum_relative_humid_temp_las_hou+Relative_humid+Wind_direction+Wind_gust+Wind_speed+Latitude+Longitude+Elevation,data=train_dat)
#prediction and plotting
#random sampling
random_test<-test_dat[sample(1:nrow(test_dat),1,replace=FALSE),]
result_L_REGRESSION<-predict(model,random_test)
if(result_L_REGRESSION<0){
  result_L_REGRESSION=0
}
result_L_REGRESSION



library(ggplot2)

ggplot(tab, aes(y = PRECIPITATION, x = Solar_radiation, color =Station)) +
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE) +
  ggtitle("y vs solar_radiation")

#CONTINOUS NEURAL NET MODEL
#using neuralnet to prediction precipation 
set.seed(500)
library(nnet)
library(neuralnet)
library(MASS)
remove2<-c(18,19)
nntab<-cbind(tab[,-remove2],class.ind(as.factor(tab$Brazilian_regions)),class.ind(as.factor(tab$State)))



#normalize data
maxi<-apply(nntab,2,max)
mini<-apply(nntab,2,min)
scaled_data<-as.data.frame(scale(nntab,center=mini,scale=maxi-mini))
#split data into training set and test set
sample_index<-sample(1:nrow(nntab),round(0.75*nrow(nntab)))
train_dat<-scaled_data[sample_index,]
test_dat<-scaled_data[-sample_index,]

neuralmodel<-neuralnet(PRECIPITATION~Atmospheric_pressure_station+
                         Maximum_air_pressure+
                         Minimum_air_pressure+Solar_radiation+Air_temperature+ Dew_poin_temperature+Maximum_temperature_las_hou + 
                         Minimum_temperature_las_hou + 
                         Maximum_dew_poin_temperature + 
                         Minimum_dew_poin_temperature+ 
                         Maximum_relative_humid_temp_las_hou+ 
                         Minimum_relative_humid_temp_las_hou+Relative_humid+Wind_direction+Wind_gust+Wind_speed+Latitude+Longitude+Elevation+CO+N+S+AM+DF+MS+RS,hidden=c(8,6),data=train_dat)
plot(neuralmodel)
#prediction using neuralmodel
pr.neuralmodel<-compute(neuralmodel,test_dat[,2:27])
#Denormalize test and predicted result
pr.neuralmodel<-pr.neuralmodel$net.result*(max(nntab$PRECIPITATION) - min(nntab$PRECIPITATION)) + min(nntab$PRECIPITATION)
test.r <- (test_dat$PRECIPITATION) *(max(nntab$PRECIPITATION) - min(nntab$PRECIPITATION)) + min(nntab$PRECIPITATION)
#calculate mse error
MSE.nn <- sum((test.r - pr.neuralmodel)^2) / nrow(test_dat)

#LOGISTIC NEURAL MODEL

neuralmodel_LOG<-neuralnet(CO+N+S~PRECIPITATION+Atmospheric_pressure_station+
                         Maximum_air_pressure+
                         Minimum_air_pressure+Solar_radiation+Air_temperature+ Dew_poin_temperature+Maximum_temperature_las_hou + 
                         Minimum_temperature_las_hou + 
                         Maximum_dew_poin_temperature + 
                         Minimum_dew_poin_temperature+ 
                         Maximum_relative_humid_temp_las_hou+ 
                         Minimum_relative_humid_temp_las_hou+Relative_humid+Wind_direction+Wind_gust+Wind_speed+Latitude+Longitude+Elevation+AM+DF+MS+RS,hidden=c(8,6),act.fct="logistic",linear.output=FALSE,data=train_dat,lifesign = "minimal")

#prediction using neuralmodel
pr.neuralmodel_LOG<-compute(neuralmodel_LOG,test_dat[,-c(21,22,23)])
# Extract results
pr.neuralmodel_LOG <- pr.neuralmodel_LOG$net.result
head(pr.neuralmodel_LOG)


original_values <- test_dat[,c(21,22,23)]
pr.nn_2 <-round(pr.neuralmodel_LOG)
ind<-rownames(original_values)
mean(original_values[ind,]==pr.nn_2[ind,])



# Set seed for reproducibility purposes
set.seed(500)
# 10 fold cross validation
k <- 10
# Results from cv
outs <- NULL

for(i in 1:k)
{
  index <- sample(1:nrow(nntab), round(0.90*nrow(nntab)))
  train_cv <- nntab[index, ]
  test_cv <- nntab[-index, ]
  nn_cv <- neuralnet(CO+N+S~PRECIPITATION+Atmospheric_pressure_station+
                       Maximum_air_pressure+
                       Minimum_air_pressure+Solar_radiation+Air_temperature+ Dew_poin_temperature+Maximum_temperature_las_hou + 
                       Minimum_temperature_las_hou + 
                       Maximum_dew_poin_temperature + 
                       Minimum_dew_poin_temperature+ 
                       Maximum_relative_humid_temp_las_hou+ 
                       Minimum_relative_humid_temp_las_hou+Relative_humid+Wind_direction+Wind_gust+Wind_speed+Latitude+Longitude+Elevation+AM+DF+MS+RS,hidden=c(8,6),act.fct="logistic",linear.output=FALSE,data=train_cv,lifesign = "minimal")
  
                     
  
  #prediction using neuralmodel
  pr.nn_log<-compute(nn_cv,test_cv[,-c(21,22,23)])
  # Extract results
  pr.nn_log <- pr.nn_log$net.result
  head(pr.nn_log)
  
  
  original_values2 <- test_cv[,c(21,22,23)]
  pr.nn_3 <-round(pr.nn_log)
  ind<-rownames(original_values2)
  mean(original_values2[ind,]==pr.nn_3[ind,])
  outs<-mean(pr.nn_3 == original_values2)
}
mean(outs)