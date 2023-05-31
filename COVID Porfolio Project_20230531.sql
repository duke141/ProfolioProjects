
Select *
From PorfolioProject1..CovidDeaths
where continent is not null
Order by 3, 4

--Select *
--From PorfolioProject1..CovidVaccinations
--Order by 3, 4

--Select Data that we are going to using

Select Location, date, total_cases, new_cases, total_deaths, population
From PorfolioProject1..CovidDeaths
where continent is not null
order by 1, 2


--Looking at Total Cases vs Total Deaths


Select Location, date, total_cases, total_deaths, (cast(total_deaths as real)/total_cases) * 100 as DeathPercentage
From PorfolioProject1..CovidDeaths
where continent is not null
--where location like ('%states%')
order by 1, 2 


-- Looking at Total Cases vs Population
-- Show what percentage of population got Covid


Select Location, date, population, total_cases, (total_cases/population) * 100 as PercentPopulationInfected
From PorfolioProject1..CovidDeaths
where continent is not null
--where location like ('%states%')
order by 1, 2 


-- Looking at Countries with Highest Infection Rate compared to Population


Select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population)) * 100 as PercentPopulationInfected
From PorfolioProject1..CovidDeaths
where continent is not null
--where location like ('%states%')
group by location, population -- group by as much as inaggrate columns
order by PercentPopulationInfected desc


-- Showing Countries with Highest Death Count per Population

Select Location, max(Total_deaths) as TotalDeathCount
From PorfolioProject1..CovidDeaths
where continent is not null
--where location like ('%states%')
group by location-- group by as much as inaggrate columns
order by TotalDeathCount desc


-- LET'S BREAL THINGS DOWN BY CONTINENT


Select continent, max(Total_deaths) as TotalDeathCount
From PorfolioProject1..CovidDeaths
where continent is not null
--where location like ('%states%')
group by continent-- group by as much as inaggegrate columns
order by TotalDeathCount desc


-- Showing continents with Highest death count per population


Select continent, max(Total_deaths) as TotalDeathCount
From PorfolioProject1..CovidDeaths
where continent is not null
--where location like ('%states%')
group by continent-- group by as much as inaggrate columns
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, sum(new_cases)/sum(new_deaths) * 100 as DeathPercentage
From PorfolioProject1..CovidDeaths
where continent is not null
--and location like ('%states%')
--group by date
order by 1, 2 


-- Looking at Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) ---????????
as RollingPeopleVaccinated --(RollingPeopleVaccinated/population) * 100
from PorfolioProject1..CovidDeaths dea
join PorfolioProject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date =  vac.date
where dea.continent is not null --and dea.location = 'Albania'
order by 2, 3 


-- USE CTE

With PopvsVac as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) ---????????
as RollingPeopleVaccinated --(RollingPeopleVaccinated/population) * 100
from PorfolioProject1..CovidDeaths dea
join PorfolioProject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date =  vac.date
where dea.continent is not null and dea.location = 'Albania'
--order by 2, 3 ????????
)
Select *, (RollingPeopleVaccinated/population) * 100
from PopvsVac


-- TEMP TABLE ????????

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(50),
Location nvarchar(50),
Date date,
Population float,
New_vaccinations  nvarchar(50),
RollingPeopleVaccinated int
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) ---????????
as RollingPeopleVaccinated --(RollingPeopleVaccinated/population) * 100
from PorfolioProject1..CovidDeaths dea
join PorfolioProject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date =  vac.date
where dea.continent is not null --and dea.location = 'Albania'
--order by 2, 3 ????????

Select *, (RollingPeopleVaccinated/Population) * 100
from #PercentPopulationVaccinated


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) ---????????
as RollingPeopleVaccinated --(RollingPeopleVaccinated/population) * 100
from PorfolioProject1..CovidDeaths dea
join PorfolioProject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date =  vac.date
where dea.continent is not null --and dea.location = 'Albania'
--order by 2, 3 ????????