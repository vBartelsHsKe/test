
#### Einbinden der Libraries ####

library(jsonlite)
library(plyr)
library(dplyr)
library(data.table)
library(ggplot2)
library(gridExtra)


#### Funktion zur Berechnung der mittleren quadratischen Abweichung  ####
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

#### erzeugen des Ausgabeplots  ####
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

createPlotIndividualBias("./reviews_Toys_and_Games_5.json", "evaluation 'toys and games'", "individualBiasToysGames.jpeg")

