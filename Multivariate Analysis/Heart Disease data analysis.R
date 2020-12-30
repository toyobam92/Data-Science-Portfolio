

library(kableExtra)
#Data Summary
heart_data <- read.csv("heart_failure_clinical_records_dataset.csv")
head(heart_data)
str(heart_data)

#check for NA values 
head(is.na(heart_data))%>%
  kbl(caption = "Glimpse of NA values check " ,
      col.names = c("age", "anaemia", "creatinine phosphokinase", "diabetes","ejection  fraction",
                    "high blood pressure","platelets","serum creatinine", "serum sodium",
                    "sex","smoking", "time", "death event")) %>%
  kable_classic(full_width = F, html_font = "Cambria")

#sum of NA values 
sum(is.na(heart_data))

#check for head values 
head(heart_data) %>%
  kbl(caption = "Glimpse of Heart Disease Data" , 
      col.names = c("age", "anaemia", "creatinine phosphokinase", "diabetes","ejection  fraction",
                    "high blood pressure","platelets","serum creatinine", "serum sodium",
                    "sex","smoking", "time", "death event")) %>%
  kable_classic(full_width = F, html_font = "Cambria")


#Glimpse of data 
table(str(heart_data)) %>%
  kbl(caption = "Glimpse of Heart Disease Data", centering = TRUE ) %>%
  kable_classic(full_width = F, html_font = "Cambria")


#Correspondence Analysis
library(funModeling) 
library(tidyverse) 
library(Hmisc)


attach(heart_data)

#subset data
heart_data$heart_failure <-factor(heart_data$DEATH_EVENT,c(0,1),labels=c('Survived','Died'))
heart_data$anaemia_cat <-factor(heart_data$anaemia,c(0,1),labels=c('False','True'))
heart_data$diabetes_cat <-factor(heart_data$diabetes,c(0,1),labels=c('False','True'))
heart_data$high_blood_pressure_cat <-factor(heart_data$high_blood_pressure,c(0,1),labels=c('False','True'))
heart_data$sex_cat <-factor(heart_data$sex,c(0,1),labels=c('Female','Male'))
heart_data$smoking_cat <-factor(heart_data$smoking,c(0,1),labels=c('False','True'))


SurT<-table(heart_data$heart_failure)
sur_t <- data.frame(addmargins(SurT)) %>%
  kbl(col.names = c("Heart Failure", "Freq"))%>%
  kable_classic(full_width = F, html_font = "Cambria")
print(sur_t)


Anaemia_T <- table(heart_data$anaemia_cat)
ana_t <- data.frame(addmargins(Anaemia_T )) %>%
  kbl(col.names = c("Anaemia", "Freq"))%>%
  kable_classic(full_width = F, html_font = "Cambria")
print(ana_t)


Diabetes_T <- table(heart_data$diabetes_cat)
dia_t <- data.frame(addmargins(Diabetes_T)) %>%
  kbl(col.names = c("Diabetes", "Freq"))%>%
  kable_classic(full_width = F, html_font = "Cambria")
print(dia_t)

cat("High Blood Pressure")
HBP_T <- table(heart_data$high_blood_pressure_cat)
HBP_t <- data.frame(addmargins(HBP_T)) %>%
  kbl(col.names = c("High Blood Pressure", "Freq"))%>%
  kable_classic(full_width = F, html_font = "Cambria")
print(HBP_t)

cat("Sex")
Sex_T <- table(heart_data$sex_cat)
sex_t <- data.frame(addmargins(Sex_T)) %>%
  kbl(col.names = c("Sex", "Freq"))%>%
  kable_classic(full_width = F, html_font = "Cambria")
print(sex_t)

cat("Smoking")

Smoking_T <- table(heart_data$smoking_cat)
smoke_T <- data.frame(addmargins(Smoking_T)) %>%
  kbl(col.names = c("Smoking", "Freq"))%>%
  kable_classic(full_width = F, html_font = "Cambria")



##########################################################
Anaemia_T2 <- table(heart_data$heart_failure,heart_data$anaemia_cat)
#addmargins(Anaemia_T2)
(addmargins(round(prop.table(Anaemia_T2),digits=2))) %>%
  kbl(col.names = c("Anaemia", "Freq", "Sum"))%>%
  kable_classic(full_width = F, html_font = "Cambria")

Diabetes_T2 <- table(heart_data$heart_failure,heart_data$diabetes_cat)
#addmargins(Diabetes_T2)
cat("Diabetes")

(addmargins(round(prop.table(Diabetes_T2),digits=2))) %>%
  kbl(col.names = c("Diabetes", "Freq", "Sum"))%>%
  kable_classic(full_width = F, html_font = "Cambria")

HBP_T2 <- table(heart_data$heart_failure,heart_data$high_blood_pressure_cat)
#addmargins(HBP_T2)
cat("High Blood Pressure")
(addmargins(round(prop.table(HBP_T2),digits=2))) %>%
  kbl(col.names = c("Diabetes", "Freq", "Sum"))%>%
  kable_classic(full_width = F, html_font = "Cambria")

#addmargins(Sex_T2)
Sex_T2 <- table(heart_data$heart_failure,heart_data$sex_cat)
(addmargins(round(prop.table(Sex_T2),digits=2))) %>%
  kbl(col.names = c("Diabetes", "Freq", "Sum"))%>%
  kable_classic(full_width = F, html_font = "Cambria")

Smoking_T2 <- table(heart_data$heart_failure,heart_data$smoking_cat)
(addmargins(round(prop.table(Smoking_T2), digits=2))) %>%
  kbl(col.names = c("Diabetes", "Freq", "Sum"))%>%
  kable_classic(full_width = F, html_font = "Cambria")
#addmargins(Smoking_T2)
cat("Smoking")
addmargins(round(prop.table(Smoking_T2),digits=2))



#Barplot
par(mfrow=c(2, 3))
barplot(prop.table(Anaemia_T2,2)*100, xlab='Anaemic Records',ylab ='Percentages',main="Percentage survival by anaemic records",beside=T,col=c("darkblue","lightcyan"),
        legend=rownames(Anaemia_T2), args.legend = list(x = "bottomright", cex = 0.7), cex.main =0.8)


barplot(prop.table(Diabetes_T2,2)*100, xlab='Diabetes Records',ylab ='Percentages',main="Percentage survival by diabetes records",beside=T,col=c("darkblue","lightcyan"),
        legend=rownames(Diabetes_T2), args.legend = list(x = "bottomright", cex = 0.7), cex.main =0.8)

barplot(prop.table(HBP_T2 ,2)*100, xlab='High Blood Pressure Records',ylab ='Percentages',main="Percentage survival by high blood pressure records",beside=T,col=c("darkblue","lightcyan"),
        legend=rownames(HBP_T2), args.legend = list(x = "bottomright", cex = 0.7), cex.main =0.8)

barplot(prop.table(Sex_T2 ,2)*100, xlab='Sex', ylab ='Percentages', main="Percentage survival by Sex",beside=T,col=c("darkblue","lightcyan"),
        legend=rownames(Sex_T2), args.legend = list(x = "bottomright", cex = 0.7), cex.main =0.8)

barplot(prop.table(Smoking_T2 ,2)*100, xlab='Smoking', ylab ='Percentages', main="Percentage survival by Smoking records",beside=T,col=c("darkblue","lightcyan"),
        legend=rownames(Smoking_T2), args.legend = list(x = "bottomright", cex = 0.7), cex.main =0.8)


#

py_install("pandas")
sns <- import('seaborn')
plt <- import('matplotlib.pyplot')
pd <- import('pandas')
library(seaborn)

#categorical vs continuous 
categoricall_data <- heart_data %>% select(anaemia,diabetes,high_blood_pressure,sex,smoking,DEATH_EVENT)
plot_num(continous_data)

continous_data <- select(heart_data, -c(anaemia,diabetes,high_blood_pressure,sex, smoking,DEATH_EVENT,heart_failure,anaemia_cat,diabetes_cat,high_blood_pressure_cat,sex_cat,smoking_cat))

sns$pairplot(r_to_py(continous_data ), hue = 'DEATH_EVENT')
#display the plot
plt$show()

#continous data 
con_dat <- select(heart_data, -c(anaemia,diabetes,high_blood_pressure,sex, smoking,heart_failure,anaemia_cat,diabetes_cat,high_blood_pressure_cat,sex_cat,smoking_cat))

con_data <- continous_data

con_data$Colour="black" # Set new column values to appropriate colours b
con_data$Colour[con_dat$DEATH_EVENT== "0"]="blue" 
con_data$Colour[con_dat$DEATH_EVENT== "1"]="red"

sns$pairplot(r_to_py(con_data))
#display the plot
plt$show()


pairs(con_dat, pch = 18, oma=c(3,3,3,15),
      col = con_data$Colour,
      lower.panel=NULL, main = "Pairplot of continous data")
legend("topright", fill = unique(con_data$Colour), legend = c("Died", "Survived"), cex = 0.5)

#continous survived vs died
survived = heart_data[heart_data$DEATH_EVENT == 0, ] 
died = heart_data[heart_data$DEATH_EVENT == 1, ]

con_surv <- select(survived, -c(anaemia,diabetes,high_blood_pressure,sex, smoking,heart_failure,anaemia_cat,diabetes_cat,high_blood_pressure_cat,sex_cat,smoking_cat))

con_die <- select(died, -c(anaemia,diabetes,high_blood_pressure,sex, smoking,heart_failure,anaemia_cat,diabetes_cat,high_blood_pressure_cat,sex_cat,smoking_cat))

cat_surv <- select(survived, c(anaemia,diabetes,high_blood_pressure,sex, smoking))
cat_die <- select(died, c(anaemia,diabetes,high_blood_pressure,sex, smoking))
#continous
cont_survived = con_surv[con_surv$DEATH_EVENT == 0, ] 
cont_died = con_die[con_die$DEATH_EVENT == 1, ]

sur <- cont_died %>% select(age:time)
die <- cont_survived %>% select(age:time)

#Quantitative analysis  of continuous data 
#full continuous data quantitative
full_data <- profiling_num(continous_data)
f_d <- select(full_data, variable, mean,std_dev,range_98,skewness)

#survived data quantitative
survived_data <- profiling_num(sur)
s_d <- select(survived_data, mean,std_dev,range_98,skewness)
colnames(s_d) <- c("sur_mean", "sur_std_dev","sur_range_98","sur_skewness")

#died data 
died_data <- profiling_num(die)
d_d <- select(died_data, mean,std_dev,range_98,skewness)
colnames(d_d) <- c("die_mean", "die_std_dev","die_range_98","die_skewness")

#full vs survived, died 
stats <- cbind(f_d,s_d,d_d)
cat("stats for continous data")

colnames(data.frame(stats))
data.frame(stats) %>%
  kbl(caption = "Quantitative details of continuous heart disease data", col.names = c ("variable","mean", "std_dev", "range_98", "skewness" ,"mean", "std_dev", "range_98", "skewness" ,
                                                                                        "mean", "std_dev", "range_98", "skewness"))%>%
  kable_classic(full_width = F, html_font = "Cambria")  %>%
  add_header_above(c(" ", "Total heart disease data " = 4, "Survived data " = 4, "Died Data" = 4))


#CORRELATION PLOT
library(corrplot)
library(RColorBrewer)

cat("Full dataset")
xy <-cor(select(heart_data, age:DEATH_EVENT))
colnames(xy) <- c("age", "anaemia","creatinine_pho","diabetes","ejection_frac","hbp","platelets",
                  "serum_cre", "serum_sodium", "sex","smoking","time","death_event")
rownames(xy) <- c("age", "anaemia","creatinine_pho","diabetes","ejection_frac","hbp","platelets",
                  "serum_cre", "serum_sodium", "sex","smoking","time","death_event")

corrplot(xy, method = "number", number.cex = 0.7,type = "lower", order = "hclust", col = brewer.pal(n = 7, name = "RdBu"))
corrplot(xy, method = "number", number.cex = 0.5,type = "lower", order = "hclust", col = brewer.pal(n = 7, name = "RdBu"))
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(xy, method = "color", col = col(200),
         type = "lower", order = "hclust", number.cex = .7,
         addCoef.col = "black", # Add coefficient of correlation
         tl.col = "black", tl.srt = 90, # Text label color and rotation
         diag = FALSE)

#continous data 
cat("continous data survived")
corrplot(cor(sur), method = "number", number.cex = 0.5,type = "lower", order = "hclust", col = brewer.pal(n =, name = "RdBu"))
cat("continous data died")
corrplot(cor(die), method = "number", number.cex = 0.5,type = "lower", order = "hclust", col = brewer.pal(n = 8, name = "RdBu"))
?corrplot
#categorical data
cat("categorical data survived")
corrplot(cor(cat_surv), method = "number", number.cex = 0.5,type = "lower", order = "hclust", col = brewer.pal(n = 8, name = "RdBu"))
cat("categorical data died")
corrplot(cor(cat_die), method = "number", number.cex = 0.5,type = "lower", order = "hclust", col = brewer.pal(n = 8, name = "RdBu"))


#OVERALL PLOT
par(mfrow=c(2, 3))
plot_num(heart_data) 
plot_num(categoricall_data)
#continous data
par(mfrow=c(2, 3))
plot_num(sur)
plot_num(die)
plot_num(cat_surv)
plot_num(cat_die)


#BOXPLOT
boxplot(heart_data$creatinine_phosphokinase ~ heart_data$heart_failure,
        main="Heart Failure by Creatinine Phosphokinase  Records",
        ylab="creatinine_phosphokinase",xlab="Heart failure", horizontal = TRUE)

boxplot(heart_data$ejection_fraction ~ heart_data$heart_failure,
        main="Heart Failure by Ejection Fraction Records",
        ylab="Ejection Fraction",xlab="Heart failure", horizontal = TRUE)

boxplot(heart_data$platelets ~ heart_data$heart_failure,
        main="Heart Failure by Platelets Records ",
        ylab="Platelets",xlab="Heart failure", horizontal = TRUE)

boxplot(heart_data$serum_creatinine ~ heart_data$heart_failure,
        main="Heart Failure by Serum Creatinine Records",
        ylab="serum_creatinine",xlab="Heart failure", horizontal = TRUE)

boxplot(heart_data$age ~ heart_data$heart_failure,
        main="Heart Failure by Age",
        ylab="age",xlab="Heart failure",horizontal = TRUE)

boxplot(heart_data$serum_sodium ~ heart_data$heart_failure,
        main="Heart Failure by Serum Sodium Records",
        ylab="serum_sodium",xlab="Heart failure", horizontal = TRUE)

boxplot(heart_data$time ~ heart_data$heart_failure,
        main="Heart Failure by Time",
        ylab="time",xlab="Heart failure",horizontal = TRUE)

#PCA
pca_dataset <- princomp(select(heart_data, age:time), cor = TRUE)
pca_dataset <- princomp(con_data, cor = TRUE)
pca_dataset$loadings
summary(pca_dataset)
heart_data_copy<- heart_data
heart_data_copy$Colour="black" # Set new column values to appropriate colours b
heart_data_copy$Colour[heart_data_copy$DEATH_EVENT== "0"]="red" 
heart_data_copy$Colour[heart_data_copy$DEATH_EVENT== "1"]="blue"
biplot(pca_dataset)

autoplot(pca_dataset, data =select(heart_data, age:DEATH_EVENT),colour = "DEATH_EVENT",loadings =TRUE, loadings.label = TRUE )


pca_col <- cbind(pca_dataset$scores, heart_data_copy$Colour)
plot(pca_col[,1:2],col = pca_col[,14])
legend("topright", fill = unique(heart_data_copy$Colour), legend = c("Died", "Survived"), cex = 0.5)

plot(prop.table(pca_dataset$sdev^2) ,xlab = 'Eigenvalues', ylab = 'Eigenvalue Size', main = 'Scree Graph', type ="b")
plot(cumsum(prop.table(pca_dataset$sdev^2)) ,xlab = 'Eigenvalues', ylab = 'Eigenvalue Size', main = 'Scree Graph', type ="b" )

#Hierachical clustering
Dist_cor <- as.dist(1-cor(select(heart_data, age:DEATH_EVENT)))
dist_corr <- as.dist(1-cor(pca_dataset$scores))
hca <- hclust(dist_cor, "average")
hcp <- hclust(dist_corr, "average")
plot(hca, main = "Average Linkage HC Dendogram")
plot(hcp, main = "Average Linkage HC Dendogram")
# Single linkage hierarchical clustering
#minimum distance between 2 points
hcs <- hclust(dist_cor, "single")
plot(hcs, main = "Single Linkage HC Dendogram")

# Complete linkage hierarchical clustering
hcc <- hclust(dist_cor, "complete")
plot(hcc, main = "Complete Linkage HC Dendogram")

#Kmeans
km.evals <- kmeans(select(heart_data, age:DEATH_EVENT), 2, nstart = 10)
km.evals$cluster
head(heart_data)
km_cluster <- data.frame(km.evals$cluster)

fitK <- kmeans(select(heart_data, age:DEATH_EVENT), 2, nstart = 10)
fitKcon <-kmeans(continous_data, 3, nstart = 10)
fitK

str(fitK)
fitK$cluster
plot(continous_data, col = fitKcon$cluster)
plot(select(heart_data, age:DEATH_EVENT), col = fitKcon$cluster)

## CHOOSING K
k <- list()
for(i in 1:10){
  k[[i]] <- kmeans(continous_data[,1:4], i)
}

k

betweenss_totss <- list()
for(i in 1:10){
  betweenss_totss[[i]] <- k[[i]]$betweenss/k[[i]]$totss
}

plot(1:10, betweenss_totss, type = "b", 
     ylab = "Between SS / Total SS", xlab = "Clusters (k)")

for(i in 1:4){
  plot(iris, col = k[[i]]$cluster)
}


split(rownames(km_cluster),km_cluster[,"km.evals.cluster"])
split(km_cluster,km_cluster[,"km.evals.cluster"])
table(km.evals$cluster)

plot(pca_col[,1:2],col = km.evals$cluster)

#Model based Clustering 
library(mclust)
mbc.heart_data <- Mclust(select(heart_data, age:DEATH_EVENT))
mbc.heart_data <- Mclust(continous_data)
table(mbc.heart_data $classification)

plot(mbc.heart_data, what = "classification")
summary(mbc.heart_data)

classify_heartdata<-data.frame(mbc.heart_data$classification)
split(rownames(classify_heartdata),classify_heartdata[,"mbc.heart_data.classification"])

plot(mbc.heart_data, what = "uncertainty")

