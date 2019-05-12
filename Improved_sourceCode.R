install.packages("data.table")
install.packages("openxlsx")
install.packages("stringr")
install.packages("wordcloud")
install.packages("tm")
install.packages("SnowballC")
install.packages("RColorBrewer")

library(openxlsx)
library(data.table)
library(stringr)
library(wordcloud)
library(tm)
library(SnowballC)
library(RColorBrewer)

getwd()
filePath <- "C:\\Users\\Max Cullen\\Desktop\\SP_19\\663\\R_Project\\JobDescMiningProject\\Job_Description"
setwd(filePath)
skills <- read.csv("./skillsList.csv",header = FALSE)
names(skills) <- c("skills")

skills_vec <- as.character(skills$skills)
jobdata <- openxlsx::read.xlsx(xlsxFile = "ProjectData.xlsx",colNames = TRUE)
jobdescription_vec <- as.character(jobdata$JobDescription)
jobdescription_vec <- na.omit(jobdescription_vec)
skills_in_jobdata <- character()
for (i in 1:length(jobdescription_vec)){
  for (j in 1:length(skills_vec)){
    if(!is.na(stringr::str_detect(string = jobdescription_vec[i],pattern = skills_vec[j])) || 
       !(stringr::str_detect(string = jobdescription_vec[i],pattern = skills_vec[j]))
    ){
      skills_in_jobdata <- skills_in_jobdata  
    } else {
      skills_in_jobdata <- c(skills_in_jobdata,skills_vec[j]) 
    }
    
  }
}
skills_in_jobdata_doc <- tm::Corpus(tm::VectorSource(skills_in_jobdata))



dtm <- tm::TermDocumentMatrix(skills_in_jobdata_doc)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
#head(d, 10)

set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))
