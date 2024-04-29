-------------------------------------------
--- wind_10minutes_process (1 Property)
-------------------------------------------

-- Base query

SELECT o.result_time, o.phenomenon_time, o.wind_speed , p.fid AS process, f.fid AS feature, s.fid, s.name AS station_name, f.shape
FROM envdamof_meteostation.wind_10minutes_process_observation o,
	  envdamof_meteostation.wind_10minutes_process p,
	  envdamof_meteostation.meteostation_sampling_location f,
	  envdamof_meteostation.meteostation s
WHERE o.procedure = p.fid 
	AND o.result_time >= p.valid_time_start 
	AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time)
	AND o.feature_of_interest = f.fid 
	AND f.station = s.fid 

-- Time instant filter

	AND phenomenon_time = '%s'
	
-- time period filter

  AND phenomenon_time >= '%s' AND phenomenon_time <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.shape, st_makeenvelope(%s, %s, %s, %s, 4326))

-- Spatial Point filter
	AND s.fid = %s


-------------------------------------------
--- wind_10minutes_process  (2 Properties)
-------------------------------------------

-- Base Query

SELECT o.result_time, o.phenomenon_time, o.wind_speed, o.wind_direction, p.fid AS process, f.fid AS feature, s.fid, s.name AS station_name, f.shape
        FROM envdamof_meteostation.wind_10minutes_process_observation o,
              envdamof_meteostation.wind_10minutes_process p,
              envdamof_meteostation.meteostation_sampling_location f,
              envdamof_meteostation.meteostation s
        WHERE o.procedure = p.fid 
        AND o.result_time >= p.valid_time_start 
        AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time)
        AND o.feature_of_interest = f.fid 
        AND f.station = s.fid


-- Time instant filter

	AND phenomenon_time = '%s'
	
-- time period filter

  AND phenomenon_time >= '%s' AND phenomenon_time <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.shape, st_makeenvelope(%s, %s, %s, %s, 4326))

-- Spatial Point filter
	AND s.fid = %s

