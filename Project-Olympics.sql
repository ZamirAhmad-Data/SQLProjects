#In this project, my goal is to analyze a comprehensive Olympic History dataset covering a span of 120 years. 
#The dataset presents a unique opportunity to uncover intriguing insights and delve deeper into the world of the Olympic games. 
# I aim to extract valuable information and uncover fascinating facts about this global sporting event. 
#Through this exploration, I hope to gain a deeper understanding of the Olympics and shed light on its historical significance, trends, and notable achievements. 


use housingproject;
Select * From Olympics;
# 1. How many Olympics games have been held? 

SELECT  COUNT(distinct Games) as total_olympic_games
FROM Olympics;

# To date, 51 games have been held. 


#2. List down all Olympics games held so far 


SELECT DISTINCT year, season, city 
FROM Olympics
ORDER BY year;

#3. Total number of nations who participated in each olympics game?

SELECT games, 
       COUNT(DISTINCT NOC) as total_countries
FROM Olympics
GROUP BY games;

#Over the years, there has been a steady increase in the number of nations participating in the Olympic games. 
#For instance, during the 1896 Summer Olympics, 12 nations took part, whereas in the more recent 2016 Summer Olympics, 
#a remarkable 207 countries participated. This growth signifies the growing global interest and participation in the Olympic movement.
#Furthermore, it is notable that the number of participating nations is generally higher in the summer Olympics compared to the winter Olympics. 
#The summer Olympics attract a larger number of countries, showcasing the wider range of sports disciplines offered in the summer edition. 
#Conversely, the winter Olympics, focusing on winter sports, tend to have a slightly smaller participation from nations worldwide. 


#4. Which year saw the highest and lowest no of countries participating in olympics?

SELECT games,
       COUNT(DISTINCT NOC) AS total_countries,
       RANK() OVER (ORDER BY COUNT(DISTINCT NOC) DESC) as rank_1
FROM Olympics
GROUP BY games;

SELECT 
  Max(Case when rank_1 = 1 then Concat(games,'-', total_countries)End) as highest_countries,
  Max(Case when rank_1 = 51 then Concat(games,'-', total_countries) End) as lowest_countries
FROM 

(SELECT games,
       COUNT(DISTINCT NOC) AS total_countries,
       RANK() OVER (ORDER BY COUNT(DISTINCT NOC) DESC) as rank_1
FROM Olympics
GROUP BY games) as test;




#5. Which nation has participated in all of the olmpic games? 




CREATE TABLE play AS
SELECT O.*,
       N.region
FROM Olympics AS O
INNER JOIN NOC AS N
ON O.NOC = N.NOC; 



SELECT * 
FROM play;


SELECT region, COUNT(DISTINCT games)  AS total_participated_games
From play 
GROUP BY region
ORDER BY count(distinct games) DESC ;



#Interestingly there are four nations that have demonstrated remarkable consistency by participating in every single Olympic game throughout history. 
#These nations include France, Italy, Switzerland, and the United Kingdom



#6. Identitfy the sport which was played in all summer olympics?



SELECT sport, COUNT(DISTINCT games) AS no_of_games,
(Select COUNT(distinct games)
FROM play 
WHERE season = 'summer' ) as total_games
FROM play 
WHERE season = 'summer'
GROUP BY sport
ORDER BY no_of_games DESC;


# Athletics, Swimming,Cycling,Fencing anf Gymnastics where part of all summer olympics. 



#7. Which sports were just played only once in the olympics?


Select sport , count(DISTINCT games),games
From Olympics 
Group by games,sport
Having COUNT(DISTINCT games) = 1;



#8. Fetch the total no of sports played in each olympic games.

SELECT games, COUNT(DISTINCT sport) as no_of_sports
FROM play
GROUP BY games
ORDER BY  no_of_sports DESC;


#The table provides a comprehensive overview of the number of sports featured in each Olympic game. 
#For example, in the 2016 Summer Olympics, a total of 34 sports were included, offering a diverse range of competitive opportunities for participating countries. 
#On the other hand, the inaugural 1896 Summer Olympics had a more limited selection, with only 9 sports being contested.
#This trend reflects the progressive evolution of the Olympic games over the span of 120 years. 
# Over time more and more disciplines were added to the olympic games. 

#9. Fetch oldest athletes to win a gold medal


SELECT *
FROM play 
WHERE medal = 'Gold' AND NOT age = 'NA'
ORDER BY age DESC
LIMIT 5;  


# Oscas Gomer Swahn and Charles Jacobus were the two oldest gold winning athletes in the olympic games. 
# At the time of their gold medal win both were 64 years old.

#10. Find the Ratio of male and female athletes participated in all olympic games.
CREATE TABLE  sex_ratio AS
SELECT DISTINCT name ,sex 
FROM play;


SELECT
COUNT(CASE WHEN sex = 'M' THEN 1 END) as male_ratio,
COUNT(CASE WHEN sex= 'F' THEN 1 END) as female_ratio,
COUNT(Case when sex = 'M' THEN 1 END) / COUNT(CASE WHEN sex= 'F' THEN 1 END) AS female_ratio
FROM sex;


# The gender distribution in the Olympics reveals an interesting male-to-female ratio, 
# with approximately 1 male participant for every 2.98 female participants. 
#This indicates a higher representation of males in the Olympic games compared to females. 
#The data highlights that throughout Olympic history, a greater number of males have taken part in this global sporting event,


# 11. Fetch the top 5 Athletes who have won the most gold medals 

SELECT name, team, COUNT(medal) AS total_gold_medals
FROM play 
WHERE medal = 'Gold'
GROUP BY name,team
ORDER BY COUNT(medal) DESC
LIMIT 5;

#The table showcases the top five athletes with the highest number of gold medal wins in Olympic history. Notably, 
#Michael Phelps holds the record for the most gold medals earned, solidifying his position as the most successful athlete in Olympic history.

# 12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

SELECT name, team, COUNT(medal)
FROM play 
WHERE medal IN ('Gold','Silver','Bronze')
GROUP BY name,team
ORDER BY COUNT(medal) DESC
LIMIT 5;

# Within this table, you can find a compilation of the top five athletes who have garnered the most medals in Olympic history. 
#One athlete, in particular, stands out prominently: Michael Phelps, who has amassed an astonishing total of 28 Olympic medals. 
#Phelps' remarkable achievement solidifies his position as one of the most decorated athletes in the history of the Olympics. 




# 13.  Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.


SELECT region AS country, 
       COUNT(medal) AS total_medals, 
       Rank() Over(order by count(medal) DESC) as rnk
FROM play
WHERE  medal  != 'NA'
GROUP BY region ;

#In this table, countries are ranked based on their total number of medals won throughout Olympic history. 
#Notably, the United States claims the top spot, securing an impressive 5637 medal wins.



# 14. List down total gold, silver and bronze medals won by each country.




SELECT region AS country,
       SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0  END) AS gold,
       SUM(CASE WHEN medal = 'Silver' THEN 1  ELSE 0 end) AS silver,
       SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0  end) AS bronze
FROM play 
Group by region
ORDER by gold DESC;



#Within this table, you will find a comprehensive overview of all countries and their respective medal counts in Olympic history. 
#Notably, the United States emerges as a standout nation with an impressive tally of 2638 gold medals, 
#1641 silver medals, and 1358 bronze medals. 
#This remarkable accomplishment solidifies the United States' position as one of the most successful nations in Olympic competition



# 15. List down total gold, silver and bronze medals won by each country corresponding to each olympic games.



SELECT games,
       region AS country,
       SUM(CASE WHEN medal = 'Gold' THEN 1  ELSE 0 END) AS gold,
       SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
       SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze
FROM play 
Group by games,region;


#The tables provide a comprehensive breakdown of the medal counts for each country in their respective Olympic games. 
#Notably, in the 1896 Summer Olympics, Germany achieved notable success with 25 gold medals, 
#18 silver medals, and 2 bronze medals



# 16. Identify which country won the most gold, most silver and most bronze medals in each olympic games.

CREATE TABLE test1 AS
Select games, 
       country,
       gold,
       silver,
       bronze,
       Rank() Over( PARTITION BY games ORDER BY gold DESC) AS gold_rank,
       Rank() Over( PARTITION BY  games ORDER BY silver DESC) AS silver_rank,
       Rank() Over( PARTITION BY  games ORDER BY silver DESC) AS bronze_rank
FROM
(SELECT games,
       region as country,
       SUM(CASE WHEN medal = 'Gold' THEN 1  ELSE 0 END) AS gold,
       SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
       SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze
FROM play 
Group by games,region) AS new
ORDER by games,country;



SELECT * FROM test1;


SELECT games,
   MAX(CASE WHEN gold_rank = 1 THEN CONCAT(country, '-', gold ) END) AS max_gold,
   MAX(CASE WHEN silver_rank = 1 THEN CONCAT(country, '-', silver) END) AS max_silver,
   MAX(CASE WHEN bronze_rank = 1 THEN CONCAT(country, '-', bronze)  END) AS max_bronze
FROM test1
GROUP by games; 

#Within this table, you will find an insightful breakdown of the countries that have secured the highest number of gold, 
#silver, and bronze medals in each Olympic event. In the 1896 Olympia, Germany emerged as the dominant force, 
#claiming the most gold medals with a remarkable total of 25. Meanwhile, Greece distinguished itself by 
#securing the highest number of silver medals (18) and bronze medals (20) during that particular Olympic event. 




# 17. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.

CREATE TABLE test2
Select games, 
       country,
       gold,
       silver,
       bronze,
       total_medals,
       Rank() Over( PARTITION BY games ORDER BY gold DESC) AS gold_rank,
       Rank() Over( PARTITION BY games ORDER BY silver DESC) AS silver_rank,
       Rank() Over( PARTITION BY games ORDER BY silver DESC) AS bronze_rank,
       Rank() Over( PARTITION BY games ORDER BY total_medals DESC) AS total_medals_rank
FROM
(SELECT games,
       region as country,
       SUM(CASE WHEN medal = 'Gold' THEN 1  ELSE 0 END) AS gold,
       SUM(CASE WHEN  medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
       SUM(CASE WHEN  medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze,
       SUM(CASE WHEN  medal = 'Gold' THEN 1  ELSE 0 END) + 
       SUM(CASE WHEN  medal = 'Silver' THEN 1 ELSE 0 END) + 
       SUM(CASE WHEN  medal = 'Bronze' THEN 1 ELSE 0 END) AS total_medals
FROM play 
Group by games,region) AS new
ORDER by games,country; 



SELECT games,
       MAX(CASE WHEN gold_rank = 1 THEN CONCAT (country,'-', gold) END) AS max_gold,
       MAX(CASE WHEN silver_rank = 1 THEN CONCAT (country,'-', silver) END) AS max_silver,
       MAX(CASE WHEN bronze_rank = 1 THEN CONCAT (country,'-', bronze) END) AS max_bronze,
       MAX(CASE WHEN total_medals_rank = 1 THEN CONCAT (country,'-', total_medals) END) AS max_medals
FROM test2
GROUP by games;

#The table displays the countries that achieved the highest number of gold, silver, bronze, and total medals in each Olympic game. 
#Notably, in the 1986 Olympics, Greece emerged as the top-performing country with a remarkable total of 48 medals, 
#the highest number of medal wins among all participating nations.



# 18. Which countries have never won gold medal but have won silver/bronze medals?


SELECT region, gold, silver, bronze
FROM(
SELECT region,
     SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 End) AS gold,
     SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 End) AS silver,
	 SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 End) AS bronze       
FROM play
GROUP BY region)  AS test1
WHERE gold = 0
ORDER BY bronze DESC;

# The table provides a comprehensive overview of countries that have achieved silver or bronze medals in the Olympic Games but have yet to secure a gold medal. 
#For instance, Ghana stands out as an example, having won a notable tally of 22 bronze medals and 1 silver medal in its Olympic history.



# 19. In which Sport/event, India has won highest medals.

SELECT  distinct sport, COUNT(medal) AS total_medals
FROM play
WHERE medal != 'NA' AND region = 'India'
GROUP BY  sport 
LIMIT 1 ; 


#India has achieved significant success in the sport of hockey, 
#earning the majority of its medals in this discipline throughout its Olympic history. 
#With an impressive tally of 177 medals in hockey, 
#India has firmly established itself as a powerhouse in the sport on the Olympic stage.


# 20.  Break down all olympic games where India won medal for Hockey and how many medals in each olympic games

SELECT  team , sport, games , COUNT(medal) AS total_medals
FROM play 
WHERE team = 'India' AND medal != 'NA'
GROUP by team,sport,games
ORDER BY total_medals DESC;


#The table provides a breakdown of the medals won by India in hockey for each Olympic game. 
#Notably, in the 1948 Summer Olympics, India achieved an exceptional feat by winning a total of 20 medals in hockey, 
#marking the highest number of medals ever secured in a single Olympic event




