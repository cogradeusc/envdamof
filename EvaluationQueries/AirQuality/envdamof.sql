-------------------------------------------
--- CALIBRATED OBSERVATIONS (1 Property)
-------------------------------------------

-- Base query

SELECT o.result_time, o.phenomenon_time, o.no2, p.note,  f.code, f.shape 
FROM envdamof_air_quality.sensor_calibrated_observation o,
	  envdamof_air_quality.sensor_calibration p,
	  envdamof_air_quality.sensor_low_cost_feature f
WHERE o.procedure = p.fid 
	AND o.result_time >= p.valid_time_start 
	AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time)
	AND o.feature_of_interest = f.fid 

-- Time instant filter

	AND phenomenon_time = '%s'
	
-- time period filter

  AND phenomenon_time >= '%s'
  AND phenomenon_time <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.shape, st_makeenvelope(%s, %s, %s, %s, 4326))

-- Spatial Point filter
	AND f.fid = %s


-------------------------------------------
--- CALIBRATED OBSERVATIONS (2 Properties)
-------------------------------------------

-- Base Query

SELECT o.result_time, o.phenomenon_time, o.no2, o.o3, p.note,  f.code, f.shape 
FROM envdamof_air_quality.sensor_calibrated_observation o,
	  envdamof_air_quality.sensor_calibration p,
	  envdamof_air_quality.sensor_low_cost_feature f
WHERE o.procedure = p.fid 
	AND o.result_time >= p.valid_time_start 
	AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time)
	AND o.feature_of_interest = f.fid 

-- Time instant filter	
	
	AND phenomenon_time = '%s'
	
-- Time period filter

  AND phenomenon_time >= '%s'
  AND phenomenon_time <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.shape, st_makeenvelope(%s, %s, %s, %s, 4326))

 
-- Spatial Point filter

	AND f.fid = %s


-------------------------------------------
--- RAW OBSERVATIONS (3 Properties)
-------------------------------------------  

-- Base query

SELECT o.result_time, o.phenomenon_time, o.no2_aux, o.no2_we, o.no2_concentration, p.model, p.trademark, f.code, f.shape
FROM envdamof_air_quality.sensor_raw_observation o,
 envdamof_air_quality.sensor_low_cost p,
 envdamof_air_quality.sensor_low_cost_feature f
WHERE o.PROCEDURE = p.fid 
  AND o.result_time >= p.valid_time_start 
  AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time)
  AND f.fid = o.feature_of_interest 

	
-- time period filter

  AND o.phenomenon_time >= '%s'
  AND o.phenomenon_time <= '%s'  
  
-- Spatial Range filter

  AND st_intersects(f.shape, st_makeenvelope(%s, %s, %s, %s, 4326))

	
-- Spatial Point filter	

  AND f.fid = %s	
