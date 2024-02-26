--Select * 
--From PortfolioProjects..CovidDeaths
--Where continent is not null
--Order by 3,4

----Select Location, date, Total_cases, New_cases, Total_deaths, Population
----From PortfolioProjects..CovidDeaths
--Where continent is not null
----Order by 1,2

------Looking at Total Cases vs Total Deaths.
----Shows the liklihood 
--Shows what percentage of population got Covid

----Select Location, date, Total_cases, Total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
----From PortfolioProjects..CovidDeaths
----Where location like '%Nigeria%'
--Where continent is not null
----Order by 1,2

----Select Location, date, Population, Total_cases, (Population/Total_cases)*100 as DeathPercentage
----From PortfolioProjects..CovidDeaths
----Where location like '%Nigeria%'
--Where continent is not null
----Order by 1,2

----Select Location, Population, Max(Total_cases) as HighestInfectionCount, Max((Population/Total_cases))*100 as PercentagePopulationInfected
----From PortfolioProjects..CovidDeaths
------Where location like '%Nigeria%'
----Group by Location, Population
--Where continent is not null
----Order by PercentagePopulationInfected

----Select Location, Population, Max(Total_cases) as HighestInfectionCount, Max((Population/Total_cases))*100 as PercentagePopulationInfected
----From PortfolioProjects..CovidDeaths
------Where location like '%Nigeria%'
----Group by Location, Population
--Where continent is not null
----Order by PercentagePopulationInfected desc

--Showing Countries with highest Death Count per Population

----Select Location, Max(Total_Deaths) as TotalDeathCount
----From PortfolioProjects..CovidDeaths
------Where location like '%Nigeria%'
----Group by Location
--Where continent is not null
----Order by TotalDeathCount desc

--Select Location, Max(cast(Total_Deaths as int)) as TotalDeathCount
--From PortfolioProjects..CovidDeaths
----Where location like '%Nigeria%'
--Where continent is not null
--Group by Location
--Order by TotalDeathCount desc


--Let's Break Things Down By Continent

--Select Continent, Max(cast(Total_Deaths as int)) as TotalDeathCount
--From PortfolioProjects..CovidDeaths
----Where location like '%Nigeria%'
--Where continent is not null
--Group by Continent
--Order by TotalDeathCount desc

--Select Location, Max(cast(Total_Deaths as int)) as TotalDeathCount
--From PortfolioProjects..CovidDeaths
----Where location like '%Nigeria%'
--Where continent is null
--Group by location
--Order by TotalDeathCount desc

--Select continent, Max(cast(Total_Deaths as int)) as TotalDeathCount
--From PortfolioProjects..CovidDeaths
----Where location like '%Nigeria%'
--Where continent is not null
--Group by continent
--Order by TotalDeathCount desc


--Select Date, SUM(New_Cases) Total_Cases, Sum(cast(New_Deaths as int)) as Total_Deaths, SUM(cast(New_Deaths as int))/Sum(New_cases)*100 as DeathsPercentage
--From PortfolioProjects..CovidDeaths
----Where location like '%Nigeria%'
--Where continent is not null
--Group by date
--Order by 1,2

--Select SUM(New_Cases) Total_Cases, Sum(cast(New_Deaths as int)) as Total_Deaths, SUM(cast(New_Deaths as int))/Sum(New_cases)*100 as DeathsPercentage
--From PortfolioProjects..CovidDeaths
----Where location like '%Nigeria%'
--Where continent is not null
----Group by date
--Order by 1,2

Drop Table if exists #PercentPopulationvaccinated
Create Table #PercentPopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationvaccinated
Select dea.Continent, dea.Location, dea.Date, dea.Population, vac.New_Vaccinations
, SUM(convert(int, vac.New_Vaccinations)) OVER (partition by dea.location Order by dea.location, dea.Date)
as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
--Where dea.continent is not null
----order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationvaccinated

Creating View

create View PercentPopulationvaccinated as 
Select dea.Continent, dea.Location, dea.Date, dea.Population, vac.New_Vaccinations
, SUM(convert(int, vac.New_Vaccinations)) OVER (partition by dea.location Order by dea.location, dea.Date)
as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
Where dea.continent is not null
----order by 2,3

Select *
From PercentPopulationvaccinated