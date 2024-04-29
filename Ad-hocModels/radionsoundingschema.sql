---------------------------------------------------------
--- Data of 2010, starting in february
---------------------------------------------------------

drop schema if exists radiosounding cascade;
create schema  radiosounding;

create table radiosounding.station (
	id integer primary key,
	name varchar(512),
	latitude real,
	longitude real,
	height real
);

insert into radiosounding.station values (
 1,
 'MeteoGalicia',
 42.8864,
 -8.5212,
  287
);

create table radiosounding.sounding(
	station integer references radiosounding.station(id),
	id integer,
	time timestamp,
	primary key (station, id)
);

create table radiosounding.measure(
	station integer,
	sounding integer,
	id integer,
	time timestamp,
	latitude real,
	longitude real,
	height real,
	pressure real,
	temperature real,
	dew_point_temperature real,
	humidity real,
	wind_direction real,
	wind_speed real,
	foreign key (station,sounding) references radiosounding.sounding (station, id),
	primary key (station, sounding, id)
);

create index on radiosounding.measure using btree (time);
create index on radiosounding.measure using gist (st_setsrid(st_makepoint(longitude, latitude),4326));
