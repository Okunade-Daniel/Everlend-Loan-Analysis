-- Create Table
/*
CREATE TABLE loan(
credit_policy int,
purpose varchar,
interest_rate numeric,
installments numeric,
log_annual_income numeric,
debt_to_income_ratio numeric,
fico_credit_score numeric,
days_with_cr_line numeric,
revolving_balance numeric,
revolving_utility numeric,
inquiry_last_six_months numeric,
two_years_delinq numeric,
public_records numeric,
not_fully_paid numeric
);
*/

-- load the data from local storage
/*
COPY loan FROM 'C:\Users\Public\Documents\archive\loan_data.csv' DELIMITER ',' CSV HEADER;
*/

-- view data
/*
SELECT *
  FROM loan
 LIMIT 10;
 */
--check duplicates 
/*
SELECT
    CASE
        WHEN COUNT(*) > 0 THEN 'Yes'
        ELSE 'No'
    END AS has_duplicates
FROM (
    SELECT
        credit_policy, purpose,interest_rate,installments,log_annual_income,debt_to_income_ratio,fico_credit_score,days_with_cr_line,
        revolving_balance,revolving_utility,inquiry_last_six_months,two_years_delinq,public_records,not_fully_paid,
        COUNT(*) AS count_duplicates
    FROM loan
    GROUP BY
        credit_policy, purpose,interest_rate,installments,log_annual_income,debt_to_income_ratio,fico_credit_score,days_with_cr_line,
        revolving_balance,revolving_utility,inquiry_last_six_months,two_years_delinq,public_records,not_fully_paid
    HAVING COUNT(*) > 1
) AS duplicates;
*/
 
-- check for null values
/*
SELECT
    CASE
        WHEN COUNT(*) > 0 THEN 'Yes'
        ELSE 'No'
    END AS has_null_values
FROM loan
WHERE
    credit_policy IS NULL
    OR purpose IS NULL
    OR interest_rate IS NULL
    OR installments IS NULL
    OR log_annual_income IS NULL
    OR debt_to_income_ratio IS NULL
    OR fico_credit_score IS NULL
    OR days_with_cr_line IS NULL
    OR revolving_balance IS NULL
    OR revolving_utility IS NULL
    OR inquiry_last_six_months IS NULL
    OR two_years_delinq IS NULL
    OR public_records IS NULL
    OR not_fully_paid IS NULL;
*/
-- inspect the columns
-- credit policy
/*
SELECT DISTINCT credit_policy
  FROM loan;

-- purpose  
SELECT purpose, COUNT(*) frequency
  FROM loan
 GROUP BY purpose
 ORDER BY frequency DESC;
--> the most reason people collect debt is for "DEBT CONSOLIDATION"

-- interest rate
SELECT MIN(interest_rate) as min_interest_rate,
	   ROUND(AVG(interest_rate),4) as avg_interest_rate,
	   MAX(interest_rate) as max_interest_rate,
	   MAX(interest_rate) - MIN(interest_rate) as interest_rate_range
 FROM loan;
--> the average interest rate is 12.26%, 6% is the least, while the maximum interest rate is 21.64%

-- Installments
SELECT MIN(installments) as min_installments_payment,
	   ROUND(AVG(installments),4) as avg_installments_payment,
	   MAX(installments) as max_installments_payments,
	   MAX(installments) - MIN(installments) as installments_range
  FROM loan;
-- $940.14 is the maximum installments paid, minimum installments is $15.67 and the average installments is $319

-- Debt to Income ratio
SELECT MIN(debt_to_income_ratio) as min_dti,
	   ROUND(AVG(debt_to_income_ratio),4) as avg_dti,
	   MAX(debt_to_income_ratio) as max_dti,
	   MAX(debt_to_income_ratio) - MIN(debt_to_income_ratio) as dti_range
  FROM loan;
-- the least debt to income ratio is 0, while 29.96 is the maximum, with an average of 12.61

-- fico credit score
SELECT MIN(fico_credit_score) as min_fico,
	   ROUND(AVG(fico_credit_score),4) as avg_fico,
	   MAX(fico_credit_score) as max_fico,
	   MAX(fico_credit_score) - MIN(fico_credit_score) as fico_range
  FROM loan;
-- the fico credit score of the borrowers is between 612 and 827 with an average of 710.85

--days with cr_line
WITH bin AS (
	SELECT GENERATE_SERIES(0, 20000, 1000) AS lower_bin,
	       GENERATE_SERIES(1000, 21000, 1000) AS upper_bin)
	
SELECT lower_bin,
	   upper_bin,
	   COUNT(*) as no_borrowers
  FROM loan
  JOIN bin
    ON days_with_cr_line >= lower_bin
   AND days_with_cr_line < upper_bin
 GROUP BY lower_bin, upper_bin
 ORDER BY lower_bin;
-- majority of the borrowers have had their credit line for less than 5000

-- revolving balance
SELECT MIN(revolving_balance) as min_rb,
	   ROUND(AVG(revolving_balance),4) as avg_rb,
	   MAX(revolving_balance) as max_rb,
	   MAX(revolving_balance) - MIN(revolving_balance) as rb_range
  FROM loan;
-- the revolving balance has a range of 1207359 and an average of 16913.96

-- revolving utilities
SELECT MIN(revolving_utility) as min_ru,
	   ROUND(AVG(revolving_utility),4) as avg_ru,
	   MAX(revolving_utility) as max_ru,
	   MAX(revolving_utility) - MIN(revolving_utility) as ru_range
  FROM loan;
--  revolving utilities also ranges from 0 to 119 with its average being 46.80. 

--
SELECT MAX(inquiry_last_six_months) - MIN(inquiry_last_six_months) ilsm_range,
	   ROUND(AVG(inquiry_last_six_months),2) avg_ilsm,
	   MAX(two_years_delinq) - MIN(two_years_delinq) delinq_range,
	   ROUND(AVG(two_years_delinq),2) delinq_avg,
	   MAX(public_records) - MIN(public_records) pr_range,
	   ROUND(AVG(public_records),2) avg_pr
  FROM loan;
-- the last six months has an inquiry of range 33 and an average of 1.58, 
-- two years delinq  has range 13 and an average of 0.16, while
-- there are 5 ranges for public records with an average of 0.06
*/

-- what is the proportion of delinquent customers
SELECT ROUND(COUNT (*)/ ((SELECT COUNT (*) FROM loan) * 1.0),2) proportion_of_delinquent_customers
  FROM loan
 WHERE two_years_delinq >0;
-- 12 percent of the customers have been delinquent over the last two years

-- How many customers where considered in total?
SELECT COUNT(*) total_customer
  FROM loan;
-- there are 9578 customers considered.

-- How many customers meet the underwriting criteria
SELECT SUM(credit_policy) customer_meet_criteria,
	   ROUND((1.0* SUM(credit_policy))/ COUNT(*),2) perc_meet_criteria
  FROM loan;
-- 7710 that is 80% of the customers meet the underwriting criteria.

-- What is the most  common purpose for taking the loan
SELECT purpose,
	   COUNT(*) no_loans
  FROM loan
 GROUP BY purpose
 ORDER BY no_loans DESC;
-- most of the loans taken were for debt_consolidation purposes, education is the least reson people collect loan.

-- How does interest rate vary with FICO credit score
SELECT
		CASE
			WHEN fico_credit_score BETWEEN 300 AND 579 THEN 'poor'
			WHEN fico_credit_score BETWEEN 580 AND 669 THEN 'fair'
			WHEN fico_credit_score BETWEEN 670 AND 739 THEN 'good'
			WHEN fico_credit_score BETWEEN 740 AND 799 THEN 'very_good'
			WHEN fico_credit_score BETWEEN 800 AND 850 THEN 'excellent'
			ELSE 'outside_range'
		END AS fico_grade,
		ROUND(AVG(interest_rate),2) avg_interest_rate
  FROM loan
 GROUP BY fico_grade
 ORDER BY avg_interest_rate DESC;

-- correlation between credit score and interest rate
SELECT CORR(fico_credit_score, interest_rate) as fico_corr_interest
  FROM loan;
--  The higher your credit score the lower your interest on loan, a correlation coefficient of (-0.71) indicate a strong negative correlation 
-- between both variables
  
-- does the income of the borrower tells us anything about the installments to be charged?
SELECT CORR(log_annual_income, installments) as income_installments_corr
  FROM loan;
-- a correlation coefficient of 0.45 implies that a moderate relationship exists between income and installments  

-- How does debt to income vary with credit score
SELECT
		CASE
			WHEN fico_credit_score BETWEEN 300 AND 579 THEN 'poor'
			WHEN fico_credit_score BETWEEN 580 AND 669 THEN 'fair'
			WHEN fico_credit_score BETWEEN 670 AND 739 THEN 'good'
			WHEN fico_credit_score BETWEEN 740 AND 799 THEN 'very_good'
			WHEN fico_credit_score BETWEEN 800 AND 850 THEN 'excellent'
			ELSE 'outside_range'
		END AS fico_grade,
		ROUND(AVG(debt_to_income_ratio),2) avg_dti
  FROM loan
 GROUP BY fico_grade
 ORDER BY avg_dti DESC;
-- The higher the credit score, the lower the  debt to income ratio.

-- Is there a correlation between revolving balance and interest rate?
SELECT CORR(revolving_balance, interest_rate) revolving_balance_corr_interest_rate
  FROM loan;
-- There is no linear relationship between revolving balance and interest rate. The amount unpaid at the end of the credit card billing cycle
-- tells us nothing about the interest charged on the loan

-- How does revolving line utilization rate vary with FICO score?
SELECT
		CASE
			WHEN fico_credit_score BETWEEN 300 AND 579 THEN 'poor'
			WHEN fico_credit_score BETWEEN 580 AND 669 THEN 'fair'
			WHEN fico_credit_score BETWEEN 670 AND 739 THEN 'good'
			WHEN fico_credit_score BETWEEN 740 AND 799 THEN 'very_good'
			WHEN fico_credit_score BETWEEN 800 AND 850 THEN 'excellent'
			ELSE 'outside_range'
		END AS fico_grade,
		ROUND(AVG(revolving_utility),2) avg_revolving_utility
  FROM loan
 GROUP BY fico_grade
 ORDER BY avg_revolving_utility DESC;
-- revolving utility decreases as fico credit score increases.

-- What is the distribution of inquiries by creditors in the last 6 months?
WITH bin AS (
	SELECT GENERATE_SERIES(0, 40, 5) AS lower_bin,
	       GENERATE_SERIES(5, 41, 5) AS upper_bin)
	
SELECT lower_bin,
	   upper_bin,
	   COUNT(*) as no_borrowers
  FROM loan
  JOIN bin
    ON inquiry_last_six_months >= lower_bin
   AND inquiry_last_six_months < upper_bin
 GROUP BY lower_bin, upper_bin
 ORDER BY lower_bin;
-- over the last six months, most creditors have inquired less than 10 times

-- How does being delinquent affect interest rate and installments
SELECT inquiry_last_six_months,
	   ROUND(AVG(interest_rate),2) avg_interest_rate,
	   ROUND(AVG(installments),2) avg_installments
  FROM (SELECT
	   		CASE
				WHEN inquiry_last_six_months = 0 THEN 'No'
				ELSE 'Yes'
	   		END AS inquiry_last_six_months,
	   			interest_rate,
	   			installments
  			FROM loan) as dpr
 GROUP BY inquiry_last_six_months;
-- customers who have been inquired in the last six months pay slightly higher interest and lower installments than customers who have not
-- been inquired.

-- How does being delinquent affect interest rate and installments
SELECT delinquent_in_two_years,
	   ROUND(AVG(interest_rate),2) avg_interest_rate,
	   ROUND(AVG(installments),2) avg_installments
  FROM (SELECT
	   		CASE
				WHEN two_years_delinq = 0 THEN 'No'
				ELSE 'Yes'
	   		END AS delinquent_in_two_years,
	   			interest_rate,
	   			installments
  			FROM loan) as dpr
 GROUP BY delinquent_in_two_years;
-- customers who have been delinquent in the last two years pay slightly higher interest and lower installments than customers who have not
-- been delinquent.

-- distibution of number of derogatory public records
SELECT public_records,
	   COUNT(*) no_borrowers
  FROM loan
 GROUP BY public_records
 ORDER BY public_records;
-- majority of the customers have no derogatory public records.

-- How does derogatory public record affect interest rate and installments
SELECT derogatory_public_record,
	   ROUND(AVG(interest_rate),2) avg_interest_rate,
	   ROUND(AVG(installments),2) avg_installments
  FROM (SELECT
	   		CASE
				WHEN public_records = 0 THEN 'No derogatory public record'
				ELSE 'Has derogatory public record'
	   		END AS derogatory_public_record,
	   			interest_rate,
	   			installments
  			FROM loan) as dpr
 GROUP BY derogatory_public_record;
-- having derogatory public record requires a slightly higher interst rate (13%) than not having a derogatory public record (12%)

-- What is the average interest rate per loan purpose
SELECT purpose,
	   ROUND(AVG(interest_rate),2) avg_interest_rate
  FROM loan
 GROUP BY purpose
 ORDER BY avg_interest_rate DESC;
-- collecting loan for major purchase has the least interest rate. loans for education and credit card makes up the top 3 
-- loan reasons with the least interest rate. collecting loans for small business has the highest interest rate.

-- What is the maximum interest rate per loan purpose.
SELECT purpose,
	   ROUND(MAX(interest_rate),2) max_interest_rate
  FROM loan
 GROUP BY purpose
 ORDER BY max_interest_rate DESC;
-- the maximum interest rate given for home improvement is 22%, this is the same for loans categorized as others.
-- the maximum given for debt consolidation, small business and credit card is 21%, while the maximum collected for educational 
-- purpose and major purchase is 20%

-- how does loan purpose affect income and installments
SELECT purpose,
	   ROUND(AVG(log_annual_income),2) avg_income,
	   ROUND(AVG(installments),2) avg_installments
  FROM loan
 GROUP BY purpose
 ORDER BY avg_installments DESC;
-- small business loan, loan for debt consolidation and home improvements loan are the top 3 loans that requires customer to pay larger installments
-- while home improvements loan, small business laon and credit_card loan requires customer to have higher income.

-- How does the loan purpose affect the FICO score and the debt-to-income ratio?
SELECT purpose,
	   ROUND(AVG(fico_credit_score),2) avg_credit_score,
	   ROUND(AVG(debt_to_income_ratio),2) avg_dti
  FROM loan
 GROUP BY purpose
 ORDER BY avg_credit_score DESC, avg_dti;
-- home improvement loans require a higher credit score as its average credit score (724.81) is higher than any other loan purpose
-- credit card loans on the other hand requires a larger debt to income ration than others

-- How does the loan purpose affect the revolving balance and the revolving utilization rate?
SELECT purpose,
	   ROUND(AVG(revolving_balance),2) avg_revol_bal,
	   ROUND(AVG(revolving_utility),2) avg_revol_util
  FROM loan
 GROUP BY purpose
 ORDER BY avg_revol_bal DESC, avg_revol_util;
-- small business loan is the loan purpose with the highest revolving balance, while major purchase loan has the least revolving balance
-- and the least revolving utility

-- How does the loan purpose affect the number of delinquency, public records, and number of inquiry?
SELECT purpose,
	   ROUND(AVG(two_years_delinq),2) avg_delinq,
	   ROUND(AVG(public_records),2) avg_pr,
	   ROUND(AVG(inquiry_last_six_months),2) avg_inq
  FROM loan
 GROUP BY purpose
 ORDER BY avg_delinq DESC;
-- customers who collect loans for other purposes have been delinquent more times on average, customers who collect educational loan has
-- the least derogatory public record on average while customers who collect loan for home improvement have been inquired by the creditors more times
-- on average than others.

-- CREDIT POLICY
-- What is the average interest rate per credit policy
SELECT credit_policy,
	   ROUND(AVG(interest_rate),2) avg_interest_rate
  FROM loan
 GROUP BY credit_policy
 ORDER BY avg_interest_rate DESC;
-- interest rate is lower for customers who meet the credit underwriting criteria

-- What is the maximum interest rate per credit policy.
SELECT credit_policy,
	   ROUND(MAX(interest_rate),2) max_interest_rate
  FROM loan
 GROUP BY credit_policy
 ORDER BY max_interest_rate DESC;
-- the maximum interest rate given for customers who do not meet the credit underwriting criteria is 22%, and 21% for those who meet it.

-- how does credit policy affect income and installments
SELECT credit_policy,
	   ROUND(AVG(log_annual_income),2) avg_income,
	   ROUND(AVG(installments),2) avg_installments
  FROM loan
 GROUP BY credit_policy
 ORDER BY avg_installments DESC;
-- There is no significant difference in the average income of customers who meets the credit underwiting criteria and those who do not meet it
-- However, customers who meet the criteria pay higher installments.

-- How does the credit policy affect the FICO score and the debt-to-income ratio?
SELECT credit_policy,
	   ROUND(AVG(fico_credit_score),2) avg_credit_score,
	   ROUND(AVG(debt_to_income_ratio),2) avg_dti
  FROM loan
 GROUP BY credit_policy
 ORDER BY avg_credit_score DESC, avg_dti;
-- customers that meet the credit underwriting policy have a higher credit score and a lower debt to income ratio than customers who do not meet the criteria

-- How does the credit policy affect the revolving balance and the revolving utilization rate?
SELECT credit_policy,
	   ROUND(AVG(revolving_balance),2) avg_revol_bal,
	   ROUND(AVG(revolving_utility),2) avg_revol_util
  FROM loan
 GROUP BY credit_policy
 ORDER BY avg_revol_bal DESC, avg_revol_util;
-- customers who do not meet the credit underwriting criteria have a higher revolving balance and a higher revolving utility than customers who meet the criteria

-- How does the credit policy affect the number of delinquency, public records, and number of inquiry?
SELECT credit_policy,
	   ROUND(AVG(two_years_delinq),2) avg_delinq,
	   ROUND(AVG(public_records),2) avg_pr,
	   ROUND(AVG(inquiry_last_six_months),2) avg_inq
  FROM loan
 GROUP BY credit_policy
 ORDER BY avg_delinq DESC;
-- customers who do not meet the credit underwriting criteria have a higher number of delinquency on average in the past two years, a higher derogatory public records
-- and a higher creditors' inquiry than those who meet the criteria.

-- Is there a pattern in loan purposes for borrowers who have not fully paid their loans?
SELECT purpose,
	   not_fully_paid,
	   ROUND(1.0 * COUNT (*) / (SELECT COUNT(*) FROM loan),2) as perc
  FROM loan
 GROUP BY purpose, not_fully_paid
 ORDER BY purpose, not_fully_paid DESC;
-- For all loan purposes, customers with fully paid loans are more than those with not fully paid loans.

-- relationship between debt to income and not fully paid loan
SELECT not_fully_paid,
	   ROUND(AVG(debt_to_income_ratio),2) avg_dti
  FROM loan
 GROUP BY not_fully_paid;
-- the debt to income ratio for customers with not fully paid loan is higher (13.20) than those with fully paid loan (12.49)

-- Average number of times customer has been delinquent in the last two years
SELECT not_fully_paid,
	   ROUND(AVG(two_years_delinq),2) avg_delinq
  FROM loan
 GROUP BY not_fully_paid;
-- the average number of times the customers have been delinquent in the last two years has been slightly different for both groups.
-- as customers with not fully paid loans have been delinquent 0.17 times on average, while customers with fully paid loans 0.16.

-- How does the number of inquiries affect the probability of not fully paying the loan?
SELECT not_fully_paid,
	   ROUND(AVG(inquiry_last_six_months),2) avg_inquiry
  FROM loan
 GROUP BY not_fully_paid;
-- the number of times the inquiry is made does not guarantee a fully paid loan, as customers that has not fully paid their loan has
-- a higher number of inquiry on average than those with fully paid loan.

-- What is the average number of days with a credit line for customers who have not fully paid their loans?
SELECT not_fully_paid,
	   ROUND(AVG(days_with_cr_line),2) avg_credit_line_days
  FROM loan
 GROUP BY not_fully_paid;
-- customers with fully paid loans has had their credit line longer (4592.63) than those with not fully paid loans(4393.54).

-- credit policy
SELECT not_fully_paid,
	   credit_policy,
	   COUNT(*) no_customers
  FROM loan
 GROUP BY not_fully_paid, credit_policy
 ORDER BY not_fully_paid;
 -- majority of customers who has fully paid their loans met the underwriting criteria. The same is for customers who have not fully
 -- paid their loans.
	   

-- What are the top 3 loan purposes is collected the most by each customer group
SELECT not_fully_paid,
	   purpose,
	   loan_rank
  FROM (SELECT not_fully_paid,
	   		   purpose,
	   		   COUNT(*) no_customers,
	   		   RANK() OVER(PARTITION BY not_fully_paid ORDER BY COUNT(*) DESC) loan_rank
  			   FROM loan
 			   GROUP BY not_fully_paid, purpose
 			   ORDER BY not_fully_paid, no_customers DESC) as rank_loan_purpose
 WHERE loan_rank in (1,2,3);
-- for customers who have fully paid their loans, debt_consolidation, debt categorized as others and credit card loans were the top 3
-- for those who have not fully paid their loans, debt_consolidation, debt categorized as others and small business loans were the top 3



