# Everlend Loan Analysis
# Overview
EverLend, a prominent player in financial services, re]lies on data to shape its strategies. With access to a vast repository of loan records, I embarked on a journey to unravel the narratives embedded within. Each data point serves as a window into the diverse experiences of EverLend's borrowers—a tale of financial decisions, creditworthiness assessments, loan dynamics, credit scores, and repayment behaviors.

My objective for this analysis was to extract actionable insights that would empower EverLend to make informed lending decisions and refine its lending strategies. By analyzing the data, I sought to uncover patterns, trends, and correlations that could guide EverLend towards more effective and customer-centric approaches.

Outcomes
Through a deep dive into EverLend's loan data, I uncovered compelling stories of financial journeys and repayment patterns. This hands-on experience not only sharpened my data analysis, predictive modelling and visualization skills but also empowered me to offer strategic insights to enhance EverLend's lending strategies. It was a rewarding journey that allowed me to apply my expertise to real-world challenges while contributing to EverLend's mission of informed decision-making.

### Data:
Step 1: Data Preparation
In this project, I worked with data from Everlend, which was in great shape right from the start. There were no duplicates, and I didn't need to do any fancy task like filling in missing values or dealing with outliers. The only tweaks I made were fixing up some data formats and making the column names easier to understand. I also transformed the categorical column by turning them into dummy variables. For instance, in the loan purpose column where we had categories like debt consolidation, credit card, and home improvements, I transformed them into separate columns where each category gets its own spot, showing up as 0 or 1 depending on whether or not the values belongs to that category.  

# Data Exploration
To analyze the data, I used descriptive statistics and visualizations to get insights. I explored the data using Postgres SQL and created reports with Power BI. Then, I built a prediction model using Python to forecast loan repayment.
Some of the questions answered include:

- What is the most common purpose for taking out a loan?
- How does the interest rate vary with FICO credit score?
- What is the correlation between installment amount and annual income?
- How does FICO score relate to interest rate?
- How does the number of inquiries affect the probability of not fully paying the loan?
- What is the proportion of customers who have been delinquent in the past 2 years?
- How does delinquency affect the interest rate and the FICO score?
- How does having a public record impact the credit policy and the loan purpose?
- What are the characteristics of the customers who have the highest and the lowest interest rates?
- What are the characteristics of the customers who have the highest and the lowest FICO scores?
- How does the credit policy affect the installment amount and the interest rate?
- How does the credit policy affect the FICO score and the debt-to-income ratio?

# Data Visualization
Using Power BI, I created a report to visualize the patterns found in the data.

# Model
To predict the likelihood of borrowers to fully pay back their loans, a supervised learning model was built. I started with a simple model Logistic Regression, then tried out Decision Tree, Random Forest, and KNN models. I didn't tweak any hyperparameter, just used them as they are. After comparing them, I found that the Random Forest model stood out because it was more accurate and precise in its predictions compared to the others. Then I selected the Random Forest model and adjusted the hyperparameter to make the model perform better. 

# Conclusion
The analysis of the loan data reveals that meeting the underwriting criteria is a key factor in determining the financial outcomes of the borrowers. Those who meet the criteria have better credit scores, get lower interest rates, and possess a higher chances of paying back their loans on time. They also tend to borrow for debt consolidation, which may indicate a more responsible use of credit. They also tend to pay back loans collected for credit card purposes than others. On the other hand, those who do not meet the criteria face higher interest rates, lower credit scores, and higher delinquency rates. They also tend to borrow for debt consolidation purposes, while they are more likely to pay back loan collected for major purchases on time than any other loan.
# Recommendation
Based on the findings, it is recommended that the Everlend should: 
- Continue to apply the underwriting criteria rigorously, as it helps to identify the most creditworthy and reliable borrowers. 
- Offer incentives or rewards to the borrowers who meet the criteria, such as lower fees, flexible repayment options, or loyalty programs, to encourage them to maintain their good financial habits and retain their loyalty. 
- Be cautious with lending to borrowers for small business purposes as they have the least repayment rate, especially borrowers who do not meet the underwriting criteria.
