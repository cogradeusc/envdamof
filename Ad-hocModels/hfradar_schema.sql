create schema hfradar;


create table hfradar.radar_antenna (
  id varchar(100),
  name varchar (500),
  citation text,
  summary text,
  rights text,
  version text,
  creator text
);

insert into hfradar.radar_antenna values 
('HFR-Galicia-PRIO', --id
 'HFR-Galicia-PRIO', --name
 'These data were collected and made freely available by the Copernicus project and the programs that contribute to it. Data collected and processed by INTECMAR-Xunta de Galicia in collaboration with Puertos del Estado and Instituto Hidrografico within Observatorio RAIA and MyCoast projects',--citation
  'The dataset consists of maps of radial velocity of the surface current along the Galician coast (North Western Spain) averaged over a time interval of 1 hour around the cardinal hour. HF-RADAR measurements of ocean velocity are radial in direction relative to the radar location and representative of the upper 0.3 - 2.5 meters of the ocean. The radar sites are operated according to Quality Assessment procedures and data are processed for Quality Control. Data access tools are compliant to Open Geospatial Consortium (OGC), Climate and Forecast (CF) convention and INSPIRE directive. The use of netCDF format allows an easy implementation of all the open source services developed by UNIDATA. The v2.1 dataset complies with the European common data and metadata model for real-time HFR data, with CMEMS-INSTAC and SeaDataCloud CF extension requirements. The v2.1.1 dataset implements data packing for geophysical variables. The v2.1.2 dataset names the depth dimension as DEPTH. The v2.2 dataset complies with the Copernicus-InSituTAC-FormatManual-1.4.',--summary 
  'The dataset is licensed under a Creative Commons Attribution 4.0',--rights 
  'v2.2 - CF-1.6 Copernicus-InSituTAC-FormatManual-1.4 Copernicus-InSituTAC-SRD-1.41 Copernicus-InSituTAC-ParametersList-3.2.0 compliant',--version 
  'Instituto Tecnoloxico para o Control do Medio-Marino de Galicia'--creator 
 ),
 
('HFR-Galicia-SILL', --id
 'HFR-Galicia-SILL', --name
 'These data were collected and made freely available by the Copernicus project and the programs that contribute to it. Data collected and processed by INTECMAR-Xunta de Galicia in collaboration with Puertos del Estado and Instituto Hidrografico within Observatorio RAIA and MyCoast projects',--citation
  'The dataset consists of maps of radial velocity of the surface current along the Galician coast (North Western Spain) averaged over a time interval of 1 hour around the cardinal hour. HF-RADAR measurements of ocean velocity are radial in direction relative to the radar location and representative of the upper 0.3 - 2.5 meters of the ocean. The radar sites are operated according to Quality Assessment procedures and data are processed for Quality Control. Data access tools are compliant to Open Geospatial Consortium (OGC), Climate and Forecast (CF) convention and INSPIRE directive. The use of netCDF format allows an easy implementation of all the open source services developed by UNIDATA. The v2.1 dataset complies with the European common data and metadata model for real-time HFR data, with CMEMS-INSTAC and SeaDataCloud CF extension requirements. The v2.1.1 dataset implements data packing for geophysical variables. The v2.1.2 dataset names the depth dimension as DEPTH. The v2.2 dataset complies with the Copernicus-InSituTAC-FormatManual-1.4.',--summary 
  'The dataset is licensed under a Creative Commons Attribution 4.0',--rights 
  'v2.2 - CF-1.6 Copernicus-InSituTAC-FormatManual-1.4 Copernicus-InSituTAC-SRD-1.41 Copernicus-InSituTAC-ParametersList-3.2.0 compliant',--version 
  'Instituto Tecnoloxico para o Control do Medio-Marino de Galicia'--creator 
 ),
 
('HFR-Galicia-VILA', --id
 'HFR-Galicia-VILA', --name
 'These data were collected and made freely available by the Copernicus project and the programs that contribute to it. Data collected and processed by INTECMAR-Xunta de Galicia in collaboration with Puertos del Estado and Instituto Hidrografico within Observatorio RAIA and MyCoast projects',--citation
  'The dataset consists of maps of radial velocity of the surface current along the Galician coast (North Western Spain) averaged over a time interval of 1 hour around the cardinal hour. HF-RADAR measurements of ocean velocity are radial in direction relative to the radar location and representative of the upper 0.3 - 2.5 meters of the ocean. The radar sites are operated according to Quality Assessment procedures and data are processed for Quality Control. Data access tools are compliant to Open Geospatial Consortium (OGC), Climate and Forecast (CF) convention and INSPIRE directive. The use of netCDF format allows an easy implementation of all the open source services developed by UNIDATA. The v2.1 dataset complies with the European common data and metadata model for real-time HFR data, with CMEMS-INSTAC and SeaDataCloud CF extension requirements. The v2.1.1 dataset implements data packing for geophysical variables. The v2.1.2 dataset names the depth dimension as DEPTH. The v2.2 dataset complies with the Copernicus-InSituTAC-FormatManual-1.4.',--summary 
  'The dataset is licensed under a Creative Commons Attribution 4.0',--rights 
  'v2.2 - CF-1.6 Copernicus-InSituTAC-FormatManual-1.4 Copernicus-InSituTAC-SRD-1.41 Copernicus-InSituTAC-ParametersList-3.2.0 compliant',--version 
  'Instituto Tecnoloxico para o Control do Medio-Marino de Galicia'--creator 
 ), 

('HFR-Galicia-LPRO', --id
 'HFR-Galicia-LPRO', --name
 'These data were collected and made freely available by the Copernicus project and the programs that contribute to it. Data collected and processed by INTECMAR-Xunta de Galicia in collaboration with Puertos del Estado and Instituto Hidrografico within Observatorio RAIA and MyCoast projects',--citation
  'The dataset consists of maps of radial velocity of the surface current along the Galician coast (North Western Spain) averaged over a time interval of 1 hour around the cardinal hour. HF-RADAR measurements of ocean velocity are radial in direction relative to the radar location and representative of the upper 0.3 - 2.5 meters of the ocean. The radar sites are operated according to Quality Assessment procedures and data are processed for Quality Control. Data access tools are compliant to Open Geospatial Consortium (OGC), Climate and Forecast (CF) convention and INSPIRE directive. The use of netCDF format allows an easy implementation of all the open source services developed by UNIDATA. The v2.1 dataset complies with the European common data and metadata model for real-time HFR data, with CMEMS-INSTAC and SeaDataCloud CF extension requirements. The v2.1.1 dataset implements data packing for geophysical variables. The v2.1.2 dataset names the depth dimension as DEPTH. The v2.2 dataset complies with the Copernicus-InSituTAC-FormatManual-1.4.',--summary 
  'The dataset is licensed under a Creative Commons Attribution 4.0',--rights 
  'v2.2 - CF-1.6 Copernicus-InSituTAC-FormatManual-1.4 Copernicus-InSituTAC-SRD-1.41 Copernicus-InSituTAC-ParametersList-3.2.0 compliant',--version 
  'Instituto Tecnoloxico para o Control do Medio-Marino de Galicia'--creator 
 );
 
 
 create table hfradar.combine (
  id varchar(100),
  name varchar (500),
  citation text,
  summary text,
  rights text,
  version text,
  creator text
);

insert into hfradar.combine values 
('HFR-Galicia-Total', --id
 'HFR-Galicia-Total', --name
 'These data were collected and made freely available by the Copernicus project and the programs that contribute to it. Data collected and processed by INTECMAR-Xunta de Galicia in collaboration with Puertos del Estado and Instituto Hidrografico within Observatorio RAIA and MyCoast projects.',--citation
  'The dataset consists of maps of total velocity of the surface current along the Galician coast (North Western Spain) averaged over a time interval of 1 hour around the cardinal hour. HF-RADAR measurements of ocean velocity are representative of the upper 0.3 - 2.5 meters of the ocean. The radar sites are operated according to Quality Assessment procedures and data are processed for Quality Control. Data access tools are compliant to Open Geospatial Consortium (OGC), Climate and Forecast (CF) convention and INSPIRE directive. The use of netCDF format allows an easy implementation of all the open source services developed by UNIDATA. The v2.1 dataset complies with the European common data and metadata model for real-time HFR data, with CMEMS-INSTAC and SeaDataCloud CF extension requirements. The v2.1.1 dataset implements data packing for geophysical variables. The v2.1.2 dataset names the depth dimension as DEPTH. The v2.2 dataset complies with the Copernicus-InSituTAC-FormatManual-1.4',--summary 
  'The dataset is licensed under a Creative Commons Attribution 4.0',--rights 
  'v2.2 - CF-1.6 Copernicus-InSituTAC-FormatManual-1.4 Copernicus-InSituTAC-SRD-1.41 Copernicus-InSituTAC-ParametersList-3.2.0 compliant',--version 
  'Instituto Tecnoloxico para o Control do Medio-Marino de Galicia'--creator 
 );
 
 CREATE TABLE hfradar.radarhourlyobservations (
  radar varchar(100),
  time timestamp,
  radial_coverage_path varchar(200)
);

create index on  hfradar.radarhourlyobservations using btree (time);
CREATE INDEX ON hfradar.radarhourlyobservations USING HASH (radar);

CREATE TABLE hfradar.totalhourlyobservations (
  combine varchar(100),
  time timestamp,
  total_coverage_path varchar(200)
);

create index on  hfradar.totalhourlyobservations using btree (time);
CREATE INDEX ON hfradar.totalhourlyobservations USING HASH (combine);



 
 