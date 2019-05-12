
library(shiny)
  #Application Title

fluidPage(
  titlePanel("Job Description Analysis"),
  sidebarLayout(
    #sidebar with a slide section
              sidebarPanel(
                
                sliderInput ("freq",
                             "Maximum frquency:",
                             min = 500,max = 5924,value = 1000),
                sliderInput ("max",
                             "Maximum number of skills:",
                             min = 10,max = 50,value = 100)
    
      
                ),
  #show word cloud
  mainPanel(
    plotOutput("plot")
    )
  )
)
