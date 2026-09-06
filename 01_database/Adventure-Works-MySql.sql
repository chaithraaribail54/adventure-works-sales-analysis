## Que-0;
show databases;
USE adventureworks;
-- Que -0
## 0. Union of Fact Internet sales and Fact internet sales new

CREATE TABLE sales AS
SELECT ProductKey,
       OrderDateKey,
       DueDateKey,
       ShipDateKey,
       CustomerKey,
       PromotionKey,
       CurrencyKey,
       SalesTerritoryKey,
       SalesOrderNumber,
       SalesOrderLineNumber,
       RevisionNumber,
       OrderQuantity,
       UnitPrice,
       ExtendedAmount,
       UnitPriceDiscountPct,
       DiscountAmount,
       ProductStandardCost,
       SalesAmount,
       TaxAmt,
       Freight,
       CarrierTrackingNumber,
       CustomerPONumber,
       OrderDate,
       DueDate,
       ShipDate
FROM factinternetsales

UNION ALL

SELECT ProductKey,
       OrderDateKey,
       DueDateKey,
       ShipDateKey,
       CustomerKey,
       PromotionKey,
       CurrencyKey,
       SalesTerritoryKey,
       SalesOrderNumber,
       SalesOrderLineNumber,
       RevisionNumber,
       OrderQuantity,
       UnitPrice,
       ExtendedAmount,
       UnitPriceDiscountPct,
       DiscountAmount,
       ProductStandardCost,
       SalesAmount,
       TaxAmt,
       Freight,
       CarrierTrackingNumber,
       CustomerPONumber,
       OrderDate,
       DueDate,
       ShipDate
FROM fact_internet_sales_new;
INSERT INTO factinternetsales
SELECT *
FROM fact_internet_sales_new;
/*ALTER TABLE factinternetsales
ADD ProductionCost DECIMAL(18,2);*/


/* DROP TABLE  Sales;
describe factinternetsales;
describe fact_internet_sales_new;*/

## 	Que-1;
SELECT
    Sales.ProductKey,
    dimproduct.EnglishProductName
FROM Sales
INNER JOIN dimproduct
ON Sales.ProductKey = dimproduct.ProductKey;

# Que-2
SELECT
    CONCAT(
        dimcustomer.Title, ' ',
        dimcustomer.FirstName, ' ',
        dimcustomer.MiddleName, ' ',
        dimcustomer.LastName
    ) AS CustomerFullName,
    dimproduct.`Unit price` AS UnitPrice
FROM Sales
INNER JOIN dimcustomer
    ON Sales.CustomerKey = dimcustomer.CustomerKey
INNER JOIN dimproduct
    ON Sales.ProductKey = dimproduct.ProductKey;
    
/*Que-3*/
-- Q3(a): create Order Date
SELECT STR_TO_DATE(OrderDateKey, '%Y%m%d') AS OrderDate
FROM Sales;

-- Q3(b): create year
SELECT YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS Year
FROM Sales;
-- Q3(c): create Month
SELECT
MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d')) AS MonthNo
FROM Sales;
-- Q3(d): create Month Full Name
SELECT
MONTHNAME(STR_TO_DATE(OrderDateKey,'%Y%m%d')) AS MonthFullName
FROM Sales;
-- Q3(e): create Quarter
SELECT
CONCAT('Q',QUARTER(STR_TO_DATE(OrderDateKey,'%Y%m%d'))) AS Quarter
FROM Sales;
-- Q3(f):create Year-Month
SELECT
DATE_FORMAT(STR_TO_DATE(OrderDateKey,'%Y%m%d'),'%Y-%b') AS YearMonth
FROM Sales;
-- Q3(g):create Weekday Number
SELECT
DAYOFWEEK(STR_TO_DATE(OrderDateKey,'%Y%m%d')) AS WeekdayNo
FROM Sales;
-- Q3(h): create weekday Name
SELECT
DAYNAME(STR_TO_DATE(OrderDateKey,'%Y%m%d')) AS WeekdayName
FROM Sales;
-- Q3(i) create financial Month
SELECT
CASE
WHEN MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d'))>=4
THEN MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d'))-3
ELSE MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d'))+9
END AS FinancialMonth
FROM Sales;

-- Q3(j) create financial Quarter
SELECT
CASE
WHEN MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d')) BETWEEN 4 AND 6 THEN 'Q1'
WHEN MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d')) BETWEEN 7 AND 9 THEN 'Q2'
WHEN MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d')) BETWEEN 10 AND 12 THEN 'Q3'
ELSE 'Q4'
END AS FinancialQuarter
FROM Sales;

-- Q4: Calculate Sales Amount
SELECT
(UnitPrice * OrderQuantity * (1-UnitPriceDiscountPct)) AS SalesAmount
FROM Sales;

#  Q5: Calculate Production Cost
SELECT
(ProductStandardCost * OrderQuantity) AS ProductionCost
FROM Sales;

--/* ALTER TABLE  Sales
ADD COLUMN ProductionCost DECIMAL(10,2);
UPDATE Sales
SET ProductionCost = ProductStandardCost * OrderQuantity;*/--

# Q6: Calculate Profit
SELECT
 (SalesAmount - (ProductStandardCost * OrderQuantity)) AS Profit
FROM Sales;
-- All the profit,sales,productcost in one query:
SELECT
    SalesAmount,
    (ProductStandardCost * OrderQuantity) AS ProductionCost,
    (SalesAmount - (ProductStandardCost * OrderQuantity)) AS Profit
FROM Sales;
-- Q7: Pivot table
SELECT
    YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS Year,
    MONTHNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS Month,
    SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY
    YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d')),
    MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')),
    MONTHNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d'))
ORDER BY
    Year,
    MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')); 
   # -- WHERE clause is used to filter the data for the year 2013
-- and display month-wise total sales for that year.
SELECT
    MONTHNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS Month,
    SUM(SalesAmount) AS TotalSales
FROM Sales
WHERE YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d')) = 2013
GROUP BY
    MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')),
    MONTHNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d'))
ORDER BY
    MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d'));
    
-- Q8: Year-wise Sales
SELECT
    YEAR(STR_TO_DATE(OrderDateKey,'%Y%m%d')) AS Year,
    SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY YEAR(STR_TO_DATE(OrderDateKey,'%Y%m%d'))
ORDER BY Year;
-- Q9: Month-wise Sales
SELECT
    MONTHNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS Month,
    SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY
    MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')),
    MONTHNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d'))
ORDER BY
    MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d'));

-- Q10: Quarter-wise Sales
SELECT
    QUARTER(STR_TO_DATE(OrderDateKey,'%Y%m%d')) AS QuarterNo,
    SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY QUARTER(STR_TO_DATE(OrderDateKey,'%Y%m%d'))
ORDER BY QUARTER(STR_TO_DATE(OrderDateKey,'%Y%m%d'));
-- Q11: Sales Amount and Production Cost by Year

SELECT
    YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS Year,
    SUM(SalesAmount) AS TotalSales,
    SUM(ProductStandardCost * OrderQuantity) AS TotalProductionCost
FROM Sales
GROUP BY YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d'))
ORDER BY Year;

# DROP TABLE Sales;
-- Que 12;  KPI Key performance Indicator
## total sales
SELECT
    ROUND(SUM(SalesAmount), 2) AS TotalSales
FROM Sales;

# a)Total order
SELECT 
    COUNT(DISTINCT SalesOrderNumber) AS TotalOrders
FROM Sales;

 -- b)  KPI for region  
SELECT COUNT(DISTINCT SalesTerritoryKey) AS TotalRegions
FROM Sales;
-- c) KPI for Total profit
SELECT 
    ROUND(SUM(SalesAmount - (ProductStandardCost * OrderQuantity)), 2) AS TotalProfit
FROM Sales;

-- d)Query-1  KPI for Totalcustomers
SELECT 
    COUNT(*) AS TotalCustomers
FROM DimCustomer;
-- E) Query-2 KPI for Totalcustomers
SELECT 
    COUNT(DISTINCT CustomerKey) AS TotalCustomers
FROM Sales;
-- ALL THE KPI
SELECT
    ROUND(SUM(SalesAmount), 2) AS TotalSales,
    ROUND(SUM(SalesAmount - (ProductStandardCost * OrderQuantity)), 2) AS TotalProfit,
    COUNT(DISTINCT SalesOrderNumber) AS TotalOrders,
    SUM(OrderQuantity) AS TotalQuantity
FROM Sales;
SELECT
    ROUND(SUM(SalesAmount), 2) AS TotalSales,
    ROUND(SUM(SalesAmount - (ProductStandardCost * OrderQuantity)), 2) AS TotalProfit,
    COUNT(DISTINCT SalesOrderNumber) AS TotalOrders,
    SUM(OrderQuantity) AS TotalQuantity,
    COUNT(DISTINCT SalesTerritoryKey) AS TotalRegions,
    COUNT(DISTINCT CustomerKey) AS TotalCustomers
FROM Sales;
