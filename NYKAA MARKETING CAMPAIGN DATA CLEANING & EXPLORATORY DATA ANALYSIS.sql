# NYKAA MARKETING CAMPAIGN DATA CLEANING

# Use database
USE marketing;

-- View Tables
SHOW TABLES;

-- View Data
SELECT * FROM nykaa_campaign;

-- Update data types

ALTER TABLE nykaa_campaign
MODIFY COLUMN Revenue DECIMAL(19,4),
MODIFY COLUMN Acquisition_Cost DECIMAL(19,4),
MODIFY COLUMN ROI DECIMAL(5,2),
MODIFY COLUMN Engagement_Score DECIMAL(5,2);

-- Convert Date to DATE Format
UPDATE nykaa_campaign
SET `Date` = STR_TO_DATE(`Date`,'%d-%m-%Y')
WHERE `Date`IS NOT NULL;

ALTER TABLE nykaa_campaign
MODIFY `Date` DATE;

-- Remove Dupicates
SELECT Campaign_ID,
ROW_NUMBER() OVER (
PARTITION BY Campaign_ID) as row_num
FROM nykaa_campaign;

WITH duplicate_cte AS
(SELECT Campaign_ID,
ROW_NUMBER() OVER (
PARTITION BY Campaign_ID) as row_num
FROM nykaa_campaign
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

# NYKAA MARKETING CAMPAIGN EXPLORATORY DATA ANALYSIS

-- 1. total Revenue, total Clicks, and total Conversions generated in all campaigns

SELECT 
	SUM(Revenue) AS Total_Revenue,
    SUM(Clicks) AS Total_Clicks,
    SUM(Conversions) AS Total_Conversions
FROM nykaa_campaign;

-- 2.  Campaign_Type generated the highest average ROI

SELECT Campaign_Type, ROUND(AVG(ROI), 2) AS Avg_ROI
FROM nykaa_campaign
GROUP BY Campaign_Type
ORDER BY Avg_ROI DESC;

-- 3. Target_Audience segment has the highest average Engagement Score?

SELECT Target_Audience, ROUND(AVG(Engagement_Score), 2) AS Avg_Engagement
FROM nykaa_campaign
GROUP BY Target_Audience
ORDER BY Avg_Engagement_Score DESC;

-- 4.  top 5 campaigns with the low Acquisition_Cost that achieved more conversions.

SELECT Campaign_ID, Acquisition_Cost, Conversions
FROM nykaa_campaign
WHERE Conversions > 1500
ORDER BY Acquisition_Cost ASC
LIMIT 5;

-- 5. average Conversion Rate for each Language.

SELECT `Language`, ROUND(SUM(ConversionS) / SUM(Clicks) * 100, 2) AS Conversion_Rate
FROM nykaa_campaign
GROUP BY `Language`
ORDER BY Conversion_Rate DESC;

-- 6. Top 10 Channel has contributed the most to total revenue.

SELECT Channel_Used, SUM(Revenue) AS Total_Revenue
FROM nykaa_campaign
GROUP BY Channel_Used
ORDER BY Total_Revenue DESC
LIMIT 10;

-- 7.Impact of Campaign Duration on ROI and total revenue.

SELECT Duration, ROUND(AVG(ROI), 2) AS Avg_ROI,
      SUM(Revenue) AS Total_Revenue
FROM nykaa_campaign
GROUP BY Duration
ORDER BY Duration ASC;

-- 8. total revenue and total campaigns targeted at each Customer_Segment.

SELECT Customer_Segment, ROUND(AVG(ROI), 2) AS Avg_ROI,
      SUM(Revenue) AS Total_Revenue
FROM nykaa_campaign
GROUP BY Customer_Segment
ORDER BY Total_Revenue DESC;

-- 9. High-Performing Campaigns that generated Revenue 5 time of Acquisition_Cost & Engagement_Score is above 20.
 
SELECT Campaign_ID, Revenue, Acquisition_Cost, Engagement_Score
FROM nykaa_campaign
WHERE Revenue >= (Acquisition_Cost * 5) AND 
	 Engagement_Score > 20
ORDER BY Revenue DESC;

-- 10.Number campaigns launched each month.
 
SELECT DATE_FORMAT(Date, '%Y-%m') AS Campaign_Month,
    COUNT(*) AS Total_Campaigns
FROM nykaa_campaign
GROUP BY Campaign_Month
ORDER BY Campaign_Month;