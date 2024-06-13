-- Cleaning and Manipulating the data 
	-- 1.removing duplicates
	-- 2.standarize the data
	-- 3.address null values
	-- 4.overlook tables, columns and rows not relevant to our analysis
			

SELECT  DISTINCT ID FROM dailyActivity_month --35 id
SELECT  DISTINCT ID FROM hourlyCalories_month --34 id
SELECT  DISTINCT ID FROM hourlyIntensities_month --34 id
SELECT  DISTINCT ID FROM hourlySteps_month --34 id
SELECT  DISTINCT ID FROM minuteCaloriesNarrow_month --34 id
SELECT  DISTINCT ID FROM minuteIntensitiesNarrow_month --34 id
SELECT  DISTINCT ID FROM minuteMETsNarrow_month --34 id
SELECT  DISTINCT ID FROM minuteStepsNarrow_month -- 34 id
SELECT  DISTINCT ID FROM minuteSleep_month --23 id
SELECT  DISTINCT ID FROM weightLogInfo_month -- 11 id



SELECT * FROM dailyActivity_month -- 457 rows
SELECT * FROM dailyActivity_merged -- 940 rows
SELECT * FROM hourlyCalories_month --24,084 rows
SELECT * FROM hourlyCalories_merged --22,099 rows
SELECT * FROM hourlyIntensities_month --24,084 rows
SELECT * FROM hourlyIntensities_merged --22,099 rows
SELECT * FROM hourlySteps_month --24,084 rows
SELECT * FROM hourlySteps_merged --22,099 rows
SELECT * FROM minuteCaloriesNarrow_month --1,445,040 rows
SELECT * FROM minuteCaloriesNarrow_merged --1,325,580 rows
SELECT * FROM minuteIntensitiesNarrow_month --1,445,040 rows
SELECT * FROM minuteIntensitiesNarrow_merged --1,325,580 rows
SELECT * FROM minuteMETsNarrow_month --1,445,040 rows
SELECT * FROM minuteMETsNarrow_merged --1,325,580 rows
SELECT * FROM minuteStepsNarrow_month --1,445,040 rows
SELECT * FROM minuteStepsNarrow_merged --1,325,580 rows
SELECT * FROM minuteSleep_month --198,559 rows
SELECT * FROM minuteSleep_merged --188,521 rows



-- cleaning the data
	-- make a copy from our raw data to work on
	-- join the tables with similar row numbers on Id and Datetime to make handling the tables more easier
		
		-- create table 1

/*create table daily_data(id, ActivityDate, TotalSteps, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes)
 insert into daily_data (id, ActivityDate, TotalSteps, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes)
 select id, ActivityDate, TotalSteps, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes
 FROM dailyActivity_month
 union
select id , ActivityDate, TotalSteps, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes
 from dailyActivity_merged*/

 /*select *
into sleep_data
from(
select id, convert(date, date) as 'Date',
sum(value) as minutes
from minuteSleep_month
where value = 1
group by id,convert(date, date), value
union
select id, convert(date, date) as 'Date',
sum(value) 
from minuteSleep_merged
where value = 1
group by id,convert(date, date), value
) a*/


 /*update daily_data 
set sleepminutes = (select minutes
from sleep_data where daily_data.id = sleep_data.id and daily_data.ActivityDate = sleep_data.date )*/

select * from daily_data

		-- create table 2

select *
into #temp1
from hourlyCalories_month
union all
select * from hourlyCalories_merged

select *
into #temp2
from hourlyIntensities_month
union all
select * from hourlyIntensities_merged

select *
into #temp3
from hourlySteps_month
union all
select * from hourlySteps_merged

select * from #temp1
select * from #temp2
select * from #temp3


		
 SELECT a.*, b.TotalIntensity, b.AverageIntensity, c.StepTotal
FROM #temp1 a, #temp2 b, #temp3 c
where (a.id = b.id and b.id = c.id and a.activityhour = b.activityhour and a.ActivityHour = c.ActivityHour)


/* SELECT a.id id, a.ActivityHour ActivityHour, a.Calories, b.TotalIntensity, b.AverageIntensity, c.StepTotal into hourly_data
FROM #temp1 a, #temp2 b, #temp3 c
where (a.id = b.id and a.id = c.id and a.activityhour = b.activityhour and a.ActivityHour = c.ActivityHour)*/

select * from hourly_data

		-- create table 3

select *
into #temp4
from minuteCaloriesNarrow_month
union all
select *
from minuteCaloriesNarrow_merged --2770620

select *
into #temp5
from minuteIntensitiesNarrow_month
union all
select *
from minuteIntensitiesNarrow_merged --2770620

select *
into #temp6
from minuteMETsNarrow_month
union all
select *
from minuteMETsNarrow_merged --2770620

select *
into #temp7
from minuteStepsNarrow_month
union all
select *
from minuteStepsNarrow_merged --2770620

select * from #temp4
select * from #temp5
select * from #temp6
select * from #temp7


SELECT a.*, b.Intensity, c.METs, d.Steps
FROM #temp4 a, #temp5 b,  #temp6 c, #temp7 d
where a.id = b.Id and b.id = c.Id and c.Id = d.Id
and a.ActivityMinute = b.ActivityMinute and b.ActivityMinute = c.ActivityMinute and c.ActivityMinute = d.ActivityMinute

/*SELECT a.*, b.Intensity, c.METs, d.Steps into minute_data
FROM #temp4 a, #temp5 b,  #temp6 c, #temp7 d
where a.id = b.Id and b.id = c.Id and c.Id = d.Id
and a.ActivityMinute = b.ActivityMinute and b.ActivityMinute = c.ActivityMinute and c.ActivityMinute = d.ActivityMinute*/

select * from minute_data



-------------------------------------------------------------------

-- Analyse the data

select * from daily_data

select *,
case
	when DATEpart(DW, ActivityDate) between 5 and 6
		THEN 'weeekend'
	else 'work_day'
	end as week_day
from daily_data

/*alter table daily_data add week_day nvarchar(50)
update daily_data 
set week_day = case
	when DATEpart(DW, ActivityDate) between 5 and 6
		THEN 'weeekend'
	else 'work_day'
	end 
*/

select ActivityDate, week_day,
avg(cast(totalsteps as int)) steps, avg(cast(veryactiveminutes as int)) VeryActive,
avg( cast(FairlyActiveMinutes as int)) FailrlyActive,
avg(cast(LightlyActiveMinutes as int)) LightlyActive,
avg(cast(SedentaryMinutes as int)) SedentaryMinutes,
avg(cast(sleepminutes as int)) SleepMinutes
from daily_data
group by ActivityDate, week_day
order by ActivityDate

select * from daily_data

select
avg(cast(totalsteps as int)) steps,
avg(SedentaryMinutes)/60 SedentaryHour,
avg(sleepminutes)/60 SleepHour
from daily_data

select * from daily_data


-----------------------------------------------------------

select * from hourly_data

select *,
case
	when DATEPART(HH, ActivityHour) between 4 and 10
		THEN 'morning'
	when DATEPART(HH, ActivityHour) between 11 and 16
		then 'Afternoon'
	when datepart(HH, ActivityHour) between 17 and 20
		then 'evening'
	else 'night'
	end as day_part
from hourly_data

/*alter table hourly_data add day_part nvarchar(50)

update hourly_data 
set day_part = case
	when DATEPART(HH, ActivityHour) between 4 and 10
		THEN 'morning'
	when DATEPART(HH, ActivityHour) between 11 and 16
		then 'Afternoon'
	when datepart(HH, ActivityHour) between 17 and 20
		then 'evening'
	else 'night'
	end
*/

select  day_part, DATEPART(HH, ActivityHour) hour,
avg(cast(calories as int)) avg_cal, avg(cast(steptotal as int))avg_step
from hourly_data
group by  day_part, DATEPART(HH, ActivityHour)
order by DATEPART(HH, ActivityHour)


select * from hourly_data

select id, convert(date, ActivityHour) day_,
sum(Calories) cal,
sum(StepTotal) step
from hourly_data
group by id, convert(date, ActivityHour)
order by 1,2

select * from hourly_data

select convert(date, ActivityHour) day_,
(sum(cast(calories as int))/ count(distinct id)) cal,
(sum(cast(steptotal as int))/ count(distinct id))step
from hourly_data
group by  convert(date, ActivityHour)
order by 1,2

select * from hourly_data

select substring(cast(ActivityHour as nchar),12,8) HourOfDay,
DATEPART(HH, ActivityHour) as hour,
day_part,
avg(cast(Calories as int)) Calories,
avg(cast(StepTotal as int)) steps
	from hourly_data
	group by substring(cast(ActivityHour as nchar),12,8), DATEPART(HH, ActivityHour), day_part
	order by DATEPART(HH, ActivityHour)

select * from hourly_data

select 
convert(Date, activityhour) as Date,
sum(cast(calories as int))/count(distinct id) sum_calories
from hourly_data
group by convert(Date, activityhour)
order by 1

select * from hourly_data


-----------------------------------------

select * from minute_data

select convert(date, activityminute), sum(cast(Calories as int)) /count(distinct(convert(date, activityminute))) ,
sum(Intensity),
sum(METs),
sum(Steps)
from minute_data
group by  convert(date, activityminute)

select count(distinct(convert(date, activityminute)))/31 from minute_data

select sum(cast(Calories as int)) /(2*34) calories_month,
sum(cast(Intensity as int))/(2*34) intensity_month,
sum(METs)/(2*34) METs_month,
sum(Steps)/(2*34) step_month
from minute_data

select sum(cast(Calories as int)) /(31*34) calories_day,
sum(cast(Intensity as int))/(31*34) intensity_day,
sum(METs)/(31*34) METs_day,
sum(Steps)/(31*34) step_day
from minute_data

select * from minute_data
