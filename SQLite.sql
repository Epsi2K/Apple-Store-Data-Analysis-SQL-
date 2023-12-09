CREATE table appleStore_description_combined AS

SELECT * from appleStore_description1

UNION ALL

SELECT * from appleStore_description2

UNION ALL

SELECT * from appleStore_description3

UNION ALL

SELECT * from appleStore_description4


**EDA**

--number of unique apps in both tablesAppleAppleStore

SELECT COUNT(DISTINCT id) as UniqueAppIDs
from AppleStore

SELECT count(DISTINCT id) as UniqueAppIDs
from appleStore_description_combined

-- check missing values in key fieldsAppleStore

SELECT Count(*) as MissingValues
from AppleStore
WHERE track_name is null or user_rating is null or prime_genre is NULL

SELECT count(*) as MissingValues
from appleStore_description_combined
WHERE app_desc is NULL

--number of apps per genre

SELECT prime_genre, COUNT(*) as NumApps
FROM AppleStore
group by prime_genre
ORDER by NumApps DESC

-- app rating

SELECT min(user_rating) as MinRating, 
       max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
FROM AppleStore

---distribution of priceAppleStore

SELECT 
	(price / 2) *2 as PriceBinStart,
    ((price / 2) *2) +2 as PriceBinEnd,
    COUNT(*) As NumApps
From AppleStore

group by PriceBinStart
Order By PriceBinStart


**Data analysis**
--Paid vs Free apps rating

SELECT Case
			when price > 0 then 'Paid'
            ELSE 'Free'
        End as App_Type,
        avg(user_rating) as Avg_Rating
from AppleStore
GROUP by App_Type

--Ratings vs language supported

SELECT CASE
		    WHEN lang_num < 10 Then '<10 Languages'
            WHEn lang_num BETWEEN 10 and 30 THEN '10-30 Languages'
            ELSE '>30 languages'
      End as language_bucket,
      avg(user_rating) as Avg_Rating
From AppleStore
GROUP by language_bucket
Order By Avg_Rating DESC

--check genres with low ratingAppleStore

SELECT prime_genre,
       avg(user_rating) as Avg_Rating
FROM AppleStore
GROUP by prime_genre
Order by Avg_Rating ASC
LIMIT 10

--app description length vs user 

SELECT case 
			when length(b.app_desc) < 500 then 'Short'
			when length(b.app_desc) BETWEEN 500 AND 1000 then 'Medium'
            else 'Long'
		END as description_length_bucket,
        avg(a.user_rating) as average_rating
from 
	 AppleStore as A
JOIN
	 appleStore_description_combined as b
on 
	a.id = b.id 
    
group by description_length_bucket
order by average_rating desc

       
--check top rated apps for each genre

SELECT
   prime_genre ,
   track_name,
   user_rating
FROM (
			SELECT
			prime_genre ,
			track_name,
			user_rating,
			RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot desc) as rank
  			From
  			AppleStore
  		  ) as a
where 
a.rank = 1








