
/* VIEWING THE TABLES FROM THE IMPORTED EXCEL SHEET*/
--SELECT * FROM PORTFOLIOPROJECT..CovidDeaths ORDER BY 3,4
--SELECT * FROM PORTFOLIOPROJECT..CovidVaccinations ORDER BY 3,4

/* SELECTING THE IMPORTANT DAT WHICH WE ARE USING IN THE PROJECT*/
--SELECT Location, date, total_cases, new_cases, total_deaths, population FROM PORTFOLIOPROJECT..CovidDeaths ORDER BY 1,2

/*LOOKING AT TOTAL CASES VS TOTAL DEATHS*/
--SELECT Location, date, total_cases, total_deaths, total_deaths/NULLIF(total_cases,0)*100 AS DeathPercentage  FROM PORTFOLIOPROJECT..CovidDeaths  
--ORDER BY 1,2

/*LOOKING AT TOTAL CASES VS TOTAL DEATHS FOR ONE COUNTRY*/
--SELECT Location, date, total_cases, total_deaths, total_deaths/NULLIF(total_cases,0)*100 AS DeathPercentage  FROM PORTFOLIOPROJECT..CovidDeaths 
--WHERE location like '%India%'
--ORDER BY 1,2

/*LOOKING AT TOTAL CASES VS POPULATION*/
--SELECT Location, date, total_cases, Population, total_deaths/NULLIF(Population,0)*100 AS PERCENTPOPULATIONINFECTED  FROM PORTFOLIOPROJECT..CovidDeaths 
--WHERE location like '%India%'
--ORDER BY 1,2

/*LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION*/
--SELECT Location, Population, MAX(total_cases) as HighestInfectionCount ,MAX(total_cases/population)*100 AS HIGHESTINFECTIONRATEPERCENT 
--FROM PORTFOLIOPROJECT..CovidDeaths 
--GROUP BY Location,Population
--ORDER BY HIGHESTINFECTIONRATEPERCENT DESC

--/*LOOKING AT COUNTRIES WITH HIGHEST DEATH COUNT COMPARED WITH THE POPULATION*/ 
--SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount  
--FROM PORTFOLIOPROJECT..CovidDeaths 
--where continent is NOT NULL
--GROUP BY Location
--ORDER BY TotalDeathCount  DESC


--/*LOOKING AT CONTINENTS WITH HIGHEST DEATH COUNT COMPARED WITH THE POPULATION*/ 
--SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount  
--FROM PORTFOLIOPROJECT..CovidDeaths 
--where continent is  NULL
--GROUP BY Location
--ORDER BY TotalDeathCount  DESC

/* PREAPRING A GLOBAL REPORT ABOUT TOTAL_CASES, TOTAL_DEATHS, PERCENTAGE_DEATH*/
--SELECT 
--    date, 
--    SUM(new_cases) AS total_cases, 
--    SUM(CAST (new_deaths AS INT)) AS total_deaths, 
--    SUM(cast(new_deaths as int)) / NULLIF(SUM(ISNULL(new_cases, 0)), 0) AS DeathPercentage
--FROM 
--    PORTFOLIOPROJECT..CovidDeaths
--WHERE 
--    continent IS NOT NULL
--GROUP BY 
--    date
--ORDER BY 
--    1,2;


/*Looking at Total Population vs Vaccination*/
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CAST(new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location,dea.date ROWS UNBOUNDED PRECEDING) as NEW_PEOPLE_VACCINATED
--FROM PORTFOLIOPROJECT..CovidDeaths dea
--JOIN PORTFOLIOPROJECT..CovidVaccinations vac
-- ON dea.location = vac.location and dea.date = vac.date
-- where dea.continent is not null
-- order by 1,2,3   

 /* LOOKING AT THE PERCENTGE OF VACCINATION*/


-- WITH PopsVsVac( Continent, Location, Date, Population, new_vaccinations, NEW_PEOPLE_VACCINATED )
-- as
-- (
-- SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CAST(new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location,dea.date ROWS UNBOUNDED PRECEDING) as NEW_PEOPLE_VACCINATED
--FROM PORTFOLIOPROJECT..CovidDeaths dea
--JOIN PORTFOLIOPROJECT..CovidVaccinations vac
-- ON dea.location = vac.location and dea.date = vac.date
-- where dea.continent is not null
-- -- order by 1,2,3 
--)
--SELECT *,(NEW_PEOPLE_VACCINATED/Population)*100 FROM PopsVsVac

/* TEMP TABLE */

--DROP TABLE IF EXISTS #PercentPopulationVaccinated

--CREATE TABLE #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccintions numeric,
--NEW_PEOPLE_VACCINATED numeric
--)

--Insert into #PercentPopulationVaccinated
-- SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CAST(new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location,dea.date ROWS UNBOUNDED PRECEDING) as NEW_PEOPLE_VACCINATED
--FROM PORTFOLIOPROJECT..CovidDeaths dea
--JOIN PORTFOLIOPROJECT..CovidVaccinations vac
-- ON dea.location = vac.location and dea.date = vac.date
-- --where dea.continent is not null
-- -- order by 1,2,3 

-- SELECT *,(NEW_PEOPLE_VACCINATED/Population)*100 as PERCENTAGE_VACCINATED FROM #PercentPopulationVaccinated

/*CREATING VIEW FOR POWERBI VISUALIZTION*/


CREATE VIEW PercentPopulationVaccinated AS
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS bigint)) 
        OVER (PARTITION BY dea.location ORDER BY dea.date ROWS UNBOUNDED PRECEDING) 
        AS NEW_PEOPLE_VACCINATED
FROM 
    PORTFOLIOPROJECT..CovidDeaths dea
JOIN 
    PORTFOLIOPROJECT..CovidVaccinations vac
ON 
    dea.location = vac.location 
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;


