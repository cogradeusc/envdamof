drop schema if exists envdamof_traffic cascade;

CREATE SCHEMA envdamof_traffic;

-------------------------------------
---------- FEATURE TYPES ------------
-------------------------------------

CREATE TABLE envdamof_traffic.road (
	fid integer PRIMARY key,
	name text
);

-- Template table for a abstract_road_section: road_section
create table envdamof_traffic.road_section (
	fid bigint PRIMARY key,
	geo geometry(LINESTRING,4326), -- replace for a more specific one if needed
	speed_limit integer,
	oneway boolean,
	num_lanes integer,
	TYPE TEXT,
	road integer REFERENCES envdamof_traffic.road(fid)
);

create index on envdamof_traffic.road_section using gist (geo);

-- Template table for a AbstractRoadSection: road_arc
create table envdamof_traffic.road_arc (
	fid integer PRIMARY key,
	geo geometry(LINESTRING,4326), -- replace for a more specific one if needed
	code text,
	inverted boolean
);

create index on envdamof_traffic.road_arc using gist (geo);

CREATE TABLE envdamof_traffic.road_node (
	fid bigint PRIMARY key,
	geo geometry(POINT,4326)
);

create index on envdamof_traffic.road_node using gist (geo);

CREATE TABLE envdamof_traffic.road_segment (
	fid bigint PRIMARY key,
	segment_number integer,
	road_section bigint REFERENCES envdamof_traffic.road_section(fid),
	node_start bigint REFERENCES envdamof_traffic.road_node(fid),
	node_end bigint REFERENCES envdamof_traffic.road_node(fid)
);

----------------------------------------------------------------
---------- SAMPLING FEATURE TYPES AND PROCESS TYPES ------------
----------------------------------------------------------------

--Template table for a AbstractTrafficStation: sensor_traffic
--Template table for a AbstractTrafficPointObservationProcess: sensor_traffic
create table envdamof_traffic.sensor_traffic (
	fid integer,
	shape geometry(POINT,4326), -- replace this field for more specific geometry data types
	sampled_feature bigint references envdamof_traffic.road_section(fid), --add foreign key for relevant feature type
	valid_time_start timestamp,
	valid_time_end timestamp,
	--platform integer references traffic_station(fid) -- replace by more specific ref. references the same tuple, thus it is not needed
	id TEXT,
	direction boolean,
	road_segment bigint REFERENCES envdamof_traffic.road_segment(fid),
	nearest_node bigint REFERENCES envdamof_traffic.road_node(fid)
);

create index on envdamof_traffic.sensor_traffic using gist (shape);
CREATE INDEX ON envdamof_traffic.sensor_traffic  USING btree (fid);

-------------------------------------
---------- PROCESS TYPES ------------
-------------------------------------

--Template table for a AbstractTrafficSpatialModel: traffic_flow_model
create table envdamof_traffic.traffic_flow_model (
	fid integer, -- same fid may be repeated, but not overlapping in valid time is allowed for same fid
	valid_time_start timestamp,
	valid_time_end timestamp,
	description text
);

CREATE INDEX ON envdamof_traffic.traffic_flow_model  USING btree (fid);
-----------------------------------------
---------- OBSERVATION TYPES ------------
-----------------------------------------


--Template table for an AbstractTrafficPointObservation: sensor_traffic_observation
create table envdamof_traffic.sensor_traffic_observation (
	procedure integer, 
	feature_of_interest integer, --references envdamof_traffic.sensor_traffic(fid), It is a process, thus we cannot add directly this reference
	phenomenon_time timestamp,
	result_time timestamp,
	flow REAL,
	occupancy real
);


create index on  envdamof_traffic.sensor_traffic_observation using btree (phenomenon_time);
create index on envdamof_traffic.sensor_traffic_observation using btree (result_time);
CREATE INDEX ON envdamof_traffic.sensor_traffic_observation USING btree (procedure);
CREATE INDEX ON envdamof_traffic.sensor_traffic_observation USING btree (feature_of_interest);

--Template table for a AbstractTrafficSpatialModelOutput: traffic_flow_model_output
create table envdamof_traffic.traffic_flow_model_output (
	procedure integer, 
	feature_of_interest integer references envdamof_traffic.road_arc(fid),
	phenomenon_time timestamp,
	result_time timestamp,
	flow real
);

create index on  envdamof_traffic.traffic_flow_model_output using btree (phenomenon_time);
create index on envdamof_traffic.traffic_flow_model_output using btree (result_time);
CREATE INDEX ON envdamof_traffic.traffic_flow_model_output USING btree (procedure);
CREATE INDEX ON envdamof_traffic.traffic_flow_model_output USING btree (feature_of_interest);

-----------------------------------------
-------- CATALOG
------------------------------------------

-- USER DEFINED TYPES

--Delete the types if they EXIST


-- FEATURE TYPES

-- Delete feature types if they EXIST

delete from omcatalog.process_type
where name IN
(
'envdamof_traffic.sensor_traffic',
'envdamof_traffic.traffic_flow_model'
); 

delete from omcatalog.spatial_sampling_feature_type
where name = 'envdamof_traffic.sensor_traffic'; 

delete from omcatalog.feature_type
where name IN
   (
   'envdamof_traffic.sensor_traffic',
   'envdamof_traffic.traffic_flow_model',
   'envdamof_traffic.road',
   'envdamof_traffic.road_section',
	'envdamof_traffic.road_arc',
	'envdamof_traffic.road_node',
	'envdamof_traffic.road_segment'
   );


INSERT INTO omcatalog.feature_type values
('envdamof_traffic.road', 
'["feature_type"]',
'[{
	"name":"name",
	"data_type":"text",
	"repeated":false
}
]',
null,
null
),
('envdamof_traffic.road_section', 
'["tf_road_section"]',
'[{
	"name":"geo",
	"data_type":"geometry(LINESTRING,4326)",
	"repeated":false
},
{
	"name":"speed_limit",
	"data_type":"integer",
	"repeated":false
},
{
	"name":"oneway",
	"data_type":"boolean",
	"repeated":false
},
{
	"name":"num_lanes",
	"data_type":"integer",
	"repeated":false
},
{
	"name":"type",
	"data_type":"text",
	"repeated":false
}
]',
'[{
	"name":"road",
	"repeated":false,
	"referenced_type": "envdamof_traffic.road"
}
]',
null
),
('envdamof_traffic.road_arc', 
'["tf_road_section"]',
'[{
	"name":"geo",
	"data_type":"geometry(LINESTRING,4326)",
	"repeated":false
},
{
	"name":"code",
	"data_type":"text",
	"repeated":false
},
{
	"name":"inverted",
	"data_type":"boolean",
	"repeated":false
}
]',
null,
null
),
('envdamof_traffic.road_node', 
'["feature_type"]',
'[{
	"name":"geo",
	"data_type":"geometry(LINESTRING,4326)",
	"repeated":false
}
]',
null,
null
),
('envdamof_traffic.road_segment', 
'["tf_road_section"]',
'[{
	"name":"segment_number",
	"data_type":"integer",
	"repeated":false
}
]',
'[{
	"name":"road_section",
	"repeated":false,
	"referenced_type": "envdamof_traffic.road_section"
},
{
	"name":"node_start",
	"repeated":false,
	"referenced_type": "envdamof_traffic.road_node"
},
{
	"name":"node_end",
	"repeated":false,
	"referenced_type": "envdamof_traffic.road_node"
}
]',
null
),
('envdamof_traffic.sensor_traffic', 
'["tf_station","tf_point_observation_process"]',
'[{
	"name":"id",
	"data_type":"text",
	"repeated":false
},
{
	"name":"direction",
	"data_type":"boolean",
	"repeated":false
}
]',
'[{
	"name":"road_segment",
	"repeated":false,
	"referenced_type": "envdamof_traffic.road_segment"
},
{
	"name":"nearest_node",
	"repeated":false,
	"referenced_type": "envdamof_traffic.road_node"
}
]',
null
),
('envdamof_traffic.traffic_flow_model', 
'["tf_spatial_model"]',
'[{
	"name":"description",
	"data_type":"text",
	"repeated":false
}
]',
null,
null
);


-- SAMPLING FEATURE TYPES

INSERT INTO omcatalog.spatial_sampling_feature_type VALUES (
	'envdamof_traffic.sensor_traffic',
	'envdamof_traffic.road_section',
	'epsg:4326',
	null
);

-- PROCESS TYPES

INSERT INTO omcatalog.process_type VALUES (
	'envdamof_traffic.sensor_traffic',
	'envdamof_traffic.sensor_traffic_observation',
	'envdamof_traffic.sensor_traffic',
	'envdamof_traffic.sensor_traffic',
	'[{
		"name":"flow",
		"data_type": "measure(vehicles/hour)",
		"repeated":false
	},
	{
		"name":"occupancy",
		"data_type": "measure(%)",
		"repeated":false
	}
	]'
),
(
	'envdamof_traffic.traffic_flow_model',
	'envdamof_traffic.traffic_flow_model_output',
     null,
	'envdamof_traffic.road_arc',
	'[{
		"name":"flow",
		"data_type": "measure(vehicles/hour)",
		"repeated":false
	}]'
);