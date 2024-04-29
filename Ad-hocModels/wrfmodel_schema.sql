CREATE SCHEMA wrfmodel;

create table wrfmodel.wrfmodel (
  id integer,
  name varchar(100),
  description varchar(500)
);

CREATE TABLE wrfmodel.dailyprediction (
  wrfmodel integer,
  time date PRIMARY KEY,
  wrfmodel_coveage_path varchar(200)
);

create index on  wrfmodel.dailyprediction using btree (time);
CREATE INDEX ON wrfmodel.dailyprediction USING HASH (wrfmodel);

insert into wrfmodel.wrfmodel values 
(1, 'WRF 1km Galicia',
'WRF model operationally executed every day at 00UTC to generate numeric prediction of meteorological variables for 96 hours with a spatial resolution of 1km'
);
