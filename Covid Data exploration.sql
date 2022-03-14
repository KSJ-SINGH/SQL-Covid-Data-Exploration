/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

/* Initialising the data*/

Select * from deaths
where continent is not null
order by 3,4;

/*Selecting the data we will be needing*/

select location, date, population, total_cases, total_deaths
from deaths
where continent is not null
order by 1,2;

-- Total cases vs Total deaths
-- Likelihood of dying if you contract covid in your country of residence

select location, date, population,total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as Deathpercentage
from deaths
where location = 'India';

--Total Cases vs Population
--Illustrates the proportion of population infected with the Virus

select location, date, population,total_cases,round((total_cases/population)*100,2) as InfectionRate
from deaths
where location = 'India'
order by 2 asc;


--Total Deaths vs Population
--Illustrates the probability of dying during the pandemic

select location, date, population, total_deaths, round((total_deaths/population)*100, 2) as DeathPercentage
from deaths
where location = 'India'
order by 2 asc;


--Countries with the highest infection rate compared to Population
select location, max(total_cases) as HighestInfectionCount, max(round((total_cases/population)*100,2))as HighestInfectionPercentage
from deaths
where  total_cases is not null
group by location
order by HighestInfectionCount desc;


-- Countries with Highest Death Count per Population

select location, max(total_deaths) as HighestDeathCount, max(round((total_deaths/population)*100, 2)) as HighestDeathPercentage
from deaths
where total_deaths is not null and population is not null
group by location
order by HighestDeathCount desc;


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

select continent, max(total_deaths)  as HighestDeathCount, max(round((total_deaths/population)*100, 2)) as HighestDeathPercentage
from deaths
where continent is not null
group by continent
order by HighestDeathCount desc;