drop schema if exists envdamof_meteostation cascade;

CREATE SCHEMA envdamof_meteostation;

-------------------------------------
---------- FEATURE TYPES ------------
-------------------------------------

-- Template table for a RegionOfInterest: meteostations_region_of_interest
create table envdamof_meteostation.meteostations_region_of_interest (
	fid integer PRIMARY key,
	geo geometry(MULTIPOLYGON, 4326), -- replace for a more specific one if needed
	name text
);

create index on envdamof_meteostation.meteostations_region_of_interest using gist (geo);

-- Template table for a FeatureType: meteostation
create table envdamof_meteostation.meteostation (
	fid integer PRIMARY key,
	code TEXT,
	name TEXT,
	start_date date,
	end_date date,
	location geometry(POINT, 4326),
	location_height REAL -- elevation in EPSG:5782
);

create index on envdamof_meteostation.meteostation using gist (location);

----------------------------------------------
---------- SAMPLING FEATURE TYPES ------------
----------------------------------------------

--Template table for a EnvSamplingLocation: meteostation_sampling_location
create table envdamof_meteostation.meteostation_sampling_location (
	fid integer PRIMARY key,
	shape geometry(POINT,4326), -- replace this field for more specific geometry data types
	shape_height REAL, -- height using vertical coord system EPSG:5782
	sampled_feature integer references envdamof_meteostation.meteostations_region_of_interest(fid), --add foreign key for relevant feature type
	station integer REFERENCES envdamof_meteostation.meteostation(fid)
);

create index on envdamof_meteostation.meteostation_sampling_location using gist (shape);

-------------------------------------
---------- PROCESS TYPES ------------
-------------------------------------

--------------------------------
-- 10 minutes process types
-------------------------------

--Template table for a EnvInsituStaticProcess: snow_height_10minutes_process
create table envdamof_meteostation.snow_height_10minutes_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.snow_height_10minutes_process USING btree (fid);

--Template table for a EnvInsituStaticProcess: wind_10minutes_process
create table envdamof_meteostation.wind_10minutes_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.wind_10minutes_process USING btree (fid);

--Template table for a EnvInsituStaticProcess: precipitation_10minutes_process
create table envdamof_meteostation.precipitation_10minutes_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.precipitation_10minutes_process USING btree (fid);


--Template table for a EnvInsituStaticProcess: presssure_10minutes_process
create table envdamof_meteostation.presssure_10minutes_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.presssure_10minutes_process USING btree (fid);

--Template table for a EnvInsituStaticProcess: solar_radiation_10minutes_process
create table envdamof_meteostation.solar_radiation_10minutes_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.solar_radiation_10minutes_process USING btree (fid);

--Template table for a EnvInsituStaticProcess: temperature_humidity_10minutes_process
create table envdamof_meteostation.temperature_humidity_10minutes_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.temperature_humidity_10minutes_process USING btree (fid);

--Template table for a EnvInsituStaticProcess: surface_temperature_10minutes_process
create table envdamof_meteostation.surface_temperature_10minutes_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.surface_temperature_10minutes_process USING btree (fid);

--------------------------------
-- Daily process types
-------------------------------

--Template table for a EnvInsituStaticProcess: snow_height_daily_process
create table envdamof_meteostation.snow_height_daily_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.snow_height_daily_process USING btree (fid);

--Template table for a EnvInsituStaticProcess: wind_daily_process
create table envdamof_meteostation.wind_daily_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.wind_daily_process USING btree (fid);

--Template table for a EnvInsituStaticProcess: precipitation_daily_process
create table envdamof_meteostation.precipitation_daily_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.precipitation_daily_process USING btree (fid);

--Template table for a EnvInsituStaticProcess: presssure_daily_process
create table envdamof_meteostation.presssure_daily_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.presssure_daily_process USING btree (fid);

--Template table for a EnvInsituStaticProcess: solar_radiation_daily_process
create table envdamof_meteostation.solar_radiation_daily_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.solar_radiation_daily_process USING btree (fid);

--Template table for a EnvInsituStaticProcess: temperature_humidity_daily_process
create table envdamof_meteostation.temperature_humidity_daily_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.temperature_humidity_daily_process USING btree (fid);

--Template table for a EnvInsituStaticProcess: surface_temperature_daily_process
create table envdamof_meteostation.surface_temperature_daily_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_meteostation.meteostation_sampling_location(fid) -- replace by more specific ref
);

CREATE INDEX ON envdamof_meteostation.surface_temperature_daily_process USING btree (fid);


-----------------------------------------
---------- OBSERVATION TYPES ------------
-----------------------------------------

-----------------------------------
---- 10 minutes observation Types
-----------------------------------

--Template table for an EnvInsituStaticObservation:  snow_height_10minutes_process_observation
create table envdamof_meteostation.snow_height_10minutes_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	snow_height real, --cm
	snow_height_validation_flag text
);



create index on  envdamof_meteostation.snow_height_10minutes_process_observation using btree (phenomenon_time);
create index on  envdamof_meteostation.snow_height_10minutes_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.snow_height_10minutes_process_observation USING HASH (procedure);
CREATE INDEX ON envdamof_meteostation.snow_height_10minutes_process_observation USING HASH (feature_of_interest);

--Template table for an EnvInsituStaticObservation:  wind_10minutes_process_observation
create table envdamof_meteostation.wind_10minutes_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	wind_direction real, --degrees
	wind_direction_validation_flag text,
	wind_speed real, -- m/s
	wind_speed_validation_flag text,
	wind_gust_direction real, -- degrees
	wind_gust_direction_validation_flag text,
	wind_gust_speed real, -- m/s
	wind_gust_speed_validation_flag text,
	wind_direction_standard_deviation real, --degrees
	wind_direction_standard_deviation_validation_flag text,
	wind_speed_standard_deviation real, -- m/s
	wind_speed_standard_deviation_validation_flag text
);

create index on  envdamof_meteostation.wind_10minutes_process_observation using btree (phenomenon_time);
create index on  envdamof_meteostation.wind_10minutes_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.wind_10minutes_process_observation USING btree (procedure);
CREATE INDEX ON envdamof_meteostation.wind_10minutes_process_observation USING btree (feature_of_interest);


--Template table for an EnvInsituStaticObservation:  precipitation_10minutes_process_observation
create table envdamof_meteostation.precipitation_10minutes_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	rainfall real, --L/m2
	rainfall_validation_flag text
);

create index on  envdamof_meteostation.precipitation_10minutes_process_observation using btree (phenomenon_time);
create index on  envdamof_meteostation.precipitation_10minutes_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.precipitation_10minutes_process_observation USING btree (procedure);
CREATE INDEX ON envdamof_meteostation.precipitation_10minutes_process_observation USING btree (feature_of_interest);



--Template table for an EnvInsituStaticObservation:  presssure_10minutes_process_observation
create table envdamof_meteostation.presssure_10minutes_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	barometric_pressure real, --hPa
	barometric_pressure_validation_flag text,
	sea_level_reduced_pressure real, --hPa
	sea_level_reduced_pressure_validation_flag text
);

create index on  envdamof_meteostation.presssure_10minutes_process_observation using btree (phenomenon_time);
create index on  envdamof_meteostation.presssure_10minutes_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.presssure_10minutes_process_observation USING btree (procedure);
CREATE INDEX ON envdamof_meteostation.presssure_10minutes_process_observation USING btree (feature_of_interest);


--Template table for an EnvInsituStaticObservation: solar_radiation_10minutes_process_observation
create table envdamof_meteostation.solar_radiation_10minutes_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	sunshine_duration real, --h
	sunshine_duration_validation_flag text,
	global_solar_radiation real, --W/m2 watts per square meter
	global_solar_radiation_validation_flag text
);

create index on  envdamof_meteostation.solar_radiation_10minutes_process_observation using btree (phenomenon_time);
create index on  envdamof_meteostation.solar_radiation_10minutes_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.solar_radiation_10minutes_process_observation USING btree (procedure);
CREATE INDEX ON envdamof_meteostation.solar_radiation_10minutes_process_observation USING btree (feature_of_interest);

--Template table for an EnvInsituStaticObservation: temperature_humidity_10minutes_process_observation
create table envdamof_meteostation.temperature_humidity_10minutes_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	relative_humidity real, --%
	relative_humidity_validation_flag text,
	mean_air_temperature real, --ºC
	mean_air_temperature_validation_flag text,
	dew_temperature real, --ºC
	dew_temperature_validation_flag text
);

create index on  envdamof_meteostation.temperature_humidity_10minutes_process_observation using btree (phenomenon_time);
create index on  envdamof_meteostation.temperature_humidity_10minutes_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.temperature_humidity_10minutes_process_observation USING btree (procedure);
CREATE INDEX ON envdamof_meteostation.temperature_humidity_10minutes_process_observation USING btree (feature_of_interest);

--Template table for an EnvInsituStaticObservation: surface_temperature_10minutes_process_observation
create table envdamof_meteostation.surface_temperature_10minutes_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	mean_air_temperature real, --ºC
	mean_air_temperature_validation_flag text,
	soil_temperature real, --ºC
	soil_temperature_validation_flag text
);

create index on  envdamof_meteostation.surface_temperature_10minutes_process_observation using btree (phenomenon_time);
create index on  envdamof_meteostation.surface_temperature_10minutes_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.surface_temperature_10minutes_process_observation USING btree (procedure);
CREATE INDEX ON envdamof_meteostation.surface_temperature_10minutes_process_observation USING btree (feature_of_interest);

-----------------------------------
---- Daily observation Types
-----------------------------------

--Template table for an EnvInsituStaticObservation:  snow_height_daily_process_observation
create table envdamof_meteostation.snow_height_daily_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	snow_height real, --cm
	snow_height_validation_flag text
);

create index on  envdamof_meteostation.snow_height_daily_process_observation using btree (phenomenon_time);
create index on  envdamof_meteostation.snow_height_daily_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.snow_height_daily_process_observation USING btree (procedure);
CREATE INDEX ON envdamof_meteostation.snow_height_daily_process_observation USING btree (feature_of_interest);

--Template table for an EnvInsituStaticObservation:  wind_daily_process_observation
create table envdamof_meteostation.wind_daily_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	wind_speed real, --m/s
	wind_speed_validation_flag text,
	wind_gust_direction real, -- degrees
	wind_gust_direction_validation_flag text,
	wind_gust_speed real, -- m/s
	wind_gust_speed_validation_flag text,
	prevailing_wind_direction real, -- degrees
	prevailing_wind_direction_validation_flag text
);

create index on  envdamof_meteostation.wind_daily_process_observation using btree (phenomenon_time);
create index on envdamof_meteostation.wind_daily_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.wind_daily_process_observation USING btree (procedure);
CREATE INDEX ON envdamof_meteostation.wind_daily_process_observation USING btree (feature_of_interest);

--Template table for an EnvInsituStaticObservation:  precipitation_daily_process_observation
create table envdamof_meteostation.precipitation_daily_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	water_balance real, -- mm
	water_balance_validation_flag text,
	rainfall real, --L/m2
	rainfall_validation_flag text
);

create index on  envdamof_meteostation.precipitation_daily_process_observation using btree (phenomenon_time);
create index on envdamof_meteostation.precipitation_daily_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.precipitation_daily_process_observation USING btree (procedure);
CREATE INDEX ON envdamof_meteostation.precipitation_daily_process_observation USING btree (feature_of_interest);

--Template table for an EnvInsituStaticObservation:  presssure_daily_process_observation
create table envdamof_meteostation.presssure_daily_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	barometric_pressure real, --hPa
	barometric_pressure_validation_flag text,
	sea_level_reduced_pressure real, --hPa
	sea_level_reduced_pressure_validation_flag text
);

create index on  envdamof_meteostation.presssure_daily_process_observation using btree (phenomenon_time);
create index on envdamof_meteostation.presssure_daily_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.presssure_daily_process_observation USING btree (procedure);
CREATE INDEX ON envdamof_meteostation.presssure_daily_process_observation USING btree (feature_of_interest);


--Template table for an EnvInsituStaticObservation: solar_radiation_daily_process_observation
create table envdamof_meteostation.solar_radiation_daily_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	insolation real, --%
	insolation_validation_flag text,
	sunshine_duration real, --h
	sunshine_duration_validation_flag text,
	daily_global_irradiation real, --10kJ/m2 
	daily_global_irradiation_validation_flag text
);

create index on  envdamof_meteostation.solar_radiation_daily_process_observation using btree (phenomenon_time);
create index on envdamof_meteostation.solar_radiation_daily_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.solar_radiation_daily_process_observation USING btree (procedure);
CREATE INDEX ON envdamof_meteostation.solar_radiation_daily_process_observation USING btree (feature_of_interest);

--Template table for an EnvInsituStaticObservation: temperature_humidity_daily_process_observation
create table envdamof_meteostation.temperature_humidity_daily_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	relative_humidity real, --%
	relative_humidity_validation_flag text,
	maximum_relative_humidity real, --%
	maximum_relative_humidity_validation_flag text,
	minimum_relative_humidity real, --%
	minimum_relative_humidity_validation_flag text,
	mean_air_temperature real, --ºC
	mean_air_temperature_validation_flag text,
	maximum_air_temperature real, --ºC
	maximum_air_temperature_validation_flag text,
	minimum_air_temperature real, --ºC
	minimum_air_temperature_validation_flag text,
	dew_temperature real, --ºC
	dew_temperature_validation_flag text,
	evapotranspiration real, --mm
	evapotranspiration_validation_flag text
);


create index on  envdamof_meteostation.temperature_humidity_daily_process_observation using btree (phenomenon_time);
create index on envdamof_meteostation.temperature_humidity_daily_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.temperature_humidity_daily_process_observation USING btree (procedure);
CREATE INDEX ON envdamof_meteostation.temperature_humidity_daily_process_observation USING btree (feature_of_interest);

--Template table for an EnvInsituStaticObservation: surface_temperature_daily_process_observation
create table envdamof_meteostation.surface_temperature_daily_process_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_meteostation.meteostation_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	mean_air_temperature real, --ºC
	mean_air_temperature_validation_flag text,
	soil_temperature real, --ºC
	soil_temperature_validation_flag text
);

create index on  envdamof_meteostation.surface_temperature_daily_process_observation using btree (phenomenon_time);
create index on envdamof_meteostation.surface_temperature_daily_process_observation using btree (result_time);
CREATE INDEX ON envdamof_meteostation.surface_temperature_daily_process_observation USING btree (procedure);
CREATE INDEX ON envdamof_meteostation.surface_temperature_daily_process_observation USING btree (feature_of_interest);

-----------------------------------------
-------- CATALOG
------------------------------------------

-- USER DEFINED TYPES

--Delete the types if they EXIST

delete from omcatalog.enumeration_type 
where name = 'envdamof_meteostation.validation_flag_type';

INSERT INTO omcatalog.enumeration_type VALUES (
	'envdamof_meteostation.validation_flag_type',
	'[
		"Not validated data",
		"Valid data",
		"Dubious data",
		"Erroneous data",
		"Accumulated data",
		"Valid interpolated data",
		"Not registered data"
	]',
	null
);


-- FEATURE TYPES

-- Delete feature types if they EXIST

delete from omcatalog.process_type
where name IN
(
'envdamof_meteostation.snow_height_10minutes_process',
'envdamof_meteostation.wind_10minutes_process',
'envdamof_meteostation.precipitation_10minutes_process',
'envdamof_meteostation.presssure_10minutes_process',
'envdamof_meteostation.solar_radiation_10minutes_process',
'envdamof_meteostation.temperature_humidity_10minutes_process',
'envdamof_meteostation.surface_temperature_10minutes_process',
'envdamof_meteostation.snow_height_daily_process',
'envdamof_meteostation.wind_daily_process',
'envdamof_meteostation.precipitation_daily_process',
'envdamof_meteostation.presssure_daily_process',
'envdamof_meteostation.solar_radiation_daily_process',
'envdamof_meteostation.temperature_humidity_daily_process',
'envdamof_meteostation.surface_temperature_daily_process'
); 

delete from omcatalog.spatial_sampling_feature_type
where name = 'envdamof_meteostation.meteostation_sampling_location'; 

delete from omcatalog.feature_type
where name in 
   (
   'envdamof_meteostation.meteostations_region_of_interest',
   'envdamof_meteostation.meteostation',
   'envdamof_meteostation.meteostation_sampling_location',
   'envdamof_meteostation.snow_height_10minutes_process',
	'envdamof_meteostation.wind_10minutes_process',
	'envdamof_meteostation.precipitation_10minutes_process',
	'envdamof_meteostation.presssure_10minutes_process',
	'envdamof_meteostation.solar_radiation_10minutes_process',
	'envdamof_meteostation.temperature_humidity_10minutes_process',
	'envdamof_meteostation.surface_temperature_10minutes_process',
	'envdamof_meteostation.snow_height_daily_process',
	'envdamof_meteostation.wind_daily_process',
	'envdamof_meteostation.precipitation_daily_process',
	'envdamof_meteostation.presssure_daily_process',
	'envdamof_meteostation.solar_radiation_daily_process',
	'envdamof_meteostation.temperature_humidity_daily_process',
	'envdamof_meteostation.surface_temperature_daily_process'
   );
   


INSERT INTO omcatalog.feature_type values
('envdamof_meteostation.meteostations_region_of_interest', 
'["cs_region_of_interest"]',
'[{
	"name":"geo",
	"data_type":"Geometry(MULTIPOLYGON,4326)",
	"repeated":false
},
{
	"name":"name",
	"data_type":"text",
	"repeated":false
}
]',
null,
null
),
('envdamof_meteostation.meteostation', 
'["feature_type"]',
'[{
	"name":"code",
	"data_type":"text",
	"repeated":false
},
{
	"name":"name",
	"data_type":"text",
	"repeated":false
},
{
	"name":"start_date",
	"data_type":"date",
	"repeated":false
},
{
	"name":"end_date",
	"data_type":"text",
	"repeated":false
},
{
	"name":"location",
	"data_type":"geometry(POINT, 4326)",
	"repeated":false
},
{
	"name":"location_height",
	"data_type":"real",
	"repeated":false
}
]',
null,
null
),
('envdamof_meteostation.meteostation_sampling_location', 
'["cs_sampling_location"]',
'[{
	"name":"shape_height",
	"data_type":"real",
	"repeated":false
}
]',
'[
{
	"name": "station",
	"referenced_feature_type": "envdamof_meteostation.meteostation",
	"repeated": false
}	
]',
null
),
('envdamof_meteostation.snow_height_10minutes_process', 
'["cs_instu_static_process"]',
null,
null,
null
),
('envdamof_meteostation.wind_10minutes_process', 
'["cs_instu_static_process"]',
null,
null,
null
),
('envdamof_meteostation.precipitation_10minutes_process', 
'["cs_instu_static_process"]',
null,
null,
null
),
('envdamof_meteostation.presssure_10minutes_process', 
'["cs_instu_static_process"]',
null,
null,
null
),
('envdamof_meteostation.solar_radiation_10minutes_process', 
'["cs_instu_static_process"]',
null,
null,
null
),
('envdamof_meteostation.temperature_humidity_10minutes_process', 
'["cs_instu_static_process"]',
null,
null,
null
),
('envdamof_meteostation.surface_temperature_10minutes_process', 
'["cs_instu_static_process"]',
null,
null,
null
),
('envdamof_meteostation.snow_height_daily_process', 
'["cs_instu_static_process"]',
null,
null,
null
),
('envdamof_meteostation.wind_daily_process', 
'["cs_instu_static_process"]',
null,
null,
null
),
('envdamof_meteostation.precipitation_daily_process', 
'["cs_instu_static_process"]',
null,
null,
null
),
('envdamof_meteostation.presssure_daily_process', 
'["cs_instu_static_process"]',
null,
null,
null
),
('envdamof_meteostation.solar_radiation_daily_process', 
'["cs_instu_static_process"]',
null,
null,
null
),
('envdamof_meteostation.temperature_humidity_daily_process', 
'["cs_instu_static_process"]',
null,
null,
null
),
('envdamof_meteostation.surface_temperature_daily_process', 
'["cs_instu_static_process"]',
null,
null,
null
);


-- SAMPLING FEATURE TYPES

INSERT INTO omcatalog.spatial_sampling_feature_type VALUES (
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostations_region_of_interest',
	'epsg:4326',
	'epsg:5782'
);

-- PROCESS TYPES

INSERT INTO omcatalog.process_type VALUES (
	'envdamof_meteostation.snow_height_10minutes_process',
	'snow_height_10minutes_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"snow_height",
		"data_type": "measure(cm)",
		"repeated":false
	},
	{
		"name":"snow_height_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
),(
	'envdamof_meteostation.wind_10minutes_process',
	'envdamof_meteostation.wind_10minutes_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"wind_direction",
		"data_type": "measure(degrees)",
		"repeated":false
	},
	{
		"name":"wind_direction_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"wind_speed",
		"data_type": "measure(m/s)",
		"repeated":false
	},
	{
		"name":"wind_speed_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"wind_gust_direction",
		"data_type": "measure(degrees)",
		"repeated":false
	},
	{
		"name":"wind_gust_direction_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"wind_gust_speed",
		"data_type": "measure(m/s)",
		"repeated":false
	},
	{
		"name":"wind_gust_speed_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"wind_direction_standard_deviation",
		"data_type": "measure(degrees)",
		"repeated":false
	},
	{
		"name":"wind_direction_standard_deviation_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"wind_speed_standard_deviation",
		"data_type": "measure(m/s)",
		"repeated":false
	},
	{
		"name":"wind_speed_standard_deviation_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
),(
	'envdamof_meteostation.precipitation_10minutes_process',
	'envdamof_meteostation.precipitation_10minutes_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"rainfall",
		"data_type": "measure(L/m2)",
		"repeated":false
	},
	{
		"name":"rainfall_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
),(
	'envdamof_meteostation.presssure_10minutes_process',
	'envdamof_meteostation.presssure_10minutes_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"barometric_pressure",
		"data_type": "measure(hPa)",
		"repeated":false
	},
	{
		"name":"barometric_pressure_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"sea_level_reduced_pressure",
		"data_type": "measure(hPa)",
		"repeated":false
	},
	{
		"name":"sea_level_reduced_pressure_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
),(
	'envdamof_meteostation.solar_radiation_10minutes_process',
	'envdamof_meteostation.solar_radiation_10minutes_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"sunshine_duration",
		"data_type": "measure(h)",
		"repeated":false
	},
	{
		"name":"sunshine_duration_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"global_solar_radiation",
		"data_type": "measure(W/m2)",
		"repeated":false
	},
	{
		"name":"global_solar_radiation_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
),(
	'envdamof_meteostation.temperature_humidity_10minutes_process',
	'envdamof_meteostation.temperature_humidity_10minutes_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"relative_humidity",
		"data_type": "measure(%)",
		"repeated":false
	},
	{
		"name":"relative_humidity_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"mean_air_temperature",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"mean_air_temperature_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"dew_temperature",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"dew_temperature_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
),(
	'envdamof_meteostation.surface_temperature_10minutes_process',
	'envdamof_meteostation.surface_temperature_10minutes_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"mean_air_temperature",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"mean_air_temperature_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"soil_temperature",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"soil_temperature_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
),(
	'envdamof_meteostation.snow_height_daily_process',
	'snow_height_daily_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"snow_height",
		"data_type": "measure(cm)",
		"repeated":false
	},
	{
		"name":"snow_height_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
),(
	'envdamof_meteostation.wind_daily_process',
	'envdamof_meteostation.wind_daily_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"wind_speed",
		"data_type": "measure(m/s)",
		"repeated":false
	},
	{
		"name":"wind_speed_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"wind_gust_direction",
		"data_type": "measure(degrees)",
		"repeated":false
	},
	{
		"name":"wind_gust_direction_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"wind_gust_speed",
		"data_type": "measure(m/s)",
		"repeated":false
	},
	{
		"name":"wind_gust_speed_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"prevailing_wind_direction",
		"data_type": "measure(degrees)",
		"repeated":false
	},
	{
		"name":"prevailing_wind_direction_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
),(
	'envdamof_meteostation.precipitation_daily_process',
	'envdamof_meteostation.precipitation_daily_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"water_balance",
		"data_type": "measure(mm)",
		"repeated":false
	},
	{
		"name":"water_balance_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"rainfall",
		"data_type": "measure(L/m2)",
		"repeated":false
	},
	{
		"name":"rainfall_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
),(
	'envdamof_meteostation.presssure_daily_process',
	'envdamof_meteostation.presssure_daily_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"barometric_pressure",
		"data_type": "measure(hPa)",
		"repeated":false
	},
	{
		"name":"barometric_pressure_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"sea_level_reduced_pressure",
		"data_type": "measure(hPa)",
		"repeated":false
	},
	{
		"name":"sea_level_reduced_pressure_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
),(
	'envdamof_meteostation.solar_radiation_daily_process',
	'envdamof_meteostation.solar_radiation_daily_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"insolation",
		"data_type": "measure(%)",
		"repeated":false
	},
	{
		"name":"insolation_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"sunshine_duration",
		"data_type": "measure(h)",
		"repeated":false
	},
	{
		"name":"sunshine_duration_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"daily_global_irradiation",
		"data_type": "measure(10kJ/m2)",
		"repeated":false
	},
	{
		"name":"daily_global_irradiation_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
),(
	'envdamof_meteostation.temperature_humidity_daily_process',
	'envdamof_meteostation.temperature_humidity_daily_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"relative_humidity",
		"data_type": "measure(%)",
		"repeated":false
	},
	{
		"name":"relative_humidity_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"maximum_relative_humidity",
		"data_type": "measure(%)",
		"repeated":false
	},
	{
		"name":"maximum_relative_humidity_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"minimum_relative_humidity",
		"data_type": "measure(%)",
		"repeated":false
	},
	{
		"name":"minimum_relative_humidity_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"mean_air_temperature",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"mean_air_temperature_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"maximum_air_temperature",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"maximum_air_temperature_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"minimum_air_temperature",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"minimum_air_temperature_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"dew_temperature",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"dew_temperature_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"evapotranspiration",
		"data_type": "measure(mm)",
		"repeated":false
	},
	{
		"name":"evapotranspiration_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
),(
	'envdamof_meteostation.surface_temperature_daily_process',
	'envdamof_meteostation.surface_temperature_daily_process_observation',
	'envdamof_meteostation.meteostation_sampling_location',
	'envdamof_meteostation.meteostation_sampling_location',
	'[{
		"name":"mean_air_temperature",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"mean_air_temperature_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	},
	{
		"name":"soil_temperature",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"soil_temperature_validation_flag",
		"data_type": "envdamof_meteostation.validation_flag_type",
		"repeated":false
	}
	]'
);


