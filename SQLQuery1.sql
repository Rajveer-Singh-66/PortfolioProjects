select * from PortfolioProject..coviddeath
where continent is not null
order by 3,4;

--select * from PortfolioProject..covidvaccinations
--order by 3,4;

--select Data that we are going to using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..coviddeath
order by 1,2

--Looking at Total Cases vs Total Deaths

select location, date, total_cases, total_deaths
from PortfolioProject..coviddeath
order by 1,2
update PortfolioProject..coviddeath set total_cases=NULL where total_cases=0
update PortfolioProject..coviddeath set total_deaths=NULL where total_deaths=0
-- Shows likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..coviddeath
where location like '%asia%'
order by 1,2

-- Looking at Total Cases vs Population
--Shows what percentage of population got Covid

select location, date,population, total_cases,  (total_cases/population)*100 as CasesPercentage
from PortfolioProject..coviddeath
--where location like '%asia%'
order by 1,2

--Looking at Countries with highest Infection RAte compared to Population

select location, population, max(total_cases) as HighestIngectionCount, max(total_cases/population)*100 as PrecentPopulationInfected
from PortfolioProject..coviddeath
--where location like '%asia%'
group by location, population
order by PrecentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..coviddeath
--where location like '%asia%'
where continent is not null
group by location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..coviddeath
--where location like '%asia%'
where continent is not null
group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBER

Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Nullif(Sum(New_cases),0)*100 as DeathPercentage
from PortfolioProject..coviddeath
--where location like '%asia%'
where continent is not null
--group by date
order by 1,2

select *
from PortfolioProject..coviddeath dea
join PortfolioProject..covidvaccinations vac

--Looking at Total Population vs Vacciantions

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..coviddeath dea
join PortfolioProject..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..coviddeath dea
join PortfolioProject..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac

-- TEMP TABLE

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..coviddeath dea
join PortfolioProject..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..coviddeath dea
join PortfolioProject..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated