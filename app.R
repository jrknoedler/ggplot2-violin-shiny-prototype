##This script generates violin plots from a normalized snRNAseq count matrix
##with minimal dependencies for maximum portability between computers.

library(shiny)
library(tidyverse)
library(bslib)
library(ggplot2)
library(dplyr)
library(cowplot)
library(rsconnect)
library(gitlink)
library(readr)

fileurl <- "https://media.githubusercontent.com/media/jrknoedler/ggplot2-violin-shiny-prototype/refs/heads/main/data/VMH_Subset_Counts.csv"
VMH <- read_csv(fileurl)
head(VMH)

#set.seed(420)

#min_val <- -3.37e-5
#max_val <- 3.37e-5
#data <- read.csv("Documents/Coding projects/R/Seurat Shiny App/VMH_New_Counts.csv", row.names=1)
#data <- t(data)
VMH$cluster <- as.factor(VMH$cluster)


#zeros_index <- which(data==0)

#num_zeros <- length(zeros_index)
#random_values <- runif(n=num_zeros, min=min_val, max=max_val)

#data[data==0] <- random_values

remove <- c("...1","barcode","cluster")
cols <- names(VMH)
genes <- cols[! cols %in% remove]


ui <- fluidPage(
  titlePanel("Seurat Violin Plot Generator"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Feature", label="Gene", choices=genes
      ), 
      actionButton("Click me!","Choose gene!")),
    mainPanel(
      plotOutput("violin_plot")),
    position="right"
  )
)



server <- function(input, output) {
  
  
  output$violin_plot <- renderPlot({
    ggplot(VMH, aes_string(x=VMH$cluster, y=input$Feature)) +geom_violin(trim=TRUE, scale="width",kernel="gaussian", fill="red") + theme_cowplot()
  })
  
}


shinyApp(ui=ui, server=server)