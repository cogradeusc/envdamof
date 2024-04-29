
DROP SCHEMA IF EXISTS omcatalog CASCADE;
CREATE SCHEMA omcatalog;

create table omcatalog.vocabulary (
	name text primary key,
	language text
);

insert into omcatalog.vocabulary values 
('castellano','es'),
('english','en'),
('galego','gl'),
('cf_standard_names', 'en');

create table omcatalog.enumeration_type(
	name text primary key,
	values json,
	names json
);

-- example of JSON for values
/*
[{"vocabulary":"...",
  "values":[...]
},
{"vocabulary":"...",
  "values":[...]
},
...
]
*/

-- example of JSON for names
/*
[{
	"vocabulary": "...",
	"term": "..."
},{
	"vocabulary": "...",
	"term": "..."
},
...
]
*/

CREATE TABLE omcatalog.complex_type (
	name text primary key,
	type_fields json,
	names json
);

CREATE TABLE omcatalog.feature_type (
	name text primary key,
	subtypes json,
	feature_properties json,
	feature_references json,
	names json
);

CREATE TABLE omcatalog.spatial_sampling_feature_type (
	name text primary key references omcatalog.feature_type(name),
	sampled_feature_type text references omcatalog.feature_type(name),
	shape_crs text,
	vertical_crs text
);

CREATE TABLE omcatalog.specimen_feature_type (
	name text primary key references omcatalog.feature_type(name),
	sampled_feature_type text references omcatalog.feature_type(name),
	sampling_location_type text references omcatalog.spatial_sampling_feature_type(name)
);


CREATE TABLE omcatalog.sampling_process_type (
	name text primary key references omcatalog.feature_type(name),
	sampling_feature_type text references omcatalog.specimen_feature_type(name)
);



CREATE TABLE omcatalog.process_type (
	name text primary key references omcatalog.feature_type(name),
	observationType text,
	platform_type text references omcatalog.feature_type(name),
	feature_of_interest_type text references omcatalog.feature_type(name),
	observed_properties json
);
-- Example of JSON for properties, observed properties and fields
/*
[{
	"name":"name of the property",
	"data_type":"data type of the property",
	"repeated":false,
	"names":[{
		"vocabulary": "...",
		"term": "..."
	},{
		"vocabulary": "...",
		"term": "..."
	}
	...
	]
},
...
]

*/

-- Example of JSON for references
/*
[{
	"name":"name of the property",
	"repeated":false,
	"referenced_type": "name of the referenced type",
	"names":[{
		"vocabulary": "...",
		"term": "..."
	},{
		"vocabulary": "...",
		"term": "..."
	}
	...
	]
},
...
]

*/


