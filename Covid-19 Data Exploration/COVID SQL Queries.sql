Select *
from PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4



--Global Numbers

Select  SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
Order by 1,2

-- Infection Per Continent
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

-- Showing Countries with the highest death count per population
Select Location, MAX(CAST(Total_deaths as int) ) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
Order by TotalDeathCount desc

--Looking at countries with the highest infection rate compared to population
Select Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/Population))*100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location, Population
Order by PercentPopulationInfected desc

-- Shows the likelihood of dying if you contract covid in the United States
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
Order by 1,2





-- Select Data that to be use
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

-- Looking at the total cases vs total deaths
-- Shows the likelihood of dying if you contract covid in the United States

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
Order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of the population got covid

Select Location, date, total_cases,Population, (total_cases/Population)*100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null
Order by 1,2


-- Showing Countries with the highest death count per population

Select Location, MAX(CAST(Total_deaths as int) ) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
Order by TotalDeathCount desc


--Looking at Total population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- USE CTE
With PopvsVac (continent, location, Date, Population,new_vaccination, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 as RollingPercentVaccinated
From PopvsVac

-- Temp Table


Create Table #PercentPopulationVaccincated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccincated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
Select *, (RollingPeopleVaccinated/Population)*100 as RollingPercentVaccinated
From #PercentPopulationVaccincated



DROP Table if exists #PercentPopulationVaccincated
Create Table #PercentPopulationVaccincated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccincated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
Select *, (RollingPeopleVaccinated/Population)*100 as RollingPercentVaccinated
From #PercentPopulationVaccincated


-- Creating View to store data for later viz

Create View PercentPopulationVaccincated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccincated
