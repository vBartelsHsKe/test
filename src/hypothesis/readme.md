# Code documentation -hypothesis


##  Table of contents


1. [Brilliant but cruel](#brilliant-but-cruel)
2. [Conformity](#conformity)
3. [Individual-Bias](#individual-bias)
4. [Text quality](#text-quality)


## Brilliant but cruel

   
     
  #### Einbinden der Libraries ####
  
  ```Rscript
  library(jsonlite)
  library(plyr)
  library(tidyr)
  library(dplyr)
  library(ggplot2)
  library(data.table)
  library(readr)
  ```
  
  
  #### erzeugen des Ausgabeplots  ####
  ```Rscript
  
  createPlot <- function(filePath, titleName){
    
    data_path <- filePath
    
    plotable_Frame <- stream_in(file(data_path))
    #Generating a data frame based on the json file read in earlier. Filtered by 'asin', 'overall' and 'helpful'
    #%>% Syntax chains the lhs(=left hand side) to the rhs(=right hand side), meaning it is not necessary to nest functions
    #for explanation see: https://stackoverflow.com/questions/24536154/what-does-mean-in-r?noredirect=1&lq=1
    reduced_Vote_Frame <- data.frame(amazonReviews) %>% select(asin,overall,helpful)
    
    #Grouping the reduced frame by 'asin' and mutating the frame adding a mean value for overall
    mean_Vote_Frame <- reduced_Vote_Frame %>% group_by(asin)  %>%  mutate(overall_Mean_Rating = mean(overall))
    
    #calculating the difference between a single overall vote and the mean vote -> variance. Adding variance to the data frame
    mean_Vote_Frame$variance <- mean_Vote_Frame$overall - mean_Vote_Frame$overall_Mean_Rating
    
    #rounding the variance of the mean value by a 0.5 quartile
    mean_Vote_Frame$rounded <- round_any(mean_Vote_Frame$variance, 0.5)
    
    #adding the single values of helpful voters and voters as columns, removing the original helpful column
    helpful_Vote_Frame <- mean_Vote_Frame %>% rowwise() %>% mutate(helpfulvoters = helpful[[1]], voters = helpful[[2]])
    helpful_Vote_Frame$helpful <- NULL
    
    #subsetting the current data to filter out reviews that have less than 5 votes
    helpful_Vote_Frame <- subset(helpful_Vote_Frame, voters > 4,
                     select=c(asin,overall,helpfulvoters, voters, variance, rounded))
    
    #calculating the quotient passing it into the plotable frame
    helpful_Vote_Frame <- helpful_Vote_Frame[!(helpful_Vote_Frame$voters==0), ]
    
    plotable_Frame <- helpful_Vote_Frame %>% mutate(quot= helpfulvoters/ voters)
  
    json_export <- toJSON(plotable_Frame)
    write_lines(json_export, "C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/book_brilliant.json", append = TRUE)
  
    setDT(plotable_Frame)[, theMedian := median(quot), by = rounded]
  
    pplot <- ggplot(data = plotable_Frame, aes(x = rounded)) + labs(x = "Absolute Deviation",y = "Helpfulness", title = "Brilliant but Cruel Hypothesis", subtitle = titleName)
    pplot + geom_boxplot(aes(y = plotable_Frame$quot, group = plotable_Frame$rounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) + geom_line( aes(x = plotable_Frame$rounded, y = plotable_Frame$theMedian) , color = 'red')
  }
  
  
  # createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/Automotive_5.json", "Evaluation 'Automotive'")
  # createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/Office_Products_5.json", "Evaluation 'Office Products'")
  # createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/Pet_Supplies_5.json", "Evaluation 'Pet Supplies'")
  createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/book_brilliant.json", "Evaluation 'Book Reviews'")
  
  ```
  
  

   
   


## Conformity


#### Einbinden der Libraries ####

```Rscript
library(jsonlite)
library(plyr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(data.table)
library(readr)
```


#### erzeugen des Ausgabeplots  ####
```Rscript

createPlot <- function(filePath, titleName){
  
  automotive_data_path <- filePath
  
  amazonReviews <- stream_in(file(automotive_data_path))

  # Generating a data frame based on the json file read in earlier. Filtered by 'asin', 'overall' and 'helpful' 
  # %>% Syntax chains the lhs(=left hand side) to the rhs(=right hand side), meaning it is not necessary to nest functions 
  # for explanation see: https://stackoverflow.com/questions/24536154/what-does-mean-in-r?noredirect=1&lq=1 
  reduced_Vote_Frame <- data.frame(amazonReviews) %>% select(asin,overall,helpful) 
  
  # Grouping the reduced frame by 'asin' and mutating the frame adding a mean value for overall 
  mean_Vote_Frame <- reduced_Vote_Frame %>% group_by(asin) %>% mutate(overall_Mean_Rating = mean(overall))  
  
  # calculating the difference between a single overall vote and the mean vote -> variance. Adding variance to the data frame 
  mean_Vote_Frame$variance <- abs(mean_Vote_Frame$overall - mean_Vote_Frame$overall_Mean_Rating) 
  
  # rounding the variance of the mean value by a 0.5 quartile 
  mean_Vote_Frame$rounded <- round_any(mean_Vote_Frame$variance, 0.5) 
  
  # adding the single values of helpful voters and voters as columns, removing the original helpful column 
  helpful_Vote_Frame <- mean_Vote_Frame %>% rowwise() %>% mutate(helpfulvoters = helpful[[1]], voters = helpful[[2]]) 
  helpful_Vote_Frame$helpful <- NULL 
  
  # calculating the quotient passing it into the plotable frame 
  helpful_Vote_Frame <- helpful_Vote_Frame[!(helpful_Vote_Frame$voters==0), ] 
  
  #subsetting the current data to filter out reviews that have less than 5 votes
  helpful_Vote_Frame <- subset(helpful_Vote_Frame, voters > 4, 
                               select=c(asin,overall,helpfulvoters, voters, rounded, variance))
  
  plotable_Frame <- helpful_Vote_Frame %>% mutate(quot = helpfulvoters / voters)
  
  son_export <- toJSON(plotable_Frame)
  write_lines(json_export, "C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/book_brilliant.json", append = TRUE)
  
  setDT(plotable_Frame)[, theMedian := median(quot), by = rounded]
  
  pplot <- ggplot(data = plotable_Frame, aes(x = rounded)) + labs(x = "Absolute Deviation",y = "Helpfulness", title = "Conformity Hypothesis", subtitle = titleName) 
  pplot + geom_boxplot(aes(y = plotable_Frame$quot, group = plotable_Frame$rounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) + geom_line(aes(x = plotable_Frame$rounded, y = plotable_Frame$theMedian) , color = 'red')
}

#createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/Automotive_5.json", "Evaluation 'Automotive'")
#createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/Office_Products_5.json", "Evaluation 'Office Products'")
#createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/Pet_Supplies_5.json", "Evaluation 'Pet Supplies'")
createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/book_brilliant.json", "Evaluation 'Book Reviews'")

```





## Individual-Bias

 #### Einbinden der Libraries ####
   
   ```Rscript
   library(jsonlite)
   library(plyr)
   library(dplyr)
   library(data.table)
   library(ggplot2)
   library(gridExtra)
   ```
   
   
   #### Funktion zur Berechnung der mittleren quadratischen Abweichung  ####
   ```Rscript
   #arithmetisches Mittel
   mqa = function(x) {
     bar_x = mean(x)
     #arithmetisches Mittel
     sab_2 = sum((x-bar_x)^2)
     #quadratische summenabweichung
     n = length(x)
     result = sab_2/n
     return
     (result)
   }
   ```
   
   #### erzeugen des Ausgabeplots  ####
   ```Rscript
   #### 1. Einlesen der json-Objekte in Tabelle ####
   
   createPlotIndividualBias <- function(filePath, titleName, fileName){
   
     #File for import + import
     url <- filePath
     con = file(url, "r")
     amazonReviews <- readLines(con, -1L)
     close(con)
   
    #generate Dataframe from 'input'
     df.reviewdata <- ldply(lapply(amazonReviews, function(x) t(unlist(fromJSON(x)))))
   
   
   #### 2. Löschen nicht benötigter Spalten und aller Reviews die keine Votes haben (d.h. helpful2-Value = 0) ####
   
   #delete all columns expect 'asin','helpful1','helpful2','overall'
   df.reviewdataCleaned <- df.reviewdata[, c('asin','helpful1','helpful2','overall')]
   
   #delete all rows where totalvotes(helpful2) = 0, we only want reviews with votes
   #and store cleaned data to new dataframe
   df.reviewdataCleaned <- df.reviewdataCleaned[!(df.reviewdataCleaned$helpful2==0), ]
   
   #typechange of column 'overall' to integer
   df.reviewdataCleaned$overall <- as.numeric(levels(df.reviewdataCleaned$overall))[df.reviewdataCleaned$overall]
   
   #rename 'asin' to 'prodID'
   colnames(df.reviewdataCleaned)[1] <- 'prodID'
   
   
   #### 3. Berechnung von Durchschnitts-Sternbewertung pro Produkt, Abweichung (gerundet), Nützlichkeit und mittlere quadratische Abweichung; Ausschließen von Reviews mit weniger als 5 Stimmen (helpful1 > 4) ####
   
   #calculate MQA
   setDT(df.reviewdataCleaned)[, middleSquaredError := round_any(mqa(overall),0.5), by = prodID]
   
   #calculate products average star rating
   setDT(df.reviewdataCleaned)[, prodAvgStarRating := mean(overall), by = prodID]
   
   #new Column with Deviation
   df.reviewdataCleaned <- df.reviewdataCleaned %>% mutate(deviation = (df.reviewdataCleaned$overall - df.reviewdataCleaned$prodAvgStarRating))
   
   #new column with rounded 'deviation'-Values to 0.5
   df.reviewdataCleaned <- df.reviewdataCleaned %>% mutate(deviationRounded = round_any(df.reviewdataCleaned$deviation,0.5))
   
   df.reviewdataCleaned$helpful1<-as.numeric(levels(df.reviewdataCleaned$helpful1))[df.reviewdataCleaned$helpful1]
   df.reviewdataCleaned$helpful2<-as.numeric(levels(df.reviewdataCleaned$helpful2))[df.reviewdataCleaned$helpful2]
   
   df.reviewdataCleaned <- subset(df.reviewdataCleaned, helpful1 > 4, select=c(prodID,overall,helpful1, helpful2, deviation, deviationRounded, middleSquaredError, prodAvgStarRating)) 
   
   #calculate helpfulness ratio
   df.reviewdataCleaned <- df.reviewdataCleaned %>% mutate(helpfulnessRatio = (df.reviewdataCleaned$helpful1/df.reviewdataCleaned$helpful2))
   
   
   #### 4. Ausgabe als Einzelplots nach MQA gruppiert ####
   
   #new tables grouped by the middle-square-Error-Values and generate Plot for each
   mqa0 <- df.reviewdataCleaned[(df.reviewdataCleaned$middleSquaredError==0), ]
   setDT(mqa0)[, theMedian := median(helpfulnessRatio), by = deviationRounded]
   pplot0 <- ggplot(data=mqa0, aes(x=deviationRounded)) + labs(x = "signed deviation",y = "helpfulness ratio", subtitle = "variance 0") + geom_boxplot(aes(y=helpfulnessRatio, group=mqa0$deviationRounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) + geom_line(aes(y=theMedian), color = 'red')
   
   mqa05 <- df.reviewdataCleaned[(df.reviewdataCleaned$middleSquaredError==0.5), ]
   setDT(mqa05)[, theMedian := median(helpfulnessRatio), by = deviationRounded]
   pplot05 <- ggplot(data=mqa05, aes(x=deviationRounded)) + labs(x = "signed deviation",y = "helpfulness ratio", subtitle = "variance 0.5") + geom_boxplot(aes(y=helpfulnessRatio, group=mqa05$deviationRounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) + geom_line(aes(y=theMedian), color = 'red')
   
   mqa1 <- df.reviewdataCleaned[(df.reviewdataCleaned$middleSquaredError==1), ]
   setDT(mqa1)[, theMedian := median(helpfulnessRatio), by = deviationRounded]
   pplot1 <- ggplot(data=mqa1, aes(x=deviationRounded)) + labs(x = "signed deviation",y = "helpfulness ratio", subtitle = "variance 1") + geom_boxplot(aes(y=helpfulnessRatio, group=mqa1$deviationRounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) + geom_line(aes(y=theMedian), color = 'red')
   
   mqa15 <- df.reviewdataCleaned[(df.reviewdataCleaned$middleSquaredError==1.5), ]
   setDT(mqa15)[, theMedian := median(helpfulnessRatio), by = deviationRounded]
   pplot15 <- ggplot(data=mqa15, aes(x=deviationRounded)) + labs(x = "signed deviation",y = "helpfulness ratio", subtitle = "variance 1.5") + geom_boxplot(aes(y=helpfulnessRatio, group=mqa15$deviationRounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) + geom_line(aes(y=theMedian), color = 'red')
   
   mqa2 <- df.reviewdataCleaned[(df.reviewdataCleaned$middleSquaredError==2), ]
   setDT(mqa2)[, theMedian := median(helpfulnessRatio), by = deviationRounded]
   pplot2 <- ggplot(data=mqa2, aes(x=deviationRounded)) + labs(x = "signed deviation",y = "helpfulness ratio", subtitle = "variance 2") + geom_boxplot(aes(y=helpfulnessRatio, group=mqa2$deviationRounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) + geom_line(aes(y=theMedian), color = 'red')
   
   mqa25 <- df.reviewdataCleaned[(df.reviewdataCleaned$middleSquaredError==2.5), ]
   setDT(mqa25)[, theMedian := median(helpfulnessRatio), by = deviationRounded]
   pplot25 <- ggplot(data=mqa25, aes(x=deviationRounded)) + labs(x = "signed deviation",y = "helpfulness ratio", subtitle = "variance 2.5") + geom_boxplot(aes(y=helpfulnessRatio, group=mqa25$deviationRounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) + geom_line(aes(y=theMedian), color = 'red')
   
   mqa3 <- df.reviewdataCleaned[(df.reviewdataCleaned$middleSquaredError==3), ]
   setDT(mqa3)[, theMedian := median(helpfulnessRatio), by = deviationRounded]
   pplot3 <- ggplot(data=mqa3, aes(x=deviationRounded)) + labs(x = "signed deviation",y = "helpfulness ratio", subtitle = "variance 3") + geom_boxplot(aes(y=helpfulnessRatio, group=mqa3$deviationRounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) + geom_line(aes(y=theMedian), color = 'red')
   
   mqa35 <- df.reviewdataCleaned[(df.reviewdataCleaned$middleSquaredError==3.5), ]
   setDT(mqa35)[, theMedian := median(helpfulnessRatio), by = deviationRounded]
   pplot35 <- ggplot(data=mqa35, aes(x=deviationRounded)) + labs(x = "signed deviation",y = "helpfulness ratio", subtitle = "variance 3.5") + geom_boxplot(aes(y=helpfulnessRatio, group=mqa35$deviationRounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) + geom_line(aes(y=theMedian), color = 'red')
   
   mqa4 <- df.reviewdataCleaned[(df.reviewdataCleaned$middleSquaredError==4), ]
   setDT(mqa4)[, theMedian := median(helpfulnessRatio), by = deviationRounded]
   pplot4 <- ggplot(data=mqa4, aes(x=deviationRounded)) + labs(x = "signed deviation",y = "helpfulness ratio", subtitle = "variance 4") + geom_boxplot(aes(y=helpfulnessRatio, group=mqa4$deviationRounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) + geom_line(aes(y=theMedian), color = 'red')
   
   #### 5.  Ausgabe von Sammelplot mit allen Einzelplots ####
   
   #draws one Plot of all single Plots
     pplot <- grid.arrange(pplot0,pplot05,pplot1,pplot15,pplot2,pplot25,pplot3,pplot35,pplot4,ncol=3,nrow=3, top = titleName)
     
     ggsave(fileName, pplot, width = 21, height = 14.8, units = "cm")
   }
   
   
   #### 6.  Funktionsaufruf mit Übergabe der Parameter ####
   
   createPlotIndividualBias("/Users/harry/Desktop/Home/FH/06_SoSe18/DV_PROJEKT/rstudio_files/reviews_Toys_and_Games_5.json", "evaluation 'toys and games'", "individualBiasToysGames.jpeg")
   #createPlotIndividualBias("/Users/harry/Desktop/Home/FH/06_SoSe18/DV_PROJEKT/rstudio_files/reviews_Video_Games_5.json", "evaluation 'video games'", "individualBiasVideoGames.jpeg")
   #createPlotIndividualBias("/Users/harry/Desktop/Home/FH/06_SoSe18/DV_PROJEKT/rstudio_files/reviews_Health_and_Personal_Care_5.json", "evaluation 'health and personal care'", "individualBiasHealthPersonalCare.jpeg")
   
   ```




## Text quality

### Scatterplot


#### Einbinden der Libraries ####

```Rscript
library("jsonlite")
library("ggplot2")
library("plyr")
library("dplyr")
library("tidyr")
library("data.table")
library("stringi")
```


#### erzeugen des Ausgabeplots  ####
```Rscript
createPlot <- function(filePath, titleName){
  
  automotive_data_path <- filePath
  
  amazonReviews <- stream_in(file(automotive_data_path))
  
  # Generating a data frame based on the json file read in earlier. Filtered by 'asin', 'overall' and 'helpful'
  # %>% Syntax chains the lhs(=left hand side) to the rhs(=right hand side), meaning it is not necessary to nest functions
  # for explanation see: https://stackoverflow.com/questions/24536154/what-does-mean-in-r?noredirect=1&lq=1
  reduced_Vote_Frame <- data.frame(amazonReviews) %>% select(asin,overall,helpful, reviewText)
  reduced_Vote_Frame <- reduced_Vote_Frame %>% mutate(wordCount = stri_count(reduced_Vote_Frame$reviewText, regex="\\S+"))
  
  
  # adding the single values of helpful voters and voters as columns, removing the original helpful column
  helpful_Vote_Frame <- reduced_Vote_Frame %>% rowwise() %>% mutate(helpfulvoters = helpful[[1]], voters = helpful[[2]])
  helpful_Vote_Frame$helpful <- NULL
  helpful_Vote_Frame <- helpful_Vote_Frame[!(helpful_Vote_Frame$voters==0), ]
  helpful_Vote_Frame <- helpful_Vote_Frame[(helpful_Vote_Frame$helpfulvoters < helpful_Vote_Frame$voters), ]
  
  #subsetting the current data to filter out reviews that have less than 5 votes
  helpful_Vote_Frame <- subset(helpful_Vote_Frame, voters > 4, 
                               select=c(asin,overall,helpfulvoters, voters, wordCount))
  
  helpful_Vote_Frame <- helpful_Vote_Frame[(helpful_Vote_Frame$wordCount < 4000), ]
  
  plotable_Frame <- helpful_Vote_Frame %>% mutate(quot = helpfulvoters / voters)
  
  
  pplot <- ggplot(data = plotable_Frame, aes(x = plotable_Frame$wordCount, y = plotable_Frame$quot, group = plotable_Frame$wordCount)) 
  pplot + labs(x = "Word count", y = "Helpfulness", title = "Textquality", subtitle = titleName) + geom_point(color="steelblue")
}

createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/Automotive_5.json", "Evaluation 'Automotive'")
#createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/Office_Products_5.json", "Evaluation 'Office Products'")
#createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/Pet_Supplies_5.json", "Evaluation 'Pet Supplies'")

```






### Boxplot


#### Einbinden der Libraries ####

```Rscript
library(jsonlite)
library(tidyr)
library(plyr)
library(dplyr)
library(ggplot2)
library(data.table)
library(gridExtra)
library(stringi)
```


#### erzeugen des Ausgabeplots  ####
```Rscript
createPlot <- function(filePath, titleName){
  
  data_path <- filePath
  
  amazonReviews <- stream_in(file(data_path))
  
  # Generating a data frame based on the json file read in earlier. Filtered by 'asin', 'overall' and 'helpful'
  # counting all words in reviewText
  reduced_Vote_Frame <- data.frame(amazonReviews) %>% select(asin,overall,helpful, reviewText)
  reduced_Vote_Frame <- reduced_Vote_Frame %>% mutate(word_count=stri_count(reduced_Vote_Frame$reviewText, regex="\\S+"))
  
  # Grouping the reduced frame by 'asin' and mutating the frame adding a mean value for overall
  mean_Vote_Frame <- reduced_Vote_Frame %>% group_by(asin)  %>%  mutate(overall_Mean_Rating = mean(overall)) 
  
  # calculating the difference between a single overall vote and the mean vote -> variance. Adding variance to the data frame
  mean_Vote_Frame$variance <- abs(mean_Vote_Frame$overall - mean_Vote_Frame$overall_Mean_Rating)
  
  # rounding the variance of the mean value by a 0.5 quartile
  mean_Vote_Frame$rounded <- round_any(mean_Vote_Frame$variance, 0.5)
  
  # adding the single values of helpful voters and voters as columns, removing the original helpful column
  helpful_Vote_Frame <- mean_Vote_Frame %>% rowwise() %>% mutate(helpfulvoters = helpful[[1]], voters = helpful[[2]])
  helpful_Vote_Frame <- helpful_Vote_Frame[!(helpful_Vote_Frame$voters==0), ]
  #helpful_Vote_Frame$helpful <- NULL
  
  #subsetting the current data to filter out reviews that have less than 5 votes
  helpful_Vote_Frame <- subset(helpful_Vote_Frame, voters > 4, 
                               select=c(asin,overall,helpfulvoters, voters, rounded, variance))
  
  # calculating the quotient passing it into the plotable frame
  plotable_Frame <- helpful_Vote_Frame %>% mutate(quot= helpfulvoters/ voters)
  plotable_Frame20_30 <- plotable_Frame[seq(from = (plotable_Frame$word_count=20), to = (plotable_Frame$word_count=100), by = 1), ]
  plotable_Frame75_125 <- plotable_Frame[seq(from = (plotable_Frame$word_count=100), to = (plotable_Frame$word_count=500), by = 1), ]
  plotable_Frame500_600 <- plotable_Frame[seq(from = (plotable_Frame$word_count=500), to = (plotable_Frame$word_count=1000), by = 1), ]
  plotable_Frame_1000 <- plotable_Frame[(plotable_Frame$word_count >= 1000), ]
  
  
  #calculating the median of the quotient so that a red line in the plot can be drawn
  setDT(plotable_Frame)[, theMedian := median(quot), by = rounded]
  setDT(plotable_Frame20_30)[, theMedian := median(quot), by = rounded]
  setDT(plotable_Frame75_125)[, theMedian := median(quot), by = rounded]
  setDT(plotable_Frame500_600)[, theMedian := median(quot), by = rounded]
  setDT(plotable_Frame_1000)[, theMedian := median(quot), by = rounded]
  
  # plotting the boxplots
  plot20_30 <- ggplot(data=plotable_Frame20_30, aes(x=rounded)) + labs(x = "",y = "", subtitle = "Wordcount 20-100") + geom_boxplot(aes(y=quot, group=plotable_Frame20_30$rounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) + geom_line(aes(y=theMedian), color = 'red')
  
  plot75_125 <- ggplot(data=plotable_Frame75_125, aes(x=rounded)) + labs(x = "",y = "", subtitle = "Wordcount 100-500") + geom_boxplot(aes(y=quot, group=plotable_Frame75_125$rounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) +  geom_line(aes(y=theMedian), color = 'red')
  
  plot500_600 <- ggplot(data=plotable_Frame500_600, aes(x=rounded)) + labs(x = "",y = "", subtitle = "Wordcount 500-1000") + geom_boxplot(aes(y=quot, group=plotable_Frame500_600$rounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) +geom_line(aes(y=theMedian), color = 'red')
  
  plot1000 <- ggplot(data=plotable_Frame_1000, aes(x=rounded)) + labs(x = "",y = "", subtitle = "Wordcount >1000") + geom_boxplot(aes(y=quot, group=plotable_Frame_1000$rounded), outlier.shape = NA, color = 'midnightblue', fill = 'lightblue', coef = 0) + geom_line(aes(y=theMedian), color = 'red')
  
  grid.arrange(plot20_30, plot75_125, plot500_600, plot1000, ncol=2,nrow=2, top = titleName)
}

createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/Automotive_5.json", "Evaluation 'Automotive'")
#createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/Office_Products_5.json", "Evaluation 'Office Products'")
#createPlot("C:/Users/Jonas/Desktop/FHkempten/6. Semester/Opinion Mining/Data/Pet_Supplies_5.json", "Evaluation 'Pet Supplies'")

```


