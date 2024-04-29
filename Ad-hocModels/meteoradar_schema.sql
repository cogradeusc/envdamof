CREATE SCHEMA meteoradar;

create table meteoradar.radar (
  id integer,
  name varchar(100),
  description varchar(500),
  latitude real,
  longitude real,
  elevation real
);

CREATE TABLE meteoradar.dailyobservations (
  radar integer,
  time date PRIMARY KEY,
  radar_coveage_path varchar(200)
);

create index on meteoradar.dailyobservations using btree (time);
CREATE INDEX ON meteoradar.dailyobservations USING HASH (radar);

insert into meteoradar.radar values 
(1, 'Monte Xesteiras',
'Radar property of MeteoGalicia. Radar doppler with dual polarization with emission in the 4-8 GHz band',
42.675560812910724, -8.58618090039684,
750
);

