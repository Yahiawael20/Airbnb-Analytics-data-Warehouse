-- check 1 : Check for Null values for columns  in required table 
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql += '
SELECT ''' + COLUMN_NAME + ''' AS column_name,
SUM(CASE 
    WHEN [' + COLUMN_NAME + '] IS NULL THEN 1 
    ELSE 0 
END) AS null_count
FROM [Bronze].[vienna_weekends]
UNION ALL
'
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'vienna_weekends'
AND TABLE_SCHEMA = 'Bronze';
SET @sql = LEFT(@sql, LEN(@sql) - 10);
EXEC(@sql);


-- check 2 : check for invalid values that cannot be converted to correct data type

select * 
from [Bronze].[amsterdam_weekdays]
where try_cast(realSum as float) is null;

select * 
from [Bronze].[amsterdam_weekdays]
where try_cast([guest_satisfaction_overall] as float) is null;

select * 
from [Bronze].[amsterdam_weekdays]
where try_cast([bedrooms] as int) is null;


select * 
from [Bronze].[amsterdam_weekdays]
where try_cast([lng] as decimal(10,7)) is null;


-- check 3 : check for correct range

select *
from [Bronze].[london_weekdays]
where TRY_CAST([cleanliness_rating] as float) not between 0.0 and 10.0;


select *
from [Bronze].[london_weekdays]
where TRY_CAST([guest_satisfaction_overall] as float) not between 0.0 and 100.0;


-- check 4 : check for value counts for columns 

select distinct [room_type] , count(*) as cnt
from [Bronze].[amsterdam_weekdays]
group by [room_type];



