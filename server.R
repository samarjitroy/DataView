
# This is the user-interface definition of a Shiny web application.
# Peer Graded Assignment: Course Project: Shiny Application and Reproducible Pitch
# By Samarjit Roy (sroy926@yahoo.com)
# 
# This Tool will allow the user to analyse some base statistics for few dataset 
# without submiting R commands one by one.
#
# 1) Select a dataset
# 2) Select the type of info to Show
# 3) Select column to analyse (X and Y)
#
#
# 
#
library(shiny) 
library(shinydashboard)
library(datasets)
library(ggplot2)
library(formattable)
library(data.table)




shinyServer(function(input, output) {
  
  # Dropdown Box for Dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "faithful" = faithful,
           "diamonds" = diamonds,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  })
  
  # Action / What to Show
  output$whatTOdo <- reactive({
    input$whatTOdo
  })
  
  #Column list from the selected dataset
  output$colList <- reactive({
    colnames(datasetInput())
  })
  
  # X Column list from the selected dataset
  output$columnXcontrols <- renderUI({
    colList <- colnames(datasetInput())
    selectInput("collistX", "X Column", colList)
  })
  
  # Y Column list from the selected dataset
  output$columnY1controls <- renderUI({
    colList <- colnames(datasetInput())
    selectInput("collistY", "Y Column", colList)
  })
  
  output$columnY2controls <- renderUI({
    colList <- colnames(datasetInput())
    selectInput("collistY", "Y Column", colList)
  })
  
  # Plot Title
  output$plotHeader <- renderUI({
    xCol <- input$collistX
    yCol <- input$collistY
    hd1 <- paste("Plot: ", xCol, "by", yCol,sep=" ")
    h4(hd1)
  })
  
  # Two Way Table Title
  output$TwoWayTableHeader <- renderUI({
    xCol <- input$collistX
    yCol <- input$collistY
    hd1 <- paste("Two Way Table: ", xCol, "by", yCol,sep=" ")
    h4(hd1)
  })
  
  # Frequency Table Title
  output$freqTabHeader <- renderUI({
    xCol <- input$collistX
    yCol <- input$collistY
    hd1 <- paste("Frequency Table for:", xCol,sep=" ")
    h4(hd1)
  })
  
  # Summary Table Title
  output$summaryHeader <- renderUI({
    xCol <- input$collistX
    yCol <- input$collistY
    hd1 <- paste("Summary Table for:", xCol,sep=" ")
    h4(hd1)
  })
  
  # Plot 
  output$distPlot <- renderPlot({
    #validate(
    #  need(input$collistY != "", "Please select Y Column"),
    #)
    xCol <- input$collistX
    yCol <- input$collistY
    #yVal <- datasetInput()[[yCol]]
    columnType <- typeof(datasetInput()[[yCol]])
    if (columnType == "integer" || columnType == "double"){
      x = datasetInput()[[xCol]]       
      y = datasetInput()[[yCol]]        
      plot(x, y, xlab=xCol,  ylab=yCol) 
    }
  })
  
  # Two Way Table
  output$dispTable <- renderTable({
    #validate(
    #  need(input$collistY != "", "Please select Y Column"),
    #)
    xCol <- input$collistX
    yCol <- input$collistY

    x = datasetInput()[[xCol]]       
    y = datasetInput()[[yCol]]
    table(x, y) 

    
  })
  
  # Frequency Table
  output$freqTab<- renderTable({
    xCol <- input$collistX
    whatTOdo <- input$whatTOdo
    Frequency = datasetInput()[[xCol]]       
    table(Frequency) 
  })
  
  #Summary Table
  output$summaryTab<- renderDataTable({
    xCol <- input$collistX
    x <- as.vector(datasetInput()[[xCol]])

    Name <- c("Min", "Max", "Range", 
                       "Mean", "Median", "Standard Deviation","Median",
                       "Interquartile Range", "Quartiles(0% : 25% : 50% : 75% : 100%)","Percentiles (25% : 75%)")
    Value=c(min(x), 
          max(x),  
          paste(range(x,na.rm=TRUE), collapse = "-"),
          mean(x),
          median(x), 
          sd(x),
          mad(x),    
          paste(IQR(x), collapse = "-"),             
          paste(quantile(x), collapse = " : "),         
          paste(quantile(x, c(1, 3)/4), collapse = " : "))
    
    DF <- data.frame(Name,Value)

    
    DF
    
    
  })
  
})
