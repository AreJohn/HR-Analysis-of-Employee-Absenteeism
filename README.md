# 📊 HR Analytis: Investigating Employee Absenteeism at UCI Global

![absenteeism picture](https://github.com/AreJohn/HR-Analysis-of-Employee-Absenteeism/blob/main/assets/images/absenteeism.png)

##### A data-driven case study uncovering the causes of absenteeism and offering targeted HR interventions using SQL.

## Table of Contents
- [Project Overview](#Project-Overview)
- [Business Challenge](#Business-Challenge)
- [Tools](#Tools)
- [Data Source](#Data-Source)
- [Data Cleaning & Transformation](#Data-Cleaning-&-Transformation)
- [Key Questions & Findings](#Key-Questions-&-Findings)
- [Insights](#Insights)
- [Featured Visuals](#Featured-Visuals)
- [Recommendations](#Recommendations)

## Project Overview
##### This project explores employee absenteeism at UCI Global using SQL. The goal was to understand the underlying causes of frequent absences, identify at-risk groups, and offer data-driven HR recommendations to improve attendance and overall performance.

## Business Challenge
##### UCI Global's management is concerned about rising absenteeism and its impact on productivity. They suspect various factors like health, family demands, and workplace policy issues. As a data analyst, I was tasked with:
##### •	Identifying absenteeism patterns
##### •	Profiling high-risk employee groups
##### •	Recommending HR strategies to improve attendance

## Tools 
|Tool | Purpose |
|----|----|
|SQL | Data cleaning and analysis |
|Excel | Visual storytelling and charts|
|PowerPoint | Final storytelling presentation |

## Data Source:
###### The [dataset](https://archive.ics.uci.edu/dataset/445/absenteeism+at+work) contains two csv files:
###### 1.	Employees_info
###### 2.	Absenteeism_info

##### 1.	Employees_info:  This table includes data on individual employees, such as their unique ID, transport expense, distance from home to work, age, number of children, pet ownership, education level, social drinking, social smoking, weight, and height.
##### 2.	Absenteeism_info: This table contains data related to employee’s absence, including their ID, reason for absence (coded numerically), month of absence, day of the week, workload average per day, employee target hit, absenteeism time in hours, service time, and disciplinary failure.

## Data Cleaning & Transformation
#### Key data wrangling tasks using SQL:
##### 1. Joined employee & absence datasets: Combined both CSV files into a unified SQL table.
##### 2. Cleaned categorical columns: Translated codes into readable values (e.g., months, days, seasons).
##### 3. Calculated BMI: Derived BMI & grouped into Health Status.
##### 4. Coded Absence Reasons: Grouped 27 reasons into 4 main categories.
###### 📂 View full SQL code: [Employee Absenteeism.sql](https://github.com/AreJohn/HR-Analysis-of-Employee-Absenteeism/blob/main/assets/images/documents/Employee%20Absenteeism.sql)

## Key Questions & Findings
#### Here's a sample of the 21 questions that guided my analysis:

##### ❓ What is the number of employees working at UCI Global? → 36
##### ❓ Total absences reported? → 612
##### ❓ Total hours lost? → 4,421 hours (~184 days)
##### ❓ Most common absenteeism reason? → Medical (528 cases)
##### ❓ Who is the high-risk employee? → Employee with ID 26 (drinker, smoker, overweight, 5 medical absences)
##### ❓ Do caregivers miss more work? → Yes, 53% of absences from those with pets/children
##### ❓ What age group is most absent on Fridays? → Eployees in their 20s miss work on midweek particularly Tuesdays & Wednesdays.
##### ❓ Which season saw highest workload & absences? → Summer, had the highest average workload but reported the fewest absences.

<details>
<summary>✔️ View full analysis breakdown here</summary>

## Full Data Analysis Breakdown
##### 1.	What is the number of employees working at UCI Global?
```sql
--1. Total number of employees 
SELECT COUNT(DISTINCT ID) AS NumberOfEmployes
FROM Absenteeism
```
**There are 36 employees**

##### 2.	What is the total number of Absenteeism Reasons?
```sql
-- 2. Number of reported absences
SELECT COUNT(*) AS CountAbsenteeism
FROM Absenteeism
```
**The total number of absences reported is 612**

##### 3. What Total absenteeism time in hours 
```sql
-- 3. Total absenteeism time in hours 
SELECT SUM([Absenteeism time in hours]) AS TotalAbsenteeismHours
FROM Absenteeism
```
**The total absenteeism time is 4,421 hours, which is around 184 days.**

##### 4. Month with the highest number of absences
```sql
-- 4. Which month had the highest number of absences?
SELECT Months,  COUNT(*)AS CountAbsenteeismReason
FROM Absenteeism 
GROUP BY Months
ORDER BY CountAbsenteeismReason
```
**March had the highest number of absences**

##### 5. Season with the highest number of absences
```sql
-- 5. What season had the most absences reported? 
SELECT Season,  COUNT(*) AS CountAbsenteeismReason
FROM Absenteeism 
GROUP BY Season
ORDER BY CountAbsenteeismReason
```
**Autumn had the most absenteeism reported with 183 absences**

##### 6.	Find out why theres a month with 0
```sql
-- 6. Finding out why theres a month with 0 
SELECT [Month of absence], Months, [Absenteeism time in hours], [Reason for absence], Absenteeism_Reason
FROM Absenteeism 
WHERE Season IS NULL
```
**For months that have 0, the reason for absenteeism is incomplete submission and the absenteeism time in hours is 0 hours.**

##### 7. What was the most reported absenteeism reason?
```sql
SELECT Absenteeism_Reason, COUNT([Reason for absence]) AS CountAbsenteeismReason
FROM Absenteeism
GROUP BY Absenteeism_Reason
ORDER BY CountAbsenteeismReason
```
**The least reported absenteeism reason was Family-related at 20 reasons, followed by unjustified leave at 30 reasons then incomplete submission at 34 reasons while medical reasons was overwhelmingly reported at 528 reasons.**

##### 8. How many employees are classified as overweight or obese?
```sql
SELECT COUNT (DISTINCT ID) AS NumberOfEmployees
FROM Absenteeism
WHERE Health_Status IN( 'Over weight', 'Obese')
```
**17 out of 36 employees are classified as overweight and obese. About 65.38% of employees are classified as overweight and obese.**

##### 9. How many times did were employees who are overweight and obese report absent?
```sql
SELECT COUNT (*) AS NumberOfEmployees
FROM Absenteeism
WHERE Health_Status IN( 'Over weight', 'Obese')
```
**Employees that are overweight and obese reported absent 338 times, accounting for 55.22% of of total absences..**

##### 10. Which employee is a drinker, smoker and overweight? 
```sql
SELECT ID
FROM Absenteeism
WHERE Drinker_Status = 'Drinker' 
AND Smoker_Status = 'Smoker'
AND Health_Status = 'Over weight'
GROUP BY ID
```
 **Employee with ID number 26 is a drinker, smoker and is overweight.**

##### 11. How many times did the employee who is a drinker, smoker and overweightvcc absent and what were the reasons?
```sql
SELECT COUNT (*) AS CountAbsenteeism, Absenteeism_Reason
FROM
(
SELECT *
FROM Absenteeism
WHERE Drinker_Status = 'Drinker' 
AND Smoker_Status = 'Smoker'
AND Health_Status = 'Over weight'
) AS UnhealthyEmployees
GROUP BY Absenteeism_Reason
```
**Employee with ID number 26 reported absent 5 times and the absenteeism reason was Medical.**

##### 12. What percentage of the absences reported from the employee in question 9 were in the summer?
```sql
SELECT Season , COUNT(*) AS PercentAbsenteeism
FROM Absenteeism
WHERE Drinker_Status = 'Drinker' 
AND Smoker_Status = 'Smoker'
AND Health_Status = 'Over weight'
GROUP BY Season
```
**60% of absences reported from the employee in question 10 was in the summer**

##### 13. How many employees have at least 2 children or one or more pets?
```sql
SELECT COUNT(DISTINCT ID) AS NumOfAbsences
FROM Absenteeism
WHERE Children >=2
AND Pet >=1
```
**21 employees have at least 2 children or one or more pets.**

##### 14. How many times did employees that have at least 2 children or one or more pets report absent?
```sql
SELECT COUNT(*) AS NumOfEmployee
FROM Absenteeism
WHERE Children >=2
AND Pet >=1
```
**Employees that have at least 2 children or one or more pets reported absent 326 times. They account for 53% of total absences.**

##### 15. Do Employees in their 20s report absent more times on Mondays and Fridays than on other days?
```sql
SELECT COUNT(*) AS YoungEmployeesAbsentMondayAndFriday
FROM Absenteeism
WHERE Age BETWEEN 20 AND 29
AND Weekdays  IN ('Monday',' Friday')

SELECT COUNT(*) AS YoungEmployeesAbsentRestOfWeek
FROM Absenteeism
WHERE Age BETWEEN 20 AND 29
AND Weekdays  IN ('Tuesday', 'Wednesday', 'Thursday')
```
**Employees in their 20s report the most absences midweek particularly Tuesdays and Wednesdays than other days.**

##### 16. How many employees disregarded disciplinary warnings, and what was the reason for their absence?
```sql
SELECT COUNT(DISTINCT ID) AS NumEmployee, Absenteeism_Reason 
FROM Absenteeism
WHERE Disciplinary_Status = 'Yes'
GROUP BY Absenteeism_Reason
```
19 Employees disregarded disciplinary warnings and Incomplete submission was the reason.

##### 17. How many times did employees that disregarded disciplinary warnings report absent, and what was the reason for their absence?
```sql
SELECT COUNT(*) AS NumEmployee, Absenteeism_Reason 
FROM Absenteeism
WHERE Disciplinary_Status = 'Yes'
GROUP BY Absenteeism_Reason 
```
**Employees that disregarded disciplinary warnings reported for absence 31 times and Incomplete submission was the reason.**

##### 18. What percentage of the employees that disregarded disciplinary warnings have a high school education level?
```sql
SELECT COUNT(*) AS NumEmployee, Absenteeism_Reason, Education_Level
FROM Absenteeism
WHERE Disciplinary_Status = 'Yes'
GROUP BY Absenteeism_Reason, Education_Level
```
**90% of employees that disregarded disciplinary warnings had high school education**

##### 19. Did employees with a high school education level and a hit target value of less than 90 disregard disciplinary warnings?
```sql
SELECT COUNT(*) AS NumEmployee, Disciplinary_Status,  Education_Level
FROM
(
SELECT *
FROM Absenteeism
WHERE Education_Level = 'High School'
) AS EmployeesDisregardWarnings 
WHERE [Hit target] < 90
GROUP BY Disciplinary_Status, Education_Level
```
**78.5% employees with a high school education level and a hit target value of less than 90 did not disregard warning while, 21.4% disregard warning**

##### 20.  Which season had the highest workload average per day?
```sql
SELECT Season, [Work load Average/day]
FROM Absenteeism
GROUP BY Season, [Work load Average/day]
ORDER BY [Work load Average/day] DESC
```
**Summer had the highest workload average per day.**

##### 21.  How many employees were only absent from work once, and what similarities do they share?
```sql
SELECT ID, COUNT(*) AS NumAbsences, AVG([Transportation expense]) AS AvgTransportExpense, AVG([Distance from home to work]) AS AvgDistance,
AVG(Age) AS AvgAge, AVG(Children) AS AvgChildren, Avg(Pet) AS AvgPet, Avg(Education) AS AvgEducation, Education_Level, 
AVG([Social drinker]) AS AvgDrinker, Drinker_Status, AVG([Social smoker]) AS AvgSmokerker, Smoker_Status, AVG(BMI) AS Avg_BMI, Health_Status,
AVG([Absenteeism time in hours]) AS AvgAbsenteeismHours
FROM Absenteeism
GROUP BY ID, Education_Level,  Drinker_Status, Smoker_Status, Health_Status
HAVING  COUNT(*) = 1
```
**Only 2 employees were absent from work only once, they are both high school education level, non-smokers, on average they spend $118 on transporting expenses and on average they spend less than hour on absenteeism.**
</details>

## Insights 
##### 1.	Employees and Absences: 
##### •	There are 36 employees in total 
##### •	The total number of absenteeism reported is 612.
##### •	The total absenteeism time is 4,421 hours. Which is around 184 days.

##### 2.	Absenteeism patterns: 
##### •	For months that have 0, the reason for absenteeism is incomplete submission and the absenteeism time was 0 hours.
##### •	March had the highest number of absences.
##### •	Autumn had the most Absenteeism reported with 186 reasons.
##### •	Summer had the highest workload on average per day.

##### 3.	Reasons for Absenteeism: 
![AbsenteeismReasons](https://github.com/AreJohn/HR-Analysis-of-Employee-Absenteeism/blob/main/assets/images/absenteeism%20reasons.png)
The least reported absenteeism reason was Family-related at 20 reasons, followed by unjustified leave at 30 reasons then incomplete submission at 34 reasons while medical reasons were overwhelmingly reported at 528 reasons.

##### 4.	Health related:
##### •	Medical reasons were the most reported absenteeism reason at 528 absences accounting for 86% of total absences.
##### •	15 employees are classified as overweight and obese.
##### •	Overweight or obese employees reported 303 absences.

##### 5.	Specific Cases:
##### •	Employee with ID number 26 is a drinker, smoker and overweight and reporting 5 absences for medical reasons.
##### •	3 out of 5 of the absences reported by the employee who is a drinker, smoker and overweight were in the Winter.

##### 6.	Pet and Children related Absenteeism:
##### •	21 employees have at least 2 children or at least 2 pets.
##### •	Employees that have at least 2 children or one or more pets reported absent 326 times and account for 53% of total absences.

##### 7.	Age related: Employees in their 20s report the most absences midweek particularly Tuesdays and Wednesdays than other days. 

##### 8.	Disciplinary related Absenteeism:
##### •	19 employees disregarded disciplinary warnings and incomplete submission was the reason resulting in 31 absences.
##### •	17 of the employees who disregarded disciplinary warnings had high school education level.
##### •	21.4% of employees with a high school education level and a hit target value of less than 90 disregarded disciplinary warning, while 78.5% did not disregard disciplinary warning. 

##### 9.	Only 2 employees were absent from work once, they are both non-smokers with a high school education level, spending an average of R$118 on transporting expenses and less than hour on average on absenteeism.

## Featured Visuals
#### Charts and visualizations to bring the story to life:
[Download the PowerPoint here](https://github.com/AreJohn/HR-Analysis-of-Employee-Absenteeism/blob/main/assets/images/documents/Abssenteeism%20Presentation.pptx)

## Recommendations 
##### 1. Implement Employee Well-being Programs:
###### ● Introduce health and wellness programs focused on regular exercise, stress management, and preventive care.
###### ● Provide targeted wellness plans for overweight or obese employees to reduce health-related absenteeism.
###### ● Implement smoking and alcohol cessation programs for employees at higher risk of absenteeism.

##### 2. Offer Flexible Scheduling During Peak Absenteeism Periods
###### ● Adjust work schedules during peak absenteeism periods, particularly in March and Autumn (186 absences).
###### ● Implement leave planning strategies to manage absenteeism spikes during Summer, where at-risk employees report higher absences.

##### 3. Encourage Healthy Behaviors and Lifestyle Changes
###### ● Promote physical activity and weight management initiatives.
###### ● Provide nutrition guidance to reduce absenteeism linked to poor health.
###### ● Support employees with smoking and drinking habits through targeted health interventions.

##### 4. Provide Support for Employees with Dependents
###### ● Offer childcare and pet-care assistance to employees with dependents, who contributed to 326 absences.
###### ● Implement flexible work arrangements to accommodate employees balancing family responsibilities.

##### 5. Develop Training Programs to Enhance Employee Skills
###### ● Conduct time management, communication, and conflict resolution workshops to improve employee performance.
###### ● Provide mentorship programs to enhance workplace discipline and reduce absenteeism from missed deadlines.

##### 6. Review and Strengthen Disciplinary Policies
###### ● Enforce stricter compliance on submission deadlines and create clear guidelines for incomplete submissions.
###### ● Address disciplinary warning disregard, particularly among employees with a high school education and low performance scores.
###### ● Implement structured interventions for employees repeatedly violating policies.

##### 7. Foster an Engaging and Supportive Work Culture
###### ● Recognize employees with good attendance records to encourage workplace motivation.
###### ● Engage younger employees to reduce absenteeism on Tuesday and Wednesdays.
