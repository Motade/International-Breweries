---PROFIT ANALYSIS
---I. Within the space of the last three years, what was the profit worth of the breweries, 
---inclusive of the anglophone and the francophone territories

SELECT years, SUM(profit) AS Total_profit,
CASE 
WHEN countries IN ('Nigeria','Ghana') THEN 'Anglophone'
ELSE 'Francophone'
END AS territory
FROM int_breweries
GROUP BY years,territory
ORDER BY years



--- Compare the total profit between these two territories in order for the territory 
--- manager, Mr. Stone made a strategic decision that will aid profit maximization in 2020.
SELECT years, SUM(profit) AS Total_profit,
CASE 
WHEN countries IN ('Nigeria','Ghana') THEN 'Anglophone'
ELSE 'Francophone'
END AS territory
FROM int_breweries
GROUP BY years,territory
ORDER BY years


--- Country that generated the highest profit in 2019
SELECT countries, SUM(profit) AS Total_profit
FROM int_breweries
WHERE years = '2019'
GROUP BY countries
ORDER BY Total_profit DESC
LIMIT 3


---- Help him find the year with the highest profit.
SELECT years, SUM(profit) AS total_profit
FROM int_breweries
GROUP BY years
ORDER BY total_profit DESC


--- Which month in the three years was the least profit generated?
SELECT *
FROM
(SELECT*
FROM
(SELECT months,years,SUM(profit) AS total_profit
FROM int_breweries
WHERE years = '2017'
GROUP BY months, years
ORDER BY total_profit
LIMIT 1) AS P
 
UNION
 
SELECT *
FROM
(SELECT months,years,SUM(profit) AS total_profit
FROM int_breweries
WHERE years = '2018'
GROUP BY months, years
ORDER BY total_profit
LIMIT 1) AS Q
 
UNION
 
SELECT *
FROM
(SELECT months,years,SUM(profit) AS total_profit
FROM int_breweries
WHERE years = '2019'
GROUP BY months, years
ORDER BY total_profit
LIMIT 1) AS R) AS t
ORDER BY years



--- What was the minimum profit in the month of December 2018?
SELECT months,years, profit
FROM int_breweries
WHERE years = '2018' AND months = 'December'
ORDER BY profit
LIMIT 1


---Compare the profit in percentage for each of the month in 2019
WITH ptable AS
(SELECT months,
CASE
	WHEN months = 'January' THEN 1
	WHEN months = 'February' THEN 2
	WHEN months = 'March' THEN 3
	WHEN months = 'April' THEN 4
	WHEN months = 'May' THEN 5
	WHEN months = 'June' THEN 6
	WHEN months = 'July' THEN 7
	WHEN months = 'August' THEN 8
	WHEN months = 'September' THEN 9
	WHEN months = 'October' THEN 10
	WHEN months = 'November' THEN 11
	WHEN months = 'December'THEN 12
END AS month_no,
SUM(profit) AS total_profit
FROM int_breweries
WHERE years = '2019'
GROUP BY months
ORDER BY month_no) 

SELECT *, ROUND((total_profit * 1.0)/ SUM(total_profit)  OVER() * 100, 2) as percentage_profit
FROM ptable


---Which particular brand generated the highest profit in Senegal
SELECT brands, SUM(profit) AS total_profit
FROM int_breweries
WHERE countries = 'Senegal'
GROUP BY brands
ORDER BY total_profit DESC
LIMIT 3


--BRAND ANALYSIS
---Within the last two years, the brand manager wants to know the top three brands consumed in the francophone countries
WITH b_table AS 
(SELECT years, brands, SUM(quantity) AS total_quantity, countries
FROM int_breweries
WHERE years IN ('2018','2019') AND countries NOT IN ('Nigeria', 'Ghana')
GROUP BY years, brands, countries
ORDER BY years)

SELECT*
FROM
((SELECT *
FROM b_table
WHERE YEARS = '2019'
ORDER BY total_quantity DESC
LIMIT 3)

UNION

(SELECT *
FROM b_table
WHERE YEARS = '2018'
ORDER BY total_quantity DESC
LIMIT 3)) AS s
ORDER BY s.years, s.total_quantity DESC


---Find out the top two choice of consumer brands in Ghana
SELECT brands, SUM(quantity) AS total_quantity
FROM int_breweries
WHERE countries = 'Ghana'
GROUP BY brands
ORDER BY total_quantity DESC
LIMIT 2


---Find out the details of beers consumed in the past three years in the most oil rich country in West Africa
SELECT brands, SUM(quantity) AS total_quantity, SUM(profit) AS total_profit, years
FROM int_breweries
WHERE countries = 'Nigeria'
GROUP BY brands, years
ORDER BY years,total_quantity DESC



---Favorites malt brand in Anglophone region between 2018 and 2019
SELECT brands, SUM(quantity) AS total_quantity, SUM(profit) AS total_profit, years, countries
FROM int_breweries
WHERE brands LIKE '%malt' AND years BETWEEN '2018' and '2019' AND countries IN ('Nigeria', 'Ghana') 
GROUP BY brands, years, countries
ORDER BY years,total_quantity DESC


---Which brands sold the highest in 2019 in Nigeria
SELECT brands, SUM(quantity) AS total_quantity
FROM int_breweries
WHERE years = '2019'
GROUP BY brands
ORDER BY total_quantity DESC



---Favorites brand in South South region in Nigeria
SELECT region,brands,SUM(quantity) AS total_quantity
FROM int_breweries
WHERE countries = 'Nigeria' AND region = 'southsouth'
GROUP BY brands,region
ORDER BY total_quantity DESC


---Bear consumption in Nigeria
SELECT SUM(quantity) AS total_quantity,countries
FROM int_breweries
WHERE countries = 'Nigeria'
GROUP BY countries



---Level of consumption of Budweiser in the regions in Nigeria
SELECT region,SUM(quantity) AS total_quantity
FROM int_breweries
WHERE countries = 'Nigeria' AND brands = 'budweiser'
GROUP BY region
ORDER BY total_quantity DESC


---Level of consumption of Budweiser in the regions in Nigeria in 2019 (Decision on Promo
SELECT region,SUM(quantity) AS total_quantity
FROM int_breweries
WHERE countries = 'Nigeria' AND brands = 'budweiser' AND years = '2019'
GROUP BY region
ORDER BY total_quantity DESC

---GEO-LOCATION ANALYSIS
---Country with the highest consumption of beer.
SELECT countries,brands,SUM(quantity) AS total_quantity
FROM int_breweries
WHERE  brands NOT IN ('beta malt', 'grand malt')
GROUP BY countries, brands
ORDER BY total_quantity DESC


---Highest sales personnel of Budweiser in Senegal
SELECT sales_rep,SUM(quantity) AS total_quantity
FROM int_breweries
WHERE  brands = 'budweiser' AND countries = 'Senegal'
GROUP BY sales_rep
ORDER BY total_quantity DESC
LIMIT 


---Country with the highest profit of the fourth quarter in 2019
SELECT countries, months,SUM(profit) AS total_profit
FROM int_breweries
WHERE  years = '2019' AND months IN ('October','November', 'December')
GROUP BY countries, months
ORDER BY total_profit DESC
LIMIT 1


