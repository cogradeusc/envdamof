-------------------------------------------
--- CALIBRATED OBSERVATIONS (1 Property)
-------------------------------------------

-- Base query

SELECT o.result_time, o.sampling_time_start, o.value_quantity, ph.identifier, p.identifier , f.identifier, f.geom
FROM sos_air_quality.observation o,
   sos_air_quality.dataset d,
   sos_air_quality.procedure p,
   sos_air_quality.feature f,
   sos_air_quality.phenomenon ph
WHERE o.dataset_id = d.dataset_id 
	AND d.procedure_id = p.procedure_id 
	AND d.feature_id = f.feature_id
	AND d.phenomenon_id = ph.phenomenon_id 
	AND ph.identifier = 'sensor_calibration-no2'

-- time instant filter

	AND o.sampling_time_start = '%s'
	
-- time period filter

  AND o.sampling_time_start >= '%s'
  AND o.sampling_time_start <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.geom, st_makeenvelope(%s, %s, %s, %s, 4326))  

-- Spatial Point filter

 AND f.identifier = 'sensor_low_cost_feature.%s'
 
	 
	 
-------------------------------------------
--- CALIBRATED OBSERVATIONS (2 Properties)
-------------------------------------------

-- Base query

SELECT ono2.result_time, ono2.sampling_time_start, ono2.value_quantity AS no2, oo3.value_quantity AS o3, p.identifier , f.identifier, f.geom
FROM sos_air_quality.observation ono2,
	   sos_air_quality.dataset dno2,
	   sos_air_quality.procedure p,
	   sos_air_quality.feature f,
	   sos_air_quality.phenomenon phno2,
	   sos_air_quality.observation oo3,
	   sos_air_quality.dataset do3,
	   sos_air_quality.phenomenon pho3
WHERE ono2.dataset_id = dno2.dataset_id 
	 AND dno2.procedure_id = p.procedure_id 
	 AND dno2.feature_id = f.feature_id
	 AND dno2.phenomenon_id = phno2.phenomenon_id 
	 AND phno2.identifier = 'sensor_calibration-no2'
	 AND oo3.dataset_id = do3.dataset_id 
	 AND do3.procedure_id = p.procedure_id 
	 AND do3.feature_id = f.feature_id
	 AND do3.phenomenon_id = pho3.phenomenon_id 
	 AND pho3.identifier = 'sensor_calibration-o3'
	 AND ono2.sampling_time_start = oo3.sampling_time_start 


-- time instant filter

	 AND ono2.sampling_time_start = '%s'
	
-- time period filter

	 AND ono2.sampling_time_start >= '%s'
	 AND ono2.sampling_time_start <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.geom, st_makeenvelope(%s, %s, %s, %s, 4326))


-- Spatial Point filter

	AND f.identifier = 'sensor_low_cost_feature.%s'
 

