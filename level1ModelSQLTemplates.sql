
-- We will use JSON to represent aggregates whenever needed. 
--     1.- Measure and Category types
--     2.- External FeatureType and Coverage references.
--     3.- InDB subsamples of small size


-- Template table for a FeatureType
create table feature_type_name (
	fid integer
);

--Template table for a SpatialSamplingFeatureType
create table spatial_sampling_feature_type_name (
	fid integer,
	shape geometry, -- replace this field for more specific geometry data types
	shape_height real,--use only if the feature has vertical dimension
	shape_height json,-- use in case the vertical dimension has extension {start:start_value,end:end_value}
	sampled_feature integer --add foreign key for relevant feature type
);

--Template table for a SamplingProcessType
create table sampling_process_type_name (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp
);

--Template table for a SpecimenType
create table specimen_type_name (
	fid integer,
	sampling_time timestamp, -- replace this field for more specific geometry data types
	sampling_time json, --use in case of period temporal type {start: ..., end: ...}
	sampled_feature integer, --add foreign key for relevant feature type
	sampling_method integer, --use in case the sampling method is recorded. Add reference
	sampling_location integer -- use in case the geospatial location  of the sample is relevant. Add reference.
);

--Template table for a ProcessType
create table process_type_name (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	platform integer --Add only if the process type is installed in a platform. Add foreign key
);

--Template table for an ObservationType
create table observation_type (
	procedure integer,
	feature_of_interest integer,
	phenomenon_time timestamp,
	phenomenon_time json, -- use in case of period temporal type {start: ..., end: ...}
	result_time timestamp,
	subsamples json --use in case the observation_type has subsamples integrated in the same schema.
	
);


