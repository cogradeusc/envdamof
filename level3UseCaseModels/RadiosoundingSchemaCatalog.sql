drop schema if exists envdamof_radiosounding cascade;

CREATE SCHEMA envdamof_radiosounding;

-------------------------------------
---------- FEATURE TYPES ------------
-------------------------------------

-- Template table for a RegionOfInterest: radiosounding_region_of_interest
create table envdamof_radiosounding.radiosounding_region_of_interest (
	fid integer PRIMARY key,
	geo geometry(MULTIPOLYGON, 4326), -- replace for a more specific one if needed
	maximum_height REAL,
	name text
);

create index on envdamof_radiosounding.radiosounding_region_of_interest using gist (geo);

-------------------------------------
---------- PROCESS TYPES ------------
-------------------------------------

--Template table for a abstract_env_insitu_mobile_process: radiosounding_process
create table envdamof_radiosounding.radiosounding_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	base_station_name TEXT,
	release_location geometry(POINT,4326),
	release_location_height REAL -- EPSG:5782. Elevation above sea level at Alicante
);

CREATE INDEX ON envdamof_radiosounding.radiosounding_process USING btree (fid);

-----------------------------------------
---------- OBSERVATION TYPES ------------
-----------------------------------------

--Template table for abstract_env_trajectory: 
create table envdamof_radiosounding.radiosounding_trajectory (
	fid integer,
	shape geometry(LINESTRING,4326), -- replace this field for more specific geometry data types
	shape_height_start real, -- Use a vertical CRS 5782
	shape_height_end real,
	sampled_feature integer, --add foreign key for relevant feature type
	procedure integer,
	phenomenon_time_start timestamp, --use in case of period temporal type
	phenomenon_time_end timestamp, -- use in case of period temporal type
	result_time timestamp,
	subsamples json 
	-- JSON Template for subsamples
	/*
	[{
	phenomenon_time: ...
	sampling_geometry: "Point in WKT with EPSG:4326",
	sampling_geometry_height: " real value using EPSG:5782"
	pressure: ,
	temperature: ,
	dew_point_temperature: ,
	humidity: ,
	wind_direction: ,
	wind_speed: 
	}, ...]
	*/
);

create index on envdamof_radiosounding.radiosounding_trajectory using gist (shape);


create index on  envdamof_radiosounding.radiosounding_trajectory using btree (phenomenon_time_start);
create index on  envdamof_radiosounding.radiosounding_trajectory using btree (phenomenon_time_end);
create index on envdamof_radiosounding.radiosounding_trajectory using btree (result_time);
CREATE INDEX ON envdamof_radiosounding.radiosounding_trajectory USING btree (procedure);



-----------------------------------------
-------- CATALOG
------------------------------------------

-- USER DEFINED TYPES

--Delete the types if they EXIST



-- FEATURE TYPES

-- Delete feature types if they EXIST

delete from omcatalog.process_type
where name ='envdamof_radiosounding.radiosounding_process'; 

delete from omcatalog.spatial_sampling_feature_type
where name = 'envdamof_radiosounding.radiosounding_trajectory'; 

delete from omcatalog.feature_type
where name in 
   (
   'envdamof_radiosounding.radiosounding_region_of_interest',
   'envdamof_radiosounding.radiosounding_process',
   'envdamof_radiosounding.radiosounding_trajectory'
   );


INSERT INTO omcatalog.feature_type values
('envdamof_radiosounding.radiosounding_region_of_interest', 
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
},
{
	"name":"maximum_height",
	"data_type":"real",
	"repeated":false
}
]',
null,
null
),
('envdamof_radiosounding.radiosounding_process', 
'["cs_insitu_mobile_process"]',
'[{
	"name":"base_station_name",
	"data_type":"text",
	"repeated":false
},
{
	"name":"release_location",
	"data_type":"Geometry(POINT,4326)",
	"repeated":false
},
{
	"name":"release_location_height",
	"data_type":"real",
	"repeated":false
}
]',
null,
null
),
('envdamof_radiosounding.radiosounding_trajectory', 
'["cs_trajectory", "cs_trajectory_observation"]',
null,
null,
null
);



-- SAMPLING FEATURE TYPES

INSERT INTO omcatalog.spatial_sampling_feature_type VALUES (
	'envdamof_radiosounding.radiosounding_trajectory',
	'envdamof_radiosounding.radiosounding_region_of_interest',
	'epsg:4326',
	'epsg:5782'
);

-- PROCESS TYPES

INSERT INTO omcatalog.process_type VALUES (
	'envdamof_radiosounding.radiosounding_process',
	'envdamof_radiosounding.radiosounding_trajectory',
	null,
	'envdamof_radiosounding.radiosounding_trajectory',
	'[{
		"name":"pressure",
		"data_type": "measure(mbar)",
		"repeated":false
	},
	{
		"name":"temperature",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"dew_point_temperature",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"humidity",
		"data_type": "measure(%)",
		"repeated":false
	},
	{
		"name":"wind_direction",
		"data_type": "measure(degree)",
		"repeated":false
	},
	{
		"name":"wind_speed",
		"data_type": "measure(m/s)",
		"repeated":false
	}
	]'
);





