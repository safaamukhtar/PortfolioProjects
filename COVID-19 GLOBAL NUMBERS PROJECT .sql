--COVID-19 GLOBAL NUMBERS CRATING TABLES


select *
  from portfolioproject1..coviddeaths 
  where continent is not null 
  order by 3,4
  
  
  select location, date, total_cases, new_cases, total_deaths, population 
  from portfolioproject1..coviddeaths
  order by 1,2

  ----------------------------------------------------------------------------------------------------

  --looking at total cases vs total deaths
  --shows the likelihood of dying by covid in your country

  select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
  from portfolioproject1..coviddeaths
  where location like '%states%'
  and continent is not null 
  order by 1,2

  --looking at total cases vs population
  --shows what percentage of the population got covid

  select location, date, population, total_cases, (isnull(total_cases,0)/isnull(population,0))*100 as percentpopulationinfected
  from portfolioproject1..coviddeaths
  where location like '%states%'
  and continent is not null 
  order by 1,2


  ---------------------------------------------------------------------------------------------------------------  

  --looking at countries with highest infection rates compared to population

  select location, population, max(total_cases) as highestinfectoncount, max((total_cases/population))*100 as percentpopulationinfected
  from portfolioproject1..coviddeaths
--where location like '%states%'
  group by location, population
  order by percentpopulationinfected desc

 
 --showing with the highest death count per population 

 select location, max(cast(total_deaths as int)) as totaldeathcount
  from portfolioproject1..coviddeaths
--where location like '%states%'
where continent is not null 
  group by location
  order by totaldeathcount desc


  -------------------------------------------------------------------------------------- 

  --lets break things down by countinent

    --showing the continents with the highest death count 

   select continent, max(cast(total_deaths as int)) as totaldeathcount
  from portfolioproject1..coviddeaths
--where location like '%states%'
where continent is not null 
  group by continent
  order by totaldeathcount desc


  -------------------------------------------------------------------------------------------

  --global numbers

select sum(total_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,sum(new_deaths)/sum(new_cases)*100 as deathpercentage
  from portfolioproject1..coviddeaths
 -- where location like '%states%'
  where continent is not null 
  --group by date 
  order by 1,2

  
  --looking at total population vs total vaccination

  select * from (
  select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
  sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
  --, (rollingpeoplevaccinated/population)
  from portfolioproject1..coviddeaths dea
  join portfolioproject1..covidvaccination vac
  on dea.location = vac.location
  and dea.date = vac.date
  where vac.continent is not null
  --having  sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) is not null
 -- order by 2,3
  ) a
  where rollingpeoplevaccinated is not null


  --use cte

  with popvsvac (continent, location, date, population,new_vaccinations, rollingpeoplevaccinated)
  as
  (
  select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
  sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
  --, (rollingpeoplevaccinated/population)
  from portfolioproject1..coviddeaths dea
  join portfolioproject1..covidvaccination vac
  on dea.location = vac.location
  and dea.date = vac.date
  where vac.continent is not null
 --order by 2,3
 )
 select *, (rollingpeoplevaccinated/population)*100
 from popvsvac


 -------------------------------------------------------------------------------------------------------------------------------

 --creating views for visualisation (in tableau)



 1-
  create view deathpercentage as
  Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From portfolioproject1..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


2-
ceate view TotalDeathCountperContinent as
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From portfolioproject1..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High income','Upper middle income', 'Lower middle income', 'Low income' )
Group by location
order by TotalDeathCount desc


3-
create view TotalPopulationInfectedinEachCountry as
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolioproject1..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc



4-
create view TotalPopulationInfectedinEachCountryperDate as
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolioproject1..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc



5-
 create view percentpopulatonvaccinated as
  select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
  sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
  --, (rollingpeoplevaccinated/population)
  from portfolioproject1..coviddeaths dea
  join portfolioproject1..covidvaccination vac
  on dea.location = vac.location
  and dea.date = vac.date
  where vac.continent is not null
 --order by 2,3

 select *
 from percentpopulatonvaccinated



 6-
 create view globalnumbers as
 select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,sum(new_deaths)/sum(new_cases)*100 as deathpercentage
  from portfolioproject1..coviddeaths
 -- where location like '%states%'
  where continent is not null 
  --group by date 
  --order by 1,2

  select *
  from globalnumbers

  
  7-
  create view continentdeathcount as
  select continent, max(cast(total_deaths as int)) as totaldeathcount
  from portfolioproject1..coviddeaths
--where location like '%states%'
where continent is not null 
  group by continent
  --order by totaldeathcount desc

  select *
  from continentdeathcount




 
