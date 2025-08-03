# 📊 HR Analytics: Investigating Employee Absenteeism at UCI Global
![absenteeism picture](https://github.com/AreJohn/HR-Analysis-of-Employee-Absenteeism/blob/main/assets/images/absenteeism.png)
##### A data-driven case study uncovering the causes of absenteeism and offering targeted HR interventions using SQL.
## Table of Contents
- [Introduction](#Introduction)
- [Scenario](#Scenario)
- [Data Source](#Data-Source)
- [Ask Phase](#Ask-Phase)
- [Data Cleaning](#Data-Cleaning)
- [Insights](#Insights)
- [Recommendations](#Recommendations)

## Introduction
##### Employee absenteeism presents a significant challenge for organizations, impacting productivity and overall performance. This project seeks to understand absenteeism patterns at UCI Global, aiming to uncover the root causes of underperformance and provide actionable insights for HR interventions. By analyzing a comprehensive dataset, we seek to transform raw data into strategic recommendations for improving workplace attendance and employee well-being.

## Scenario
##### The management of UCI Global seeks to understand the underperformance of its employees over the past six months. As the data analyst, you are expected to use the dataset to derive why employees of different age, educational and health levels are underperforming at work.

## Data Source:
###### The [dataset](https://archive.ics.uci.edu/dataset/445/absenteeism+at+work) contains two csv files:
###### 1.	Employees_info
###### 2.	Absenteeism_info

##### 1.	Employees_info:  This table includes data on individual employees, such as their unique ID, transport expense, distance from home to work, age, number of children, pet ownership, education level, social drinking, social smoking, weight, and height.
##### 2.	Absenteeism_info: This table contains data related to employee’s absence, including their ID, reason for absence (coded numerically), month of absence, day of the week, workload average per day, employee target hit, absenteeism time in hours, service time, and disciplinary failure.

## Ask Phase
##### Questions that will guide my case study:
##### 1.	What is the number of employees working at UCI Global?
##### 2.	What is the total number of Absenteeism Reasons?
##### 3.	Total absenteeism time in hours 
##### 4.	Which month had the highest number of absences?
##### 5.	What season had the most absences reported? 
##### 6.	Find out why theres a month with 0 
##### 7.	What was the most reported absenteeism reason?
##### 8.	How many employees are classified as overweight or obese?
##### 9.	How many times did were employees who are overweight and obese report absent?
##### 10.	Which employee is a drinker, smoker and overweight? 
##### 11.	How many times did the employee who is a drinker, smoker and overweight report absent and what were the reasons?
##### 12.	What percentage of the absences reported from the employee who is a drinker, smoker and overweight were in the summer?
##### 13.	How many employees have at least 2 children or one or more pets?
##### 14.	How many times did employees that have at least 2 children or one or more pets report absent?
##### 15.	Do Employees in their 20s report absent more times on Mondays and Fridays than on other days?
##### 16.	How many employees disregarded disciplinary warnings, and what was the reason for their absence?
##### 17.	How many times did employees that disregarded disciplinary warnings report absent, and what was the reason for their absence?
##### 18.	What percentage of the employees that disregarded disciplinary warnings have a high school education level?
##### 19.	Did employees with a high school education level and a hit target value of less than 90 disregard disciplinary warnings?
##### 20.	Which season had the highest workload average per day?
##### 21.	  How many employees were only absent from work once, and what similarities do they share?


## Data Cleaning & Processing:
##### 1. Initial Data Processing

```sql
-- Exploring the data
SELECT *
FROM [Employee Absenteeism]..[Absenteeisms$]

SELECT *
FROM [Employee Absenteeism]..Employee_info$
```

```sql
-- Joining both columns
SELECT *
FROM [Employee Absenteeism]..[Absenteeisms$] AS A
INNER JOIN [Employee Absenteeism]..[Employee_info$] AS E
ON A.ID = E.Employee_ID
```

```sql
-- Create a new table called Absenteeism by joining [Employee Absenteeism] and [Employee_info$]
SELECT *
INTO Absenteeism 
FROM [Employee Absenteeism].[dbo].[Absenteeisms$] AS A
INNER JOIN [Employee Absenteeism].[dbo].[Employee_info$] AS E
ON A.ID = E.Employee_ID
```

##### 2. Checking for missing values and duplicates
```sql
-- Viewing the new table 
SELECT *
FROM
Absenteeism

-- Checking for missing values
SELECT *
FROM Absenteeism
WHERE 1-20 IS NULL
```
The data did not contain missing values

##### 1.	Checking for duplicate

```sql
SELECT ID, [Reason for absence], [Month of absence], [Day of the week], [Work load Average/day], [Hit target], [Disciplinary failure],
[Absenteeism time in hours], [Service time], COUNT(*) AS duplicate_count
FROM Absenteeism
GROUP BY ID, [Reason for absence], [Month of absence], [Day of the week], [Work load Average/day], [Hit target], [Disciplinary failure],
[Absenteeism time in hours], [Service time]
HAVING COUNT(*) > 1
```
The data does not contain duplicate values


2.	Handling categorical data
##### 2.1 Createa new column from the [Reason for absence] column to convert the numerical data to categorical
```sql
-- Create column Absenteeism_Reason from [Reason for absence]
ALTER TABLE Absenteeism 
ADD Absenteeism_Reason VARCHAR(50)

UPDATE Absenteeism
SET Absenteeism_Reason =
CASE
WHEN [Reason for absence] = 0 THEN 'Incomplete submission'
WHEN [Reason for absence] BETWEEN 1 AND 4 THEN 'Family-related'
WHEN [Reason for absence] IN (5, 6, 7, 8, 9, 10 , 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28) THEN 'Medical reasons'
ELSE 'Unjustified leave'
END
```

##### 2.2 Createa new column from the [Month of absence] column to convert the numerical data to categorical
```sql
-- Create column Months from [Month of absence]
ALTER TABLE Absenteeism 
ADD Months VARCHAR(50)

UPDATE Absenteeism
SET Months =
CASE [Month of absence]
WHEN 1 THEN 'January'
WHEN 2 THEN 'February'
WHEN 3 THEN 'March'
WHEN 4 THEN 'April'
WHEN 5 THEN 'May'
WHEN 6 THEN 'June'
WHEN 7 THEN 'July'
WHEN 8 THEN 'August'
WHEN 9 THEN 'September'
WHEN 10 THEN 'October'
WHEN 11 THEN 'November'
WHEN 12 THEN 'December'
ELSE 'Unknown'
END
```

##### 2.3 Createa new column from the [Day of the week] column to convert the numerical data to categorical
```sql
-- Create column Weekdays from [Day of the week]
ALTER TABLE Absenteeism 
ADD Weekdays VARCHAR(50)

UPDATE Absenteeism
SET Weekdays =
CASE [Day of the week]
WHEN 1 THEN 'Sunday'
WHEN 2 THEN 'Monday'
WHEN 3 THEN 'Tuesday'
WHEN 4 THEN 'Wednesday'
WHEN 5 THEN 'Thursday'
WHEN 6 THEN 'Friday'
ELSE 'Saturday'
END
```

##### 2.4 Createa new column from the [Disciplinary failure] column to convert the numerical data to categorical(Yes / No)
```sql
-- Create column Disciplinary_Status from [Disciplinary failure]
ALTER TABLE Absenteeism 
ADD Disciplinary_Status VARCHAR(50)

UPDATE Absenteeism
SET Disciplinary_Status =
CASE [Disciplinary failure]
WHEN 0 THEN 'No'
ELSE 'Yes'
END
```

##### 2.5 Createa new column from the [Education] column to convert the numerical data to categorical
```sql
-- Create column Education_Level from [Education]
ALTER TABLE Absenteeism 
ADD Education_Level VARCHAR(50)

UPDATE Absenteeism
SET Education_Level =
CASE [Education]
WHEN 1 THEN 'High School'
WHEN 2 THEN 'Graduate'
WHEN 3 THEN 'Postgraduate'
ELSE 'Master and Doctor'
END
```

##### 2.6 Createa new column from the [Social drinker] column to convert the numerical data to categorical(Yes / No)
```sql
-- Create column Drinker_Status from [Social drinker]
ALTER TABLE Absenteeism 
ADD Drinker_Status VARCHAR(50)

UPDATE Absenteeism
SET Drinker_Status =
CASE [Social drinker]
WHEN 0 THEN 'Non-drinker'
ELSE 'Drinker'
END   
```

##### 2.7 Createa new column from the [Social smoker] column to convert the numerical data to categorical(Yes / No)
```sql
-- Create a new column Smoker_Status from [Social smoker]
ALTER TABLE Absenteeism 
ADD Smoker_Status VARCHAR(50)

UPDATE Absenteeism
SET Smoker_Status =
CASE [Social smoker]
WHEN 0 THEN 'Non-smoker'
ELSE 'Smoker'
END
```

##### 2.8 Createa new column from the [Month of absence] column to convert the numerical data to categorical
```sql
-- Create a new column Season from [Month of absence]
ALTER TABLE Absenteeism 
ADD Season VARCHAR(50)

UPDATE Absenteeism
SET Season =
CASE 
WHEN [Month of absence] IN (12, 1, 2) THEN 'Winter'
WHEN [Month of absence] BETWEEN 3 AND 5 THEN 'Spring'
WHEN [Month of absence] BETWEEN 6 AND 8 THEN 'Summer'
WHEN [Month of absence] BETWEEN 9 AND 11 THEN 'Autumn'
END
```

##### 2.8 Createa new column called BMI(Body Mass Index) from the Weight and Height columns to calculate employees Body Mass Index
```sql
-- Create column BMI by calculating from Weight & Height  
ALTER TABLE Absenteeism 
ADD BMI FLOAT(50)

UPDATE Absenteeism
SET BMI = ROUND(Weight/ ((Height / 100) * (Height / 100)), 2)
```

##### 2.9 Createa new column called Health_Status from the BMI column to group employee by their weight(e.g Under weight, Over weight)
```sql
-- Create column Health_Status from BMI  
ALTER TABLE Absenteeism 
ADD Health_Status VARCHAR(50)

UPDATE Absenteeism
SET Health_Status =
CASE 
WHEN BMI < 18.5 THEN 'Under weight'
WHEN BMI <= 24.9 THEN 'Healthy weight'
WHEN BMI <= 29.9 THEN 'Over weight'
WHEN BMI >=  30.0 THEN 'Obese'
ELSE 'Underweight'
END
```

##### 3.0 View the clean data
```sql
SELECT *
FROM Absenteeism
```

## Data Analysis 
##### 1. 1.	What is the number of employees working at UCI Global?
```sql
--1. Total number of employees 
SELECT COUNT(DISTINCT ID) AS NumberOfEmployes
FROM Absenteeism
```
There are 36 employees 

##### 2. 2.	What is the total number of Absenteeism Reasons?
```sql
-- 2. Number of reported absences
SELECT COUNT(*) AS CountAbsenteeism
FROM Absenteeism
```
The total number of absences reported is 612

##### 3. What Total absenteeism time in hours 
```sql
-- 3. Total absenteeism time in hours 
SELECT SUM([Absenteeism time in hours]) AS TotalAbsenteeismHours
FROM Absenteeism
```
The total absenteeism time is 4421 hours, which is around 184 days.

##### 4. Month with the highest number of absences
```sql
-- 4. Which month had the highest number of absences?
SELECT Months,  COUNT(*)AS CountAbsenteeismReason
FROM Absenteeism 
GROUP BY Months
ORDER BY CountAbsenteeismReason
```
March had the highest number of absences

##### 5. Season with the highest number of absences
```sql
-- 5. What season had the most absences reported? 
SELECT Season,  COUNT(*) AS CountAbsenteeismReason
FROM Absenteeism 
GROUP BY Season
ORDER BY CountAbsenteeismReason
```
Spring had the most absenteeism reported with 183 absences

##### 6.	Find out why theres a month with 0
```sql
-- 6. Finding out why theres a month with 0 
SELECT [Month of absence], Months, [Absenteeism time in hours], [Reason for absence], Absenteeism_Reason
FROM Absenteeism 
WHERE Season IS NULL
```
For months that have 0, the reason for absenteeism is incomplete submission and the absenteeism time in hours is 0 hours 

##### 7. What was the most reported absenteeism reason?
```sql
SELECT Absenteeism_Reason, COUNT([Reason for absence]) AS CountAbsenteeismReason
FROM Absenteeism
GROUP BY Absenteeism_Reason
ORDER BY CountAbsenteeismReason
```
The least reported absenteeism reason was Family-related at 20 reasons, followed by unjustified leave at 30 reasons then incomplete submission at 34 reasons while medical reasons was overwhelmingly reported at 528 reasons.

##### 8. How many employees are classified as overweight or obese?
```sql
SELECT COUNT (DISTINCT ID) AS NumberOfEmployees
FROM Absenteeism
WHERE Health_Status IN( 'Over weight', 'Obese')
```
17 out of 36 employees are classified as overweight and obese. About 65.38% of employees are classified as overweight and obese

##### 9. How many times did were employees who are overweight and obese report absent?
```sql
SELECT COUNT (*) AS NumberOfEmployees
FROM Absenteeism
WHERE Health_Status IN( 'Over weight', 'Obese')
```
Employees that are overweight and obese reported absent 338 times. Employees reported absent around 55.22% of times.

##### 10. Which employee is a drinker, smoker and overweight? 
```sql
SELECT ID
FROM Absenteeism
WHERE Drinker_Status = 'Drinker' 
AND Smoker_Status = 'Smoker'
AND Health_Status = 'Over weight'
GROUP BY ID
```
 Employee with ID number 26 is a drinker, smoker and is overweight. 

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
Employee with ID number 26 reported absent 5 times and the absenteeism reason was Medical.

##### 12. What percentage of the absences reported from the employee in question 9 were in the summer?
```sql
SELECT Season , COUNT(*) AS PercentAbsenteeism
FROM Absenteeism
WHERE Drinker_Status = 'Drinker' 
AND Smoker_Status = 'Smoker'
AND Health_Status = 'Over weight'
GROUP BY Season
```
60% of absences reported from the employee in question 10 was in the summer

##### 13. How many employees have at least 2 children or one or more pets?
```sql
SELECT COUNT(DISTINCT ID) AS NumOfAbsences
FROM Absenteeism
WHERE Children >=2
AND Pet >=1
```
-- 8 employees have at least 2 children or one or more pets

##### 14. How many times did employees that have at least 2 children or one or more pets report absent?
```sql
SELECT COUNT(*) AS NumOfEmployee
FROM Absenteeism
WHERE Children >=2
AND Pet >=1
```
Employees that have at least 2 children or one or more pets reported absent 109 times. They reported absent around 17.81% of the time.

#####15. Do Employees in their 20s report absent more times on Mondays and Fridays than on other days?
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
Employees in their 20s reported absent 22 times on Mondays and Fridays and reported absent 69 times on other days.

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
Employees that disregarded disciplinary warnings reported for absence 31 times and Incomplete submission was the reason.

##### 18. What percentage of the employees that disregarded disciplinary warnings have a high school education level?
```sql
SELECT COUNT(*) AS NumEmployee, Absenteeism_Reason, Education_Level
FROM Absenteeism
WHERE Disciplinary_Status = 'Yes'
GROUP BY Absenteeism_Reason, Education_Level
```
90% of employees that disregarded disciplinary warnings had high school education

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
78.5% employees with a high school education level and a hit target value of less than 90 did not disregard warning while, 21.4% disregard warning

##### 20.  Which season had the highest workload average per day?
```sql
SELECT Season, [Work load Average/day]
FROM Absenteeism
GROUP BY Season, [Work load Average/day]
ORDER BY [Work load Average/day] DESC
```
Spring had the highest workload average per day

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
2 employees were absent from work only once, they are both high school education level, non-smokers, on average they spend $118 on transporting expenses and on average they spend less than hour on absenteeism.


## Insights 
##### 1.	Employees and Absences: 
##### •	There are 36 employees in total 
##### •	The total number of absenteeism reported is 612.
##### •	The total absenteeism time is 4,421 hours. Which is around 184 days.

##### 2.	Absenteeism patterns: 
##### •	For months that have 0, the reason for absenteeism is incomplete submission and the absenteeism time was 0 hours.
##### •	March had the highest number of absences.
##### •	Spring had the most Absenteeism reported with 183 reasons.
##### •	Spring had the highest workload on average per day.

##### 3.	Reasons for Absenteeism: The least reported absenteeism reason was Family-related at 20 reasons, followed by unjustified leave at 30 reasons then incomplete submission at 34 reasons while medical reasons were overwhelmingly reported at 528 reasons.

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


## Recommendations 
##### 1. Implement Employee Well-being Programs:
###### ● Introduce health and wellness programs focused on regular exercise, stress management, and preventive care.
###### ● Provide targeted wellness plans for overweight or obese employees to reduce health-related absenteeism.
###### ● Implement smoking and alcohol cessation programs for employees at higher risk of absenteeism.

##### 2. Offer Flexible Scheduling During Peak Absenteeism Periods
###### ● Adjust work schedules during peak absenteeism periods, particularly in March and Spring (183 absences).
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
###### ● Engage younger employees to reduce absenteeism on Mondays and Fridays.
