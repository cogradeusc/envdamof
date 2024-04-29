-----------------
--- 1 Property
------------------

-- Base query

SELECT o.result_time, o.phenomenon_time, o.flow , pf.fid AS process, pf.id AS name, pf.fid AS feature, pf.shape AS shape
FROM envdamof_traffic.sensor_traffic pf, envdamof_traffic.sensor_traffic_observation o
WHERE o.procedure = pf.fid  
	AND o.result_time >= pf.valid_time_start 
	AND (pf.valid_time_end IS NULL OR  pf.valid_time_end >= o.result_time)
	AND o.feature_of_interest = pf.fid

-- Time instant filter

	 AND o.phenomenon_time = '%s'
	
-- time period filter

    AND o.phenomenon_time >= '%s' AND o.phenomenon_time <= '%s'
  
-- Spatial Range filter

	AND st_intersects(pf.shape, st_makeenvelope(%s, %s, %s, %s, 4326))

-- Spatial Point filter
	AND pf.fid = %s


---------------------
--- 2 Properties
--------------------

-- Base Query

SELECT o.result_time, o.phenomenon_time, o.flow,o.occupancy, pf.fid AS process, pf.id AS name, pf.fid AS feature, pf.shape AS shape
FROM envdamof_traffic.sensor_traffic pf, envdamof_traffic.sensor_traffic_observation o
WHERE o.procedure = pf.fid  
	AND o.result_time >= pf.valid_time_start 
	AND (pf.valid_time_end IS NULL OR  pf.valid_time_end >= o.result_time)
	AND o.feature_of_interest = pf.fid

-- Time instant filter	
	
	AND o.phenomenon_time = '%s'
	
-- Time period filter

  AND o.phenomenon_time >= '%s' AND o.phenomenon_time <= '%s'
  
-- Spatial Range filter

	AND st_intersects(pf.shape, st_makeenvelope(%s, %s, %s, %s, 4326))
 
-- Spatial Point filter

	AND pf.fid = %s

