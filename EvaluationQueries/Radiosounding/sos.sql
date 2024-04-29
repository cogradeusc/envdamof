-----------------------------------
--- Query Subsamples (1 Property)
-----------------------------------

-- Base query

select o.result_time, o.sampling_time_start, o.vertical_from, o.value_quantity as temperature, 
                      p.procedure_id as process, p.name as name, o.sampling_geometry as sampling_geometry
from sos_radiosounding.observation o, sos_radiosounding.dataset d, sos_radiosounding.phenomenon ph,
	 sos_radiosounding.procedure p, sos_radiosounding.feature f 
where o.dataset_id = d.dataset_id and d.procedure_id = p.procedure_id and d.phenomenon_id = ph.phenomenon_id 
  and d.feature_id = f.feature_id 
  and ph.identifier = 'radiosounding_process-temperature'
  and o.parent_observation_id is not null


-- time period filter

 and o.sampling_time_start >= '%s' and o.sampling_time_start <= '%s'
  
-- Spatial Range filter

	and st_intersects(o.sampling_geometry, st_makeenvelope(%s, %s, %s, %s, 4326))  

-- Height Range filter

 AND o.vertical_from >= %s AND o.vertical_from <= %s
 
	 
	 
-----------------------------------
--- Query Subsamples (2 Properties)
-----------------------------------
-- Base query

select ot.result_time, ot.sampling_time_start, ot.vertical_from, ot.value_quantity as temperature, oh.value_quantity as humidity,
       p.procedure_id as process, p.name as name, ot.sampling_geometry as sampling_geometry
from sos_radiosounding.observation ot, sos_radiosounding.dataset dt, sos_radiosounding.phenomenon pht,
   sos_radiosounding.observation oh, sos_radiosounding.dataset dh, sos_radiosounding.phenomenon phh,
 sos_radiosounding.procedure p, sos_radiosounding.feature f 
where ot.dataset_id = dt.dataset_id and dt.procedure_id = p.procedure_id and dt.phenomenon_id = pht.phenomenon_id
	and dt.feature_id = f.feature_id 
	and pht.identifier = 'radiosounding_process-temperature'
	and ot.parent_observation_id is not null
	and oh.dataset_id = dh.dataset_id and dh.procedure_id = p.procedure_id and dh.phenomenon_id = phh.phenomenon_id
	and dh.feature_id = f.feature_id 
	and phh.identifier = 'radiosounding_process-humidity'
	and oh.parent_observation_id is not null
	and ot.sampling_time_start = oh.sampling_time_start 


-- time period filter

	 and ot.sampling_time_start >= '%s' and ot.sampling_time_start <= '%s'
  
-- Spatial Range filter

	and st_intersects(ot.sampling_geometry, st_makeenvelope(%s, %s, %s, %s, 4326))


-- Height Range filter

	AND ot.vertical_from >= %s AND ot.vertical_from <= %s
 

--------------------------------------
--- Query Trajectory (All Properties)
--------------------------------------


select ot.result_time,
	   ot.sampling_time_start, ot.vertical_from, ot.value_quantity as temperature, oh.value_quantity as humidity,
	   op.value_quantity AS pressure, od.value_quantity AS dew_point_temperature, owd.value_quantity AS wind_direction,
	   ows.value_quantity AS wind_speed,
	   p.procedure_id as process, p.name as name, ot.sampling_geometry as sampling_geometry
from sos_radiosounding.observation ot, sos_radiosounding.dataset dt, sos_radiosounding.phenomenon pht,
   sos_radiosounding.observation oh, sos_radiosounding.dataset dh, sos_radiosounding.phenomenon phh,
   sos_radiosounding.observation op, sos_radiosounding.dataset dp, sos_radiosounding.phenomenon php,
   sos_radiosounding.observation od, sos_radiosounding.dataset dd, sos_radiosounding.phenomenon phd,
   sos_radiosounding.observation owd, sos_radiosounding.dataset dwd, sos_radiosounding.phenomenon phwd,
   sos_radiosounding.observation ows, sos_radiosounding.dataset dws, sos_radiosounding.phenomenon phws,
   sos_radiosounding.procedure p, sos_radiosounding.feature f,
   sos_radiosounding.observation ph
where ot.dataset_id = dt.dataset_id and dt.procedure_id = p.procedure_id and dt.phenomenon_id = pht.phenomenon_id
	and dt.feature_id = f.feature_id 
	and pht.identifier = 'radiosounding_process-temperature'
	and ot.parent_observation_id is not null
	and oh.dataset_id = dh.dataset_id and dh.procedure_id = p.procedure_id and dh.phenomenon_id = phh.phenomenon_id
	and dh.feature_id = f.feature_id 
	and phh.identifier = 'radiosounding_process-humidity'
	and oh.parent_observation_id is not NULL
	and op.dataset_id = dp.dataset_id and dp.procedure_id = p.procedure_id and dp.phenomenon_id = php.phenomenon_id
	and dp.feature_id = f.feature_id 
	and php.identifier = 'radiosounding_process-pressure'
	and op.parent_observation_id is not NULL
	and od.dataset_id = dd.dataset_id and dd.procedure_id = p.procedure_id and dd.phenomenon_id = phd.phenomenon_id
	and dd.feature_id = f.feature_id 
	and phd.identifier = 'radiosounding_process-dew_point_temperature'
	and od.parent_observation_id is not NULL
	and owd.dataset_id = dwd.dataset_id and dwd.procedure_id = p.procedure_id and dwd.phenomenon_id = phwd.phenomenon_id
	and dwd.feature_id = f.feature_id 
	and phwd.identifier = 'radiosounding_process-wind_direction'
	and owd.parent_observation_id is not NULL
	and ows.dataset_id = dws.dataset_id and dws.procedure_id = p.procedure_id and dws.phenomenon_id = phws.phenomenon_id
	and dws.feature_id = f.feature_id 
	and phws.identifier = 'radiosounding_process-wind_speed'
	and ows.parent_observation_id is not NULL
	and ot.sampling_time_start = oh.sampling_time_start 
	and ot.sampling_time_start = op.sampling_time_start 
	and ot.sampling_time_start = od.sampling_time_start 
	and ot.sampling_time_start = owd.sampling_time_start 
	and ot.sampling_time_start = ows.sampling_time_start
	AND ot.parent_observation_id = ph.observation_id 
	AND ph.sampling_time_start <= '%s' AND ph.sampling_time_start >= '%s'
	AND st_intersects(f.geom, st_makeenvelope(%s,%s, %s, %s, 4326))