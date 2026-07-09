--1 Gold.Dim_location
CREATE TABLE GOLD.DimLocation (
    location_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    city VARCHAR(50),
    latitude FLOAT,
    longitude FLOAT
);

INSERT INTO GOLD.DimLocation (city, latitude, longitude)
SELECT DISTINCT
    city,
    latitude,
    longitude
FROM [Silver].[airbnb_cleaned]
WHERE city IS NOT NULL;

--2 Gold.Dim_property
CREATE TABLE GOLD.DimProperty (
    property_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    room_type VARCHAR(50),
    person_capacity INT,
    bedrooms INT,
    room_shared VARCHAR(10),
    room_private VARCHAR(10)
);

INSERT INTO GOLD.DimProperty
(room_type, person_capacity, bedrooms, room_shared, room_private)
SELECT DISTINCT
    room_type,
    ISNULL(person_capacity, 0),
    bedrooms,
    room_shared,
    room_private
FROM [Silver].[airbnb_cleaned];

select count(*)
from [Gold].[DimHost] ;

--3 GOld.dim_host
CREATE TABLE GOLD.DimHost (
    host_id INT IDENTITY(1,1) not null PRIMARY KEY,
    host_is_superhost VARCHAR(10),
    multi VARCHAR(10),
    biz VARCHAR(10)
);

INSERT INTO GOLD.DimHost (host_is_superhost, multi, biz)
SELECT DISTINCT
    host_is_superhost,
    multi,
    biz
FROM [Silver].[airbnb_cleaned];

--3 Gold.Dim_daytype
CREATE TABLE GOLD.DimDayType (
    day_type_id INT IDENTITY(1,1) PRIMARY KEY,
    day_type NVARCHAR(20)
);

INSERT INTO GOLD.DimDayType (day_type)
SELECT DISTINCT day_type
FROM [Silver].[airbnb_cleaned];

--4 Fact Table

CREATE TABLE GOLD.FactListings (
    listing_id INT IDENTITY(1,1) not null  PRIMARY KEY,

    price FLOAT,
    cleanliness_rating FLOAT,
    guest_satisfaction FLOAT,
    dist FLOAT,
    metro_dist FLOAT,
    attr_index FLOAT,
    attr_index_norm FLOAT,
    rest_index FLOAT,
    rest_index_norm FLOAT,

    location_id INT,
    property_id INT,
    host_id INT,
    day_type_id INT
);

INSERT INTO GOLD.FactListings (
    price,
    cleanliness_rating,
    guest_satisfaction,
    dist,
    metro_dist,
    attr_index,
    attr_index_norm,
    rest_index,
    rest_index_norm,
    location_id,
    property_id,
    host_id,
    day_type_id
)
SELECT
    t.price,
    t.cleanliness_rating,
    t.guest_satisfaction,
    t.dist,
    t.metro_dist,
    t.attr_index,
    t.attr_index_norm,
    t.rest_index,
    t.rest_index_norm,

    l.location_id,
    p.property_id,
    h.host_id,
    d.day_type_id

FROM [Silver].[airbnb_cleaned] t

LEFT JOIN GOLD.DimLocation l
    ON t.city = l.city
    AND t.latitude = l.latitude
    AND t.longitude = l.longitude

LEFT JOIN GOLD.DimProperty p
    ON ISNULL(t.person_capacity,0) = p.person_capacity
    AND t.room_type = p.room_type
    AND t.bedrooms = p.bedrooms
    AND t.room_shared = p.room_shared
    AND t.room_private = p.room_private

LEFT JOIN GOLD.DimHost h
    ON t.host_is_superhost = h.host_is_superhost
    AND t.multi = h.multi
    AND t.biz = h.biz

LEFT JOIN GOLD.DimDayType d
    ON t.day_type = d.day_type;


ALTER TABLE GOLD.FactListings
ADD CONSTRAINT FK_Fact_Location
FOREIGN KEY (location_id)
REFERENCES GOLD.DimLocation(location_id);

ALTER TABLE GOLD.FactListings
ADD CONSTRAINT FK_Fact_Property
FOREIGN KEY (property_id)
REFERENCES GOLD.DimProperty(property_id);

ALTER TABLE GOLD.FactListings
ADD CONSTRAINT FK_Fact_Host
FOREIGN KEY (host_id)
REFERENCES GOLD.DimHost(host_id);

ALTER TABLE GOLD.FactListings
ADD CONSTRAINT FK_Fact_DayType
FOREIGN KEY (day_type_id)
REFERENCES GOLD.DimDayType(day_type_id);

--5 Create indexes on foreign key columns in Fact table (To speed up joins and filtering on Fact table foreign keys)

CREATE INDEX IX_FACT_location_id ON [Gold].[FactListings](location_id);

CREATE INDEX IX_FACT_property_id ON [Gold].[FactListings]([property_id]);

CREATE INDEX IX_FACT_host_id ON [Gold].[FactListings]([host_id]);

CREATE INDEX IX_FACT_day_type_id ON [Gold].[FactListings]([day_type_id]);


