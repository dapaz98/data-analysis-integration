--The first task is to build a transformation 
--that provides the percentage of smart meters and the average energy consumption per contract. 
--These need to be calculated by municipality in June 2024. The output should be a CSV file with three columns: Municipality,
--Percentage of smart meters, Consumption per contract.



--CREATE NONCLUSTERED	INDEX month_per_contract on dbo.number_contracts (month, number_of_CPE_s)
--DROP INDEX month_per_contract ON dbo.number_contracts 

with cte_avg_consumption as (
select 
	 nc.DistrictCode
	,nc.Municipality
	,round(AVG(ec.active_energy_kWh), 2) as mean_active_energy
from dbo.energy_consumption ec, 
	 dbo.number_contracts nc
where ec.Year = nc.Year
  and ec.Month = nc.Month
  and ec.Month = 06
  and ec.Year = 2024
group by 	
	 nc.DistrictCode
	,nc.Municipality
)
select 
	nc.Municipality
	,(count(
		case 
			when lower(nc.Includes_Smart_Meter) = 'sim' 
			then 1
			end) * 100 / count(1)
			) as 'percentage_smart_meters'
from cte_avg_consumption ec, 
	 dbo.number_contracts nc
where ec.DistrictCode = nc.DistrictCode
  and nc.Month = 06
  and nc.Year = 2024
group by 	
	  nc.Municipality
Order by nc.Municipality asc

select top 1 * from dbo.number_contracts

select top 1 * from dbo.energy_consumption
eduardo.paz@tecnico.ulisboa.pt
