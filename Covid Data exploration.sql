/*
Covid 19 Data Exploration 
Skills used: JOINs, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

/* InitialISing the data*/

SELECT * FROM deaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

/*SELECTing the data we will be needing*/

SELECT location, date, population, total_cases, total_deaths
FROM deaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Total cases vs Total deaths
-- Likelihood of dying if you contract covid in your country of residence

SELECT location, date, population,total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,2) as Deathpercentage
FROM deaths
WHERE location = 'India' and total_cases IS NOT NULL and total_deaths IS NOT NULL;

--Total Cases vs Population
--Illustrates the proportion of population infected with the Virus

SELECT location, date, population,total_cases,ROUND((total_cases/population)*100,2) as InfectionRate
FROM deaths
WHERE location = 'India'
ORDER BY 2 asc;


--Total Deaths vs Population
--Illustrates the probability of dying during the pandemic

SELECT location, date, population, total_deaths, ROUND((total_deaths/population)*100, 2) as DeathPercentage
FROM deaths
WHERE location = 'India'
ORDER BY 2 asc;


--Countries with the highest infection rate compared to Population
SELECT location,SUM(total_cases) as HighestInfectionCount,SUM(ROUND((total_cases/population)*100,2))as HighestInfectionPercentage
FROM deaths
WHERE  total_cases IS NOT NULL
GROUP BY location
ORDER BY HighestInfectionCount desc;


-- Countries with Highest Death Count per Population

SELECT location,SUM(total_deaths) as HighestDeathCount,SUM(ROUND((total_deaths/population)*100, 2)) as HighestDeathPercentage
FROM deaths
WHERE total_deaths IS NOT NULL and population IS NOT NULL
GROUP BY location
ORDER BY HighestDeathCount desc;



-- Showing contintents with the highest death count per population

SELECT continent,SUM(total_deaths)  as HighestDeathCount,SUM(ROUND((total_deaths/population)*100, 2)) as HighestDeathPercentage
FROM deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY HighestDeathCount desc;

-- Showing continents with the highest infection rate compared to Population

SELECT continent,SUM(total_cases) as HighestInfectionCount,SUM(ROUND((total_cases/population)*100,2))as HighestInfectionPercentage
FROM deaths
WHERE continent IS NOT NULL and total_cases IS NOT NULL
GROUP BY continent
ORDER BY HighestInfectionCount desc;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine in India
 
 SELECT d.location, d.date,d.population,  v.new_vaccinations,  ROUND((v.new_vaccinations/d.population)*100,2) as VaccinationPercentage
 FROM deaths d
 JOIN vaccinations v on d.date = v.date and d.location = v.location
 WHERE d.continent IS NOT NULL and v.new_vaccinations IS NOT NULL and d.location = 'india'
 ORDER BY d.date asc;

 --Total Population vs fully vaccinated
 --Shows Percentage of Population that have been fully vacinnatied in India

 SELECT d.location, d.date, d.population, v.people_fully_vaccinated,ROUND((v.people_fully_vaccinated/population)*100,2) as FullyVaccinatedPercentage
 FROM deaths d
 JOIN vaccinations v on d.date = v.date and d.location = v.location
 WHERE d.continent IS NOT NULL and v.people_fully_vaccinated IS NOT NULL and d.location = 'india'
 ORDER BY d.date asc;


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From deaths as d
Join vaccinations as v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From deaths as d
Join vaccinations as v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac
