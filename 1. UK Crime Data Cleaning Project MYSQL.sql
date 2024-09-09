-- Data Cleaning
-- Using data from January 2024 to February 2024
-- https://data.police.uk/data/ 

--  Import data

use crime ;

DROP TABLE IF EXISTS policecrimedata;
CREATE TABLE policecrimedata (
    Crime_ID VARCHAR(255),
    Month VARCHAR(255),
	Reported_by VARCHAR(255),
    Falls_within VARCHAR(255),
    Longitude FLOAT,
    Latitude FLOAT,
    Location VARCHAR(255),
    LSOA_code VARCHAR(255),
    LSOA_name VARCHAR(255),
    Crime_type VARCHAR(255),
    Last_outcome_category VARCHAR(255),
    Context VARCHAR(255) 
    );

LOAD DATA INFILE 'policecrimedata.csv' INTO TABLE policecrimedata
fields terminated by ','
ignore 1 lines;

-- 1. Duplicate table

-- We are duplicating the table in case we make a mistake, then we still have the raw data available

Select *
from policecrimedata ;

Create table policecrimedata_staging
like policecrimedata ;

Select *
from policecrimedata_staging ;

Insert policecrimedata_staging
select *
from policecrimedata ;

-- 2. Remove Duplicates

-- The below will check if there are any duplicates in Crime_id, if there is then the value will be above 1. We will then delete any duplicates.

Select *,
Row_number() over(
partition by Crime_id) as row_num
from policecrimedata_staging ;

With cte as 
(Select *,
Row_number() over(
partition by Crime_id) as row_num
from policecrimedata_staging)
delete 
from cte 
where row_num > 1 ;

-- creating extra table and then deleting where row is bigger than 1

CREATE TABLE `policecrimedata_staging2` (
  `Crime_ID` varchar(255) DEFAULT NULL,
  `Month` varchar(255) DEFAULT NULL,
  `Reported_by` varchar(255) DEFAULT NULL,
  `Falls_within` varchar(255) DEFAULT NULL,
  `Longitude` float DEFAULT NULL,
  `Latitude` float DEFAULT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `LSOA_code` varchar(255) DEFAULT NULL,
  `LSOA_name` varchar(255) DEFAULT NULL,
  `Crime_type` varchar(255) DEFAULT NULL,
  `Last_outcome_category` varchar(255) DEFAULT NULL,
  `Context` varchar(255) DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Insert Into policecrimedata_staging2
Select *,
Row_number() over(
partition by Crime_id) as row_num
from policecrimedata_staging;

Select *
from policecrimedata_staging2
where row_num > 1 ;

delete
from policecrimedata_staging2
where row_num > 1 ;

Select *
from policecrimedata_staging2;

-- 3. Standardizing data

-- trimming a column and making sure that the data looks correct

select Reported_by, trim(Reported_by)
from policecrimedata_staging2;

update policecrimedata_staging2
set Reported_by = trim(Reported_by);

Select distinct crime_type
from policecrimedata_staging2
order by 1;

Select *
from policecrimedata_staging2
where location like 'no%';

-- 4 Remove null values

Select *
from policecrimedata_staging2
where Crime_ID = '' ;

delete
from policecrimedata_staging2
where Crime_ID = '' ;

Select *
from policecrimedata_staging2
where Crime_ID = ''
or Crime_ID is Null ;

-- 5. remove any unecessary columns and rows

Alter Table policecrimedata_staging2
Drop Column row_num ;

Alter Table policecrimedata_staging2
Drop Column Falls_within ;

Alter Table policecrimedata_staging2
Drop Column LSOA_code ;

Alter Table policecrimedata_staging2
Drop Column LSOA_name ;

Alter Table policecrimedata_staging2
Drop Column Context ;
