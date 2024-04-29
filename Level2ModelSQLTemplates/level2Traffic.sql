
-- We will use JSON to represent aggregates whenever needed. 
--     1.- Measure and Category types
--     2.- External FeatureType and Coverage references.
--     3.- InDB subsamples of small size

-------------------------------------
---------- FEATURE TYPES ------------
-------------------------------------


-- Template table for a AbstractRoadSection
create table abstract_road_section (
	fid integer,
	geo geometry(LINESTRING,4326) -- replace for a more specific one if needed
);


----------------------------------------------
---------- SAMPLING FEATURE TYPES ------------
----------------------------------------------

--Template table for a AbstractTrafficStation
create table abstract_traffic_station (
	fid integer,
	shape geometry(POINT,4326), -- replace this field for more specific geometry data types
	sampled_feature integer references road_section(fid) --add foreign key for relevant feature type
);



-------------------------------------
---------- PROCESS TYPES ------------
-------------------------------------

--Template table for a AbstractTrafficPointObservationProcess
create table abstract_traffic_point_observation_process (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer references traffic_station(fid) -- replace by more specific ref
);

--Template table for a AbstractTrafficSpatialModel
create table abstract_traffic_spatial_model (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp
);

--Template table for a AbstractTrafficSpatioTemporalModel
create table abstract_traffic_spatiotemporal_model (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp
);




-----------------------------------------
---------- OBSERVATION TYPES ------------
-----------------------------------------

--Template table for an AbstractTrafficPointObservation
create table abstract_traffic_point_observation (
	procedure integer, 
	feature_of_interest integer references traffic_station(fid),
	phenomenon_time timestamp,
	result_time timestamp
);

--Template table for a AbstractTrafficSpatialModelOutput
create table abstract_traffic_spatial_model_output (
	procedure integer, 
	feature_of_interest integer references road_section(fid),
	phenomenon_time timestamp,
	result_time timestamp
);

--Template table for a AbstractTrafficSpatioTemporalModelOutput
create table abstract_traffic_spatio_temporal_model_output (
	procedure integer, 
	feature_of_interest integer references road_section(fid),
	phenomenon_time_start timestamp, --use in case of period temporal type
	phenomenon_time_end timestamp, -- use in case of period temporal type
	result_time timestamp,
	subsamples json 
	-- JSON Template for subsamples
	/*
	[{
		phenomenonTime: "instant",
		...
	}, ...]
	*/
);


