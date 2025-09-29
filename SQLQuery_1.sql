CREATE TABLE exports_staging (
    Species VARCHAR(100),
    Product VARCHAR(100),
    Country VARCHAR(100),
    Volume INT,
    Value FLOAT,
    Year INT
);

CREATE TABLE exports (
    Species VARCHAR(100),
    Product VARCHAR(100),
    Country VARCHAR(100),
    Volume INT,
    Value FLOAT,
    Year INT,
    Price_per_kg FLOAT
);

SELECT * FROM exports_staging;

UPDATE exports_staging
SET Year = 2023;


UPDATE exports_staging
SET Year = 2024 WHERE YEAR IS NULL;

UPDATE exports_staging
SET Year = 2025 WHERE YEAR IS NULL;

UPDATE exports_staging
SET Product = REPLACE(Product, '"', '');

UPDATE exports_staging
SET Country = REPLACE(Country, '"', '');

INSERT INTO exports
SELECT
    Species,
    Product,
    Country,
    Volume,
    Value,
    Year,
    CASE WHEN Volume > 0 THEN Value / Volume ELSE NULL END AS Price_per_kg
FROM exports_staging;

SELECT * FROM exports;


-- Right Market: Best Growth/Pricing by Country
-- Total Export Value & Volume by Country

SELECT  
Year, 
Country, 
SUM(Value) AS Total_value, 
SUM(Volume) AS Total_volume, 
AVG(Price_per_kg) AS Avg_price 
FROM exports
GROUP BY Year, Country 
ORDER BY total_value DESC;


-- Year-over-Year Growth by Country
SELECT  
Country, 
Year, 
Total_value, 
    LAG(Total_value) OVER (PARTITION BY Country ORDER BY Year) AS 
prev_year_value, 
    (total_value - LAG(Total_value) OVER (PARTITION BY Country ORDER 
BY Year)) * 100.0 / 
        NULLIF(LAG(Total_value) OVER (PARTITION BY Country ORDER BY 
Year),0) AS yoy_growth_pct 
FROM ( 
    SELECT Country, Year, SUM(Value) AS Total_value 
    FROM exports 
    GROUP BY Country, Year
) t 
ORDER BY Country, Year;

-- Average Price per kg by Country
SELECT Country, AVG(Price_per_kg) AS AvgPricePerKg
FROM exports
GROUP BY Country
ORDER BY AvgPricePerKg DESC;

-- Right Product: Most Profitable Species/Products

SELECT  
    Year, 
    Species, 
    Product, 
    SUM(Value) AS Total_value, 
    SUM(Volume) AS Total_volume, 
    SUM(Value)/NULLIF(SUM(Volume),0) AS Avg_price_per_kg 
FROM exports 
GROUP BY Year, Species, Product 
ORDER BY Total_value DESC;

-- Right Price: Optimal Pricing Strategy by Market
-- Average Price per kg by Country & Product
SELECT  
    Country, 
    Year, 
    SUM(Value)/NULLIF(SUM(Volume),0) AS Avg_price_per_kg 
FROM exports 
GROUP BY Country, Year 
ORDER BY Country, Year;
