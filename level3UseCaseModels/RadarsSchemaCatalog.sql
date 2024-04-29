drop schema if exists envdamof_radars cascade;

CREATE SCHEMA envdamof_radars;

-------------------------------------
---------- FEATURE TYPES ------------
-------------------------------------

-- Template table for a RegionOfInterest: RadarRegionOfInterst
create table envdamof_radars.radar_region_of_interest (
	fid integer PRIMARY key,
	geo geometry(POLYGON,4326), -- replace for a more specific one if needed
	name TEXT,
	description text
);

create index on envdamof_radars.radar_region_of_interest using gist (geo);

----------------------------------------------------------------
---------- SAMPLING FEATURE TYPES AND PROCESS TYPES ------------
----------------------------------------------------------------

--Template table for EnvRSIrregularCoverage: HFRadarAntenna
create table envdamof_radars.hf_radar_antenna (
	fid integer,
	shape geometry(POLYGON,4326),-- replace this field for more specific geometry data types
	sampled_feature integer references envdamof_radars.radar_region_of_interest(fid), --add foreign key for relevant feature type
	valid_time_start timestamp,
	valid_time_end timestamp,
	name TEXT,
	citation TEXT,
	rights TEXT,
	version TEXT,
	creator TEXT,
	origin geometry(POINT,4326),
	bearing_offset REAL,
	bearing_resolution REAL,
	min_bearing integer,
	max_bearing integer,
	range_resolution REAL,
	min_range integer,
	max_range integer,
	sensor TEXT,
	software_name TEXT,
	software_version TEXT,
	last_calibration_date date,
	last_calibration_type text
);

create index on envdamof_radars.hf_radar_antenna using gist (shape);
CREATE INDEX ON envdamof_radars.hf_radar_antenna USING btree (fid);

--Template table for EnvRSRegularGridCoverage: HFRadarCombine
create table envdamof_radars.hf_radar_combine (
	fid integer,
	shape geometry(POLYGON,4326),-- replace this field for more specific geometry data types
	grid_size json,
	sampled_feature integer references envdamof_radars.radar_region_of_interest(fid), --add foreign key for relevant feature type
	valid_time_start timestamp,
	valid_time_end timestamp,
	name TEXT,
	citation TEXT,
	rights TEXT,
	version TEXT,
	creator TEXT,
	software_name TEXT,
	software_version TEXT,
	antennas json
	-- Array of fids of antennas involved in the process
	/*
	[1,2,3]
	*/
	
);

create index on envdamof_radars.hf_radar_combine using gist (shape);
CREATE INDEX ON envdamof_radars.hf_radar_combine USING btree (fid);


--Template table for EnvRSRegularGridCoverage: MeteoRadarAntenna
create table envdamof_radars.meteo_radar_antenna (
	fid integer,
	shape geometry(POLYGON,4326),-- replace this field for more specific geometry data types
	grid_size json,
	sampled_feature integer references envdamof_radars.radar_region_of_interest(fid), --add foreign key for relevant feature type
	valid_time_start timestamp,
	valid_time_end timestamp,
	name TEXT,
	description TEXT,
	location geometry(POINT,4326),
	location_height real -- in EPSG:5782. Above sea level at alicante
);

create index on envdamof_radars.meteo_radar_antenna using gist (shape);
CREATE INDEX ON envdamof_radars.meteo_radar_antenna USING btree (fid);

----------------------------------------------------------------
---------- Observation Types ------------
----------------------------------------------------------------

--Template table for a EnvRemoteSensingObservation: HFRadarAntennaObservation
create table envdamof_radars.hf_radar_antenna_observation (
	procedure integer, 
	feature_of_interest integer, -- Same as procedure
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples json 
	-- JSON Template for subsamples
	/*
	{
		path: "path to feature" -- Name the GeoPackage with the discrete coverage "envdamof_radars.hf_radar_antenna_observation/subsamples_procedure_phenomenon_time"
	}
	
	--Structure of feature type
	
	create table observation1 (
		fid integer,
		sampling_geometry geometry(point,4326), --Standard name for sampling_geometries. For temporal subsamples use phenomenon_time.
		sea_water_velocity_eastward_component_value real, -- complex types are decomposed. Array values are nos supported in coverages.
		sea_water_velocity_northward_component_value real,
		quality_flag int -- The dictionary for this is in the enumeration type of the catalog
	);
	
	*/
);

create index on  envdamof_radars.hf_radar_antenna_observation using btree (phenomenon_time);
create index on envdamof_radars.hf_radar_antenna_observation using btree (result_time);
CREATE INDEX ON envdamof_radars.hf_radar_antenna_observation USING btree (procedure);
CREATE INDEX ON envdamof_radars.hf_radar_antenna_observation USING btree (feature_of_interest);

--Template table for a EnvRemoteSensingObservation: HFRadarCombineObservation
create table envdamof_radars.hf_radar_combine_observation (
	procedure integer, 
	feature_of_interest integer, -- Same as procedure
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples json 
	-- JSON Template for subsamples
	/*
	{
		path: "path to coverage", -- Path to a GeoTIFF file. "envdamof_radars.hf_radar_combine_observation/subsamples_procedure_phenomenon_time"
	}
	
	  -- Coverage bands
	  band1: sea_water_velocity_eastward_component real
	  band2: sea_water_velocity_northward_component real
	  band3: quality_flag integer
	*/
);

create index on  envdamof_radars.hf_radar_combine_observation using btree (phenomenon_time);
create index on envdamof_radars.hf_radar_combine_observation using btree (result_time);
CREATE INDEX ON envdamof_radars.hf_radar_combine_observation USING btree (procedure);
CREATE INDEX ON envdamof_radars.hf_radar_combine_observation USING btree (feature_of_interest);



--Template table for a EnvRemoteSensingObservation: MeteoRadarAntennaObservation
create table envdamof_radars.meteo_radar_antenna_observation (
	procedure integer, 
	feature_of_interest integer, -- Same as procedure
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples json 
	-- JSON Template for subsamples
	/*
	{
		path: "path to coverage", -- Path to a GeoTIFF file. "envdamof_radars.meteo_radar_antenna_observation/subsamples_procedure_phenomenon_time"
		
		-- Bands
		band1: reflectivity_value real
	}
	*/
);

create index on  envdamof_radars.meteo_radar_antenna_observation using btree (phenomenon_time);
create index on envdamof_radars.meteo_radar_antenna_observation using btree (result_time);
CREATE INDEX ON envdamof_radars.meteo_radar_antenna_observation USING btree (procedure);
CREATE INDEX ON envdamof_radars.meteo_radar_antenna_observation USING btree (feature_of_interest);

-----------------------------------------
-------- CATALOG
------------------------------------------

-- USER DEFINED TYPES

delete from omcatalog.complex_type
where name = 'envdamof_radars.sea_water_velocity';

delete from omcatalog.enumeration_type 
where name = 'envdamof_radars.quality_flag_type';

INSERT INTO omcatalog.complex_type VALUES 
(
	'envdamof_radars.sea_water_velocity',
	'[
		{
			"name":"eastward_component",
			"data_type":"measure(m/s)",
			"repeated":false
		},
		{
			"name":"northward_component",
			"data_type": "measure(m/s)",
			"repeated":false
			}
	]',
	null
);

INSERT INTO omcatalog.enumeration_type VALUES (
	'envdamof_radars.quality_flag_type',
	'[
		"no_qc_performed",
		"godd_data",
		"probably_good_data",
		"bad_data_that_are_potentially_correctable",
		"bad_data",
		"value_changed",
		"value_below_detection",
		"nominal_value",
		"interpolated_value",
		"missing_value"
	]',
    null
);



-- FEATURE TYPES

-- Delete feature types if they EXIST

delete from omcatalog.process_type
where name IN 
	('envdamof_radars.hf_radar_antenna',
	 'envdamof_radars.hf_radar_combine',
	 'envdamof_radars.meteo_radar_antenna'
	); 

delete from omcatalog.spatial_sampling_feature_type
where name IN 
	('envdamof_radars.hf_radar_antenna',
	 'envdamof_radars.hf_radar_combine',
	 'envdamof_radars.meteo_radar_antenna'
	); 

delete from omcatalog.feature_type
where name IN 
	('envdamof_radars.hf_radar_antenna',
	 'envdamof_radars.hf_radar_combine',
	 'envdamof_radars.meteo_radar_antenna',
	 'envdamof_radars.radar_region_of_interest'
	); 
   

-- insert feature types
INSERT INTO omcatalog.feature_type values
('envdamof_radars.radar_region_of_interest', 
'["cs_region_of_interest"]',
'[{
	"name":"geo",
	"data_type":"Geometry(POLYGON,4326)",
	"repeated":false
},
{
	"name":"name",
	"data_type":"text",
	"repeated":false
},
{
	"name":"description",
	"data_type":"text",
	"repeated":false
}
]',
null,
null
),
('envdamof_radars.hf_radar_antenna', 
'["cs_rs_irregular_coverage","cs_rs_process"]',
'[{
	"name":"name",
	"data_type":"text",
	"repeated":false
},
{
	"name":"citation",
	"data_type":"text",
	"repeated":false
},
{
	"name":"rights",
	"data_type":"text",
	"repeated":false
},
{
	"name":"version",
	"data_type":"text",
	"repeated":false
},
{
	"name":"creator",
	"data_type":"text",
	"repeated":false
},
{
	"name":"origin",
	"data_type":"Geometry(POINT,4326)",
	"repeated":false
},
{
	"name":"bearing_offset",
	"data_type":"real",
	"repeated":false
},
{
	"name":"bearing_resolution",
	"data_type":"real",
	"repeated":false
},
{
	"name":"min_bearing",
	"data_type":"integer",
	"repeated":false
},
{
	"name":"max_bearing",
	"data_type":"integer",
	"repeated":false
},
{
	"name":"range_resolution",
	"data_type":"real",
	"repeated":false
},
{
	"name":"min_range",
	"data_type":"integer",
	"repeated":false
},
{
	"name":"max_range",
	"data_type":"integer",
	"repeated":false
},
{
	"name":"sensor",
	"data_type":"text",
	"repeated":false
},
{
	"name":"software_name",
	"data_type":"text",
	"repeated":false
},
{
	"name":"software_version",
	"data_type":"text",
	"repeated":false
},
{
	"name":"last_calibration_date",
	"data_type":"date",
	"repeated":false
},
{
	"name":"last_calibration_type",
	"data_type":"text",
	"repeated":false
}
]',
null,
null
),
('envdamof_radars.hf_radar_combine',
'["cs_rs_regular_coverage", "cs_rs_process"]',
'[
{
	"name":"name",
	"data_type":"text",
	"repeated":false
},
{
	"name":"citation",
	"data_type":"text",
	"repeated":false
},
{
	"name":"rights",
	"data_type":"text",
	"repeated":false
},
{
	"name":"version",
	"data_type":"text",
	"repeated":false
},
{
	"name":"creator",
	"data_type":"text",
	"repeated":false
},
{
	"name":"software_name",
	"data_type":"text",
	"repeated":false
},
{
	"name":"software_version",
	"data_type":"text",
	"repeated":false
}
]',
'[
{
	"name": "antennas",
	"referenced_feature_type": "envdamof_radars.hf_radar_antenna",
	"repeated": true
}	
]',
null
),
('envdamof_radars.meteo_radar_antenna', 
'["cs_rs_regular_coverage", "cs_rs_process"]',
'[
{
	"name":"name",
	"data_type":"text",
	"repeated":false
},
{
	"name":"description",
	"data_type":"text",
	"repeated":false
},
{
	"name":"location",
	"data_type":"Geometry(POINTZ,4326)",
	"repeated":false
}
]',
null,
null
);


-- SAMPLING FEATURE TYPES

INSERT INTO omcatalog.spatial_sampling_feature_type VALUES 
(
	'envdamof_radars.hf_radar_antenna',
	'envdamof_radars.radar_region_of_interest',
	'epsg:4326',
	null
),
(
	'envdamof_radars.hf_radar_combine',
	'envdamof_radars.radar_region_of_interest',
	'epsg:4326',
	null
),
(
	'envdamof_radars.meteo_radar_antenna',
	'envdamof_radars.radar_region_of_interest',
	'epsg:4326',
	null
);

-- PROCESS TYPES

INSERT INTO omcatalog.process_type VALUES 
(
	'envdamof_radars.hf_radar_antenna',
	'envdamof_radars.hf_radar_antenna_observation',
	NULL,
	'envdamof_radars.hf_radar_antenna',
	'[{
		"name":"sea_water_velocity",
		"data_type": "envdamof_radars.sea_water_velocity",
		"repeated":false
	},
	{
		"name":"quality_flag",
		"data_type": "envdamof_radars.quality_flag_type",
		"repeated":false
	}
	]'
);

INSERT INTO omcatalog.process_type VALUES 
(
	'envdamof_radars.hf_radar_combine',
	'envdamof_radars.hf_radar_combine_observation',
	NULL,
	'envdamof_radars.hf_radar_combine',
	'[{
		"name":"sea_water_velocity",
		"data_type": "envdamof_radars.sea_water_velocity",
		"repeated":false
	},
	{
		"name":"quality_flag",
		"data_type": "envdamof_radars.quality_flag_type",
		"repeated":false
	}
	]'
);

INSERT INTO omcatalog.process_type VALUES 
(
	'envdamof_radars.meteo_radar_antenna',
	'envdamof_radars.meteo_radar_antenna_observation',
	NULL,
	'envdamof_radars.meteo_radar_antenna',
	'[{
		"name":"reflectivity",
		"data_type": "measure(dBZ)",
		"repeated":false
	}
	]'
);
