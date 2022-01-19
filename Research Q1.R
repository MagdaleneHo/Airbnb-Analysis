library(readxl)
Airtest <- read_excel(file.choose())
summary (Airtest$neighborhood_overview)

install.packages ("Hmisc")
library(Hmisc)
describe(Airtest$neighborhood_overview) #to explore the variable
sum(Airtest$neighborhood_overview == "NA") #count the values that are "NA" in neighborhood_overview column 
sum (Airtest$neighborhood_overview ==" ") #check if there is any blank values in neighborhood_overview column

#remove the rows that contain "NA"
Airtest <-Airtest [!(is.na(Airtest$neighborhood_overview) | Airtest$neighborhood_overview == "NA"),]

#load neededlibraries
library(tm) #for text mining
library(ggplot2) #for plotting
library(RColorBrewer) #for plot colors
library(wordcloud) #for generating word cloud

#Store the review texts in a corpus
Ab.corpus <- Corpus(VectorSource(Airtest$neighborhood_overview))

Ab.corpus <- tm_map(Ab.corpus, removePunctuation)

Ab.corpus <- tm_map(Ab.corpus, content_transformer(tolower)) #convert all text to lower cases

Ab.corpus <- tm_map(Ab.corpus, function(x)removeWords(x,stopwords())) #remove stop words

#remove custom irrelavnt words
Ab.corpus <- tm_map(Ab.corpus, removeWords, c("is", "are", "that", "can", "just", "from", "here", "away", "one", "many", "also", 
                                              "new", "great", "within", "blocks", "area", "located","york","around","neighborhood", 
                                              "williamsburg","block", "manhattan", "brooklyn","will","right","nyc"))


Abwords <- TermDocumentMatrix(Ab.corpus) #group the values together and calculate frequency
Abwords <- as.matrix(Abwords)
Abwords <- sort(rowSums(Abwords), decreasing = TRUE) #sorting

Abwords <- data.frame(word= names(Abwords), freq= Abwords)

#plotting the bar chart of words with top frequencies
barplot(Abwords[1:30,]$freq, las= 2, names.arg = Abwords[1:30,]$word,   #names.arg is the names appear under each bar
        col= brewer.pal(12,"RdYlBu"), main= "Top 30 Most Frequent Words Used in Neighborhood_Overview",
        ylab = "Word Frequencies", 
        ylim = c(0,15815))

#generatung wird cloud
set.seed(1234)
dev.new(width = 1000, height = 1000, unit = "px") #open the word cloud in a bigger window
wordcloud(words = Abwords$word,
          freq = Abwords$freq,
          min.freq = 1000,
          rot.per = 0.05,
          max.words = 200,
          colors = brewer.pal(10,"RdBu"),
          random.order = FALSE)

