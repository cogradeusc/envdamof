drop schema if exists envdamof_wrfmodel cascade;

CREATE SCHEMA envdamof_wrfmodel;

-------------------------------------
---------- FEATURE TYPES ------------
-------------------------------------

-- Template table for a RegionOfInterest: RadarRegionOfInterst
create table envdamof_wrfmodel.wrf_region_of_interest (
	fid integer PRIMARY key,
	geo geometry(POLYGON,4326), -- replace for a more specific one if needed
	name TEXT,
	description text
);

create index on envdamof_wrfmodel.wrf_region_of_interest using gist (geo);

----------------------------------------------------------------
---------- SAMPLING FEATURE TYPES AND PROCESS TYPES ------------
----------------------------------------------------------------

-- Insert the SRID for the LCC CRS

/*delete from public.spatial_ref_sys where srid=500001;


insert into public.spatial_ref_sys (srid,auth_name,auth_srid,srtext,proj4text) values 
(500001,'COGRADE',1,
'PROJCRS["unnamed",
    BASEGEOGCRS["WGS 84",
        DATUM["World Geodetic System 1984",
            ELLIPSOID["WGS 84",6378137,298.257223563,
                LENGTHUNIT["metre",1]]],
        PRIMEM["Greenwich",0,
            ANGLEUNIT["degree",0.0174532925199433]],
        ID["EPSG",4326]],
    CONVERSION["Lambert Conic Conformal (2SP)",
        METHOD["Lambert Conic Conformal (2SP)",
            ID["EPSG",9802]],
        PARAMETER["Latitude of false origin",41.3530006408691,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8821]],
        PARAMETER["Longitude of false origin",353.272003173828,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8822]],
        PARAMETER["Latitude of 1st standard parallel",42.5,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8823]],
        PARAMETER["Latitude of 2nd standard parallel",42.5,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8824]],
        PARAMETER["Easting at false origin",281939.206,
            LENGTHUNIT["metre",1],
            ID["EPSG",8826]],
        PARAMETER["Northing at false origin",-5615.692,
            LENGTHUNIT["metre",1],
            ID["EPSG",8827]]],
    CS[Cartesian,2],
        AXIS["easting",east,
            ORDER[1],
            LENGTHUNIT["kilometre",1000,
                ID["EPSG",9036]]],
        AXIS["northing",north,
            ORDER[2],
            LENGTHUNIT["kilometre",1000,
                ID["EPSG",9036]]]]',
 '+proj=lcc +lat_0=41.3530006408691 +lon_0=353.272003173828 +lat_1=42.5 +lat_2=42.5 +x_0=281939.206 +y_0=-5615.692 +datum=WGS84 +units=km +no_defs +type=crs'
);

*/


--Template table for EnvModelGrid. 2D and 3D regular spatial grids
--Template table for a EnvSpatioTemporalModel: wrf_model
create table envdamof_wrfmodel.wrf_model (
	fid integer,
	shape geometry(POLYGON,500001),-- replace this field for more specific geometry data types
	shape_grid_size json,
	phenomenon_time_grid_size integer,
	sampled_feature integer references envdamof_wrfmodel.wrf_region_of_interest(fid), --add foreign key for relevant feature type
	valid_time_start timestamp,
	valid_time_end timestamp,
	name TEXT,
	description text
);

create index on envdamof_wrfmodel.wrf_model using gist (shape);
CREATE INDEX ON envdamof_wrfmodel.wrf_model USING btree (fid);
-----------------------------------------
---------- OBSERVATION TYPES ------------
-----------------------------------------


--Template table for a EnvSpatioTemporalModelOutput: wrf_daily_prediction
create table envdamof_wrfmodel.wrf_daily_prediction (
	procedure integer, 
	feature_of_interest integer, --references envdamof_wrfmodel.wrf_model(fid). We cannot add this because it is also a process
	phenomenon_time_start timestamp, --use in case of period temporal type
	phenomenon_time_end timestamp, -- use in case of period temporal type
	result_time timestamp,
	subsamples json 
	-- JSON Template for subsamples
	/*
	[{phenomenon_time: ,
	  path: "path_to_coverage" --2D spaital coverage
	}, ...]
	
	
	-- Bands: 
	  wind_direction (degrees)
	  wind_speed (m/s)
	  air_pressure_at_sea_level (Pa)
	  rainfall (kg/m2)
	  relative_humidity(%)
	  snowfall_amount(kg/m2)
	  snow_level(m)
	  sea_surface_temperature(K)
	  air_temperature(K)
	*/
);

create index on  envdamof_wrfmodel.wrf_daily_prediction using btree (phenomenon_time_start);
create index on  envdamof_wrfmodel.wrf_daily_prediction using btree (phenomenon_time_end);
create index on envdamof_wrfmodel.wrf_daily_prediction using btree (result_time);
CREATE INDEX ON envdamof_wrfmodel.wrf_daily_prediction USING btree (procedure);
CREATE INDEX ON envdamof_wrfmodel.wrf_daily_prediction USING btree (feature_of_interest);


-----------------------------------------
-------- CATALOG
------------------------------------------

-- USER DEFINED TYPES

-- FEATURE TYPES

-- Delete feature types if they EXIST


delete from omcatalog.process_type
where name = 'envdamof_wrfmodel.wrf_model'; 

delete from omcatalog.spatial_sampling_feature_type
where name = 'envdamof_wrfmodel.wrf_model';


delete from omcatalog.feature_type
where name IN 
	('envdamof_wrfmodel.wrf_region_of_interest',
	 'envdamof_wrfmodel.wrf_model'); 


-- insert feature types
INSERT INTO omcatalog.feature_type values
('envdamof_wrfmodel.wrf_region_of_interest', 
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
('envdamof_wrfmodel.wrf_model', 
'["cs_spatiotemporal_model", "cs_model_grid"]',
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
);

-- SAMPLING FEATURE TYPES

INSERT INTO omcatalog.spatial_sampling_feature_type VALUES 
(
	'envdamof_wrfmodel.wrf_model',
	'envdamof_wrfmodel.wrf_region_of_interest',
	'epsg:4326',
	null
);

-- PROCESS TYPES

INSERT INTO omcatalog.process_type VALUES 
(
	'envdamof_wrfmodel.wrf_model',
	'envdamof_wrfmodel.wrf_daily_prediction',
	NULL,
	'envdamof_wrfmodel.wrf_model',
	'[{
		"name":"wind_direction",
		"data_type": "measure(degrees)",
		"repeated":false
	},
	{
		"name":"wind_speed",
		"data_type": "measure(m/s)",
		"repeated":false
	},
	{
		"name":"air_pressure_at_sea_level",
		"data_type": "measure(Pa)",
		"repeated":false
	},
	{
		"name":"rainfall",
		"data_type": "measure(kg/m2)",
		"repeated":false
	},
	{
		"name":"relative_humidity",
		"data_type": "measure(%)",
		"repeated":false
	},
	{
		"name":"snowfall_amount",
		"data_type": "measure(kg/m2)",
		"repeated":false
	},
	{
		"name":"snow_level",
		"data_type": "measure(m)",
		"repeated":false
	},
	{
		"name":"sea_surface_temperature",
		"data_type": "measure(K)",
		"repeated":false
	},
	{
		"name":"air_temperature",
		"data_type": "measure(K)",
		"repeated":false
	}
	]'
);



