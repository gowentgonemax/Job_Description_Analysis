install.packages("openxlsx")
install.packages("Xlsx")
install.packages("tm")
install.packages("dplyr")
install.packages("wordcloud") # word-cloud generator 
install.packages("ggplot2")
install.packages("RColorBrewer")
require("RColorBrewer")
require("ggplot2")
require("wordcloud")
require("xlsx")
require("openxlsx")
library("tm")
require("dplyr")
library(shiny)

#read the data


myfile <- "ProjectData.xlsx"
myData <- read.xlsx2(myfile,sheetIndex = 1)
DF <- data.frame(myData)


textFile <- "C:\\Users\\Max Cullen\\Desktop\\SP_19\\663\\R_Project\\JobDescMiningProject\\Job_Description\\skillsList.txt"
filePath <- "C:\\Users\\Max Cullen\\Desktop\\SP_19\\663\\R_Project\\JobDescMiningProject\\Job_Description"
setwd(filePath)
myTextFile <- read.csv(file = textFile,header = FALSE,sep = "\n")
skills_DF <- data.frame(myTextFile)

jobDesc <- DF$JobDescription          



Corpus <- VCorpus(VectorSource(jobDesc))
Corpus <- tm_map(Corpus,stripWhitespace)
Corpus <- tm_map(Corpus,removePunctuation)
Corpus <- tm_map(Corpus,content_transformer(tolower))
Corpus <- tm_map(Corpus, removeWords, stopwords("en"))
#jobDesc_DF <- data.frame(DF$JobDescription)  


  myDTM <- TermDocumentMatrix(Corpus)
  m= as.matrix(myDTM)
  v <- sort(rowSums(m),decreasing = TRUE)
  Frequency <- data.frame(word=names(v),freq = v)
  
  
  
  #forming word clouds
  set.seed(1234)
  wordcloud(words = Frequency$word, 
            freq = Frequency$freq, 
            min.freq = 1000,
            use.r.layout = FALSE,
            fixed.asp = TRUE,
            max.words=30, 
            random.order=TRUE, 
            rot.per=.45,
            colors=brewer.pal(8, "Dark2"))
  
  
  barplot(Frequency[1:15,]$freq, las = 2, names.arg = Frequency[1:15,]$word,
          col ="lightblue", main ="Most frequent Skills",
          ylab = "Skills frequencies")

