--1 Add City and Day type Column 
-- Amsterdam
alter table [Bronze].[amsterdam_weekdays]
add  city varchar(50) , day_type varchar(20) ;

update [Bronze].[amsterdam_weekdays] 
set city='Amesterdam' , day_type='weekday' ;

alter table [Bronze].[amsterdam_weekends]
add  city varchar(50) , day_type varchar(20) ;

update [Bronze].[amsterdam_weekends] 
set city='Amesterdam' , day_type='weekend' ;
-- Athens
alter table [Bronze].[athens_weekdays]
add  city varchar(50) , day_type varchar(20) ;

update [Bronze].[athens_weekdays] 
set city='Athens' , day_type='weekday' ;


alter table [Bronze].[athens_weekends]
add  city varchar(50) , day_type varchar(20) ;

update [Bronze].[athens_weekends] 
set city='Athens' , day_type='weekend' ;
-- Barcelona
ALTER TABLE [Bronze].[barcelona_weekdays]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[barcelona_weekdays]
SET city = 'barcelona', day_type = 'weekday';


ALTER TABLE [Bronze].[barcelona_weekends]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[barcelona_weekends]
SET city = 'barcelona', day_type = 'weekend';
-- Berlin
ALTER TABLE [Bronze].[berlin_weekdays]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[berlin_weekdays]
SET city = 'berlin', day_type = 'weekday';


ALTER TABLE [Bronze].[berlin_weekends]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[berlin_weekends]
SET city = 'berlin', day_type = 'weekend';
-- Budapest
ALTER TABLE [Bronze].[budapest_weekdays]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[budapest_weekdays]
SET city = 'budapest', day_type = 'weekday';


ALTER TABLE [Bronze].[budapest_weekends]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[budapest_weekends]
SET city = 'budapest', day_type = 'weekend';
-- Lisbon
ALTER TABLE [Bronze].[lisbon_weekdays]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[lisbon_weekdays]
SET city = 'lisbon', day_type = 'weekday';


ALTER TABLE [Bronze].[lisbon_weekends]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[lisbon_weekends]
SET city = 'lisbon', day_type = 'weekend';
-- London
ALTER TABLE [Bronze].[london_weekdays]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[london_weekdays]
SET city = 'london', day_type = 'weekday';


ALTER TABLE [Bronze].[london_weekends]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[london_weekends]
SET city = 'london', day_type = 'weekend';
-- Paris
ALTER TABLE [Bronze].[paris_weekdays]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[paris_weekdays]
SET city = 'paris', day_type = 'weekday';


ALTER TABLE [Bronze].[paris_weekends]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[paris_weekends]
SET city = 'paris', day_type = 'weekend';
-- Rome
ALTER TABLE [Bronze].[rome_weekdays]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[rome_weekdays]
SET city = 'rome', day_type = 'weekday';


ALTER TABLE [Bronze].[rome_weekends]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[rome_weekends]
SET city = 'rome', day_type = 'weekend';
-- Vienna
ALTER TABLE [Bronze].[vienna_weekdays]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[vienna_weekdays]
SET city = 'vienna', day_type = 'weekday';


ALTER TABLE [Bronze].[vienna_weekends]
ADD city VARCHAR(50), day_type VARCHAR(20);

UPDATE [Bronze].[vienna_weekends]
SET city = 'vienna', day_type = 'weekend';

--2 delete column 0 (wrong column come with files)
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql += 
'IF EXISTS (
    SELECT 1 
    FROM sys.columns 
    WHERE name = ''Column 0''
    AND object_id = OBJECT_ID(''' + s.name + '.' + t.name + ''')
)
BEGIN
    ALTER TABLE [' + s.name + '].[' + t.name + '] 
    DROP COLUMN [Column 0];
END;
'
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'Bronze';

EXEC sp_executesql @sql;

--3 change Wrong Data type and merge cleaned tables togther as master table
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql += '
SELECT
    TRY_CAST(realSum AS DECIMAL(10,2)) AS price,

    NULLIF(LTRIM(RTRIM(room_type)), '''') AS room_type,

    CASE WHEN room_shared = ''True'' THEN ''Yes'' ELSE ''No'' END AS room_shared,
    CASE WHEN room_private = ''True'' THEN ''Yes'' ELSE ''No'' END AS room_private,

    TRY_CAST(NULLIF(LTRIM(RTRIM(person_capacity)), '''') AS FLOAT ) AS person_capacity,

    CASE WHEN host_is_superhost = ''True'' THEN ''Yes'' ELSE ''No'' END AS host_is_superhost,

    CASE WHEN multi = ''1'' THEN ''Yes'' ELSE ''No'' END AS multi,
    CASE WHEN biz = ''1'' THEN ''Yes'' ELSE ''No'' END AS biz,

    TRY_CAST(cleanliness_rating AS FLOAT) AS cleanliness_rating,
    TRY_CAST(guest_satisfaction_overall AS FLOAT) AS guest_satisfaction,

    TRY_CAST(bedrooms AS INT) AS bedrooms,

    TRY_CAST(dist AS FLOAT) AS dist,
    TRY_CAST(metro_dist AS FLOAT) AS metro_dist,

    TRY_CAST(attr_index AS FLOAT) AS attr_index,
    TRY_CAST(attr_index_norm AS FLOAT) AS attr_index_norm,

    TRY_CAST(rest_index AS FLOAT) AS rest_index,
    TRY_CAST(rest_index_norm AS FLOAT) AS rest_index_norm,

    TRY_CAST(lng AS FLOAT) AS longitude,
    TRY_CAST(lat AS FLOAT) AS latitude,

    NULLIF(LTRIM(RTRIM(city)), '''') AS city,
    NULLIF(LTRIM(RTRIM(day_type)), '''') AS day_type

FROM [' + s.name + '].[' + t.name + ']

UNION ALL
'
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'Bronze';


SET @sql = LEFT(@sql, LEN(@sql) - 10);


SET @sql = '
SELECT *
INTO Silver.airbnb_cleaned
FROM (
' + @sql + '
) t;
';

EXEC sp_executesql @sql;

