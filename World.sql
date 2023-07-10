#
# In this Case Study, I will analyze 163 countries and 6 continents in 2020 using SQL and Tableau Public. My focus will be on various metrics such as fertility rate, GDP (PPP) per capita adjusted 
#for inflation and living expenses, life expectancy, meat consumption per person, median age, population growth rate, sex ratio, and suicide rate per 100,000 people. By comparing these metrics, 
#I aim to identify both differences and similarities among continents.
#Additionally, I will explore the relationships between these variables to gain insights. 
#Through this analysis, I hope to uncover patterns and trends that may highlight potential challenges for continents in the coming decades. 
#I believe this study will be intriguing and provide valuable information. Attached to this study, you will find the data files and Tableau visualizations.





create database world;
use world;


# The fertility table provides the fertility rate for 201 countries.


 # 1. The first step is to import and prepare the files to merge them into a single table.  
 # I'm  going to look at  duplicates, missing values and count the rows of the tables. 

SELECT * 
FROM world.fertility;





# To address the missing continent field for the country 'The Gambia', I will input 'Africa' as the continent value. 
UPDATE world.fertility AS t1
JOIN (
    SELECT Country
    FROM world.fertility
    WHERE Country = 'The Gambia'
) AS t2 ON t1.Country = t2.Country
SET t1.continent = 'Africa';



# Upon careful review, I identified a minor error in the continent field for the country 'Cyprus'. Cyrpus is an island country situated in Europe, rather than Asia.
Update world.fertility  as t1
Join( 
Select country 
From world.fertility
Where country = 'Cyprus')
as t2 On t1.country = t2.country
Set t1.continent = 'Europe'; 



SELECT * 
FROM world.gdp;
FROM world.gdp 
WHERE gdp_capita is null;

Select count(*) 
From world.gdp; 

Select count(Distinct country) 
From world.gdp; 

# In the GDP dataset, there are three columns: 'gdp_capita' representing the GDP per capita,
# 'country' indicating the country name, and 'iso-code' which represents the country code.
# Notably, the 'gdp_capita' column does not contain any missing values, ensuring a complete dataset in terms of GDP per capita information. 
# Within the table, we have identified 190 unique countries, demonstrating the breadth of coverage in our analysis.

SELECT * 
FROM world.life;

SELECT count(*) 
FROM world.life; 


SELECT count(*) 
WHERE country is null;

SELECT count(Distinct country) 
FROM world.life 
WHERE country is null;

SELECT * 
FROM life;

# 
#The life tables provide comprehensive data on the life expectancy of all countries. 
#This dataset comprises 185 rows and 3 columns. 
#Importantly, there are no missing rows in the dataset. 



SELECT * 
FROM meat; 
SELECT count(*) 
FROM meat;
SELECT count( distinct country) 
FROM meat;



#The meat table provides us the average meat consumption per person for all 187 countries in 2020.  
# 17.3 means that the average person in Afghanistan consumed 17.3 kg of meat in 2020. We have 3 columns and 187 rows and no missing values. 



SELECT * 
FROM median_age;
SELECT count(*) 
FROM median_age;
SELECT count(distinct country) 
FROM median_age;


# We have 223 rows, 3 columns and no missing rows in the median_age table . The median_age column gives us the median age of all coutries. We have one duplicate country, 
# which I will remove in the next few steps. 



SELECT * 
FROM pop_growth;
SELECT count(*) 
FROM pop_growth;
SELECT count(distinct country) 
FROM pop_growth;
SELECT count(*) 
FROM pop_growth
WHERE country is null;

#We have 207 rows, 3 columns and no missing rows in the pop_growth table . The population_growth column provides us the population growth rate for all countries in 2020. 

SELECT * 
FROM sex;
SELECT count(*) 
FROM sex;
SELECT count(distinct country) 
FROM sex;

#The table sex has 3 columns and 226 rows and no missing rows. The sex_ratio columns provides with the the male-to-female ratio.  
# A ratio of 1.03 indicates the country has 
# a slightly higher proportion of males compared to females.  

SELECT * 
FROM suicide;
SELECT count(*) 
FROM suicide; 
SELECT count(distinct country) 
FROM suicide; 
SELECT count(*) 
FROM suicide 
WHERE country is null;
# The 'suicide' table offers comprehensive data on suicide rates for every 100,000 people across all countries. 
# It is important to note that there are no missing values in this dataset


# In this step, I will perform a join operation to merge all the tables into a single unified table. 
# The join will be based on the 'country' and 'code' fields, which serve as common identifiers across the tables.


CREATE TABLE world
SELECT f1.country, f1.code, f1.continent, f1.fertility, g1.gdp_capita, l1.life_expectancy, m1.meat_cons,age1.median_age, p1.population_growth, 
s1.sex_ratio, suicide.suicide_rate
FROM fertility as f1 
JOIN gdp as g1 
On f1.code = g1.code and f1.country = g1.country
JOIN life as l1 
ON f1.code = l1.code and f1.country = l1.country 
JOIN median_age as age1 
ON f1.code = age1.code and f1.country = age1.country
JOIN meat as m1 
ON f1.code = m1.code and f1.country = m1.country
JOIN pop_growth as p1 
ON f1.code = p1.code and p1.country = f1.country
JOIN sex as s1 
ON f1.code = s1.code and s1.country = f1.country
JOIN suicide  
ON f1.code = suicide.code and f1.country = suicide.country; 
SELECT count(* ) 
FROM world;

# In the step, I'm looking at the newly created tables and makes sure that all countries have the right continent field. I will check for duplicates, missing values and I'm going count
# the number of distinct countries. 

UPDATE world as w1 
JOIN
(SELECT country 
FROM world_map
WHERE country = 'Antigua and Barbuda')
as t2 
ON t2.country = w1.country 
SET w1.continent = 'Africa'; 


SELECT * 
FROM world
LIMIT 5;



SELECT
count(*)
FROM world
WHERE country is NULL;



SELECT country, continent 
FROM world
WHERE continent = 'Asia';


SELECT country, continent 
WHERE continent = 'Europe';

# I removed a duplicated row
DELETE 
FROM world 
WHERE country = 'Russia' and fertility > 1.8;


SELECT country, continent 
FROM world
WHERE continent = 'Africa';

SELECT * 
FROM world;


SELECT country, continent 
FROM world
WHERE continent = 'Africa';

# I decided to remove all instances of the country Guinea from our dataset, 
# because I was unable to select a specific entry to keep while deleting the others. 

DELETE
FROM world
WHERE country = 'Guinea';


SELECT  country, continent
FROM world
Where continent = 'North America';

SELECT  country, continent
FROM world
Where continent = 'South America';
SELECT  country, continent
FROM world
Where continent = 'Oceania';



SELECT * 
FROM world;



# Top 10 countries with the highest fertility rate.  


SELECT country, fertility,continent
FROM world 
ORDER BY fertility desc
LIMIT 10;


#The table presents the top 10 countries worldwide with the highest fertility rates, 
#and interestingly, all ten countries are located in Africa. 
#Taking the lead is Somalia, which boasts the highest fertility rate of 6.1.



# Top 10 countries with the lowest fertility rates. 

SELECT country, fertility,continent
FROM world
ORDER BY fertility 
LIMIT 10;


# The presented table showcases the top 10 countries globally with the lowest birthrates.
# Remarkably, Singapore stands out with the lowest birth rate per woman, at 1.1. 
#Notably, among the top ten, there are two Asian countries  
#and a significant presence of eight European countries. This composition suggests that 
#Europe faces a pressing issue that requires prompt attention, as a sustained low birthrate 
#could lead to a potential population decline.




-------- Population growth 


SELECT country, continent, population_growth
FROM world
ORDER BY population_growth
LIMIT 10;

#The provided table presents the top 10 countries worldwide that encountered the lowest population growth. 
#Interestingly, all countries on the list experienced a minor decrease in their populations by a small percentage. 
#Among them, Latvia recorded the most significant population decline, with a reduction of 1.6%. 
#It is noteworthy that European countries dominate the list, as nine out of the ten countries 
#included are from Europe.



SELECT country, continent, population_growth
FROM world
ORDER BY population_growth desc
LIMIT 10;


#The table showcases the top ten countries that witnessed the most substantial percentage increase in their population. 
#Oman experienced the most significant increase in their population, with a growth of 9.13% .
#The list comprises two Asian countries and eight African countries,  
#highlighting the rapid population growth in Africa. Meanwhile, Europe's population is experiencing a decline,  
#indicating a contrasting demographic trend between the two regions. 



----- Median Age 

SELECT country, continent, median_age
FROM world
ORDER BY median_age
LIMIT 10;


# The presented table highlights the top ten countries with the most youthful population, 
#as determined by the median age. Notably, Niger claims the youngest population with a median age of 15.4 years. 
#It is worth mentioning that all the countries within the top ten belong to the African continent, 
#emphasizing the significant concentration of youthful populations in Africa.





SELECT country, continent, median_age
FROM world
ORDER BY median_age desc
LIMIT 10;


#The provided table displays the top ten countries worldwide with the most elderly populations
#based on the median age. Remarkably, nine out of the ten countries listed are located in Europe, 
#with Japan being the only exception. 
#This highlights Europe's prominence as a region with a significant concentration of older populations. 
#Furthermore, Europe is characterized by having some of the lowest fertility rates and slowest population growth rates. 
#These three variables—older population, low fertility rates, and slow population growth—are interconnected, as lower fertility rates 
#contribute to both reduced population growth and an increase in the proportion of older individuals within the population.

#One notable concern revolves around the increasing number of retirees who will rely on their pensions for support. 
#This demographic shift could lead to job vacancies that may not be adequately filled, potentially resulting in labor shortages across various sectors. 
#A consequence of reduced workforce participation is the subsequent decline in tax revenue generation for countries. 
#This predicament highlights the necessity to explore strategies to sustain adequate pension provision.
#One potential solution involves considering the recruitment of young individuals from developing countries and investing in their education and skills. 
# By attracting and supporting immigrants, countries can address the declining labor force and mitigate potential labor shortages. 
#This approach would not only help fill vacant job positions but also contribute to the overall economic growth and development of the host countries.




------- Life Expectancy 



SELECT country, continent, life_expectancy 
FROM world
ORDER BY life_expectancy 
LIMIT 10;

#The presented table showcases the top ten countries worldwide with the lowest life expectancy. 
#Notably, all the countries listed belong to the African continent. 
#The country with the lowest life expectancy among them is the Central African Republic, 
#with a value of 52.8.

SELECT country, continent, life_expectancy 
FROM world
ORDER BY life_expectancy desc
LIMIT 10;

#Now, let's examine the countries with the highest life expectancy. 
#Japan stands at the top with the highest average life expectancy of 84.5 years, closely followed by Singapore at 83.8 years and Italy at 83.4 years. 
#Notably, the list comprises six European countries, three Asian countries, and Australia.

#These countries have achieved high life expectancy due to a combination of factors that contribute to a good quality of life. 
#As a result, the population in these countries tends to live longer. However, this longevity presents a significant challenge 
#for these nations in terms of providing for their aging populations. As life expectancy increases, countries must address the 
#implications of supporting a larger elderly population, including healthcare, social welfare, and pension systems.



----------------- Gdp per capita

SELECT country, continent, gdp_capita
FROM world
ORDER BY gdp_capita
LIMIT 10;

#The provided list showcases the top countries worldwide with the lowest GDP (PPP) per capita. 
#The GDP per capita figures have been adjusted to account for living expenses and the inflation rate 
#specific to each country. Notably, Somalia stands out with the lowest GDP per capita, amounting to only 313 USD. 
#It is worth mentioning that all the countries included in the list belong to the African continent.

SELECT country, continent, gdp_capita
FROM world
ORDER BY gdp_capita desc
LIMIT 10;


#The presented table highlights the top ten countries worldwide with the highest GDP per capita. 
#At the pinnacle is Luxembourg, boasting a remarkable GDP per capita of 112,045 US dollars. 
#The list consists of a diverse range of countries, including five European countries, 
#four Asian countries, and one North American country.



------------------  Meat consumption per person 


SELECT country, continent, meat_cons
FROM world
ORDER BY meat_cons
LIMIT 10;

 #The table displays the countries worldwide that exhibited the lowest meat consumption per person (in kg) in 2020.
 #Notably, Bhutan stood out with an average meat consumption of only 3 kg per person during that year. 
 #It is important to note that meat consumption can be influenced by various factors, including GDP per capita, cultural considerations, and other relevant aspects.
 


SELECT country, continent, meat_cons
FROM world
ORDER BY meat_cons desc
LIMIT 10;

UPDATE world as w1
JOIN (
SELECT country 
FROM world 
WHERE country = 'The Bahamas') 
as t1 
ON t1.country = w1.country
Set w1.continent = 'North America' ;


#The top ten countries in meat consumption exhibit a diverse representation of regions. 
#Among them, four European countries, three North American countries, one Asian country, and Australia stand out. 
#Notably, the average person in Denmark consumed a significant amount of meat, with a consumption of 145.9 kg in 2020.
#There exists a noticeable contrast in meat consumption patterns between the Asian, African, and European regions. 
#The data suggests that Europe and North America tend to have higher levels of meat consumption compared to Asian and African regions. 
#This disparity reflects differing dietary preferences, cultural factors, and economic influences across these regions.



--------------- Sex_ratio

SELECT country, continent, sex_ratio
FROM world
ORDER BY sex_ratio
LIMIT  10; 


# The provided table showcases the top ten countries with the lowest Male-to-Female ratios,
# indicating a higher proportion of females compared to males. 
# Leading the list is Djibouti, with the lowest ratio recorded at 0.83. 
# This suggests a slightly higher number of females in relation to males within the country.
# Among the remaining nine countries, seven are from Europe, one is from Asia, and one is from Africa. The data suggests that European countries, 
#in particular, exhibit a trend of having more females than males, as indicated by their lower Male-to-Female ratios.


SELECT country, continent, sex_ratio
FROM world
ORDER BY sex_ratio desc
LIMIT  10; 


#The presented table highlights the top ten countries with the highest Male-to-Female ratios, 
#indicating a higher proportion of males compared to females. Leading the list is the United Arab Emirates, 
#with a Male-to-Female ratio of 2.56, the highest in the world.
#Among the remaining nine countries, eight are from Asia, one is from Africa, and one is from North America. 
#The data suggests that Asian countries, in particular, exhibit a trend of having more males than females, as indicated by their higher Male-to-Female ratios.
 
 
 

----- Suicide rate 


SELECT country, continent, suicide_rate
FROM world
ORDER BY suicide_rate desc
LIMIT  10; 


#The table showcases the top ten countries with the highest suicide rates per 100,000 individuals. 
#Remarkably, Guyana in South America claims the highest suicide rate in the world, with a rate of 30.2 suicides per 100,000 individuals.
#It is worth noting that the list comprises ten countries from five different continents, suggesting a global issue with suicide rates.

SELECT country, continent, suicide_rate
FROM world
ORDER BY suicide_rate 
LIMIT  10; 

#The table displays the top ten countries with the lowest suicide rates globally in 2020. 
#Remarkably, Barbados stands out with the lowest suicide rate, recorded at 0.4 suicides per 100,000 individuals.
#Among the countries listed, there is a diverse representation from various regions. 
#Five North American countries, three Asian countries, and two African countries are included in the list. 
#However, it would be inaccurate to draw a direct conclusion about happiness and life satisfaction solely based on suicide rates. 
#Multiple factors contribute to well-being and life satisfaction, including cultural, social, and economic factors that extend beyond the scope of suicide rates.


--------- Group by continent 

#In the following section, I will categorize the countries based on their respective continents and conduct cross-comparisons using various metrics.


Update world  as w1
Join 
(Select country 
From world 
where country = 'East Timor') 
as t1 
ON t1.country = w1.country 
Set w1.continent = 'Asia'; 





SELECT continent,round(avg(fertility),2) as 'Average Fertility rate'
FROM world
GROUP BY  continent 
ORDER BY avg(fertility) desc;

#The table presents the average fertility rates by continent in 2020. 
#Notably, Africa stands out with the highest fertility rate, recorded at 4.11 births per woman. 
#On the other hand, Europe exhibits the lowest fertility rate, with only 1.54 births per woman. 
#These figures highlight significant variations in fertility rates between the two continents.




SELECT continent,round(avg(population_growth),2) as 'Average Population Growth (%)'
FROM world
GROUP BY continent 
ORDER BY avg(population_growth) desc;

#In 2020, Africa recorded the highest average population growth rate compared to all other continents, 
#with a substantial value of 2.33%. This signifies a significant increase in the population size within Africa during that year. 
#On the other hand, Europe witnessed a much lower population growth rate, with only 0.18% growth recorded. 
#This indicates a comparatively slower rate of population increase within Europe in 2020.


SELECT continent,round(avg(gdp_capita),2) as 'Average GDP(PPP) per Capita'
FROM world
GROUP BY continent 
ORDER BY avg(gdp_capita) desc;


#In 2020, Europe exhibited the highest average GDP per capita among all continents. 
#On the other hand, Africa recorded the lowest GDP per capita, amounting to 6833 U.S dollars, 
#which represents only 15% of the average GDP per capita in Europe. This significant difference in GDP per capita underscores the substantial economic disparity 
#between Europe and the other five continents. 


SELECT continent,round(avg(life_expectancy),2) as 'Average life expectancy'
FROM world
GROUP BY continent 
ORDER BY avg(life_expectancy) desc;

#The table displays the average life expectancy by continent. In 2020, Europe recorded the highest life expectancy among all continents, 
#with an average of 79.34 years. Conversely, Africa exhibited the lowest life expectancy, with an average of 64.21 years. 
#This indicates a notable disparity in life expectancy between Europe and Africa during that year. 



SELECT continent,round(avg(meat_cons),2) as 'Average Meat consumption per person in kg'
FROM world
GROUP BY continent 
ORDER BY avg(meat_cons) desc;

#The table showcases the average meat consumption per person annually by continent. Europeans, on average, recorded the highest meat consumption per person, 
#reaching 77.57 kilograms annually. There is a significant variation in meat consumption between North America, South America, Oceania, Europe and Africa, and Asia.
#In 2020, the average person in South America consumed approximately 57.46 kilograms of meat, indicating a relatively high consumption. 
#OThe average person in Asia and Africa consumed 34.42 kilograms and 17.8 kilograms of meat, respectively, 
#demonstrating lower meat consumption rates compared to the other continents.
#These figures illustrate notable differences in meat consumption patterns across continents, 
#influenced by various factors such as dietary preferences, cultural practices, and economic considerations.


SELECT continent,round(avg(median_age),2) as 'Average Median Age'
FROM world
GROUP BY continent 
ORDER BY avg(median_age) desc;




#In 2020, Europe had the oldest population among the continents, with an average median age of 41.47 years. 
#This indicates a higher proportion of older individuals within the population. Conversely, Africa exhibited a relatively young population, 
#with an average median age of 21.11 years.
#The remaining continents had average median ages ranging between 27 and 30 years. These figures suggest that the populations 
#in those continents had a comparatively younger age structure, with a smaller proportion of older individuals.
#The disparity in median ages between Europe and Africa reflects the differences in demographic profiles and age distributions among the continents.


SELECT continent,round(avg(sex_ratio),2) as 'Average Sex Ratio'
FROM world
GROUP BY continent 
ORDER BY avg(sex_ratio) desc;

#Among all continents, Asia recorded the highest male-to-female ratio, with a value of 1.07. 
#This indicates a slightly higher proportion of males compared to females in the overall population of Asia. 
#On the other hand, the remaining continents displayed a relatively equal distribution of males and females, with similar proportions.
#It's worth noting that while Asia had a slightly higher male-to-female ratio, the difference was not significant enough to suggest a major imbalance in gender distribution. The ratios in other continents were closer to parity, indicating a relatively balanced proportion of males and females. 


SELECT continent,round(avg(suicide_rate),2) as 'Average Suicide rate per 100,000 people'
FROM world
GROUP BY continent 
ORDER BY avg(suicide_rate) desc;

#In terms of average suicide rates, South America had the highest rate among the continents, with an average of 11.68 suicides per 100,000 people. 
#This indicates a relatively higher prevalence of suicide in South America compared to other continents.
#On the other hand, Asia and North America exhibited the lowest average suicide rates, both approximately at 7.32 suicides per 100,000 people. 
#This suggests a relatively lower occurrence of suicide in these regions compared to South America.
#These figures provide a comparative overview of suicide rates across continents, highlighting the variations in prevalence. However, it's important to note that individual countries within each continent may still exhibit different suicide rates, and various factors contribute to suicidal behavior.

# I exported the world table to Tableau public to create the visualizations and complete the project. 
