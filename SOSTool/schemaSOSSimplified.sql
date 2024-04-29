

-- procedure
create table procedure (
	procedure_id bigint PRIMARY KEY,
	identifier text,
	name text,
	description text
);

-- Phenomena
create table phenomenon (
	phenomenon_id bigint PRIMARY KEY,
	identifier text,
	name text,
	description text
);

create table composite_phenomenon (
	child_phenomenon_id bigint references phenomenon(phenomenon_id),
	parent_phenomenon_id bigint references phenomenon(phenomenon_id)
);

--units
create table unit (
	unit_id bigint PRIMARY KEY,
	symbol text,
	name text,
	link text
);


-- Parameters
create table parameter (
	parameter_id bigint PRIMARY KEY,
	type text,
	name text,
	value_boolean boolean,
	value_category text,
	unit_id bigint references unit(unit_id),
	value_count integer,
	value_quantity real,
	value_text text,
	value_xml text,
	value_json text
);

-- Feature of interest
create table feature (
	feature_id bigint PRIMARY KEY,
	identifier text,
	name text,
	description text,
	xml text,
	url text,
	geom geometry
);

create table feature_hierarchy (
	child_feature_id bigint references feature(feature_id),
	parent_feature_id bigint references feature(feature_id)
);

create table related_feature (
	related_feature_id bigint  references feature(feature_id),
	feature_id bigint  references feature(feature_id),
	role text
);

create table feature_parameter (
	feature_id bigint references feature(feature_id),
	parameter_id bigint references parameter(parameter_id)
);

-- Platform
create table platform (
	platform_id bigint PRIMARY KEY,
	identifier text,
	name text,
	description text,
	properties text
);

create table platform_parameter (
	platform_Id bigint references platform(platform_id),
	parameter_id bigint references parameter(parameter_id)
);


--Value profile
create table value_profile (
	value_profile_id bigint PRIMARY KEY,
	orientation smallint,
	vertical_origin_name text,
	vertical_from_name text,
	vertical_to_name text,
	vertical_unit bigint references unit(unit_id)
);


--dataset
create table dataset (
	dataset_id bigint PRIMARY KEY,
	dataset_type text, -- 'individualObservation', 'sampling', 'timeseries', 'profile', 'trajectory', 'not_initialized'
	observation_type text, -- 'simple', 'profile', 'timeseries', 'trajectory', 'not_initialized'
	value_type text, --'quantity', 'count', 'text', 'category', 'bool', 'geometry', 'blob', 'reference', 'complex', 'dataarray', 'not_initialized'
	procedure_id bigint references procedure(procedure_id),
	phenomenon_id bigint references phenomenon(phenomenon_id),
	feature_id bigint references feature(feature_id),
	platform_id bigint references platform(platform_id),
	unit_id bigint references unit(unit_id),
	is_mobile boolean,
	is_insitu boolean,
	first_time timestamp,
	last_time timestamp,
	first_value real,
	last_value real,
	first_observation_id bigint,
	last_observation_id bigint,
	identifier text,
	name text,
	description text,
	value_profile_id bigint references value_profile(value_profile_id)
);


--Observation
create table observation (
	observation_id bigserial PRIMARY KEY,
	value_type text, --'quantity', 'count', 'text', 'category', 'bool', 'profile', 'complex', 'dataarray', 'geometry', 'blob', 'reference', 'sensorML20'
	dataset_id bigint references dataset(dataset_id),
	sampling_time_start timestamp,
	sampling_time_end timestamp,
	result_time timestamp,
	identifier TEXT,
	name TEXT,
	description TEXT,
	valid_time_start timestamp,
	valid_time_end timestamp,
	sampling_geometry geometry,
	value_identifier TEXT,
	value_name TEXT,
	value_description TEXT,
	vertical_from REAL,
	vertical_to REAL,
	parent_observation_id bigint REFERENCES observation (observation_id),
	value_quantity REAL,
	value_text TEXT,
	value_reference TEXT,
	value_count integer,
	value_boolean bool,
	value_category TEXT,
	value_geometry geometry,
	value_array text
);

create index on feature using gist (geom);
create index on observation using gist (sampling_geometry);
CREATE INDEX ON observation USING btree (dataset_id, sampling_time_start);
CREATE INDEX ON observation USING btree (sampling_time_start,dataset_id);
CREATE INDEX ON observation USING btree (dataset_id, sampling_time_end);
CREATE INDEX ON observation USING btree (sampling_time_end,dataset_id);
CREATE INDEX ON observation  USING btree (parent_observation_id);
CREATE INDEX ON observation USING btree (value_type);

