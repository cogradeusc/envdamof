DROP SCHEMA IF EXISTS ctdcampaigns cascade;
CREATE SCHEMA ctdcampaigns;

CREATE TABLE ctdcampaigns.estuary (
	id integer PRIMARY KEY,
	shortname varchar(100),
	name varchar(500),
	zone varchar(500)
);

CREATE TABLE ctdcampaigns.station (
	id integer PRIMARY KEY,
	code char(5),
	name varchar(500),
	description TEXT,
	lat REAL,
	lon REAL,
	DEPTH REAL,
	starttime timestamp,
	endtime timestamp,
	estuary integer REFERENCES ctdcampaigns.estuary(id)
);

create index on ctdcampaigns.station using gist (st_setsrid(st_makepoint(lon, lat),4326));

CREATE TABLE ctdcampaigns.ctddevice (
	id integer PRIMARY KEY,
	name varchar(500),
	starttime timestamp,
	endtime timestamp
);

CREATE TABLE ctdcampaigns.sensor (
	id integer PRIMARY KEY,
	code varchar(10),
	ctddevice integer REFERENCES ctdcampaigns.ctddevice (id)
);

CREATE TABLE ctdcampaigns.campaign (
	id integer PRIMARY KEY,
	starttime timestamp,
	ship varchar(500),
	COMMENTS text
);

CREATE TABLE ctdcampaigns.profile (
	id integer PRIMARY KEY,
	time timestamp,
	campaign integer REFERENCES ctdcampaigns.campaign (id),
	station integer REFERENCES ctdcampaigns.station (id),
	ctddevice integer REFERENCES ctdcampaigns.ctddevice(id)
);

create index on  ctdcampaigns.profile using btree (time);

CREATE TABLE ctdcampaigns.PARAMETER (
	id integer PRIMARY key,
	name varchar(500),
	unit varchar(30),
	description TEXT,
	max REAL,
	min REAL,
	DERIVED boolean
);

CREATE TABLE ctdcampaigns.measurement (
	id integer PRIMARY KEY,
	profile integer REFERENCES ctdcampaigns.profile (id),
	PARAMETER integer REFERENCES ctdcampaigns.parameter(id)
);

CREATE INDEX ON ctdcampaigns.measurement USING HASH (PARAMETER);
CREATE INDEX ON ctdcampaigns.measurement USING HASH (profile);

CREATE TABLE ctdcampaigns.validationflag (
	id integer PRIMARY key,
	description text
);

CREATE TABLE ctdcampaigns.DATA (
	id integer PRIMARY key,
	scan integer,
	value REAL,
	measurement integer references ctdcampaigns.measurement(id),
	flag integer REFERENCES ctdcampaigns.validationflag(id)
);

CREATE INDEX ON ctdcampaigns.DATA USING HASH (measurement);
