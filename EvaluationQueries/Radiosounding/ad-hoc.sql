-----------------------------------
--- Query Subsamples (1 Property)
-----------------------------------
--Base query
select m.time as result_time, m.time as phenomenon_time, m.height as height, m.temperature as temperature, 
      s.id as process, s.name as name, st_setsrid(st_makepoint(s.longitude,s.latitude),4326) as sampling_geometry
from radiosounding.measure m, radiosounding.station s 
where m.station = s.id 


-- time period filter

  and m.time >= '%s' and m.time <= '%s'
    
-- Spatial Range filter

 and st_intersects(st_setsrid(st_makepoint(m.longitude,m.latitude),4326) , st_makeenvelope(%s, %s, %s, %s, 4326))
  

-- Height Range filter

  AND m.height >= %s AND m.height <= %s 
  
  
  
-----------------------------------
--- Query Subsamples (2 Properties)
-----------------------------------

-- Base query

select m.time as result_time, m.time as phenomenon_time, m.height as height, m.temperature as temperature, m.humidity as humidity,
       s.id as process, s.name as name, st_setsrid(st_makepoint(s.longitude,s.latitude),4326) as sampling_geometry
from radiosounding.measure m, radiosounding.station s 
where m.station = s.id 

-- time period filter

  and m.time >= '%s' and m.time <= '%s'
    
-- Spatial Range filter

 and st_intersects(st_setsrid(st_makepoint(m.longitude,m.latitude),4326) , st_makeenvelope(%s, %s, %s, %s, 4326))
  

-- Height Range filter

  AND m.height >= %s AND m.height <= %s 
  
  
  

--------------------------------------
--- Query Trajectory (All Properties)
--------------------------------------

SELECT m.time as result_time, 
	   m.time as phenomenon_time, m.height as height, m.temperature as temperature, m.humidity as humidity,
	  m.pressure, m.dew_point_temperature, m.wind_direction, m.wind_speed,
	   s.id as process, s.name as name, st_setsrid(st_makepoint(m.longitude,m.latitude),4326) as sampling_geometry
from radiosounding.measure m, 
	(SELECT so.id, so.station, 
			min(m.time) AS phenomenon_time_start,
			max(m.time) AS phenomenon_time_end,
			st_makeline(st_setsrid(st_makepoint(m.longitude,m.latitude),4326) ORDER BY m.id) AS shape
	 FROM radiosounding.sounding so, radiosounding.measure m
	 WHERE m.station=so.station and m.sounding=so.id
	 GROUP BY so.id, so.station) as so, 
	radiosounding.station s 
where m.station = so.station 
	 and m.sounding = so.id
	 AND so.station = s.id 
	 AND so.phenomenon_time_start <= '%s' AND so.phenomenon_time_end >= '%s'
	 AND st_intersects(so.shape, st_makeenvelope(%s, %s, %s, %s, 4326))