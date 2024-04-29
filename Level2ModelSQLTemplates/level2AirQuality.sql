
-- We will use JSON to represent aggregates whenever needed. 
--     1.- Measure and Category types
--     2.- External FeatureType and Coverage references.
--     3.- InDB subsamples of small size

-------------------------------------
---------- FEATURE TYPES ------------
-------------------------------------


-- Template table for a AdministrativeDivisionType
create table administrative_division_type (
	fid integer,
	geo geometry(POLYGON,4326) -- replace for a more specific one if needed
);


-- Template table for a PopulationCenterType
create table population_center_type (
	fid integer,
	geo geometry(POLYGON,4326) -- replace for a more specific one if needed
	located_at integer references adminitrative_division_type(fid) --replace for a more specific reference
);

-- Template table for a vehicle
create table vehicle (
	fid integer
);

-- Template table for a FlyingPlatform
create table flying_platform (
	fid integer
);

----------------------------------------------
---------- SAMPLING FEATURE TYPES ------------
----------------------------------------------

--Template table for a AQStationLocation
create table aq_station (
	fid integer,
	shape geometry(POINT,4326), -- replace this field for more specific geometry data types
	shape_height real, -- Use some vertical CRS
	sampled_feature integer --add foreign key for relevant feature type
);

--Template table for a AQGroundArea
create table aq_ground_area (
	fid integer,
	shape geometry(POLYGON,4326), -- replace this field for more specific geometry data types
	shape_height real,
	sampled_feature integer --add foreign key for relevant feature type
);

--Template table for a AQModelGrid
create table aq_model_grid (
	fid integer,
	shape geometry(POLYGON,4326), -- replace this field for more specific geometry data types
	shape_grid_size json, --array with the size in each axis
	sampled_feature integer --add foreign key for relevant feature type
);

--Template table for a AQTemporalModelGrid
create table aq_temporal_model_grid (
	fid integer,
	shape geometry(POLYGON,4326), -- replace this field for more specific geometry data types
	shape_grid_size json, --array with the size in each axis
	sampled_feature integer, --add foreign key for relevant feature type
	phenomenon_time_grid_size integer
);

--Template table for a AQHeightModelGrid
create table aq_height_model_grid (
	fid integer,
	shape geometry(POLYGON,4326), -- replace this field for more specific geometry data types
	shape_grid_size json, --array with the size in each axis
	sampled_feature integer, --add foreign key for relevant feature type
	height_grid_size:integer
);

-------------------------------------
---------- PROCESS TYPES ------------
-------------------------------------

--Template table for a AQInSituStaticProcess
create table aq_insitu_static_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references station_location(fid) -- replace by more specific ref
);


--Template table for a InSituOnRouteProcess
create table aq_insitu_ground_mobile_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references vehicle(fid) -- replace by more specific ref
);


--Template table for a InSituAirboneProcess
create table aq_insitu_airbone_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references flying_platform(fid) -- replace by more specific ref
);


--Template table for a RemoteSensingSceneProcess
create table aq_remote_sensing_scene_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references flying_platform(fid) -- replace by more specific ref
);

--Template table for a RemoteSensingSwathProcess
create table aq_remote_sensing_swath_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references flying_platform(fid) -- replace by more specific ref
);


--Template table for a spatialModel
create table aq_spatial_model (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp
);

--Template table for a spatioTemporalModel
create table aq_spatiotemporal_model (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp
);


-----------------------------------------
---------- OBSERVATION TYPES ------------
-----------------------------------------

--Template table for an InSituStaticObservation
create table aq_insitu_static_observation (
	procedure integer, 
	feature_of_interest integer references station_location(fid),
	phenomenon_time timestamp,
	result_time timestamp
);

--Template table for OnRouteObservation
create table aq_ground_mobile_observation (
	fid integer,
	sampling_geometry geometry(POINT,4326), -- replace this field for more specific geometry data types
	procedure integer,
	phenomenon_time timestamp,
	result_time timestamp
);

--Template table for FlightTrajectory
create table aq_flight_trajectory (
	fid integer,
	shape geometry(LINESTRING,4326), -- replace this field for more specific geometry data types
	shape_height_start real,
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
		phenomenonTime: "instant",
		sampling_geometry: "wkt point2D	in EPSG:4326",
		sampling_geometry_height: "height with some vertical CRS"
		...
	}, ...]
	*/
);

--Template table for AQRSIrregularCoverage
create table aq_rs_irregular_scene (
	fid integer,
	shape geometry(POLYGON,4326), -- replace this field for more specific geometry data types
	sampled_feature integer, --add foreign key for relevant feature type
	procedure integer,
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples text --path to feature type
);


--Template table for AQRSRegularGridCoverage
create table aq_rs_grid_scene (
	fid integer,
	shape geometry(POLYGON,4326), -- replace this field for more specific geometry data types
	shape_grid_size json,
	sampled_feature integer, --add foreign key for relevant feature type
	procedure integer,
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples text -- path_to_coverage
);


--Template table for AQRSIrregularSwath
create table aq_rs_irregular_swath (
	fid integer,
	shape geometry(POLYGON,4326), -- replace this field for more specific geometry data types
	sampled_feature integer, --add foreign key for relevant feature type
	procedure integer,
	phenomenon_time_start timestamp,
	phenomenon_time_end timestamp,
	result_time timestamp,
	subsamples json 
	-- JSON Template for subsamples 
	/*
	[{
		sampling_geometry: "WKT of the shape",
		phenomenon_time: "timestamp",
		subsamples: "path to multipoint coverage"
	}, ...]
	*/
);

--Template table for AQRSGridSwath
create table aq_rs_grid_swath (
	fid integer,
	shape geometry(POLYGON,4326), -- replace this field for more specific geometry data types
	sampled_feature integer, --add foreign key for relevant feature type
	procedure integer,
	phenomenon_time_start timestamp,
	phenomenon_time_end timestamp,
	result_time timestamp,
	shape_grid_size json,
	subsamples json 
	-- JSON Template for subsamples 
	/*
	[{
		sampling_geometry: "WKT of the shape",
		phenomenon_time: "timestamp",
		subsamples: "path to multipoint coverage"
	}, ...]
	*/
);



--Template table for a SpatialModelOutput
create table aq_spatial_model_output (
	procedure integer, 
	feature_of_interest integer, -- references a model grid which is not temporal
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples json
	--JSON template for subsamples
	/*
	--Spatial 2d coverage
	{
		subsamples: "path to coverage"
	}
	
	--Spatial 2D coverage
	[{
		sampling_geometry_height: "height",
		subsamples: "path to coverage"
	},...]
	*/
	
	
);

--Template table for a SpatioTemporalModelOutput
create table aq_spatiotemporal_model_output (
	procedure integer, 
	feature_of_interest integer, -- must reference a temporal model grid
	phenomenon_time_start timestamp, --use in case of period temporal type
	phenomenon_time_end timestamp, -- use in case of period temporal type
	result_time timestamp,
	subsamples json
	--JSON template for subsamples
	/*
	--Spatial 2d coverage
	[{
		phenomenon_time: "instant",
		subsamples: "path to coverage"
	},...]
	
	--Spatial 2D coverage
	[{
		phenomenon_time: "instant",
		sampling_geometry_height: "height",
		subsamples: "path to coverage"
	},...]
	*/
);

