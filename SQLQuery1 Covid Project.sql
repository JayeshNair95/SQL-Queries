select * from [Portfolio project] ..Death_by_Covid_data
where continent is not Null 
order by 3,4


select * from [Portfolio project] ..Covid_Vaccination_data
where continent is not Null 
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population 
from [Portfolio project] ..Death_by_Covid_data
where continent is not Null 
order by 1,2

--Total cases vs Total deaths
--Probability of dying if one gets covid


select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from [Portfolio project] ..Death_by_Covid_data
where continent is not Null 
--where location like 'india'
order by 1,2

--Total cases vs Population
--Percentage of People affected by covid

select location, date, total_cases, population, (total_cases/population)*100 as Percentage_of_population_affected
from [Portfolio project] ..Death_by_Covid_data
where continent is not Null 
--where location like 'india'
order by 1,2


--countries with highest infection count


select location, population, max(total_cases) as Highest_Infection_Count, max(total_cases/population)*100 as Percentage_of_population_affected
from [Portfolio project] ..Death_by_Covid_data
where continent is not Null 
--where location like 'india'
Group by location, population
order by Percentage_of_population_affected desc


--countries with highest death count


select location, population, max(cast(Total_deaths as int)) as Total_Death_Count
from [Portfolio project] ..Death_by_Covid_data 
where continent is not Null 
--where location like 'india'
group by location, population
order by Total_Death_Count desc


--continent with highest death count


select location, max(cast(Total_deaths as int)) as Total_Death_Count
from [Portfolio project] ..Death_by_Covid_data 
where continent is Null 
--where location like 'india'
group by location
order by Total_Death_Count desc


select date, sum(cast(new_cases as int)) as Total_Cases, sum(cast(new_deaths as int))as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from [Portfolio project] ..Death_by_Covid_data 
where continent is not Null 
group by date
order by date



select sum(cast(new_cases as int)) as Total_Cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from [Portfolio project] ..Death_by_Covid_data 
where continent is not Null 
order by 1,2


-- Total Popolation VS Vaccinations

SELECT X.continent, X.location, X.date, X.population, Y.new_vaccinations,
SUM(CAST(Y.new_vaccinations AS NUMERIC)) OVER (PARTITION BY X.location ORDER BY X.location, X.date) as Cumilated_Vaccinations
FROM [Portfolio project] ..Death_by_Covid_data X
Join [Portfolio project]..Covid_Vaccination_data Y
    ON X.location = Y.location
	AND X.date = Y.date
where X.continent is not Null 
order by 2,3



--Use of CTE



WITH populationVSvaccination (continent, location, date, population, new_vaccinations, Cumilated_Vaccinations)
as
(
SELECT X.continent, X.location, X.date, X.population, Y.new_vaccinations,
SUM(CAST(Y.new_vaccinations AS NUMERIC)) OVER (PARTITION BY X.location ORDER BY X.location, X.date) as Cumilated_Vaccinations
FROM [Portfolio project] ..Death_by_Covid_data X
Join [Portfolio project]..Covid_Vaccination_data Y
    ON X.location = Y.location
	AND X.date = Y.date
where X.continent is not Null 
)
SELECT*, (Cumilated_Vaccinations/population)*100
FROM populationVSvaccination
ORDER BY 2,3



--TABLEAU PROJECT QUERY

--1.

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Portfolio project]..Death_by_Covid_data
--Where location like 'india'
where continent is not null 
--Group By date
order by 1,2


--2.

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Portfolio project]..Death_by_Covid_data
--Where location like 'india'
Where continent is null 
and location not in ('World', 'European Union', 'International','Upper middle income','High income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc


--3.

Select location, population, max(total_cases) as Highest_Infection_Count, max(total_cases/population)*100 as Percentage_of_population_affected
From [Portfolio project] ..Death_by_Covid_data
Where continent is not Null 
--where location like 'india'
Group by location, population
order by Percentage_of_population_affected desc


--4.


Select location, population, date, max(total_cases) as Highest_Infection_Count, max(total_cases/population)*100 as Percentage_of_population_affected
From [Portfolio project] ..Death_by_Covid_data
Where continent is not Null 
--where location like 'india'
Group by location, population
order by Percentage_of_population_affected desc
