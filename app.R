##This script generates violin plots from a normalized snRNAseq count matrix
##with minimal dependencies for maximum portability between computers.

library(shiny)
library(ggplot2)
library(dplyr)
library(cowplot)
library(rsconnect)
library(gitlink)
data <- read.csv("data/VMH_Subset_Counts.csv", header=TRUE, row.names=1)

set.seed(420)

min_val <- -3.37e-5
max_val <- 3.37e-5
#data <- read.csv("Documents/Coding projects/R/Seurat Shiny App/VMH_New_Counts.csv", row.names=1)
#data <- t(data)
data$cluster <- as.factor(data$cluster)

zeros_index <- which(data==0)

num_zeros <- length(zeros_index)
random_values <- runif(n=num_zeros, min=min_val, max=max_val)

data[data==0] <- random_values

remove <- c("barcode","cluster")
cols <- names(data)
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
    ggplot(data, aes_string(x=data$cluster, y=input$Feature)) +geom_violin(trim=TRUE, scale="width",kernel="gaussian", fill="red") + theme_cowplot()
  })
  
}


shinyApp(ui=ui, server=server)