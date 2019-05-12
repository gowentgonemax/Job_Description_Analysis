require("RColorBrewer")
require("ggplot2")
require("wordcloud")
require("xlsx")
require("openxlsx")
library(tm)
require("dplyr")
library(shiny)

myfile <- "ProjectData.xlsx"
myData <- read.xlsx2(myfile,sheetIndex = 1)
#myData <- read.xlsx2(myfile, sheetIndex=1 ,password = NULL, write.res.password = NULL)
DF <- data.frame(myData)

getTermMatrix <- function(DF){
  
  jobDesc <- DF$JobDescription
  Corpus <- VCorpus(VectorSource(jobDesc))
  Corpus <- tm_map(Corpus,stripWhitespace)
  Corpus <- tm_map(Corpus,removePunctuation)
  Corpus <- tm_map(Corpus,content_transformer(tolower))
  Corpus <- tm_map(Corpus, removeWords, stopwords("en"))
  
  myDTM <- TermDocumentMatrix(Corpus)
  m= as.matrix(myDTM)
  sort(rowSums(m),decreasing = TRUE)
  
}

# Define server logic required to draw a histogram
function(input, output,session) {
   
            terms <- reactive({
                        input$update
                        isolate({
                          withProgress({
                              setProgress(message = "Processing corpus....")
                              getTermMatrix(input$selection)
                          })
                       })
                    })
            wordcloud_rep <- repeatable(wordcloud)
            output$plot <- renderPlot({
              
                    v <- terms()
                    wordcloud_rep(names(v),v,scale(4,0.5),
                                  min.freq = input$freq,max.words = input$max,
                                  colors=brewer.pal(8,"Dark2")
                                  )
            })
}
