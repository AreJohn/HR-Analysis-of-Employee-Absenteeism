-- Exploring the data
SELECT *
FROM [Employee Absenteeism]..[Absenteeisms$]

SELECT *
FROM [Employee Absenteeism]..Employee_info$

-- Joining both columns
SELECT  *
FROM [Employee Absenteeism]..[Absenteeisms$] AS A
INNER JOIN [Employee Absenteeism]..[Employee_info$] AS E
ON A.ID = E.Employee_ID

-- Checking for missing values
SELECT DISTINCT A.ID
FROM [Employee Absenteeism]..[Absenteeisms$] AS A
LEFT JOIN [Employee Absenteeism]..[Employee_info$] AS E ON A.ID = E.Employee_ID
WHERE E.Employee_ID IS NULL
-- The data did not contain missing values


-- Create a new table called Absenteeism by joining [Employee Absenteeism] and [Employee_info$]
SELECT *
INTO Absenteeism 
FROM [Employee Absenteeism].[dbo].[Absenteeisms$] AS A
INNER JOIN [Employee Absenteeism].[dbo].[Employee_info$] AS E
ON A.ID = E.Employee_ID

-- View the new table 
SELECT *
FROM Absenteeism


-- Data Transformation: changing categorical data into ordinal data
-- Create a new column called AbsenteeismReason from [Reason for absence]
ALTER TABLE Absenteeism
ADD AbsenteeismReason VARCHAR(60)

UPDATE Absenteeism
SET AbsenteeismReason =
CASE
WHEN [Reason for absence] = 0 THEN 'Incomplete submission'
WHEN [Reason for absence] BETWEEN 1 AND 4 THEN 'Family-related'
WHEN [Reason for absence] = 26 THEN 'Unjustified leave'
ELSE 'Medical reasons'
END

-- Create a new column called months from [Month of absence]
ALTER TABLE Absenteeism 
ADD Months VARCHAR(60)

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

-- Create a new column called Weekdays from [Day of the week]
ALTER TABLE Absenteeism 
ADD Weekdays VARCHAR(60)

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

-- Create a new column called DisciplinaryStatus from [Disciplinary failure]
ALTER TABLE Absenteeism 
ADD DisciplinaryStatus VARCHAR(60)

UPDATE Absenteeism
SET DisciplinaryStatus =
CASE [Disciplinary failure]
WHEN 0 THEN 'No'
ELSE 'Yes'
END

-- Create a new column called EducationLevel from [Education]
ALTER TABLE Absenteeism 
ADD EducationLevel VARCHAR(60)

UPDATE Absenteeism
SET EducationLevel =
CASE [Education]
WHEN 1 THEN 'High School'
WHEN 2 THEN 'Graduate'
WHEN 3 THEN 'Postgraduate'
ELSE 'Master and Doctor'
END
 
-- Create a new column called DrinkerStatus from [Social drinker]
ALTER TABLE Absenteeism 
ADD DrinkerStatus VARCHAR(60)

UPDATE Absenteeism
SET DrinkerStatus =
CASE [Social drinker]
WHEN 0 THEN 'Non-drinker'
ELSE 'Drinker'
END  

-- Create a new column called SmokerStatus from [Social smoker]
ALTER TABLE Absenteeism 
ADD SmokerStatus VARCHAR(60)

UPDATE Absenteeism
SET SmokerStatus =
CASE [Social smoker]
WHEN 0 THEN 'Non-smoker'
ELSE 'Smoker'
END 

-- Create a new column called Season from [Month of absence]
ALTER TABLE Absenteeism
ADD Season VARCHAR(60)

UPDATE Absenteeism
SET Season =
CASE
WHEN [Month of absence] BETWEEN 1 AND 2 THEN 'Summer'
WHEN [Month of absence] = 12 THEN 'Summer'
WHEN [Month of absence] BETWEEN 3 And 5 THEN 'Autumn'
WHEN [Month of absence] BETWEEN 6 AND 8 THEN 'Winter'
WHEN [Month of absence] BETWEEN 9 AND 11 THEN 'Spring'
END

-- Impute the mode of Season for Unknown months
UPDATE Absenteeism
SET Season = (
  SELECT Top 1 Season
  FROM(
    SELECT Season, COUNT(*) AS SeasonCount
    FROM Absenteeism
    GROUP BY Season
  ) AS SeasonCount
  ORDER BY SeasonCount DESC)
WHERE Months = 'Unknown'

-- Create new column BMI from Height and Weight
ALTER TABLE Absenteeism
ADD BMI INT

UPDATE Absenteeism
SET BMI = ROUND(Weight/((Height/100)*(Height/100)), 2)

-- Create a new column called HealthStatus from BMI
ALTER TABLE Absenteeism
ADD HealthStatus VARCHAR(60)

UPDATE Absenteeism
SET HealthStatus =
CASE 
WHEN BMI < 19 THEN 'Underweight'
WHEN BMI >= 19 AND BMI < 25 THEN 'Normal weight'
WHEN BMI >= 25 AND BMI < 30 THEN 'Overweight'
WHEN BMI >= 30  THEN 'Obese'
END


-- Analysis 
--1. What is the total number of employees at UCI Global?
SELECT COUNT (DISTINCT Employee_ID)
FROM Absenteeism  

--2. Total numbr of absenteeism reasons
SELECT COUNT([Reason for absence]) 
FROM Absenteeism  

--3. Which month had the highest recorded absences and in what season did they happen? 
SELECT Months, Season, COUNT(AbsenteeismReason) AS ReportedAbsenteeism
FROM Absenteeism
GROUP BY Months, Season
ORDER BY ReportedAbsenteeism DESC

-- 4. Is there any recorded absences that is out of place?
SELECT Months, AbsenteeismReason, COUNT(AbsenteeismReason) AS ReportedAbsenteeism
FROM Absenteeism
WHERE Months = 'Unknown'
GROUP BY Months, AbsenteeismReason

-- 5. How many times was family-relayed absenteeism reported?
SELECT AbsenteeismReason, COUNT(AbsenteeismReason) AS ReportedAbsenteeism
FROM Absenteeism
GROUP BY AbsenteeismReason

---- 6. How many employees are classified as overweight and obese?
SELECT HealthStatus, COUNT( DISTINCT ID) AS NumAbsentEmployees
FROM Absenteeism
GROUP BY HealthStatus

-- Are overweight or obese employees absent more frequently?
SELECT HealthStatus, COUNT([Reason for absence]) AS NumAbsences
FROM Absenteeism
GROUP BY HealthStatus

----7. Which employee is Overweight, Social drinker, Social Smoker
SELECT Employee_ID, HealthStatus, DrinkerStatus,SmokerStatus
FROM Absenteeism
WHERE BMI >= 25 
AND DrinkerStatus = 'Drinker'
AND SmokerStatus = 'Smoker'

-- 8.  How many times did the employee from question 7 report absenteeism, and what were the reasons?
SELECT AbsenteeismReason, COUNT(*) AS CountReportedAbsenteeism
FROM Absenteeism
WHERE BMI >= 25 AND BMI < 30
AND DrinkerStatus = 'Drinker'
AND SmokerStatus = 'Smoker'
Group by AbsenteeismReason

-- 9.  What percentage of the absences reported from the employee from question 7 were in winter?
SELECT Employee_ID, AbsenteeismReason, Season, HealthStatus, DrinkerStatus,SmokerStatus
FROM Absenteeism
WHERE BMI >= 25 
AND DrinkerStatus = 'Drinker'
AND SmokerStatus = 'Smoker'

-- 10.	How many employees have at least two children and at least more than two pets
--and how many times did they report absent?
SELECT COUNT (DISTINCT Employee_ID)
FROM Absenteeism
WHERE Children >= 2
OR Pet >= 2

SELECT COUNT (*)
FROM Absenteeism
WHERE Children >= 2
OR Pet >= 2

SELECT COUNT (*), Pet, Children
FROM Absenteeism
Group By Pet, Children

-- 11.	Were employees in their 20s more absent on Mondays and Fridays than on other days?
-- How many employees are in their 20s?
SELECT COUNT(DISTINCT ID)
FROM Absenteeism
WHERE Age BETWEEN 20 AND 29 

-- Number of absences by employees in their 20s
SELECT ID, Age, Weekdays
FROM Absenteeism
WHERE Age BETWEEN 20 AND 29 
OR Weekdays = 'Monday' OR 
Weekdays = 'Friday'

--12.	How many employees disregarded disciplinary warnings, and what was the reason for their absence?
-- How many employees disregarded disciplinary warnings?
SELECT COUNT(DISTINCT ID) AS CountDisciplinaryDefaulter, AbsenteeismReason
FROM Absenteeism
WHERE DisciplinaryStatus = 'Yes'
GROUP BY AbsenteeismReason

-- How many Employees were absent and ignored disciplinary warnings?
SELECT COUNT(*) AS DisciplinaryAbsences
FROM Absenteeism
WHERE DisciplinaryStatus = 'Yes'


SELECT COUNT(DISTINCT ID) AS CountDisciplinaryDefaulter, AbsenteeismReason,
EducationLevel,DisciplinaryStatus
FROM Absenteeism
GROUP BY AbsenteeismReason, EducationLevel, DisciplinaryStatus

-- 13. Based on the data, did employees with a high school education level and a hit target less than 90 disregard disciplinary warnings?
SELECT COUNT(DISTINCT ID) AS CountDisciplinaryDefaulter, AbsenteeismReason, EducationLevel, [Hit target], DisciplinaryStatus
FROM Absenteeism
WHERE EducationLevel = 'High School'
AND [Hit target] < 90
GROUP BY AbsenteeismReason, EducationLevel, [Hit target], DisciplinaryStatus

--14.	What season had had the highest work load average per day?
SELECT Season, [Work load Average/day], COUNT(*) AS NumAbsences
FROM Absenteeism
GROUP BY Season, [Work load Average/day]
ORDER BY [Work load Average/day] DESC

--15. How many employees were only absent from work once and what similarities did they share?
SELECT 
    ID,
    COUNT(*) AS NumAbsences,
    AVG([Transportation expense]) AS AvgTransportExpense,
    AVG([Distance from home to work]) AS AvgDistance,
    AVG(Age) AS AvgAge,
    AVG(Children) AS AvgChildren,
    AVG(Pet) AS AvgPet,
    AVG([Education]) AS AvgEducation,
    EducationLevel,
    AVG([Social drinker]) AS AvgDrinker,
    DrinkerStatus,
    AVG([Social smoker]) AS AvgSmoker,
    SmokerStatus,
    AVG(BMI) AS AvgBMI,
    HealthStatus,
    AVG([Absenteeism time in hours]) AS AvgAbsenteeismHours
FROM Absenteeism
GROUP BY 
    ID, 
    EducationLevel, 
    DrinkerStatus, 
    SmokerStatus, 
    HealthStatus
HAVING COUNT(*) = 1

