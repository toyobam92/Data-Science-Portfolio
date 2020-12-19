#libraries 
library(shiny)
library(tidyverse)
library(imager)
library(OpenImageR)
library(EBImage)
library(dplyr)
library(shinythemes)


ui <- fluidPage(theme = shinytheme("united"),
                
                titlePanel("The One Stop PCA Center"),
                sidebarLayout(
                    sidebarPanel (
                        fileInput("images","Upload images", multiple = T, accept = c('image/png',"image/jpeg"),),
                        numericInput("num_class", 
                                     "number of classes", 
                                     value = 8) ,
                        numericInput("img_class", 
                                     "Images per class", 
                                     value = 5), 
                        numericInput("train_split", 
                                     "training split percent", 
                                     value = 0.8),
                        numericInput("var_percent", 
                                     "threshold for variance", 
                                     value = 0.95)
                        
                    ),
                    
                    mainPanel(  
                        tabsetPanel(
                            tabPanel('Images for PCA', plotOutput("image")),
                            tabPanel('Average face', plotOutput("avg_face")),
                            tabPanel('Var plots',numericInput("dis_eigval","percentage of eigen values for display",
                                                              value = 0.01),plotOutput("var_plots"),),
                            tabPanel('Eigenfaces', plotOutput("eigenfaces"),),
                            tabPanel('Reconstructed images', uiOutput("slider"),plotOutput("recon_image")),
                            tabPanel('PCA Summary', tableOutput("var_table")),
                            tabPanel('Eigenfaces Classifier',tableOutput("classify"),tableOutput("acc_percent") )
                            
                        )
                        
                    )))

server <- function(input, output, session) {
  # =============================================================
  #              READ IMAGES
  # =============================================================
    img <- reactive ({
        f<- input$images
        #faces <- list.files(path = image_directory, full.names = TRUE, recursive = TRUE)
        if(is.null(f))
            return(NULL)
        readImage(f$datapath)
        #lapply(f$datapath,readImage)
        #o.call('cbind',lapply(image_list,as.numeric))
        
    })
    
    # =============================================================
    #              CREATE IMAGE MATRIX
    # =============================================================
    matrices <- reactive ({
        req(img)
        if(is.null(img()))
            return(NULL)
        f<- input$images
        faces <- as.list(f$datapath)
        image_list= lapply(faces,readImage)
        image_matrix <-do.call('cbind',lapply(image_list,as.numeric))
    })
    
    #display image
    # =============================================================
    #              DISPLAY IMAGES tabPanel:Images for PCA
    # =============================================================
    output$image <- renderPlot({
        req(img())
        plot(img(), all = TRUE)
        
    })
    
    
    # =============================================================
    #             TRAINING DATA MATRIX
    # =============================================================
    trainin_data <- reactive ({
        req(img)
        req(matrices)
        if(is.null(img()))
            return(NULL)
        if(is.null(matrices()))
            return(NULL)
        image_matrix <- matrices()
        # input - number of classes and image per class
        num_classes <- input$num_class
        img_per_class <- input$img_class
        
        #class
        class_labels<-seq(1:num_classes) %>% 
            rep(each=img_per_class ) %>% 
            data.frame() %>% 
            mutate(index = row_number()) %>% 
            select(2, label = 1) 
      
        #split
        train_percent = round(input$train_split* img_per_class)
        #training labels
        train_labels <- class_labels%>%
            group_by(label) %>%
            #choose 80% images per class to train 
            sample_n(train_percent) %>% 
            arrange(index)
        #remaining images for test will be img_per_class -training data 20% images per class
        test_labels <-  setdiff(class_labels, train_labels)
        #tranpose data matrix to obtain covariance matrix 
        t_matrix <- as.data.frame(t(image_matrix))
        
        #train data
        train_data <- t_matrix %>%
            filter(row_number() %in% train_labels[, "index", drop=TRUE]) %>%
            data.matrix() %>%
            `rownames<-`(train_labels[, "label", drop=TRUE])
        return(train_data)

    })
    
    # =============================================================
    #             COVARIANCE MATRIX AND EIGEN COMPUTATION
    # =============================================================
    eig_comp <- reactive({
        req(img())
        req(matrices())
        req(trainin_data())
        train_data <- trainin_data()
        
        #center and scale train data 
        train_scaled <- scale(train_data, center = TRUE, scale = FALSE)
        
        #calculate covariance matrix and perform eigen computation
        cov_matrix<-   t(train_scaled) %*% train_scaled / nrow(train_data-1) 
        eig_compute <- eigen(cov_matrix)
       
    })
    
    # =============================================================
    #              PROP TABLE FOR VARIANCE PLOTS
    # =============================================================
  
    vari_table<- reactive({
      req(eig_comp())
      if(is.null(eig_comp()))
        return(NULL)
      eig_compute <- eig_comp()
      eig_val  <- eig_compute$values 
      r <- round(prop.table(eig_val),3)
      std_dev <- as.matrix(sqrt(eig_val))
      var_percent <- as.matrix(prop.table(eig_val))
      cum_var_percent<- as.matrix(cumsum(prop.table(eig_val)))
      var_table <- round(cbind(var_percent,cum_var_percent,std_dev),3)
      colnames(var_table)  <- c("v","cv","std_dev")
      summary_tbl <- round(as.data.frame(t(subset(var_table, var_table[ ,1] > 0, select = c(v, cv,std_dev)))),2)
      rownames(summary_tbl)  <- c("Proportion of variance","Cumulative variance","Standard deviation")
      return(summary_tbl)
    })
    
    
    # =============================================================
    #              TABLE OUTPUT FOR PCA SUMMARY
    # =============================================================
    
    output$var_table<- renderTable({
      req(vari_table())
      summary_tbl<-vari_table()
      summary_tbl
    },
    rownames = TRUE
    
    )
    
    
    # =============================================================
    #              IMAGE FUNCTION
    # =============================================================
  
    #image function for plotting
    img_function <- reactive ({
      img_plot <-   function(x) {
            x %>%
                as.numeric() %>%
                matrix(nrow = 64, byrow = TRUE) %>% 
                apply(2, rev) %>%  
                t %>% 
                image(col=grey(seq(0, 1, length=256)), xaxt="n", yaxt="n")
            
        }
        
    })
    
    # =============================================================
    #              OUTPUT OF AVERAGE FACE
    # =============================================================
    
    #render average face of training data
    output$avg_face <- renderPlot({
      #render average face of training data
        req(matrices())
        req(trainin_data())
        req(img_function())
        train_data <- trainin_data()
        img_plot <- img_function()
        avg_img<- colMeans(train_data)
        img_plot(avg_img)
        
    })
  
    # =============================================================
    #     OUTPUT OF VARIANCE AND CUMMULATIVE VARIANCE PLOTS
    # =============================================================
    
    output$var_plots <- renderPlot({
      
        req(img())
        req(matrices())
        req(trainin_data())
        req(eig_comp())
        eig_compute <- eig_comp()
        eig_val  <- eig_compute$values 
        train_data <- trainin_data()
  
        # Display selected % of eigenvalues 
        num_eig_val <- round(input$dis_eigval*length(eig_val))
        par(mfrow=c(2, 1))
        par(mar=c(3.5, 3.5, 2, 1), mgp=c(2.4, 0.8, 0), las=1)
        plot(
          x = seq(1:length(eig_val[1:num_eig_val])), y = eig_val[1:num_eig_val],
          type = "o",
          main = "Variance Plot",
          xlab = "Principle Component", ylab = "Variance")
        plot(
          x = seq(1:length(eig_val[1:num_eig_val])), y = cumsum(eig_val[1:num_eig_val]),
          type = "o",
          main = " Cummulative Variance Plot",
          xlab = "Principal Component", ylab = "Cummulative Variance")
    })

    # =============================================================
    #              EIGENFACES based on threshold
    # =============================================================
    
    eig_faces <- reactive({
      
      req(eig_comp())
      eig_compute <- eig_comp()
      eig_val  <- eig_compute$values
      eig_vector <- eig_compute$vectors
      #var <- eig_val/sum(eig_val) 
      cum_var <- cumsum(eig_val)/sum(eig_val) 
      max_PC <- min(which(cum_var > input$var_percent)) 
      #eigenvectors for plots and PC
      eigenfaces <-  eig_vector[,1:max_PC]
    
    })
    
    # =============================================================
    #              OUTPUT OF EIGEN FACES IMAGES "GHOST IMAGES"
    # =============================================================
    
    output$eigenfaces <- renderPlot({
      
      req(img_function())
      img_plot <- img_function()
      
      req(eig_faces())
      eigenfaces <- eig_faces()
      
      par(mfrow=c(input$img_class,input$num_class))
      par(mar=c(0.05, 0.05, 0.05, 0.05))
      for (i in 1:ncol(eigenfaces)) {
        img_plot(eigenfaces[, i])
      }
     
    }) 
    
   
    # =============================================================
    #              SLIDER INPUT 
    # =============================================================
    
    output$slider <- renderUI({
      
      req(eig_faces())
      eigenfaces <- eig_faces()
      
      maxim = ncol(eigenfaces)
      
      sliderInput("prin_comp", "Choose the number of Principal Components", min=1, max=maxim, value = maxim, step = 1)
    })
    
  
    
    # =============================================================
    #              RECONSTRUCTED IMAGES
    # =============================================================
    
   output$recon_image <- renderPlot({
     req(img())
     
     req(img_function())
     img_plot <- img_function()
     
     req(trainin_data())
     train_data <- trainin_data()
     
     req(eig_comp())
     eig_compute <- eig_comp()
     eig_val  <- eig_compute$values
     
     req(eig_faces())
     eigenfaces <- eig_faces()
     
     #labels
     class_labels<-seq(1:input$num_class) %>% 
       rep(each=input$img_class ) %>% 
       data.frame() %>% 
       mutate(index = row_number()) %>% 
       select(2, label = 1) 
     
     train_percent = round(input$train_split * input$img_class )
     train_labels <- class_labels%>%
       group_by(label) %>%
       #choose images per class to train 
       sample_n(train_percent) %>% 
       arrange(index)
     
      #scaled data 
      train_scaled <- scale(train_data, center = TRUE, scale = FALSE)
      avg_img<- colMeans(train_data)
      
      #obtain principal components 
      train_transform <- train_scaled %*% eigenfaces[, 1:input$prin_comp] %>% 
        `rownames<-`(rownames(train_data)) 
    
     #plot training data transformed images 
      
      par(mfrow=c(input$img_class,input$img_class))
      par(mar=c(0.1, 0.1, 0.1, 0.1))
      for (i in 1:nrow(train_data)) {  
       img_plot((train_data[i, ]))
       (train_transform[i, ] %*% t(eigenfaces[,1:input$prin_comp]) + avg_img) %>%
        img_plot()
      }
    })
   
   
   # =============================================================
   #      EIGENfACES BASED CLASSIFIER
   # =============================================================
    
   
   output$classify<- renderTable({
     
     req(matrices())
     image_matrix <- matrices()
     
     req(eig_faces())
     eigenfaces <- eig_faces()
     
     req(trainin_data())
     train_data <- trainin_data()
     
     class_labels<-seq(1:input$num_class) %>% 
     rep(each=input$img_class) %>% 
     data.frame() %>% 
     mutate(index = row_number()) %>% 
     select(2, label = 1) 
     
     train_percent = round(input$train_split * input$img_class)
     #training labels
     train_labels <- class_labels%>%
       group_by(label) %>%
       #choose 80% images per class to train 
       sample_n(train_percent) %>% 
       arrange(index)
     #remaining images for test will be img_per_class -training data 20% images per class
     test_labels <-  setdiff(class_labels, train_labels)
     
     t_matrix <- as.data.frame(t(image_matrix))
     
     test_data <- t_matrix%>%
     filter(row_number() %in% test_labels[,"index",drop=TRUE]) %>%
      data.matrix() %>%
     `rownames<-`(test_labels[, "label", drop=TRUE])
     
     avg_img <- colMeans(train_data)
     
       #obtain principal components 
       train_scaled <- scale(train_data, center = TRUE, scale = FALSE)
       
       train_transform <- train_scaled %*% eigenfaces[, 1:input$prin_comp] %>% 
         `rownames<-`(rownames(train_data)) 
       
     #empty dataframe for results
       #classification test 
       test_faces <- test_data %>% 
         apply(1, function(x) x-avg_img) %>%  
         t %*% 
         eigenfaces
     #empty dataframe for results
       acc <- matrix(NA, nrow = nrow(test_faces), ncol = 2) %>%
         data.frame %>%
         `colnames<-`(c("Image label", "Classification test"))
       
       dist_fun<- function(x){
         ((x-test_img) %*% t(x-test_img)) %>%
           sqrt
           }
       
       for (i in 1:nrow(test_faces)) { 
         test_img<- test_faces[i, , drop=FALSE]
         app_dist <- apply(train_transform, 1, dist_fun)
         acc$`Image label`[i]  <- rownames(test_faces)[i]
         acc$`Classification test`[i] <- rownames(train_transform)[which(min(app_dist)==app_dist)]
           }
       
       acc$Results <- ifelse(acc$`Classification test` == acc$`Image label`, 1, 0)
       acc$Accuracy <- ifelse(acc$`Classification test` == acc$`Image label`, 'Match', "No Match")
       
       acc <- acc
       as.data.frame(acc)
       
      }) 
   
   # =============================================================
   #              ACCURACY PERCENTAGE
   # =============================================================
   
   output$acc_result<- renderTable({
     
     acc <- acc
     x <- as.data.frame(acc)
     #proportion of accuracy of test faces
     accuracy <- (sum(x$`Results`))/(nrow(x))*100 
     cat("The model accuracy is",accuracy,"% based on the test images")
     
   })
   


}   


# Run the application 
shinyApp(ui = ui, server = server)


