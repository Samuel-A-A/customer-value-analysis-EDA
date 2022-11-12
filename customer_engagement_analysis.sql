CREATE TABLE customer (
	Customer VARCHAR,
	State VARCHAR,
	CustomerLifetimeValue MONEY,
	Response BOOLEAN,
	Coverage VARCHAR,
	Education VARCHAR,
	EffectiveToDate DATE,
	EmploymentStatus VARCHAR,
	Gender VARCHAR,
	Income MONEY,
	LocationCode VARCHAR,
	MaritalStatus VARCHAR,
	MonthlyPremiumAuto MONEY,
	MonthsSinceLastClaim NUMERIC,
	MonthsSincePolicyInception NUMERIC,
	NumberofOpenComplaints NUMERIC,
	NumberofPolicies NUMERIC,
	PolicyType VARCHAR,
	Policy VARCHAR,
	RenewOfferType VARCHAR,
	SalesChannel VARCHAR,
	TotalClaimAmount MONEY,
	VehicleClass VARCHAR,
	VehicleSize VARCHAR
);

SELECT * From customer;

SELECT COUNT(*) no_of_rows
, COUNT(DISTINCT customer) AS customers
FROM customers;

--Policy holders in each state
SELECT state, COUNT(customer)
from customer
GROUP BY state;

--Policy holders in each state by gender
SELECT state,gender, COUNT(customer)
from customer
GROUP BY state, gender
ORDER BY state;

--Policy holders by coverage and policy type
SELECT coverage, policytype, COUNT(customer)
from customer
GROUP BY coverage, policytype
ORDER BY coverage;

--claim amount by gender and state
SELECT state, gender, SUM(totalclaimamount)
from customer
GROUP BY state, gender
ORDER BY state;

--Month-to-month premium colected
SELECT EXTRACT, effectivetodate


--daily premium collected
SELECT effectivetodate, SUM(monthlypremiumauto)
FROM customer
GROUP BY 1
ORDER BY 1;

SELECT effectivetodate, SUM(monthlypremiumauto), '' AS lag_value, '' AS percentage_value
FROM customer
GROUP BY 1
ORDER BY 1;


SELECT date , premium, LAG(premium, 1) OVER (ORDER BY date) AS lag_value
FROM 
(
	SELECT effectivetodate as date,
	SUM(monthlypremiumauto) premium
	,'' AS lag_value, '' AS prcg_value
	FROM customer
	GROUP BY 1) sub1
ORDER BY 1;

--First way
SELECT *
   ,(premium-lag_value)*100/lag_value AS prcg_change
FROM
(
	SELECT date , premium, LAG(premium, 1) OVER (ORDER BY date) AS lag_value
	FROM 
	(
		SELECT effectivetodate as date,
		SUM(monthlypremiumauto) premium
		FROM customer
		GROUP BY 1) sub1
	)sub2
	
--Second way Decimal using "cast"
SELECT *
   , CAST ((premium-lag_value)*100/lag_value AS DECIMAL(5, 2)) AS prcg_change
FROM
(
	SELECT date , premium, LAG(premium, 1) OVER (ORDER BY date) AS lag_value
	FROM 
	(
		SELECT effectivetodate as date,
		SUM(monthlypremiumauto) premium
		FROM customer
		GROUP BY 1) sub1
	)sub2

--Third way using "with"
WITH lag_premium AS (
     SELECT date , premium, LAG(premium, 1) OVER (ORDER BY date) AS lag_value
	FROM 
	(
		SELECT effectivetodate as date,
		SUM(monthlypremiumauto) premium
		FROM customer
		GROUP BY 1) sub1
)


SELECT *
   , CAST ((premium-lag_value)*100/lag_value AS DECIMAL(5, 2)) AS prcg_change
FROM lag_premium

