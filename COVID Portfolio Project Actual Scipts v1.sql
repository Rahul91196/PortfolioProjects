Select *
From [Portfolio Project]..[CovidDeaths]
where continent is not null
order by 3,4

--Select *
--From [Portfolio Project]..CovidVaccinations
--Order by 3,4

-- Select Data that we are going to use
Select Location,date, total_cases,new_cases,total_deaths,population
From [Portfolio Project]..CovidDeaths
where continent is not null
Order by 1,2

-- Looking at total cases vs total deaths
Select Location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
where continent is not null
--Where location like 'India'
Order by 1,2

--Looking at total cases vs Population
-- Shows what percentage of population got covid
Select Location,date, total_cases,population,(total_cases/population)*100 as PercentofPopulationInfected
From [Portfolio Project]..CovidDeaths
where continent is not null
--Where location like 'India'
Order by 1,2

-- Looking at countries with highest infection rate comapred to population
Select Location, MAX(total_cases) as HighestInfectionCount,population,MAX(total_cases/population)*100 as PercentofPopulationInfected
From [Portfolio Project]..CovidDeaths
where continent is not null
--Where location like 'India'
Group by Location, population
Order by PercentofPopulationInfected desc


--Showing Countries with highest death count per population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
where continent is not null
--Where location like 'India'
Group by Location
Order by TotalDeathCount desc


--Lets break things down by continent


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
where continent is not null
--Where location like 'India'
Group by continent
Order by TotalDeathCount desc


--Showing the continents with highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
where continent is not null
--Where location like 'India'
Group by continent
Order by TotalDeathCount desc

--Global Numbers
Select SUM((new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(new_cases)*100

from [Portfolio Project]..CovidDeaths
Where continent is not null
--Where location like 'India'
--Group By date
Order by 1,2


--looking at total popluations vs vaccinations

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rollingpeoplevaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
Order by 2,3


--USE CTE

With PopvsVac (continent, location,date,population,new_vacciantions, Rollingpeoplevaccianted)
as
(Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rollingpeoplevaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
--Order by 2,3
)
Select *,(Rollingpeoplevaccianted/population)*100
From PopvsVac


--Temp table
DROP table if exists #Percentagepopulationvaccinated
Create Table #Percentagepopulationvaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
Rollingpeoplevaccinated numeric 
)

Insert into #Percentagepopulationvaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rollingpeoplevaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
--Order by 2,3

Select *,(Rollingpeoplevaccinated/population)*100
From #Percentagepopulationvaccinated



--Creatin view to store data for later visualizations

CREATE VIEW Percentagepopulationvaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rollingpeoplevaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
--Order by 2,3


Select *
From Percentagepopulationvaccinated