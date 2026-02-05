drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);


--data exploration
select count(*) from zepto;
select * from zepto;

--sample data
select * from zepto
limit 10;

--null values
SELECT * FROM zepto
WHERE name is NULL
OR
category is NULL
OR
mrp is NULL
OR
discountPercent is NULL
OR
discountSellingPrice is NULL
OR
weightInGms is NULL
OR
availableQuantity is NULL
OR
outOfStock is NULL
OR
quantity is NULL;

--different product categories
select DISTINCT category
FROM zepto
Order BY category;

--products in stock vs out of stock
select outOfStock, COUNT(*)
FROM zepto
GROUP BY outOfStock;

--product names present multiple times
select name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

--data cleaning

--products with price=0
select * from zepto
where mrp=0 OR discountSellingPrice=0;

DELETE FROM zepto 
where mrp=0;

--convert paisa to rupees
UPDATE zepto
SET mrp= mrp/100.0,
discountSellingPrice = discountSellingPrice/100.0;


select mrp, discountSellingPrice from zepto;

--1. Find the top 10 best-valued products based on the discount percentage
select DISTINCT name,mrp, discountPercent
from zepto
ORDER BY discountPercent DESC
LIMIT 10;

--2. What are the products with High MRP but Out of stock
select DISTINCT name,mrp
from zepto
Where outOfStock=TRUE and mrp>300
ORDER BY mrp DESC;

--3.Calculate Estimated Revenue for each category
Select category,
SUM(discountSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--4.Find all products where MRP is greater than Rs.500 and discount is less than 10%.
select DISTINCT name, mrp, discountPercent
from zepto
where mrp>500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

--5. Identify the top 5 categories offering the highest average discount percentage.
Select category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--6. Find the price per gram for products above 100g and sort_by best value
select DISTINCT name, weightIngms, discountSellingPrice,
ROUND(discountSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--7. Group the products into catgeories like low, medium, Bulk.
select DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
from zepto;

--8. What is the Total Inventory Weight Per Catgeory
select category,
SUM(weightInGms * availableQuantity) AS total_weight
from zepto
group by category
order by total_weight;


