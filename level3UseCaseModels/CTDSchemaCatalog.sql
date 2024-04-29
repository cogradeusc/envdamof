drop schema if exists envdamof_ctd cascade;

CREATE SCHEMA envdamof_ctd;

-------------------------------------
---------- FEATURE TYPES ------------
-------------------------------------

-- Estuary
create table envdamof_ctd.estuary (
	fid integer PRIMARY KEY,
	geo geometry(POLYGON,4326), -- replace for a more specific one if needed
	short_name TEXT,
	name TEXT,
	ZONE TEXT
);

create index on envdamof_ctd.estuary using gist (geo);

----------------------------------------------
---------- SAMPLING FEATURE TYPES ------------
----------------------------------------------

--Environmental Profile: ctd_station
create table envdamof_ctd.ctd_station (
	fid integer PRIMARY key,
	shape geometry(POINT,4326), -- replace this field for more specific geometry data types
	shape_height_start real, -- Vertical positive coordinate in EPSG:5831. Alwats set to 0
	shape_height_end real, --vertical positive coordinate in EPSG:5831
	sampled_feature integer references envdamof_ctd.estuary(fid), --add foreign key for relevant feature type
	code TEXT,
	name TEXT,
	description TEXT,
	start_time timestamp,
	end_time timestamp
);

create index on envdamof_ctd.ctd_station using gist (shape);

-------------------------------------
---------- PROCESS TYPES ------------
-------------------------------------




--AbstractEnvProfilerProcess: ctd_device

-- ctd_device
CREATE TABLE envdamof_ctd.ctd_device (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	name TEXT,
	sensors json,
	ship TEXT,
	COMMENTS text
);

--JSON FORMAT
/*
[{
	id:231,
	code:"code1"
},
{
	id:232,
	code:"code2"
}. . .
] 
 */

CREATE INDEX ON envdamof_ctd.ctd_device USING btree (fid);

-----------------------------------------
---------- OBSERVATION TYPES ------------
-----------------------------------------

--EnvProfileObservation: ctd_observation
create table envdamof_ctd.ctd_observation (
	procedure integer, 
	feature_of_interest integer references envdamof_ctd.ctd_station(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples json
	-- JSON format
	/*
	[{
	sampling_geometry_height: "vertical positive coordiante in EPSG:5831",
	temperature_ITS90: ,
	salinity: ,
	pressure: ,
	ph: ,
	oxigen: ,
	transmittance: ,
	irradiance: ,
	uv_flourescence: ,
	flourescence: ,
	density: ,
	depth: ,
	temperature_ITS68: ,
	conductivity:,
	validation_flags: {temperature_ITS90: 1,
						salinity: 1,
						pressure: 1,
						ph: 1,
						oxigen: 1,
						transmittance: 1,
						irradiance: 1,
						uv_flourescence: 1,
						flourescence: 1,
						density: 1,
						depth: 1,
						temperature_ITS68: 1,
						conductivity: 1
						} 
	}, ...]
	*/
);


create index on  envdamof_ctd.ctd_observation using btree (phenomenon_time);
create index on  envdamof_ctd.ctd_observation using btree (result_time);
CREATE INDEX ON envdamof_ctd.ctd_observation USING btree (procedure);
CREATE INDEX ON envdamof_ctd.ctd_observation USING btree (feature_of_interest);

-----------------------------------------
-------- CATALOG
------------------------------------------

-- USER DEFINED TYPES

--Delete the types if they EXIST

delete from omcatalog.enumeration_type 
where name = 'envdamof_ctd.validation_flag_type';

delete from omcatalog.complex_type
where name = 'envdamof_ctd.validation_flags_type';


INSERT INTO omcatalog.enumeration_type VALUES (
	'envdamof_ctd.validation_flag_type',
	'[{"vocabulary":"english",
	    "values":
		 [
			"No quality control",
			"Good value",
			"Probably good value",
			"Probably bad value",
			"Bad value",
			"Changed value",
			"Good value without recalibration",
			"Lost value"
		]
	}
	]',
	null
);

INSERT INTO omcatalog.complex_type VALUES 
(
	'envdamof_ctd.validation_flags_type',
	'[
		{
			"name":"temperature_ITS90",
			"data_type":"envdamof_ctd.validation_flag_type",
			"repeated":false
		},
		{
			"name":"salinity",
			"data_type": "envdamof_ctd.validation_flag_type",
			"repeated":false
			},
		{
			"name":"pressure",
			"data_type": "envdamof_ctd.validation_flag_type",
			"repeated":false
		},
		{
			"name":"ph",
			"data_type": "envdamof_ctd.validation_flag_type",
			"repeated":false
		},
		{
			"name":"oxigen",
			"data_type": "envdamof_ctd.validation_flag_type",
			"repeated":false
		},
		{
			"name":"transmittance",
			"data_type": "envdamof_ctd.validation_flag_type",
			"repeated":false
		},
		{
			"name":"irradiance",
			"data_type": "envdamof_ctd.validation_flag_type",
			"repeated":false
		},
		{
			"name":"uv_flourescence",
			"data_type": "envdamof_ctd.validation_flag_type",
			"repeated":false
		},
		{
			"name":"flourescence",
			"data_type": "envdamof_ctd.validation_flag_type",
			"repeated":false
		},
		{
			"name":"density",
			"data_type": "envdamof_ctd.validation_flag_type",
			"repeated":false
		},
		{
			"name":"depth",
			"data_type": "envdamof_ctd.validation_flag_type",
			"repeated":false
		},
		{
			"name":"temperature_ITS68",
			"data_type": "envdamof_ctd.validation_flag_type",
			"repeated":false
		},
		{
			"name":"conductivity",
			"data_type": "envdamof_ctd.validation_flag_type",
			"repeated":false
		}
	]',
	null
);


-- FEATURE TYPES

-- Delete feature types if they EXIST

delete from omcatalog.process_type
where name = 'envdamof_ctd.ctd_device'; 

delete from omcatalog.spatial_sampling_feature_type
where name = 'envdamof_ctd.ctd_station'; 

delete from omcatalog.feature_type
where name in 
   (
   'envdamof_ctd.ctd_device',
   'envdamof_ctd.ctd_station',
   'envdamof_ctd.estuary'
   );
   


INSERT INTO omcatalog.feature_type values
('envdamof_ctd.estuary', 
'["cs_region_of_interest"]',
'[{
	"name":"geo",
	"data_type":"Geometry(POLYGON,4326)",
	"repeated":false
},
{
	"name":"short_name",
	"data_type":"text",
	"repeated":false
},
{
	"name":"name",
	"data_type":"text",
	"repeated":false
},
{
	"name":"zone",
	"data_type":"text",
	"repeated":false
}
]',
null, 
null
),
('envdamof_ctd.ctd_station', 
'["cs_profile"]',
'[{
	"name":"max_depth",
	"data_type":"real",
	"repeated":false
},
{
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
	"name":"description",
	"data_type":"text",
	"repeated":false
},
{
	"name":"start_time",
	"data_type":"timestamp",
	"repeated":false
},
{
	"name":"end_time",
	"data_type":"timestamp",
	"repeated":false
}
]',
null,
null
),
('envdamof_ctd.ctd_device',
'["cs_profiler_process"]',
'[{
	"name":"name",
	"data_type":"text",
	"repeated":false
},
{
	"name":"sensors",
	"data_type":"json",
	"repeated":false
},
{
	"name":"ship",
	"data_type":"text",
	"repeated":false
},
{
	"name":"comments",
	"data_type":"text",
	"repeated":false
}
]',
null,
null
);


-- SAMPLING FEATURE TYPES

INSERT INTO omcatalog.spatial_sampling_feature_type VALUES (
	'envdamof_ctd.ctd_station',
	'envdamof_ctd.estuary',
	'epsg:4326',
	'epsg:5831'
);

-- PROCESS TYPES

INSERT INTO omcatalog.process_type VALUES (
	'envdamof_ctd.ctd_device',
	'envdamof_ctd.ctd_observation',
	NULL,
	'envdamof_ctd.ctd_station',
	'[{
		"name":"temperature_ITS90",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"salinity",
		"data_type": "measure(null)",
		"repeated":false
	},
	{
		"name":"pressure",
		"data_type": "measure(db)",
		"repeated":false
	},
	{
		"name":"ph",
		"data_type": "measure(null)",
		"repeated":false
	},
	{
		"name":"oxigen",
		"data_type": "measure(ml/l)",
		"repeated":false
	},
	{
		"name":"transmittance",
		"data_type": "measure(%)",
		"repeated":false
	},
	{
		"name":"irradiance",
		"data_type": "measure(quanta/cm2sec)",
		"repeated":false
	},
	{
		"name":"uv_flourescence",
		"data_type": "measure(ug/l)",
		"repeated":false
	},
	{
		"name":"flourescence",
		"data_type": "measure(mg/m3)",
		"repeated":false
	},
	{
		"name":"density",
		"data_type": "measure(kg/m3)",
		"repeated":false
	},
	{
		"name":"depth",
		"data_type": "measure(m)",
		"repeated":false
	},
	{
		"name":"temperature_ITS68",
		"data_type": "measure(ºC)",
		"repeated":false
	},
	{
		"name":"conductivity",
		"data_type": "measure(Siemens/m)",
		"repeated":false
	},
	{
		"name":"validation_flag",
		"data_type": "envdamof_ctd.validation_flags_type",
		"repeated":false
	}
	]'
);



