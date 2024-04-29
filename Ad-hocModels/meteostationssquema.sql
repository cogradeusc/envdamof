---------------------------------------------------------
--- Data from 2010-02-22 00:00:00 to 2010-05-27 22:20:00
---------------------------------------------------------

drop schema if exists meteostations cascade;
create schema  meteostations;

create table meteostations.granparameter (
 id integer primary key,
 code varchar(50),
 name varchar(512)
);

create table meteostations.station (
  id integer primary key,
  code varchar(50),
  name varchar(512),
  start_date date,
  end_date date,
  latitude double precision,
  longitude double precision,
  elevation real
);

create index on meteostations.station using gist (st_setsrid(st_makepoint(longitude, latitude),4326));

create table meteostations.parameter (
  id integer primary key,
  code varchar(50),
  name varchar(512),
  unit varchar(50),
  granparameter integer references meteostations.granparameter(id)
);

create table meteostations.sensor (
	id integer primary key,
	description varchar(512),
	height real,
	start_date date,
	end_date date,
	station integer references meteostations.station(id)
);

create table meteostations.interval(
	id integer primary key,
	minutes integer,
	description varchar(512)
);

create table meteostations.measurement (
	id integer primary key,
	name varchar(512),
	mode varchar(255),
	parameter integer references meteostations.parameter(id),
	sensor integer references meteostations.sensor(id),
	interval integer references meteostations.interval(id)
);

CREATE INDEX ON meteostations.measurement USING HASH (parameter);
CREATE INDEX ON meteostations.measurement USING HASH (sensor);


create table meteostations.validationcodes(
	id integer primary key,
	description varchar(512)
);

create table meteostations.tenminutesdata (
	measurement integer references meteostations.measurement (id),
	time timestamp,
	value real,
	validationcode integer references meteostations.validationcodes(id),
	primary key (measurement, time)
);

create index on  meteostations.tenminutesdata using btree (time);
CREATE INDEX ON meteostations.tenminutesdata USING HASH (measurement);

create table meteostations.dailydata (
	measurement integer references meteostations.measurement (id),
	time timestamp,
	value real,
	validationcode integer references meteostations.validationcodes(id),
	primary key (measurement, time)
);

create index on  meteostations.dailydata using btree (time);
CREATE INDEX ON meteostations.dailydata USING HASH (measurement);

create table meteostations.monthlydata (
	measurement integer references meteostations.measurement (id),
	time timestamp,
	value real,
	validationcode integer references meteostations.validationcodes(id),
	primary key (measurement, time)
);

create index on  meteostations.monthlydata using btree (time);
CREATE INDEX ON meteostations.monthlydata USING HASH (measurement);



