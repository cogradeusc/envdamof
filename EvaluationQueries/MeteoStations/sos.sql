-------------------------------------------
--- wind_10minutes_process (1 Property)
-------------------------------------------

-- Base query

SELECT o.result_time, o.sampling_time_start AS phenomenon_time, o.value_quantity AS wind_speed,
               p.procedure_id AS process, f.feature_id AS feature, f.name AS station_name, f.geom AS feature_shape
FROM sos_meteostation.observation o, sos_meteostation.dataset d, sos_meteostation.phenomenon ph,
	 sos_meteostation.feature f, sos_meteostation.procedure p
WHERE o.dataset_id = d.dataset_id AND d.feature_id = f.feature_id AND d.phenomenon_id = ph.phenomenon_id 
  AND d.procedure_id = p.procedure_id 
  AND ph.identifier = 'wind_10minutes_process-wind_speed'

-- time instant filter

	AND o.sampling_time_start = '%s'
	
-- time period filter

 AND o.sampling_time_start >= '%s' AND o.sampling_time_start <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.geom, st_makeenvelope(%s, %s, %s, %s, 4326))  

-- Spatial Point filter

	AND f.feature_id = %s
 
	 
	 
-------------------------------------------
--- wind_10minutes_process  (2 Properties)
-------------------------------------------

-- Base query

SELECT os.result_time, os.sampling_time_start AS phenomenon_time, os.value_quantity AS wind_speed, od.value_quantity AS wind_direcction,
               p.procedure_id AS process, f.feature_id AS feature, f.name AS station_name, f.geom AS feature_shape
FROM sos_meteostation.observation os, sos_meteostation.dataset ds, sos_meteostation.phenomenon phs, sos_meteostation.procedure p,
	 sos_meteostation.observation od, sos_meteostation.dataset dd, sos_meteostation.phenomenon phd,
	 sos_meteostation.feature f
WHERE os.dataset_id = ds.dataset_id AND ds.feature_id = f.feature_id 
  AND ds.phenomenon_id = phs.phenomenon_id 
  AND ds.procedure_id = p.procedure_id 
  AND phs.identifier = 'wind_10minutes_process-wind_speed'
  AND od.dataset_id = dd.dataset_id AND dd.feature_id = f.feature_id 
  AND dd.phenomenon_id = phd.phenomenon_id 
  AND dd.procedure_id = p.procedure_id 
  AND phd.identifier = 'wind_10minutes_process-wind_direction'
  AND os.sampling_time_start = od.sampling_time_start


-- time instant filter

	AND os.sampling_time_start = '%s'
	
-- time period filter

 AND os.sampling_time_start >= '%s' AND os.sampling_time_start <= '%s'
  
-- Spatial Range filter

	 AND st_intersects(f.geom, st_makeenvelope(%s, %s, %s, %s, 4326))  

-- Spatial Point filter

	AND f.feature_id = %s
