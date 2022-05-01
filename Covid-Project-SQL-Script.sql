use portfolio_project_1;
select * from covid_deaths;
## select data that we are going to use
select location,date,total_cases,new_cases,total_deaths,population from covid_deaths;

## looking at total cases vs total deaths
## shows likelihood of dying if you contract covid in your country
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from covid_deaths 
where location like "%india%";

## looking at total cases vs populations
## what % of population got covid
select location,date,total_cases,population,(total_cases/population)*100 as infection_percentage
from covid_deaths 
where location like "%india%";

##looking at countries with highest infection rate compared with population
select continent,location,population,max(total_cases)as highest_infection_count,
max(total_cases)/population*100 as infection_percentage,
case when location like "Africa" then "Africa"
     when location like "Europe" or location like "European Union"  then "Europe"
     when location like "North America" then "North America"
     when location like "South America" then "South America"
     when location like "Oceania" then "Oceania"
     else continent
end as cont
from covid_vaccinations
group by continent,location
order by infection_percentage desc;

## Date Wise Infection
select location,population,date,max(total_cases)as highest_infection_count,
max(total_cases)/population*100 as infection_percentage,
case when location like "Africa" then "Africa"
     when location like "Europe" or location like "European Union"  then "Europe"
     when location like "North America" then "North America"
     when location like "South America" then "South America"
     when location like "Oceania" then "Oceania"
     else continent
end as cont
from covid_vaccinations 
group by location,population,date
order by infection_percentage desc;

##showing countries with highest death counts per calculation
select continent,location,max(cast(total_deaths as decimal(10,0))) as total_deaths_count
from covid_deaths
group by location
order by total_deaths_count desc;

## lets break things down by continent

## select continent,sum(total_deaths) from covid_deaths
## where total_deaths in
##(select max(total_deaths) from covid_deaths group by location)
## group by continent;

select continent,max(cast(total_deaths as decimal(10,0))) as total_deaths_count
from covid_deaths
where continent is not null
group by continent
order by total_deaths_count desc;

## Global Numbers 
select date,sum(new_cases) as total_cases,sum(cast(new_deaths as decimal(10,0))) as total_deaths,
sum(cast(new_deaths as decimal(10,0)))/sum(new_cases)*100 as death_percentage
from covid_deaths 
group by date
order by 1; 

select sum(new_cases) as total_cases,sum(cast(new_deaths as decimal(10,0))) as total_deaths,
sum(cast(new_deaths as decimal(10,0)))/sum(new_cases)*100 as death_percentage
from covid_vaccinations; 

## looking at total population vs vaccination 
select continent,location,date,population,new_vaccinations,
sum(cast(new_vaccinations as decimal(10,0))) over (partition by location) as RollingPeople_Vaccinated
from covid_vaccinations;

with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeople_Vaccinated) as 
(select continent,location,date,population,new_vaccinations,
sum(cast(new_vaccinations as decimal(10,0))) over (partition by location) as RollingPeople_Vaccinated
from covid_vaccinations)
select *,(RollingPeople_Vaccinated/population)*100 from PopvsVAc;

## creating table PercentPopulationVaccinated
Drop table  if exists PercentPopulationVaccinated;
create table PercentPopulationVaccinated
(continent varchar(255),location varchar(255),Population int,vaccinated_population char(10));

#,PercentPopulationVaccinated varchar(255));


#insert into PercentPopulationVaccinated 
select 
continent,location,population,max(cast(new_vaccinations as decimal)) as vaccinated_population,
max(cast(new_vaccinations as decimal(10,0)))/population*100 as PercentPopulationVaccinated
from covid_vaccinations
group by location;

select  * from covid_vaccinations;

##creating view to store data for later visualisation
drop view if exists percent_popln_vacc;
create view percent_popln_vacc as 
select 
continent,location,population,max(cast(new_vaccinations as decimal)) as vaccinated_population,
max(cast(new_vaccinations as decimal(10,0)))/population*100 as PercentPopulationVaccinated,
case when location like "Africa" then "Africa"
     when location like "Europe" or location like "European Union"  then "Europe"
     when location like "North America" then "North America"
     when location like "South America" then "South America"
     when location like "Oceania" then "Oceania"
     else continent
end as cont
from covid_vaccinations
group by location;

select * from percent_popln_vacc;
select * from covid_vaccinations;

## deaths continent and location wise
select continent,location,sum(cast(new_deaths as decimal)) as total_deaths,
case when location like "Africa" then "Africa"
     when location like "Europe" or location like "European Union"  then "Europe"
     when location like "North America" then "North America"
     when location like "South America" then "South America"
     when location like "Oceania" then "Oceania"
     else continent
end as cont
from covid_vaccinations
group by continent,location ;

select continent,location,max(people_vaccinated),max(people_fully_vaccinated),
max(total_vaccinations),population,max(people_vaccinated)/population*100 as vaccination_percent,
case when location like "Africa" then "Africa"
     when location like "Europe" or location like "European Union"  then "Europe"
     when location like "North America" then "North America"
     when location like "South America" then "South America"
     when location like "Oceania" then "Oceania"
     else continent
end as cont
from covid_vaccinations
group by continent,location;

select cast(male_smokers as decimal) as male_smokers,cast(female_smokers as decimal) as female_smokers,
location,max(cast(total_deaths as decimal(10,0))),
max(cast(total_cases as decimal(10,0))),
max(cast(total_deaths as decimal(10,0)))/max(cast(total_cases as decimal(10,0)))*100 as death_percentage 
from covid_vaccinations
group by location;

select location,extreme_poverty,
max(cast(total_cases as decimal))/population*100 as infection_percentage,
max(cast(total_deaths as decimal(10,0)))/max(cast(total_cases as decimal(10,0)))*100 as death_percentage
from covid_vaccinations
group by location;

select location,human_development_index,
max(cast(total_deaths as decimal(10,0)))/max(cast(total_cases as decimal(10,0)))*100 as death_percentage,
max(people_vaccinated)/population*100 as vaccination_percent
from covid_vaccinations
group by location;

select location,max(cardiovasc_death_rate),human_development_index*100,life_expectancy
from covid_vaccinations
group by location; 

select location,aged_65_older,max(cast(total_deaths as decimal)),
max(cast(total_deaths as decimal(10,0)))/max(cast(total_cases as decimal(10,0)))*100 as death_percentage
from covid_vaccinations
group by location;

select location,gdp_per_capita,human_development_index*100,life_expectancy,extreme_poverty,
max(cast(total_deaths as decimal(10,0)))/max(cast(total_cases as decimal(10,0)))*100 as death_percentage
from covid_vaccinations
group by location;




