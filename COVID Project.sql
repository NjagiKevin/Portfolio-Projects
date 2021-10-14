select *
from [PortfolioProject].[dbo].[Covid_Deaths$]
where continent is not null
order  by 3,4


--select *
--from [PortfolioProject].[dbo].[Covid_Vaccinations$]


--Select data that we are going to be using

select location, date, new_cases, total_cases, total_deaths, population
from [PortfolioProject].[dbo].[Covid_Deaths$]
order  by 1,2


--Looking ar Total cases vs Total Deaths
--Shows likelihood of dying if you contract Covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [PortfolioProject].[dbo].[Covid_Deaths$]
where location like 'Kenya'
order  by 1,2


--Looking at Total cases vs Population
--Showing what percentage of population got covid
select location, date, total_cases, population, (total_cases/population)*100 as PositivityRate
from [PortfolioProject].[dbo].[Covid_Deaths$]
--where location like 'Kenya'
order  by 1,2


--Looking at countries with highest infction rate compared to population
select location, population, max(total_cases) as HighestInfctionCount, max((total_cases/population))*100 as PercentOfPopulationInfected
from [PortfolioProject].[dbo].[Covid_Deaths$]
group by population, location
order  by PercentOfPopulationInfected desc


--Showing the countries with Highest Death Count per Population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from [PortfolioProject].[dbo].[Covid_Deaths$]
where [continent] is not null
group by location
order  by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from [PortfolioProject].[dbo].[Covid_Deaths$]
where [continent] is not null
group by continent
order  by TotalDeathCount desc


--Showing the continents with the highest death count per population
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from [PortfolioProject].[dbo].[Covid_Deaths$]
where [continent] is not null
group by continent
order  by TotalDeathCount desc


--GLOBAL NUMBERS
select date, sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/ sum(new_cases) *100 as Death_Percentage
from [PortfolioProject].[dbo].[Covid_Deaths$]
where continent is not null
group by date
order  by 1,2

select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/ sum(new_cases)*100 as Death_Percentage
from [PortfolioProject].[dbo].[Covid_Deaths$]
where continent is not null
--group by date
order  by 1,2


--Looking at total population vs Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) 
over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [PortfolioProject].[dbo].[covid_deaths$] as dea
join [PortfolioProject].[dbo].[covid_vaccinations$] as vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3




--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) 
over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [PortfolioProject].[dbo].[covid_deaths$] as dea
join [PortfolioProject].[dbo].[covid_vaccinations$] as vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)
from PopvsVac



--TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
CREATE Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert  into  #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) 
over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [PortfolioProject].[dbo].[covid_deaths$] as dea
join [PortfolioProject].[dbo].[covid_vaccinations$] as vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3

Select *, (RollingPeopleVaccinated/Population)
from  #PercentPopulationVaccinated





--Creating View to store  data later for visualizations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) 
over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [PortfolioProject].[dbo].[covid_deaths$] as dea
join [PortfolioProject].[dbo].[covid_vaccinations$] as vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null



Select *
from [PercentPopulationVaccinated]
