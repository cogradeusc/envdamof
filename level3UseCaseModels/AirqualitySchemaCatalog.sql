drop schema if exists envdamof_air_quality cascade;

CREATE SCHEMA envdamof_air_quality;

-------------------------------------
---------- FEATURE TYPES ------------
-------------------------------------

-- Template table for a PopulationCenterType: city
create table envdamof_air_quality.city (
	fid integer PRIMARY key,
	geo geometry(POLYGON,4326), -- replace for a more specific one if needed
	--located_at integer references adminitrative_division_type(fid) --replace for a more specific reference
	name text
);

create index on envdamof_air_quality.city using gist (geo);

----------------------------------------------
---------- SAMPLING FEATURE TYPES ------------
----------------------------------------------

-- Template table for a Station
-- Template table for a AQStationLocation: 
-- Template table for a AQInSituStaticProcess: aq_legal_station
create table envdamof_air_quality.aq_legal_station (
	fid integer,
	valid_time_start timestamp,
	valid_time_end timestamp,
	--platform integer references station_location(fid) -- Not needed because the entity represents process, sampling_feature and platform
	shape geometry(POINT,4326), -- replace this field for more specific geometry data types
	--shape_height real, -- Use some vertical CRS. No vertical extension
	sampled_feature integer references envdamof_air_quality.city(fid), --add foreign key for relevant feature type
	--station integer references station(fid) not needed because the entity represents process, sampling_feature and platform
	name text,
	description text
);

create index on  envdamof_air_quality.aq_legal_station using gist (shape);
CREATE INDEX ON envdamof_air_quality.aq_legal_station USING btree (fid);

-- Template table for a Station
--Template table for a AQStationLocation: sensor_low_cost_feature
create table envdamof_air_quality.sensor_low_cost_feature (
	fid integer PRIMARY key,
	shape geometry(POINT,4326), -- replace this field for more specific geometry data types
	--shape_height real, -- Use some vertical CRS. NO vertical extension
	sampled_feature integer references envdamof_air_quality.city(fid), --add foreign key for relevant feature type
	--station integer references station(fid) Not needed because the entity represents both location and station
	legal_station integer, --references envdamof_air_quality.aq_legal_station(fid), we cannot reference a process
	code text,
	note text,
	location text
);

create index on  envdamof_air_quality.sensor_low_cost_feature using gist (shape);


--Template table for a AQModelGrid: air_quality_model
--Template table for a spatioTemporalModel: air_quality_model
create table envdamof_air_quality.air_quality_model (
	fid integer,
	shape geometry(POLYGON,4326), -- replace this field for more specific geometry data types
	--min_shape_height real, -- Use only if required with some vertical CRS. No vertical extension
	--max_shape_height real,
	grid_origin geometry(POINT, 32629), -- replace for more specific to adapt to 2d, 3d grid
	--grid_origin_height real, -- use if needed with some vertical CRS. No vertical extension
	grid_res json, --array with the resolutions in each axis
	grid_size json, --array with the size in each axis
	sampled_feature integer references envdamof_air_quality.city(fid), --add foreign key for relevant feature type
	valid_time_start timestamp,
	valid_time_end timestamp,
	description text
);

create index on  envdamof_air_quality.air_quality_model using gist (shape);
CREATE INDEX ON envdamof_air_quality.air_quality_model USING btree (fid);

-------------------------------------
---------- PROCESS TYPES ------------
-------------------------------------


create type envdamof_air_quality.sensor_low_cost_status as enum (
	'offline','calibration','running'
);


--Template table for a AQInSituStaticProcess: sensor_low_cost
create table envdamof_air_quality.sensor_low_cost (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references envdamof_air_quality.sensor_low_cost_feature(fid), -- replace by more specific ref
	model text,
	sensor_note text,
	trademark text,
	sensor_box_code text,
	operator text,
	status envdamof_air_quality.sensor_low_cost_status,
	status_note text
);

CREATE INDEX ON envdamof_air_quality.sensor_low_cost USING btree (fid);

--Template table for a AQInSituStaticProcess: sensor_calibration
create table envdamof_air_quality.sensor_calibration (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	--platform integer references station_location(fid) -- replace by more specific ref. No reference to any platform
	note TEXT,
	co_algorithm json,
	no_algorithm json,
	no2_algorithm json,
	o3_algorithm json,
	sensor integer --REFERENCES envdamof_air_quality.sensor_low_cost(fid). we cannot reference a process
);

CREATE INDEX ON envdamof_air_quality.sensor_calibration USING btree (fid);

-----------------------------------------
---------- OBSERVATION TYPES ------------
-----------------------------------------

--Template table for an InSituStaticObservation: aq_legal_station_observation
create table envdamof_air_quality.aq_legal_station_observation (
	procedure integer, 
	feature_of_interest integer, --references station_location(fid), We cannot reference directly a FOI that is also a process
	phenomenon_time timestamp,
	result_time timestamp,
	co REAL, --mg/m3
	NO REAL, --ug/m3
	no2 REAL, --ug/m3
	o3 REAL, --ug/m3
	nox REAL --ug/m3
);

create index on  envdamof_air_quality.aq_legal_station_observation using btree (phenomenon_time);
create index on  envdamof_air_quality.aq_legal_station_observation using btree (result_time);
CREATE INDEX ON envdamof_air_quality.aq_legal_station_observation USING btree (procedure);
CREATE INDEX ON envdamof_air_quality.aq_legal_station_observation USING btree (feature_of_interest);


--Template table for an InSituStaticObservation: sensor_raw_observation
create table envdamof_air_quality.sensor_raw_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_air_quality.sensor_low_cost_feature(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	battery_voltage REAL, -- V
	humidity REAL, -- %
	temperature real, -- ºC
	no_we real, -- mV
	no_aux real, -- mV
	no2_we real, -- mV
	no2_aux real,-- mV
	ox_we real,-- mV
	ox_aux real,-- mV
	co_we real,-- mV
	co_aux real,-- mV
	co_concentration real, --mg/m3
	no_concentration real,--ug/m3
	no2_concentration REAL,--ug/m3
	ox_concentration REAL --ug/m3
);

create index on  envdamof_air_quality.sensor_raw_observation using btree (phenomenon_time);
create index on  envdamof_air_quality.sensor_raw_observation using btree (result_time);
CREATE INDEX ON envdamof_air_quality.sensor_raw_observation USING btree (procedure);
CREATE INDEX ON envdamof_air_quality.sensor_raw_observation USING btree (feature_of_interest);

--Template table for an InSituStaticObservation: sensor_calibrated_observation
create table envdamof_air_quality.sensor_calibrated_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_air_quality.sensor_low_cost_feature(fid),
	phenomenon_time timestamp,
	result_time timestamp, 
	no real ,--ug/m3
	no2 real ,--ug/m3
	co real ,--mg/m3
	o3 real ,--ug/m3
	co_out_of_range bool ,
	no_out_of_range bool ,
	no2_out_of_range bool ,
	o3_out_of_range bool ,
	coverage REAL --%
);

create index on  envdamof_air_quality.sensor_calibrated_observation using btree (phenomenon_time);
create index on  envdamof_air_quality.sensor_calibrated_observation using btree (result_time);
CREATE INDEX ON envdamof_air_quality.sensor_calibrated_observation USING btree (procedure);
CREATE INDEX ON envdamof_air_quality.sensor_calibrated_observation USING btree (feature_of_interest);


--Template table for a SpatioTemporalModelOutput: air_quality_model_output
create table envdamof_air_quality.air_quality_model_output (
	procedure integer, 
	feature_of_interest integer, --references envdamof_air_quality.air_quality_model(fid), we cannot reference a process
	phenomenon_time_start timestamp, --use in case of period temporal type
	phenomenon_time_end timestamp, -- use in case of period temporal type
	result_time timestamp,
	subsamples json 
	-- JSON Template for subsamples
	/*
	[{
		phenomenon_time: 
		path: "path_to_coverage" --2D spatial coverage
	}, ...]
	
	bands:
	nox --ug/m3
	*/
);

create index on  envdamof_air_quality.air_quality_model_output using btree (phenomenon_time_start);
create index on  envdamof_air_quality.air_quality_model_output using btree (phenomenon_time_end);
create index on  envdamof_air_quality.air_quality_model_output using btree (result_time);
CREATE INDEX ON envdamof_air_quality.air_quality_model_output USING btree (procedure);
CREATE INDEX ON envdamof_air_quality.air_quality_model_output USING btree (feature_of_interest);


-----------------------------------------
-------- CATALOG ------------------------
------------------------------------------

-- USER DEFINED TYPES

--Delete the types if they EXIST

delete from omcatalog.enumeration_type 
where name = 'envdamof_air_quality.sensor_low_cost_status';

delete from omcatalog.complex_type
where name = 'envdamof_air_quality.sensor_calibration_algorithm';


-- User defined types

--sensor_low_cost_status

INSERT INTO omcatalog.enumeration_type VALUES (
	'envdamof_air_quality.sensor_low_cost_status',
	'[
		"offline",
		"calibration",
		"running"
	]',
	null
);


--sensor_calibration_algorith (model_name, hyper_parameters, training_start, training_end, regression_variables, note, python_libraray, legal_station, info)

INSERT INTO omcatalog.complex_type VALUES 
(
	'envdamof_air_quality.sensor_calibration_algorithm',
	'[
		{
			"name":"model_name",
			"data_type":"text",
			"repeated":false
		},
		{
			"name":"hyper_parameters",
			"data_type": "text",
			"repeated":false
		},
		{
			"name":"training_start",
			"data_type": "timestamp",
			"repeated":false
		},
		{
			"name":"training_end",
			"data_type": "timestamp",
			"repeated":false
		},
		{
			"name":"regression_variables",
			"data_type": "text",
			"repeated":false
		},
		{
			"name":"note",
			"data_type": "text",
			"repeated":false
		},
		{
			"name":"python_library",
			"data_type": "text",
			"repeated":false
		},
		{
			"name":"legal_station",
			"data_type": "integer",
			"repeated":false
		},
		{
			"name":"info",
			"data_type": "json",
			"repeated":false
		}
	]',
	null
);

-- FEATURE TYPES

-- Delete feature types if they EXIST

delete from omcatalog.process_type
where name IN 
	(
	'envdamof_air_quality.aq_legal_station',
	'envdamof_air_quality.sensor_low_cost',
	'envdamof_air_quality.sensor_calibration',
	'envdamof_air_quality.air_quality_model'
	); 

delete from omcatalog.spatial_sampling_feature_type
where name IN 
	(
	'envdamof_air_quality.aq_legal_station',
	'envdamof_air_quality.sensor_low_cost_feature',
	'envdamof_air_quality.air_quality_model'
	);  

delete from omcatalog.feature_type
where name in 
   (
   'envdamof_air_quality.aq_legal_station',
	'envdamof_air_quality.sensor_low_cost',
	'envdamof_air_quality.sensor_calibration',
	'envdamof_air_quality.air_quality_model',
	'envdamof_air_quality.sensor_low_cost_feature',
	'envdamof_air_quality.city'
   );
   


INSERT INTO omcatalog.feature_type values
('envdamof_air_quality.city', 
'["aq_population_center_type"]',
'[{
	"name":"geo",
	"data_type":"Geometry(POLYGON,4326)",
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
('envdamof_air_quality.aq_legal_station', 
'["aq_station","aq_station_location","aq_insitu_static_process"]',
'[{
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
('envdamof_air_quality.sensor_low_cost_feature', 
'["aq_station","aq_station_location"]',
'[{
	"name":"code",
	"data_type":"text",
	"repeated":false
},
{
	"name":"note",
	"data_type":"text",
	"repeated":false
},
{
	"name":"location",
	"data_type":"text",
	"repeated":false
}
]',
'[{
	"name":"legal_station",
	"repeated":false,
	"referenced_type": "envdamof_air_quality.aq_legal_station"
}
]',
null
),
('envdamof_air_quality.air_quality_model', 
'["aq_model_grid","aq_spatiotemporal_model"]',
'[{
	"name":"description",
	"data_type":"text",
	"repeated":false
}
]',
null,
null
),
('envdamof_air_quality.sensor_low_cost', 
'["aq_insitu_static_process"]',
'[{
	"name":"model",
	"data_type":"text",
	"repeated":false
},
{
	"name":"note",
	"data_type":"text",
	"repeated":false
},
{
	"name":"trademark",
	"data_type":"text",
	"repeated":false
},
{
	"name":"sensor_box_code",
	"data_type":"text",
	"repeated":false
},
{
	"name":"operator",
	"data_type":"text",
	"repeated":false
},
{
	"name":"status",
	"data_type":"envdamof_air_quality.sensor_low_cost_status",
	"repeated":false
}
]',
null,
null
),
('envdamof_air_quality.sensor_calibration', 
'["aq_insitu_static_process"]',
'[{
	"name":"note",
	"data_type":"text",
	"repeated":false
},
{
	"name":"co_algorithm",
	"data_type":"envdamof_air_quality.sensor_calibration_algorithm",
	"repeated":false
},
{
	"name":"no_algorithm",
	"data_type":"envdamof_air_quality.sensor_calibration_algorithm",
	"repeated":false
},
{
	"name":"no2_algorithm",
	"data_type":"envdamof_air_quality.sensor_calibration_algorithm",
	"repeated":false
},
{
	"name":"o3_algorithm",
	"data_type":"envdamof_air_quality.sensor_calibration_algorithm",
	"repeated":false
}
]',
'[{
	"name":"sensor",
	"repeated":false,
	"referenced_type": "envdamof_air_quality.sensor_low_cost"
}
]',
null
);


-- SAMPLING FEATURE TYPES

INSERT INTO omcatalog.spatial_sampling_feature_type VALUES (
	'envdamof_air_quality.aq_legal_station',
	'envdamof_air_quality.city',
	'epsg:4326',
	null
),
(
	'envdamof_air_quality.sensor_low_cost_feature',
	'envdamof_air_quality.city',
	'epsg:4326',
	null
),
(
	'envdamof_air_quality.air_quality_model',
	'envdamof_air_quality.city',
	'epsg:4326',
	null
);


-- PROCESS TYPES

INSERT INTO omcatalog.process_type VALUES (
	'envdamof_air_quality.aq_legal_station',
	'envdamof_air_quality.aq_legal_station_observation',
	'envdamof_air_quality.aq_legal_station',
	'envdamof_air_quality.aq_legal_station',
	'[{
		"name":"co",
		"data_type": "measure(mg/m3)",
		"repeated":false
	},
	{
		"name":"no",
		"data_type": "measure(ug/m3)",
		"repeated":false
	},
	{
		"name":"no2",
		"data_type": "measure(ug/m3)",
		"repeated":false
	},
	{
		"name":"o3",
		"data_type": "measure(ug/m3)",
		"repeated":false
	},
	{
		"name":"nox",
		"data_type": "measure(ug/m3)",
		"repeated":false
	}
	]'
),
(
	'envdamof_air_quality.sensor_low_cost',
	'envdamof_air_quality.sensor_raw_observation',
	'envdamof_air_quality.sensor_low_cost_feature',
	'envdamof_air_quality.sensor_low_cost_feature',
	'[{
		"name":"battery_voltage",
		"data_type": "measure(V)",
		"repeated":false
	},
	{
		"name":"humidity",
		"data_type": "measure(%)",
		"repeated":false
	},
	{
		"name":"temperature",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"no_we",
		"data_type": "measure(mV)",
		"repeated":false
	},
	{
		"name":"no_aux",
		"data_type": "measure(mV)",
		"repeated":false
	},
	{
		"name":"no2_we",
		"data_type": "measure(mV)",
		"repeated":false
	},
	{
		"name":"no2_aux",
		"data_type": "measure(mV)",
		"repeated":false
	},
	{
		"name":"ox_we",
		"data_type": "measure(mV)",
		"repeated":false
	},
	{
		"name":"ox_aux",
		"data_type": "measure(mV)",
		"repeated":false
	},
	{
		"name":"co_we",
		"data_type": "measure(mV)",
		"repeated":false
	},
	{
		"name":"co_aux",
		"data_type": "measure(mV)",
		"repeated":false
	},
	{
		"name":"co_concentration",
		"data_type": "measure(mg/m3)",
		"repeated":false
	},
	{
		"name":"no_concentration",
		"data_type": "measure(ug/m3)",
		"repeated":false
	},
	{
		"name":"no2_concentration",
		"data_type": "measure(ug/m3)",
		"repeated":false
	},
	{
		"name":"ox_concentration",
		"data_type": "measure(ug/m3)",
		"repeated":false
	}
	]'
),
(
	'envdamof_air_quality.sensor_calibration',
	'envdamof_air_quality.sensor_calibrated_observation',
	null,
	'envdamof_air_quality.sensor_low_cost_feature',
	'[{
		"name":"co",
		"data_type": "measure(mg/m3)",
		"repeated":false
	},
	{
		"name":"no",
		"data_type": "measure(ug/m3)",
		"repeated":false
	},
	{
		"name":"no2",
		"data_type": "measure(ug/m3)",
		"repeated":false
	},
	{
		"name":"o3",
		"data_type": "measure(ug/m3)",
		"repeated":false
	},
	{
		"name":"co_out_of_range",
		"data_type": "bool",
		"repeated":false
	},
	{
		"name":"no_out_of_range",
		"data_type": "bool",
		"repeated":false
	},
	{
		"name":"no2_out_of_range",
		"data_type": "bool",
		"repeated":false
	},
	{
		"name":"o3_out_of_range",
		"data_type": "bool",
		"repeated":false
	},
	{
		"name":"coverage",
		"data_type": "measure(%)",
		"repeated":false
	}
	]'
),
(
	'envdamof_air_quality.air_quality_model',
	'envdamof_air_quality.air_quality_model_output',
	null,
	'envdamof_air_quality.air_quality_model',
	'[{
		"name":"nox",
		"data_type": "measure(ug/m3)",
		"repeated":false
	}
	]'
);

