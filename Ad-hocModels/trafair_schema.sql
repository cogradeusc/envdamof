drop schema if exists trafair cascade;
create schema  trafair;


-----------------------------
---- TRAFFIC
-----------------------------

CREATE TABLE trafair.road (
	name varchar(255) NOT NULL,
	PRIMARY KEY (name)
);

CREATE TABLE trafair.road_section (
	id bigint NOT NULL primary key,
	speed_limit integer NOT NULL,
	oneway bool NULL DEFAULT false,
	num_lanes integer NULL,
	type varchar(255) NOT NULL,
	name_road varchar(255) NULL references trafair.road(name),
	geom geometry(LINESTRING, 4326) NOT NULL
);

create index on trafair.road_section using gist (geom);

CREATE TABLE trafair.road_node (
	id bigint NOT NULL primary key,
	geom geometry(POINT, 4326) NOT NULL
);

create index on trafair.road_node using gist (geom);

CREATE TABLE trafair.road_segment (
	segment_number integer NOT NULL,
	node_start bigint NOT NULL references trafair.road_node(id),
	node_end bigint NOT NULL references trafair.road_node(id),
	id_road_section bigint NOT NULL references trafair.road_section(id),
	PRIMARY KEY (id_road_section, segment_number)
);

CREATE TABLE trafair.sensor_traffic (
	id varchar(255) NOT NULL primary key,
	geom geometry(POINT, 4326) NOT NULL,
	direction bool NULL DEFAULT true,
	road_section bigint NULL,
	num_segment integer NULL,
	nearest_node bigint NULL references trafair.road_node(id),
	foreign key (road_section, num_segment) references trafair.road_segment(id_road_section,segment_number)
);

create index on trafair.sensor_traffic using gist (geom);

CREATE TABLE trafair.sensor_traffic_observation (
	id_sensor_traffic varchar(255) NOT NULL references trafair.sensor_traffic(id),
	datetime timestamp NOT NULL,
	flow integer NOT NULL,
	occupancy real NULL,
	PRIMARY KEY (id_sensor_traffic, datetime)
);

create index on  trafair.sensor_traffic_observation using btree (datetime);
CREATE INDEX ON trafair.sensor_traffic_observation USING HASH (id_sensor_traffic);

CREATE TABLE trafair.road_arc (
	id integer NOT NULL primary key,
	code varchar(255) NULL unique,
	inverted bool NULL,
	geom geometry(LINESTRING, 4326) NULL
);

create index on trafair.road_arc using gist (geom);

CREATE TABLE trafair.road_arc_to_road_segment (
	id_road_section bigint NOT NULL,
	segment_number_in_road_section integer NOT NULL,
	arc integer NOT NULL references trafair.road_arc(id),
	segment_number_in_arc integer NULL,
	PRIMARY KEY (arc, id_road_section, segment_number_in_road_section),
	UNIQUE (arc, segment_number_in_arc),
	foreign key (id_road_section, segment_number_in_road_section) references trafair.road_segment(id_road_section, segment_number)
);

CREATE TABLE trafair.road_arc_traffic_flow (
	arc integer NOT NULL references trafair.road_arc(id),
	datetime timestamp NOT NULL,
	flow integer NOT NULL,
	PRIMARY KEY (arc, datetime)
);

create index on  trafair.road_arc_traffic_flow using btree (datetime);
CREATE INDEX ON trafair.road_arc_traffic_flow USING HASH (arc);


-----------------------------
---- AIR QUALITY
-----------------------------

CREATE TABLE trafair.aq_legal_station (
	id integer NOT NULL primary key,
	name varchar(255) NOT NULL,
	description text NULL,
	geom geometry(POINT, 4326) NOT NULL,
	height real NULL
);

create index on trafair.aq_legal_station using gist (geom);

CREATE TABLE trafair.aq_legal_station_observation (
	datetime timestamp NOT NULL,
	id_aq_legal_station integer NOT NULL references trafair.aq_legal_station(id),
	c6h6 real NULL,
	co real NULL,
	no real NULL,
	no2 real NULL,
	o3 real NULL,
	nox real NULL,
	PRIMARY KEY (datetime, id_aq_legal_station)
);

create index on  trafair.aq_legal_station_observation using btree (datetime);
CREATE INDEX ON trafair.aq_legal_station_observation USING HASH (id_aq_legal_station);

CREATE TABLE trafair.sensor_low_cost_feature (
	id integer NOT NULL,
	code varchar(255) NULL,
	note text NULL,
	geom geometry(POINT, 4326) NOT NULL,
	"location" varchar(255) NULL,
	id_aq_legal_station int4 NULL,
	CONSTRAINT sensor_low_cost_feature_pkey PRIMARY KEY (id),
	CONSTRAINT sensor_low_cost_feature_unique UNIQUE (code)
);

create index on trafair.sensor_low_cost_feature using gist (geom);


CREATE TABLE trafair.sensor_low_cost (
	id integer NOT NULL primary key,
	model varchar(255) NOT NULL,
	note text NULL,
	trademark varchar(255) NULL,
	sensor_box_code varchar(20) NULL
);

create type trafair.sensor_low_cost_status_type as enum (
'offline','calibration','running'
);

CREATE TABLE trafair.sensor_low_cost_status (
	id integer NOT NULL primary key,
	id_sensor_low_cost integer NULL references trafair.sensor_low_cost(id),
	id_sensor_low_cost_feature integer NULL references trafair.sensor_low_cost_feature(id),
	datetime timestamp NULL,
    operator varchar(255) NULL,
	status trafair.sensor_low_cost_status_type NULL,
	note text NULL
);

CREATE INDEX ON trafair.sensor_low_cost_status USING HASH (id_sensor_low_cost);
CREATE INDEX ON trafair.sensor_low_cost_status USING HASH (id_sensor_low_cost_feature);



CREATE TABLE trafair.sensor_raw_observation (
	datetime timestamp NOT NULL,
	id_sensor_low_cost_status integer NOT NULL references trafair.sensor_low_cost_status(id),
	battery_voltage real NULL, -- V
	humidity real NOT NULL, --%
	temperature real NOT NULL, --ºC
	no_we real NOT NULL, -- mV
	no_aux real NOT NULL, -- mV
	no2_we real NOT NULL, -- mV
	no2_aux real NOT NULL, -- mV
	ox_we real NOT NULL, -- mV
	ox_aux real NOT NULL, -- mV
	co_we real NOT NULL, -- mV
	co_aux real NOT NULL, -- mV
	co_concentration real NULL, --ug/m3
	no_concentration real NULL, --ug/m3
	no2_concentration real NULL, --ug/m3
	ox_concentration real NULL, --ug/m3
	PRIMARY KEY (id_sensor_low_cost_status, datetime)
);

create index on  trafair.sensor_raw_observation using btree (datetime);
CREATE INDEX ON trafair.sensor_raw_observation USING HASH (id_sensor_low_cost_status);


CREATE TABLE trafair.sensor_calibration_algorithm (
	id integer NOT NULL primary key,
	model_name varchar(255) NOT NULL,
	hyper_parameters varchar(255) NOT NULL,
	training_start timestamp NOT NULL,
	training_end timestamp NOT NULL,
	regression_variables varchar(255) NOT NULL,
	note text NULL,
	python_library varchar(255) NOT NULL,
	id_aq_legal_station integer NULL references trafair.aq_legal_station(id),
	info json NULL
);

CREATE TABLE trafair.sensor_calibration (
	id integer NOT NULL primary key,
	co_algorithm integer NULL references trafair.sensor_calibration_algorithm(id),
	no_algorithm integer NULL references trafair.sensor_calibration_algorithm(id),
	no2_algorithm integer NULL references trafair.sensor_calibration_algorithm(id),
	o3_algorithm integer NULL references trafair.sensor_calibration_algorithm(id),
	id_sensor_low_cost integer NULL references trafair.sensor_low_cost,
	note text NULL,
	datetime timestamp NULL
);

CREATE TABLE trafair.sensor_calibrated_observation (
	id_sensor_calibration integer NOT NULL references trafair.sensor_calibration(id),
	phenomenon_time timestamp NOT NULL,
	result_time timestamp NULL,
	no real NULL, --ug/m3
	no2 real NULL, --ug/m3
	co real NULL, --ug/m3
	o3 real NULL, --ug/m3
	co_out_of_range bool NULL, 
	no_out_of_range bool NULL,
	no2_out_of_range bool NULL,
	o3_out_of_range bool NULL,
	id_sensor_low_cost_feature integer NOT NULL references trafair.sensor_low_cost_feature(id),
	coverage real NULL,
	PRIMARY KEY (id_sensor_calibration, phenomenon_time)
);

create index on  trafair.sensor_calibrated_observation using btree (phenomenon_time);
CREATE INDEX ON trafair.sensor_calibrated_observation USING HASH (id_sensor_calibration);

create table trafair.airquality_model_output (
	result_time date
);

create table trafair.airquality_model_coverage (
	phenomenon_time TIMESTAMP,
	result_time date,
	path varchar(500)
);

create index on  trafair.airquality_model_coverage using btree (phenomenon_time);
create index on  trafair.airquality_model_coverage using btree (result_time);

