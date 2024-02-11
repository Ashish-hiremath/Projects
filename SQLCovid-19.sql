use PortfolioProject;
select * from coviddeaths
select * from covidvacc

select location,date,total_cases,new_cases,total_deaths,population from coviddeaths
where continent is not null
order by 1,2

ALTER TABLE coviddeaths
ALTER COLUMN total_cases int

ALTER TABLE coviddeaths
ALTER COLUMN total_deaths int

--total cases vs total deaths
select location,date,total_deaths,total_cases,(total_deaths/total_cases)*100 as per_of_deaths from coviddeaths
where continent is not null

--looking at total cases vs population
select population,total_cases from coviddeaths
where continent is not null

--shows percentage of population got Covid
select location,(total_cases/population)* 100 as percentpopulationinfected from coviddeaths
where location like '%India%'

--looking at countries with highest infection rate compared to population
select population,location,max(total_cases/population)* 100 as highestinfectionrate from coviddeaths
group by location,population
order by highestinfectionrate desc

ALTER TABLE coviddeaths
ALTER COLUMN total_deaths int

--showing countries with highest death count per population
select continent,max(cast(total_deaths as int)) as totaldeathcount from coviddeaths
where continent is not null
group by continent
order by totaldeathcount desc

--global numbers

select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast (new_deaths as int))/sum(new_cases)*100 as deathpercentage from coviddeaths
where continent is not null
group by date
order by 1,2

-- joining both tables
select * from coviddeaths cd
join covidvacc cv on cv.date=cd.date and cv.location=cd.location 

--looking at total population vs vaccinations
select cd.continent,cd.location,population,cd.date,new_vaccinations,sum(convert(bigint,cv.new_vaccinations)) over(partition by cd.location order by cd.location) from coviddeaths cd
join covidvacc cv on cv.date=cd.date and cv.location=cd.location 
where cd.continent is not null
order by 1,2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CONVERT(bigint,cv.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths cd
Join CovidVacc  cv
	On cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--temp table
drop table if exists percentpopulationvaccinated
create table percentpopulationvaccinated
(
continent varchar(255),
loaction varchar(255),
date datetime,
population numeric,
rollingpeoplevaccinated numeric
)


insert into percentpopulationvaccinated

Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CONVERT(bigint,cv.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths cd
Join CovidVacc  cv
	On cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null 
--order by 2,3

--creating view for later visulizations
create view percentpopulationvaccinatedview as 
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CONVERT(bigint,cv.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths cd
Join CovidVacc  cv
	On cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null 
--order by 2,3


select * from percentpopulationvaccinatedview





