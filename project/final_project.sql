
use grocerries
 
select item_nbr,
COUNT (id) as co
into count1
from train
GROUP BY item_nbr

select *,  year([date]) AS Year, month([date]) AS month
into #train1
FROM train
DROP TABLE #train1


SELECT a.[date], a.id, a.item_nbr, a.onpromotion, a.store_nbr, a.unit_sales, year(a.[date]) AS [Year], month(a.[date]) AS month
INTO #train2
FROM train AS a
left JOIN count1 As b
ON a.item_nbr=b.item_nbr
WHERE b.co >= 50000

select top 100 * from #train2

SELECT  item_nbr, store_nbr, [Year], [month], 
CAST(unit_sales AS FLOAT) AS unit_sales 
INTO #train3
FROM #train2

SELECT top 100 * from #train3

SELECT item_nbr, store_nbr, [Year], [month],
SUM (unit_sales) AS total_unit_sales
INTO #train4
FROM #train3
GROUP BY item_nbr, store_nbr, [Year], [month]

SELECT *  
INTO train5
FROM #train4

SELECT * from train5

-- sales over time table
SELECT item_nbr, store_nbr, [Year],[month],total_unit_sales, 
LAG(total_unit_sales,1) OVER (PARTITION BY item_nbr,store_nbr ORDER BY [Year],[month]) AS prev_month_sales,
LAG(total_unit_sales,3) OVER (PARTITION BY item_nbr,store_nbr ORDER BY [Year],[month]) AS prev_3month_sales,
AVG (total_unit_sales) OVER (PARTITION BY item_nbr,store_nbr ORDER BY [Year],[month] ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS avg_prev_3months_sales,
MIN (total_unit_sales) OVER (PARTITION BY item_nbr,store_nbr ORDER BY [Year],[month] ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS min_prev_3months_sales,
MAX (total_unit_sales) OVER (PARTITION BY item_nbr,store_nbr ORDER BY [Year],[month] ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS max_prev_3months_sales
INTO sales_over_time
from train5

SELECT Year([date]) AS [Year], month([date]) AS [month],
CAST(dcoilwtico AS FLOAT) AS dcoilwtico
INTO #oil1 
FROM oil
SELECT * from #oil1

--monnthlyoilpricetable---
SELECT [Year], [month],
AVG(dcoilwtico) AS monthly_oilprice_avg
INTO avg_oilprice_bymonth
FROM #oil1
WHERE dcoilwtico <> 0
GROUP BY [Year], [month]
ORDER BY [Year], [month]

--
SELECT  YEAR([date]) AS Year, month([date]) AS [month], *
INTO #holidays_events1
FROM holidays_events

SELECT [Year], [month],
SUM (CASE WHEN (([type]='Holiday' AND transferred='False') OR [type]='transfer') then 1 else 0 END) AS total_month_holidays 
INTO tot_holidays_by_month
FROM #holidays_events1
GROUP BY [Year], [month]

SELECT * FROM holidays_events

SELECT * from oil
order by  item_nbr,[year],[month]

select * from #train1



select [date], unit_sales
into timeseries_sales 
from train

SELECT * FROM train5

select * From holidays_events
order by [date]

SELECT count(distinct total_unit_sales)
from train5

select * from stores

--- items by families-----
SELECT a.item_nbr, a.family,
CASE WHEN (a.family = 'SEAFOOD') THEN 1 ELSE 0 END AS 'SEAFOOD',
CASE WHEN (a.family = 'LAWN AND GARDEN') THEN 1 ELSE 0 END AS 'LAWN AND GARDEN',
CASE WHEN (a.family = 'HOME AND KITCHEN I' ) THEN 1 ELSE 0 END AS 'HOME AND KITCHEN',
CASE WHEN (a.family = 'SCHOOL AND OFFICE SUPPLIES') THEN 1 ELSE 0 END AS 'SCHOOL AND OFFICE SUPPLIES',
CASE WHEN (a.family = 'AUTOMOTIVE') THEN 1 ELSE 0 END AS 'AUTOMOTIVE',
CASE WHEN (a.family = 'BOOKS') THEN 1 ELSE 0 END AS 'BOOKS',
CASE WHEN (a.family = 'BREAD/BAKERY') THEN 1 ELSE 0 END AS 'BREAD/BAKERY',
CASE WHEN (a.family = 'LINGERIE') THEN 1 ELSE 0 END AS 'LINGERIE',
CASE WHEN (a.family = 'BEVERAGES') THEN 1 ELSE 0 END AS 'BEVERAGES',
CASE WHEN (a.family = 'DAIRY') THEN 1 ELSE 0 END AS 'DAIRY',
CASE WHEN (a.family = 'PERSONAL CARE') THEN 1 ELSE 0 END AS 'PERSONAL CARE',
CASE WHEN (a.family = 'PREPARED FOOD') THEN 1 ELSE 0 END AS 'PREPARED FOOD',
CASE WHEN (a.family = 'MAGAZINES') THEN 1 ELSE 0 END AS 'MAGAZINES',
CASE WHEN (a.family = 'PET SUPPLIES') THEN 1 ELSE 0 END AS 'PET SUPPLIES',
CASE WHEN (a.family = 'HOME APPLIANCES') THEN 1 ELSE 0 END AS 'HOME APPLIANCES',
CASE WHEN (a.family = 'PRODUCE') THEN 1 ELSE 0 END AS 'PRODUCE',
CASE WHEN (a.family = 'HARDWARE') THEN 1 ELSE 0 END AS 'HARDWARE',
CASE WHEN (a.family = 'HOME CARE') THEN 1 ELSE 0 END AS 'HOME CARE',
CASE WHEN (a.family = 'FROZEN FOODS') THEN 1 ELSE 0 END AS 'FROZEN FOODS',
CASE WHEN (a.family = 'BEAUTY') THEN 1 ELSE 0 END AS 'BEAUTY',
CASE WHEN (a.family = 'POULTRY') THEN 1 ELSE 0 END AS 'POULTRY',
CASE WHEN (a.family = 'PLAYERS AND ELECTRONICS') THEN 1 ELSE 0 END AS 'PLAYERS AND ELECTRONICS',
CASE WHEN (a.family = 'CELEBRATION') THEN 1 ELSE 0 END AS 'CELEBRATION',
CASE WHEN (a.family = 'GROCERY II') THEN 1 ELSE 0 END AS 'GROCERY II',
CASE WHEN (a.family = '"LIQUOR') THEN 1 ELSE 0 END AS '"LIQUOR',
CASE WHEN (a.family = 'MEATS') THEN 1 ELSE 0 END AS 'MEATS',
CASE WHEN (a.family = 'EGGS') THEN 1 ELSE 0 END AS 'EGGS',
CASE WHEN (a.family = 'LADIESWEAR') THEN 1 ELSE 0 END AS 'LADIESWEAR',
CASE WHEN (a.family = 'GROCERY I') THEN 1 ELSE 0 END AS 'GROCERY I',
CASE WHEN (a.family = 'BABY CARE') THEN 1 ELSE 0 END AS 'BABY CARE',
CASE WHEN (a.family = 'CLEANING') THEN 1 ELSE 0 END AS 'CLEANING',
CASE WHEN (a.family = 'HOME AND KITCHEN II') THEN 1 ELSE 0 END AS 'HOME AND KITCHEN II',
CASE WHEN (a.family = 'DELI') THEN 1 ELSE 0 END AS 'DELI'
INTO families
from items AS a 
inner join count1 AS b ON a.item_nbr=b.item_nbr
WHERE b.co >= 50000


SELECT * FROM items_by_families



DROP TABLE items_by_families

SELECT * FROM stores

SELECT [type],
count (store_nbr)
FROM stores 
GROUP BY [type]

----store_type_table----
SELECT store_nbr,
CASE WHEN ([type] = 'A') THEN 1 ELSE 0 END AS 'store_typeA',
CASE WHEN ([type] = 'B') THEN 1 ELSE 0 END AS 'store_typeB',
CASE WHEN ([type] = 'C' ) THEN 1 ELSE 0 END AS 'store_typeC',
CASE WHEN ([type] = 'D') THEN 1 ELSE 0 END AS 'store_typeD',
CASE WHEN ([type] = 'E') THEN 1 ELSE 0 END AS 'store_typeE'
INTO store_type_by_store
FROM stores

SELECT cluster, count(store_nbr)
FROM stores
GROUP BY cluster
ORDER BY cluster 


SELECT store_nbr,
CASE WHEN (cluster = 1) THEN 1 ELSE 0 END AS 'cluster1',
CASE WHEN (cluster = 2) THEN 1 ELSE 0 END AS 'cluster2',
CASE WHEN (cluster = 3) THEN 1 ELSE 0 END AS 'cluster3',
CASE WHEN (cluster = 4) THEN 1 ELSE 0 END AS 'cluster4',
CASE WHEN (cluster = 5) THEN 1 ELSE 0 END AS 'cluster5',
CASE WHEN (cluster = 6) THEN 1 ELSE 0 END AS 'cluster6',
CASE WHEN (cluster = 7) THEN 1 ELSE 0 END AS 'cluster7',
CASE WHEN (cluster = 8) THEN 1 ELSE 0 END AS 'cluster8',
CASE WHEN (cluster = 9) THEN 1 ELSE 0 END AS 'cluster9',
CASE WHEN (cluster = 10) THEN 1 ELSE 0 END AS 'cluster10',
CASE WHEN (cluster = 11) THEN 1 ELSE 0 END AS 'cluster11',
CASE WHEN (cluster = 12) THEN 1 ELSE 0 END AS 'cluster12',
CASE WHEN (cluster = 13) THEN 1 ELSE 0 END AS 'cluster13',
CASE WHEN (cluster = 14) THEN 1 ELSE 0 END AS 'cluster14',
CASE WHEN (cluster = 15) THEN 1 ELSE 0 END AS 'cluster15',
CASE WHEN (cluster = 16) THEN 1 ELSE 0 END AS 'cluster16',
CASE WHEN (cluster = 17) THEN 1 ELSE 0 END AS 'cluster17'
INTO store_cluster_by_store
FROM stores



SELECT city,
count (store_nbr)
FROM stores 
GROUP BY city


---city category---
SELECT store_nbr, 
CASE WHEN (city ='Ambato') THEN 1 ELSE 0 END AS 'city_Ambato',
CASE WHEN (city ='Babahoyo') THEN 1 ELSE 0 END AS 'city_Babahoyo',
CASE WHEN (city ='Cayambe') THEN 1 ELSE 0 END AS 'city_Cayambe',
CASE WHEN (city ='Cuenca') THEN 1 ELSE 0 END AS 'city_Cuenca',
CASE WHEN (city ='Daule') THEN 1 ELSE 0 END AS 'city_Daule',
CASE WHEN (city ='El Carmen') THEN 1 ELSE 0 END AS 'city_El Carmen',
CASE WHEN (city ='Esmeraldas') THEN 1 ELSE 0 END AS 'city_Esmeraldas',
CASE WHEN (city ='Guaranda') THEN 1 ELSE 0 END AS 'city_Guaranda',
CASE WHEN (city ='Guayaquil') THEN 1 ELSE 0 END AS 'city_Guayaquil',
CASE WHEN (city ='Ibarra') THEN 1 ELSE 0 END AS 'city_Ibarra',
CASE WHEN (city ='Latacunga') THEN 1 ELSE 0 END AS 'city_Latacunga',
CASE WHEN (city ='Libertad') THEN 1 ELSE 0 END AS 'city_Libertad',
CASE WHEN (city ='Loja') THEN 1 ELSE 0 END AS 'city_Loja',
CASE WHEN (city ='Machala') THEN 1 ELSE 0 END AS 'city_Machala',
CASE WHEN (city ='Manta') THEN 1 ELSE 0 END AS 'city_Manta',
CASE WHEN (city ='Playas') THEN 1 ELSE 0 END AS 'city_Playas',
CASE WHEN (city ='Puyo') THEN 1 ELSE 0 END AS 'city_Puyo',
CASE WHEN (city ='Quevedo') THEN 1 ELSE 0 END AS 'city_Quevedo',
CASE WHEN (city ='Quito') THEN 1 ELSE 0 END AS 'city_Quito',
CASE WHEN (city ='Riobamba') THEN 1 ELSE 0 END AS 'city_Riobamba',
CASE WHEN (city ='Salinas') THEN 1 ELSE 0 END AS 'city_Salinas',
CASE WHEN (city ='Santo Domingo') THEN 1 ELSE 0 END AS 'city_Santo Domingo'
INTO store_nbr_by_city
from stores

DROP TABLE st

SELECT * FROM stores

SELECT [date],Year([date]) AS [Year], month([date]) AS [month], store_nbr,
CAST(transactions AS FLOAT) AS transactions 
INTO #transactions1
FROM transactions

SELECT * FROM #transactions1
----transactions by store table-----
SELECT [Year],[month],store_nbr,
SUM (transactions) AS total_month_transactions
INTO transaction_by_store
FROM #transactions1
GROUP BY [Year],[month],store_nbr

SELECT * FROM transaction_by_store


SELECT  store_nbr, [Year],[month],total_month_transactions, 
LAG(total_month_transactions,1) OVER (PARTITION BY store_nbr ORDER BY [Year],[month]) AS prev_month_transactions,
LAG(total_month_transactions,3) OVER (PARTITION BY store_nbr ORDER BY [Year],[month]) AS prev_3month_transactions,
AVG (total_month_transactions) OVER (PARTITION BY store_nbr ORDER BY [Year],[month] ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS avg_prev_3months_transactions,
MIN (total_month_transactions) OVER (PARTITION BY store_nbr ORDER BY [Year],[month] ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS min_prev_3months_transactions,
MAX (total_month_transactions) OVER (PARTITION BY store_nbr ORDER BY [Year],[month] ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS max_prev_3months_transactions
INTO transactions_over_time
from transaction_by_store



SELECT * FROM transactions
SELECT * FROM stores 
SELECT * FROM avg_oilprice_bymonth

FROM #transactions1

SELECT * FROM transactions_over_time
SELECT * FROM items

SELECT TOP 100 * FROM train5
SELECT TOP 100 * FROM sales_over_time


GO 



SELECT * FROM project_flatfilev

SELECT TOP 100 * FROM train5

SELECT * FROM stores

SELECT city,
count (distinct store_nbr) AS total_city_stores
INTO #stores_by_cities
FROM stores 
GROUP BY city

SELECT city,total_city_stores, cast(total_city_stores AS float)/54*100 AS total_store_fraction 
INTO total_store_perc_by_city
FROM #stores_by_cities

SELECT * FROM total_store_perc_by_city

SELECT TOP 100 * FROM train5
SELECT TOP 100 * FROM stores

SELECT a.*, b.city
INTO train_city
FROM train5 AS a
INNER JOIN stores AS b
ON a.store_nbr=b.store_nbr

SELECT * FROM train_city

SELECT city,[Year],[month],
SUM(total_unit_sales) AS total_city_sales
INTO total_sales_by_city
FROM train_city
GROUP BY city,[Year],[month]

SELECT [Year],[month],
SUM(total_unit_sales) AS total_month_sales
INTO total_sales_by_month
FROM train_city
GROUP BY [Year],[month]

SELECT * FROM total_sales_by_city
SELECT * FROM total_sales_by_month

SELECT a.*, a.total_city_sales/b.total_month_sales*100 AS sales_perc
INTO sales_by_cities
FROM total_sales_by_city AS a
INNER JOIN total_sales_by_month AS b 
ON a.[Year]=b.[Year] AND a.[month]=b.[month]

SELECT TOP 100 * FROM #train2

SELECT item_nbr,[Year],[month],
sum(CASE WHEN onpromotion='TRUE' THEN 1 ELSE 0 END) AS total_month_onpromotion 
INTO onprom_by_month
FROM #train2
GROUP BY item_nbr,[Year],[month]

DROP TABLE onprom_by_month



SELECT * FROM sales_by_cities
SELECT * FROM stores

SELECT city, 
COUNT (store_nbr) AS total_city_stores,
CAST(COUNT (store_nbr)AS float)/54*100 AS tot_stores_percentage
INTO city_total_stores
FROM stores
GROUP BY city

SELECT * FROM sales_by_cities
SELECT * FROM city_total_stores



CREATE VIEW project_flatfilev AS 
SELECT a.item_nbr, a.store_nbr, a.[Year], a.[month], a.total_unit_sales,
b.city, b.[state], b.[type] AS store_type, b.cluster AS store_cluster,
c.prev_month_sales, c.prev_3month_sales, c.avg_prev_3months_sales, c.min_prev_3months_sales, c.max_prev_3months_sales,
d.monthly_oilprice_avg,
e.total_month_holidays,
f.total_month_transactions,
g.prev_month_transactions, g.prev_3month_transactions, g.avg_prev_3months_transactions, g.min_prev_3months_transactions, g.max_prev_3months_transactions,
h.family, h.class, h.perishable,
i.SEAFOOD, i.[LAWN AND GARDEN],i.[HOME AND KITCHEN], i.[SCHOOL AND OFFICE SUPPLIES],i.AUTOMOTIVE,i.BOOKS,
i.[BREAD/BAKERY], i.LINGERIE, i.BEVERAGES, i.DAIRY, i.[PERSONAL CARE],
i.[PREPARED FOOD],i.MAGAZINES,i.[PET SUPPLIES],i.[HOME APPLIANCES],i.PRODUCE,i.HARDWARE,i.[HOME CARE], i.[FROZEN FOODS],
i.BEAUTY,i.POULTRY,i.[PLAYERS AND ELECTRONICS],i.CELEBRATION,i.[GROCERY II],i."""LIQUOR", i.MEATS, i.EGGS, i.LADIESWEAR,
i.[GROCERY I], i.[BABY CARE], i.CLEANING, i.[HOME AND KITCHEN II], i.DELI,
j.store_typeA, j.store_typeB, j.store_typeC, j.store_typeD, j.store_typeE,
k.city_Ambato, k.city_Babahoyo, k.city_Cayambe, k.city_Cuenca,k.city_Daule,
k.[city_El Carmen],k.city_Esmeraldas,k.city_Guaranda,k.city_Guayaquil,k.city_Ibarra,
k.city_Latacunga,k.city_Libertad,k.city_Loja, k.city_Machala, k.city_Manta,
k.city_Playas,k.city_Puyo,k.city_Quevedo,k.city_Quito,k.city_Riobamba,
k.city_Salinas,k.[city_Santo Domingo]
FROM train5 AS a
INNER JOIN stores AS b
ON a.store_nbr=b.store_nbr
INNER JOIN sales_over_time AS c 
ON a.item_nbr=c.item_nbr AND a.store_nbr=c.store_nbr AND a.[Year]=c.[Year] AND a.[month]=c.[month]
INNER JOIN avg_oilprice_bymonth AS d 
ON a.[Year]=d.[Year] AND a.[month]=d.[month]
INNER JOIN tot_holidays_by_month AS e 
ON a.[Year]=e.[Year] AND a.[month]=e.[month]
INNER JOIN transaction_by_store AS f 
ON a.[month]=f.[month] AND a.[Year]=f.[Year] AND a.store_nbr=f.store_nbr
INNER JOIN transactions_over_time AS g 
ON a.store_nbr=g.store_nbr AND a.[Year]=g.[Year] AND a.[month]=g.[month]
INNER JOIN items AS h 
ON a.item_nbr=h.item_nbr
INNER JOIN families AS i 
ON a.item_nbr=i.item_nbr
INNER JOIN store_type_by_store AS j 
ON a.store_nbr=j.store_nbr
INNER JOIN store_nbr_by_city AS k 
ON a.store_nbr=k.store_nbr

CREATE VIEW project_flatfilev1 AS 
SELECT a.item_nbr, a.store_nbr, a.[Year], a.[month], a.total_unit_sales,
c.prev_month_sales, c.prev_3month_sales, c.avg_prev_3months_sales, c.min_prev_3months_sales, c.max_prev_3months_sales,
d.monthly_oilprice_avg,
e.total_month_holidays,
f.total_month_transactions,
g.prev_month_transactions, g.prev_3month_transactions, g.avg_prev_3months_transactions, g.min_prev_3months_transactions, g.max_prev_3months_transactions,
h.perishable,
i.SEAFOOD, i.[LAWN AND GARDEN],i.[HOME AND KITCHEN], i.[SCHOOL AND OFFICE SUPPLIES],i.AUTOMOTIVE,i.BOOKS,
i.[BREAD/BAKERY], i.LINGERIE, i.BEVERAGES, i.DAIRY, i.[PERSONAL CARE],
i.[PREPARED FOOD],i.MAGAZINES,i.[PET SUPPLIES],i.[HOME APPLIANCES],i.PRODUCE,i.HARDWARE,i.[HOME CARE], i.[FROZEN FOODS],
i.BEAUTY,i.POULTRY,i.[PLAYERS AND ELECTRONICS],i.CELEBRATION,i.[GROCERY II],i."""LIQUOR", i.MEATS, i.EGGS, i.LADIESWEAR,
i.[GROCERY I], i.[BABY CARE], i.CLEANING, i.[HOME AND KITCHEN II], i.DELI,
j.store_typeA, j.store_typeB, j.store_typeC, j.store_typeD, j.store_typeE,
k.city_Ambato, k.city_Babahoyo, k.city_Cayambe, k.city_Cuenca,k.city_Daule,
k.[city_El Carmen],k.city_Esmeraldas,k.city_Guaranda,k.city_Guayaquil,k.city_Ibarra,
k.city_Latacunga,k.city_Libertad,k.city_Loja, k.city_Machala, k.city_Manta,
k.city_Playas,k.city_Puyo,k.city_Quevedo,k.city_Quito,k.city_Riobamba,
k.city_Salinas,k.[city_Santo Domingo],
l.total_city_stores,l.tot_stores_percentage,m.total_city_sales,m.sales_perc,n.total_month_onpromotion
FROM train5 AS a
INNER JOIN stores AS b
ON a.store_nbr=b.store_nbr
INNER JOIN sales_over_time AS c 
ON a.item_nbr=c.item_nbr AND a.store_nbr=c.store_nbr AND a.[Year]=c.[Year] AND a.[month]=c.[month]
INNER JOIN avg_oilprice_bymonth AS d 
ON a.[Year]=d.[Year] AND a.[month]=d.[month]
INNER JOIN tot_holidays_by_month AS e 
ON a.[Year]=e.[Year] AND a.[month]=e.[month]
INNER JOIN transaction_by_store AS f 
ON a.[month]=f.[month] AND a.[Year]=f.[Year] AND a.store_nbr=f.store_nbr
INNER JOIN transactions_over_time AS g 
ON a.store_nbr=g.store_nbr AND a.[Year]=g.[Year] AND a.[month]=g.[month]
INNER JOIN items AS h 
ON a.item_nbr=h.item_nbr
INNER JOIN families AS i 
ON a.item_nbr=i.item_nbr
INNER JOIN store_type_by_store AS j 
ON a.store_nbr=j.store_nbr
INNER JOIN store_nbr_by_city AS k 
ON a.store_nbr=k.store_nbr
INNER JOIN city_total_stores AS l 
ON b.city=l.city
INNER JOIN sales_by_cities AS m
ON a.[Year]=m.[Year] AND a.[month]=m.[month]
INNER JOIN onprom_by_month AS n 
ON a.item_nbr=n.item_nbr AND a.[Year]=n.[Year] AND a.[month]=n.[month]

select * from project_flatfilev1