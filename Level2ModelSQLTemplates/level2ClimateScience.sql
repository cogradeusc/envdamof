
-- We will use JSON to represent aggregates whenever needed. 
--     1.- Measure and Category types
--     2.- External FeatureType and Coverage references.
--     3.- InDB subsamples of small size

-------------------------------------
---------- FEATURE TYPES ------------
-------------------------------------


-- Template table for a CSRegionOfInterest
create table cs_region_of_interest (
	fid integer,
	geo geometry(POLYGON,4326) -- replace for a more specific one if needed
);

----------------------------------------------
---------- SAMPLING PROCESS TYPES ------------
----------------------------------------------

--Template table for a CSSeaWaterSampleProcess
create table cs_ocean_sampling_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
);



----------------------------------------------
---------- SAMPLING FEATURE TYPES ------------
----------------------------------------------

--Template table for a CSSamplingLocation
create table cs_sampling_location (
	fid integer,
	shape geometry(POINT,4326), -- replace this field for more specific geometry data types
	sampled_feature integer references cs_region_of_interest(fid) --add foreign key for relevant feature type
);

--Template table for a CSSamplingLocationHeight
create table cs_sampling_location_height (
	fid integer,
	shape geometry(POINT,4326), -- replace this field for more specific geometry data types
	shape_height real, -- height with some vertical crs
	sampled_feature integer references cs_region_of_interest(fid) --add foreign key for relevant feature type
);

--Template table for a CSProfile
create table cs_profile (
	fid integer,
	shape geometry(POINT,4326), -- replace this field for more specific geometry data types
	shape_height_start real, -- height with some vertical crs
	shape_height_end real,
	sampled_feature integer references cs_region_of_interest(fid) --add foreign key for relevant feature type
);

--Template table for a CSSection
create table cs_section (
	fid integer,
	shape geometry(LINESTRING,4326), -- replace this field for more specific geometry data types
	shape_height_start real, -- height with some vertical crs
	shape_height_end real,
	sampled_feature integer references cs_region_of_interest(fid) --add foreign key for relevant feature type
);


--Template table for a CSTransect
create table cs_transect (
	fid integer,
	shape geometry(LINESTRING,4326), -- replace this field for more specific geometry data types
	shape_height_start real, -- height with some vertical crs
	shape_height_end real, -- height with some vertical crs
	sampled_feature integer references cs_region_of_interest(fid) --add foreign key for relevant feature type
);

--Template table for a CSTrajectory
create table cs_trajectory (
	fid integer,
	shape geometry(LINESTRING,4326), -- replace this field for more specific geometry data types
	shape_height_start real, -- height with some vertical crs
	shape_height_end real,
	sampled_feature integer references cs_region_of_interest(fid) --add foreign key for relevant feature type
);

--Template table for CRSIrregularScene
create table cs_rs_irregular_scene (
	fid integer,
	shape geometry(POLYGON,4326),-- replace this field for more specific geometry data types
	sampled_feature integer references cs_region_of_interest(fid) --add foreign key for relevant feature type
);

--Template table for CSRSGridScene
create table cs_rs_grid_scene (
	fid integer,
	shape geometry(POLYGON,4326),-- replace this field for more specific geometry data types
	shape_grid_size json,
	sampled_feature integer references cs_region_of_interest(fid) --add foreign key for relevant feature type
);


--Template table for CSModelGrid
create table cs_model_grid (
	fid integer,
	shape geometry(POLYGON,4326),-- replace this field for more specific geometry data types
	shape_grid_size json,
	sampled_feature integer references cs_region_of_interest(fid) --add foreign key for relevant feature type
);

--Template table for HeightRegularModelGrid
create table cs_model_grid (
	fid integer,
	shape geometry(POLYGON,4326),-- replace this field for more specific geometry data types
	shape_grid_size json,
	shape_height_start real,
	shape_height_end real,
	shape_height_grid_size integer,
	sampled_feature integer references cs_region_of_interest(fid) --add foreign key for relevant feature type
);

--Template table for HeightIrregularModelGrid
create table cs_model_grid (
	fid integer,
	shape geometry(POLYGON,4326),-- replace this field for more specific geometry data types
	shape_grid_size json,
	shape_height json, --height values stored in a json array
	sampled_feature integer references cs_region_of_interest(fid) --add foreign key for relevant feature type
);


--Template table for temporalModelGrid
create table cs_model_grid (
	fid integer,
	shape geometry(POLYGON,4326),-- replace this field for more specific geometry data types
	shape_grid_size json,
	phenomenon_time_grid_size integer,
	sampled_feature integer references cs_region_of_interest(fid) --add foreign key for relevant feature type
);


--Template table for a CSOceanSample
create table cs_ocean_sample (
	fid integer,
	sampling_time timestamp, -- replace this field for more specific geometry data types
	sampled_feature integer, --add foreign key for relevant feature type
	sampling_method integer, --use in case the sampling method is recorded. Add reference
	sampling_location integer -- use in case the geospatial location  of the sample is relevant. Add reference.
);

-------------------------------------
---------- PROCESS TYPES ------------
-------------------------------------

--Template table for a CSInsituStaticProcess
create table cs_insitu_static_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer 
);

--Template table for a CSProfilerProcess
create table cs_profiler_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer 
);


--Template table for a CSSectionProcess
create table cs_section_scan_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer 
);

--Template table for a CSTransectScanProcess
create table cs_transect_scan_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer
);


--Template table for a CSInsituMobileProcess
create table cs_insitu_mobile_sensing_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer
);



--Template table for a CSRemoteSensingProcess
create table cs_remote_sensing_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer
);


--Template table for a CSSpatialModel
create table cs_spatial_model (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer
);

--Template table for a CSSpatioTemporalModel
create table cs_spatiotemporal_model (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer
);


--Template table for a CSSeaWaterAnalysisProcess
create table cs_ocean_sample_analysis_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer
);



-----------------------------------------
---------- OBSERVATION TYPES ------------
-----------------------------------------

--Template table for an CSInsituStaticObservation
create table cs_insitu_static_observation (
	procedure integer, 
	feature_of_interest integer references cs_sampling_location(fid),
	phenomenon_time timestamp,
	result_time timestamp
);

--Template table for an CSProfileObservation
create table cs_profile_observation (
	procedure integer, 
	feature_of_interest integer references cs_profile(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples json
	-- JSON Template for subsamples
	/*
	[{
		sampling_geometry_height: "vertical coordinate in some vertical CRS",
	}, ...]
	*/
);


--Template table for an CSSectionObservation
create table cs_section_observation (
	procedure integer, 
	feature_of_interest integer references cs_profile(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples json
	-- JSON Template for subsamples
	/*
	[{
		sampling_geometry: "WKT representation of the point"
		sampling_geometry_height: "vertical coordinate in some vertical CRS",
	}, ...]
	*/
);

--Template table for an CSTransectObservation
create table cs_transect_observation (
	procedure integer, 
	feature_of_interest integer references cs_transect(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples json
	-- JSON Template for subsamples
	/*
	[{
		sampling_geometry: "wkt point3D in EPSG:4979",
		sampling_geometry_height: "vertical coordinate in some vertical CRS",
		...
	}, ...]
	*/
);

--Template table for CSTrajectoryObservation
create table cs_trajectory_observation (
	procedure integer,
	feature_of_interest integer references cs_trajectory(fid),
	phenomenon_time_start timestamp, --use in case of period temporal type
	phenomenon_time_end timestamp, -- use in case of period temporal type
	result_time timestamp,
	subsamples json 
	-- JSON Template for subsamples
	/*
	[{
		phenomenon_time: "instant",
		sampling_geometry: "wkt point3D in EPSG:4326",
		sampling_geometry_height: "height using some vertical crs"
		...
	}, ...]
	*/
);

--Template table for a 
create table cs_rs_irregular_scene_observation (
	procedure integer, 
	feature_of_interest integer references cs_rs_irregular_scene(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples text --path to feature type
);

--Template table for a 
create table cs_rs_grid_scene_observation (
	procedure integer, 
	feature_of_interest integer references cs_rs_grid_scene(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples text --path to grid coverage
);


--Template table for a 
create table cs_rs_irregular_swath_observation (
	procedure integer, 
	feature_of_interest integer references cs_rs_irregular_scene(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples json 
	-- JSON Template for subsamples
	/*
	[{
		phenomenon_time: "instant",
		sampling_geometry: "wkt of a polygon",
		subsamples: "path to feature type" 
	}, ...]
	*/
);

--Template table for a CSRemoteSensingObservation
create table cs_rs_grid_swath_observation (
	procedure integer, 
	feature_of_interest integer references cs_rs_grid_scene(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	subsamples json 
	-- JSON Template for subsamples
	/*
	[{
		phenomenon_time: "instant",
		sampling_geometry: "wkt of a polygon",
		subsamples: "path to grid coverage" 
	}, ...]
	*/
);





--Template table for a CSSpatialModelOutput
create table cs_spatial_model_output (
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

--Template table for a CSSpatioTemporalModelOutput
create table cs_spatiotemporal_model_output (
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

--Template table for an CSOceanSampleObservation
create table cs_ocean_sample_observation (
	procedure integer, 
	feature_of_interest integer references cs_ocean_sample(fid),
	phenomenon_time timestamp,
	result_time timestamp
);


