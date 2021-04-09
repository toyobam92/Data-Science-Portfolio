#read image 
cakes_codes <- read.csv("lda_tes.csv", header = FALSE)
str(cakes_codes)


pr_pca<- prcomp(cakes_codes, scale = TRUE, center = TRUE)

summary(pr_pca)
str(pr_pca)
screeplot(pr_pca)

plot(prop.table(pr_pca$sdev^2) ,xlab = 'Eigenvalues', ylab = 'Eigenvalue Size', main = 'Scree Graph')
plot(cumsum(prop.table(pr_pca$sdev^2)) ,xlab = 'Eigenvalues', ylab = 'Eigenvalue Size', main = 'Scree Graph')

          
         
str(pr_pca)
#pca
pr_result <- irlba::prcomp_irlba(cakes_code, n = 400 ,scale. = TRUE)
str(pr_result)
pr_result

pca_matrix<- pr_result$x 


pca_400 <- pr_pca$x[,1:400]

pca_700 <- pr_pca$x[,1:700]

pca_1000 <- pr_pca$x[,1:1000]

pca_1500 <- pr_pca$x[,1:1500]

pc_2000 <- pr_pca$x[,1:2000]

#pca plot
plot(prop.table(pr_result$sdev^2) ,xlab = 'Eigenvalues', ylab = 'Eigenvalue Size', main = 'Scree Graph')
plot(cumsum(prop.table(pr_result$sdev^2)) ,xlab = 'Eigenvalues', ylab = 'Eigenvalue Size', main = 'Scree Graph')

#PC plot
plot(train_data, col = train_labels$label) 

#pca
score_matrix <- pr_result$x

#number of classes and images per class
num_classes <- 3
img_per_class <- 1000


#class labels
class_labels <-seq(1:num_classes) %>% 
  rep(each=img_per_class ) %>% 
  data.frame() %>% 
  mutate(index = row_number()) %>% 
  select(2, label = 1) 

#training labels
train_percent = round(0.75* img_per_class)
train_labels <- class_labels%>%
  group_by(label) %>%
  sample_n(train_percent) %>% 
  arrange(index)

#test labels
test_labels <-  setdiff(class_labels, train_labels)


#train data 400
train_data_400 <-as.data.frame((pca_400)) %>%
  filter(row_number() %in% train_labels[, "index", drop=TRUE]) %>%
  data.matrix() %>%
  `rownames<-`(train_labels[, "label", drop=TRUE])

#train data 700
train_data_700 <-as.data.frame((pca_700)) %>%
  filter(row_number() %in% train_labels[, "index", drop=TRUE]) %>%
  data.matrix() %>%
  `rownames<-`(train_labels[, "label", drop=TRUE])

#train data 1000
train_data_1000 <-as.data.frame((pca_1000)) %>%
  filter(row_number() %in% train_labels[, "index", drop=TRUE]) %>%
  data.matrix() %>%
  `rownames<-`(train_labels[, "label", drop=TRUE])

#train data 1500
train_data_1500 <-as.data.frame((pc_1500)) %>%
  filter(row_number() %in% train_labels[, "index", drop=TRUE]) %>%
  data.matrix() %>%
  `rownames<-`(train_labels[, "label", drop=TRUE])

#train data 2000
train_data_2000 <-as.data.frame((pc_2000)) %>%
  filter(row_number() %in% train_labels[, "index", drop=TRUE]) %>%
  data.matrix() %>%
  `rownames<-`(train_labels[, "label", drop=TRUE])
str(train_data_2000)


#test data  400
test_data_400 <- as.data.frame(pca_400) %>%
  dplyr::filter(row_number() %in% test_labels[, "index", drop=TRUE]) %>%
  data.matrix() %>%
  `rownames<-`(test_labels[, "label", drop=TRUE])
str(test_data)

#test data  700
test_data_700 <- as.data.frame(pca_700) %>%
  dplyr::filter(row_number() %in% test_labels[, "index", drop=TRUE]) %>%
  data.matrix() %>%
  `rownames<-`(test_labels[, "label", drop=TRUE])
str(test_data)

#test data  1000
test_data_1000 <- as.data.frame(pca_1000) %>%
  dplyr::filter(row_number() %in% test_labels[, "index", drop=TRUE]) %>%
  data.matrix() %>%
  `rownames<-`(test_labels[, "label", drop=TRUE])

#test data  1500
test_data_1500 <- as.data.frame(pc_1500) %>%
  dplyr::filter(row_number() %in% test_labels[, "index", drop=TRUE]) %>%
  data.matrix() %>%
  `rownames<-`(test_labels[, "label", drop=TRUE])

#test data  2000
test_data_2000 <- as.data.frame(pc_2000) %>%
  dplyr::filter(row_number() %in% test_labels[, "index", drop=TRUE]) %>%
  data.matrix() %>%
  `rownames<-`(test_labels[, "label", drop=TRUE])

#model 400
lda_model_400 <- lda(x= train_data_400, grouping = train_labels$label)
plot(lda_model_400, col = train_labels$label)
partimat(train_data, grouping = as.factor(train_labels$label), method ="lda")

a
#model 700
lda_model_700 <- lda(x= train_data_700, grouping = train_labels$label)
b<- plot(lda_model_700, col = train_labels$label)
partimat(train_data, grouping = as.factor(train_labels$label), method ="lda")


#model 1000
lda_model_1000 <- lda(x= train_data_1000, grouping = train_labels$label)
c<- plot(lda_model_1000, col = train_labels$label)
partimat(train_data, grouping = as.factor(train_labels$label), method ="lda")

#model 1500
lda_model_1500 <- lda(x= train_data_1500, grouping = train_labels$label)
plot(lda_model_1500, col = train_labels$label)
partimat(train_data, grouping = as.factor(train_labels$label), method ="lda")

#model 2000
lda_model_2000 <- lda(x= train_data_2000, grouping = train_labels$label)
plot(lda_model_2000, col = train_labels$label)
partimat(train_data, grouping = as.factor(train_labels$label), method ="lda")


par(mfrow=c(2, 2))
#par(mar=c(3.5, 3.5, 2, 1), mgp=c(2.4, 0.8, 0), las=1)
plot(lda_model_400, col = train_labels$label, main = "400 Principal components")
plot(lda_model_700, col = train_labels$label, main = "700 Principal components")
plot(lda_model_1000, col = train_labels$label, main  = "1000 Principal components")

?plot()
?par

#prediction 400
lda_predicts_400 <- predict(lda_model_400 ,test_data_400)$class
lda_table_400 <- table(lda_predicts_400,test_labels$label)
accuracy_400 <- sum(diag(lda_table_400)/sum(lda_table_400)*100)


#prediction 700
lda_predictss_700  <- predict(lda_model_700 ,test_data_700)$class
lda_table_700 <- table(lda_predictss_700,test_labels$label)
accuracy_700 <- sum(diag(lda_table_700)/sum(lda_table_700)*100)
confusionMatrix(lda_table_700)


#prediction 1000
lda_predicts_1000  <- predict(lda_model_1000 ,test_data_1000)$class
lda_table_1000 <- table(lda_predicts_1000,test_labels$label)
accuracy_1000 <- sum(diag(lda_table_1000)/sum(lda_table_1000)*100)
confusionMatrix(lda_table_1000)

#prediction 1500
lda_predicts_1500  <- predict(lda_model_1500 ,test_data_1500)$class
lda_table_1500 <- table(lda_predicts_1500,test_labels$label)
accuracy_1500 <- sum(diag(lda_table_1500)/sum(lda_table_1500)*100)
plot(confusionMatrix(lda_table)$table, col= c("red","green","black"))
confusionMatrix(lda_table_1500)$table

#prediction 2000
lda_predicts_2000  <- predict(lda_model_2000 ,test_data_2000)$class
lda_table_2000 <- table(lda_predicts_2000,test_labels$label)
accuracy_2000 <- sum(diag(lda_table_2000)/sum(lda_table_2000)*100)
plot(confusionMatrix(lda_table_2000)$table, col= c("red","green","black"))


as.matrix(lda_model_2000)
data.frame(lda_table_2000)
autoplot(confusionMatrix(lda_table_2000)$table, type = "heatmap") +
  scale_fill_gradient(low="#D6EAF8",high = "#2E86C1")

daaa.frame(lds)
plot(confusionMatrix(lda_table)$table, col= c("red","green","black"))

ggarrange(bxp, dp, bp + rremove("x.text"), 
          labels = c("A", "B", "C"),
          ncol = 2, nrow = 2)






check <- cbind(data.frame(lda_predicts), test_labels$label)


#confusion matrix
plot(confusionMatrix(lda_table)$table, col= c("red","green","black"))
which(lda_predicts!= test_data[,1]) 

misclassified = (lda_predicts != test_data)

logistic.rocr = prediction(logistic.scores, Z)
plot(performance(lda_predicts, "tpr", "fpr"), col = "red")
lda.counts <- misclassCounts(class.lda,true.class)
lda.counts$conf.matrix
print(lda.counts$metrics,digits=3)


library(ElemStatLearn)
set = train_data_2000
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('x.LD1', 'x.LD2')  # note here we need the real names of the extracted features
y_grid = predict(classifier, newdata = grid_set)
plot(set[, -3],
     main = 'Linear Discriminant Analysis (LDA) (Training set)',
     xlab = 'LD1', ylab = 'LD2',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 2, 'deepskyblue', ifelse(y_grid == 1, 'springgreen3', 'tomato')))
points(set, pch = 21, bg = ifelse(set[, 3] == 2, 'blue3', ifelse(set[, 3] == 1, 'green4', 'red3')))



