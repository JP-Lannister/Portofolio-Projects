

  select * from Portofolioproject.dbo.['owid-covid-data (1)$']
  order by 3,4

  
  select * from Portofolioproject.dbo.['owid-covid-data (1)$']
  where continent is not null
  order by 3,4

  select * from Portofolioproject.dbo.Covid_Vaccinations$
  order by 3,4

  select location, date, total_cases, new_cases, total_deaths, population
  from Portofolioproject.dbo.['owid-covid-data (1)$']
    order by 1,2

-- Looking at Total Cases vs Total Deaths

-- Shows death rate due to covid in Nigeria
select location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as Death_Percentage
from Portofolioproject.dbo.['owid-covid-data (1)$']
where location = 'Nigeria'
order by 1,2 

-- Total cases vs Population
-- Shows what percentage of population got Covid

select location, date, total_cases, population, ((total_cases/population)*100) as Percentage_infectionRate
from Portofolioproject.dbo.['owid-covid-data (1)$']
where location = 'Nigeria'
order by 1,2 

-- Looking at countries with highest infection rate compared to population

select location, population, max(total_cases) as Highest_InfectionCount, max((total_cases/population)*100) as
Percentage_population_Infected
from Portofolioproject.dbo.['owid-covid-data (1)$']
group by location, population
order by Percentage_population_Infected desc 

-- Showing Countries with highest death count per population


select location, max(cast(total_deaths as int)) as Total_BodyCount
from Portofolioproject.dbo.['owid-covid-data (1)$']
where continent is not null
group by location
order by Total_BodyCount desc 

-- BREAKING  IT DOWN BY CONTINENT

select continent, max(cast(total_deaths as int)) as Total_BodyCount
from Portofolioproject.dbo.['owid-covid-data (1)$']
where continent is not null
group by continent
order by Total_BodyCount desc   

select location, max(cast(total_deaths as int)) as Total_BodyCount
from Portofolioproject.dbo.['owid-covid-data (1)$']
where location is not null
group by location
order by Total_BodyCount desc   

-- Showing continents with the highest death count per population

select continent, max(cast(total_deaths as int)) as Total_BodyCount
from Portofolioproject.dbo.['owid-covid-data (1)$']
where continent is not null
group by continent
order by Total_BodyCount desc   

select sum(new_cases) as Total_cases, sum(cast (new_deaths as int)) as Total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as Death_Percsentage
from Portofolioproject.dbo.['owid-covid-data (1)$']
-- where location = 'Nigeria'
where continent is not null
--group by date
order by 1,2 


-- Total Population vs Vaccination

select * from Portofolioproject.dbo.Covid_Vaccinations$

select * from Portofolioproject.dbo.['owid-covid-data (1)$'] dea
join Portofolioproject.dbo.Covid_Vaccinations$ vac
	on dea.location = vac.location
	and
	dea.date = vac.date

     

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from Portofolioproject.dbo.['owid-covid-data (1)$'] dea
join Portofolioproject.dbo.Covid_Vaccinations$ vac 
	on dea.location = vac.location
	and
	dea.date = vac.date
where dea.continent is not null 
-- and new_vaccinations is not null
-- and dea.location = 'Nigeria'
order by 2,3



select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from Portofolioproject.dbo.['owid-covid-data (1)$'] dea
join Portofolioproject.dbo.Covid_Vaccinations$ vac 
	on dea.location = vac.location
	and
	dea.date = vac.date
where dea.continent is not null 
-- and new_vaccinations is not null
-- and dea.location = 'Nigeria'
order by 2,3


-- USING CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from Portofolioproject.dbo.['owid-covid-data (1)$'] dea
join Portofolioproject.dbo.Covid_Vaccinations$ vac 
	on dea.location = vac.location
	and
	dea.date = vac.date
where dea.continent is not null 
-- and new_vaccinations is not null
-- and dea.location = 'Nigeria'
)

select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac


-- TEMP TABLE


Drop Table if exists #PercentagePopulationVaccinated
create table #PercentagePopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from Portofolioproject.dbo.['owid-covid-data (1)$'] dea
join Portofolioproject.dbo.Covid_Vaccinations$ vac 
	on dea.location = vac.location
	and
	dea.date = vac.date
where dea.continent is not null 
-- and new_vaccinations is not null
-- and dea.location = 'Nigeria'


select *, (RollingPeopleVaccinated/Population)*100
from #PercentagePopulationVaccinated

 
-- Create view to store data for visualization

drop view PercentPopulationVaccinated

Use Portofolioproject
Create view
PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from Portofolioproject.dbo.['owid-covid-data (1)$'] dea
join Portofolioproject.dbo.Covid_Vaccinations$ vac 
	on dea.location = vac.location
	and
	dea.date = vac.date
where dea.continent is not null 
-- and new_vaccinations is not null
-- and dea.location = 'Nigeria'
 

 select * from PercentPopulationVaccinated