<p align="center">
  <a href="https://hs-kempten.de/">
    <img src="https://www.hs-kempten.de/fileadmin/fh-kempten/HK/Logo_Studierende/logo-hs-kempten-rgb-screen.jpg" alt="University of Applied Sciences Kempten logo" width=488.5 height=264>
  </a>

  <h3 align="center">Opinion-Mining and Meta-Opinion-Mining with Amazon-Reviewdata</h3>

  <p align="center">
    <a href="https://vbartelshske.github.io/)"><strong>Presentation of research results</strong></a>
</p>
<br>


##  Table of contents

1. [Data set](#data-set)
2. [Tools & setup](#tools--setup)
3. [Hypothesis](#hypothesis)
   1. [Brilliant but cruel](#brilliant-but-cruel)
   2. [Conformity](#conformity)
   3. [Individual-Bias](#individual-bias)
   4. [Text quality](#text-quality)
4. [Power law](#power-law)
   1. [Textlength](#textlength)
   2. [Total Votes](#total-votes)
   3. [Helpful Voters](#helpful-voters)
5. [Analysis of the most used words](#analysis-of-the-most-used-words)
   1. [Wordcloud](#wordcloud)    
   2. [Barplot](#barplot)
6. [Creators](#creators)
7. [License](#licence)



## Data set

Made possible with data from <a href="https://cseweb.ucsd.edu/~jmcauley/">
Julian McAuley</a>. Analysis of the following categories:

*   [Movies and TV](./images/movies-tv)
*   [CDs and Vinyl](./images/cds-vinyl)
*   [Clothing, Shoes and Jewelry](./images/clothing-shoes-jewelry)
*   [Home and Kitchen](./images/home-kitchen)
*   [Kindle Store](./images/kindle_store)
*   [Sports and Outdoors](./images/sports-outdoors)
*   [Cell Phones and Accessories](./images/cell_phones-accessories)
*   [Health and Personal Care](./images/health-personal_care)
*   [Toys and Games](./images/toys-games)
*   [Video Games](./images/video_games)
*   [Tools and Home Improvement](./images/tools-home_improvement)
*   [Beauty](./images/beauty)
*   [Apps for Android](./images/apps_for_android)
*   [Office Products](./images/office_products)
*   [Pet Supplies](./images/pet_supplies)
*   [Automotive](./images/automotive)
*   [Grocery and Gourmet Food](./images/grocery-gourmet_food)
*   [Patio, Lawn and Garden](./images/patio-lawn-garden)
*   [Baby](./images/baby)
*   [Digital Music](./images/digital_music)
*   [Musical Instruments](./images/musical_instruments)
*   [Amazon Instant Video](./images/amazon_instant_video)
*   [Books](./images/books)
*   [Electronics](./images/electronics)

## Tools & setup

To get started you need to install the latest R language packge and the R-compatible IDE of your choice. We suggest you use RStudio. 


## Hypothesis

### Brilliant but cruel
![](./images/cds-vinyl/brilliantButCruelCDsVinyl.gif)

![](./images/video_games/brilliantButCruelVideoGames.gif)


### Conformity
![](./images/movies/)

![](./images/kindle_store/conformityKindleStore.gif)


### Individual-Bias 
![](./images/cds-vinyl/individualBiasCDsVinyl.gif)

![](./images/beauty/individualBiasBeauty.gif)


### Text quality
![](./images/health-personal_care/scatterPlotwordcountHealthPersonalCare.gif)

![](./images/home-kitchen/scatterPlotWordCountHomeKitchen.gif)


## Power law

### Textlength

![](./images/cds-vinyl/c_compareWordcountToOccurenceCDs_Vinyl.gif)
![](./images/cds-vinyl/c_powerlawWordcountCDs_Vinyl.gif)

![](./images/electronics/c_compareWordcountToOccurence_Electronics.gif)
![](./images/electronics/c_powerlawWordcount_Electronics.gif)


![](./images/movies-tv/c_compareWordcountToOccurenceMovies_TV.gif)
![](./images/movies-tv/c_powerlawWordcountMovies_TV.gif)


### Total Votes

![](./images/cds-vinyl/b_compareVotersToOccurenceCDs_Vinyl.gif)
![](./images/cds-vinyl/b_powerlawVotersCDs_Vinyl.gif)

![](./images/electronics/b_compareVotersToOccurence_Electronics.gif)
![](./images/electronics/b_powerlawVoters_Electronics.gif)

![](./images/movies-tv/b_compareVotersToOccurenceMovies_TV.gif)
![](./images/movies-tv/b_powerlawVotersMovies_TV.gif)


### Helpful Voters

![](./images/cds-vinyl/a_comparehelpfulVotersToOccurenceCDs_Vinyl.gif)
![](./images/cds-vinyl/a_powerlawHelpfulVotersCDs_Vinyl.gif)

![](./images/electronics/a_comparehelpfulVotersToOccurence_Electronics.gif)
![](./images/electronics/a_powerlawHelpfulVoters_Electronics.gif)

![](./images/movies-tv/a_comparehelpfulVotersToOccurenceMovies_TV.gif)
![](./images/movies-tv/a_powerlawHelpfulVotersMovies_TV.gif)


## Analysis of the most used words

### Wordcloud
![](./images/health-personal_care/plotWordcloudEvaluationHealthandPersonalCare.png)

![](./images/amazon_instant_video/plotWordcloudEvaluationAmazonInstantVideo.png)


### Barplot

![](./images/toys-games/plotWordfrequencyEvaluationToysandGames.png)

![](./images/beauty/plotWordfrequencyEvaluationBeauty.png)

   
 ## Creators
 
 For questions please contact:<br/>
 <a href="https://www.hs-kempten.de/index.php?id=4238&typo3state=persons&lsfid=1000329&L=1">
 Prof. Staudacher</a>
 
 ## Licence
 
