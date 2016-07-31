
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


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Dataset Column View"),
  
  # Sidebar with a slider input to Analyse
  sidebarLayout(
    sidebarPanel(
      # Partial example
      selectInput("dataset", "Dataset", c("faithful", "diamonds", "rock", "pressure", "cars")),
      radioButtons("whatTOdo","Show",c("Scattered","2-way Table","Frequency Table","Data Summary")),
      uiOutput("columnXcontrols"),
      conditionalPanel(condition = "input.whatTOdo == 'Scattered'", uiOutput("columnY1controls")),
      conditionalPanel(condition = "input.whatTOdo == '2-way Table'", uiOutput("columnY2controls"))
    ),
    
    # Show a plot/data of the generated from the column(s)
    mainPanel(
      conditionalPanel(condition = "input.whatTOdo == 'Scattered'", uiOutput("plotHeader")),
      conditionalPanel(condition = "input.whatTOdo == '2-way Table'",uiOutput("TwoWayTableHeader")),
      conditionalPanel(condition = "input.whatTOdo == 'Frequency Table'",uiOutput("freqTabHeader")),
      conditionalPanel(condition = "input.whatTOdo == 'Data Summary'",uiOutput("summaryHeader")),
                                        
      conditionalPanel(condition = "input.whatTOdo == 'Scattered'",plotOutput("distPlot")),
      conditionalPanel(condition = "input.whatTOdo == '2-way Table'",tableOutput("dispTable")),
      conditionalPanel(condition = "input.whatTOdo == 'Frequency Table'",tableOutput("freqTab")),
      conditionalPanel(condition = "input.whatTOdo == 'Data Summary'",dataTableOutput("summaryTab"))
    )
  )
))