----------------
--- 1 Property
----------------

-- Base query

SELECT o.result_time, o.phenomenon_time, (s->>'sampling_geometry')::REAL AS height, 
      (s->>'temperature_ITS90')::REAL AS temperature,
      p.fid AS procedure, p.name AS procedure_name, f.fid AS feature, f.name AS feature_name, f.shape AS feature_shape
FROM envdamof_ctd.ctd_observation o, envdamof_ctd.ctd_device p, envdamof_ctd.ctd_station f, jsonb_array_elements(subsamples) s(s)
WHERE o.procedure = p.fid AND o.feature_of_interest = f.fid
	AND o.result_time >= p.valid_time_start 
	AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time)

	
-- time period filter

   AND phenomenon_time >= '%s' AND phenomenon_time <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.shape , st_makeenvelope(%s, %s, %s, %s, 4326))
	
-- Spatial one point

   AND f.fid = %s

-- Height Range filter
	AND (s->>'sampling_geometry')::REAL >= %s
    AND (s->>'sampling_geometry')::REAL <= %s

-- Base Query to obtain just one depth (surface level)

SELECT o.result_time, o.phenomenon_time, (subsamples#>>'{0,sampling_geometry}')::REAL AS height, 
                 (subsamples#>>'{0,temperature_ITS90}')::REAL AS temperature,
                 p.fid AS procedure, p.name AS procedure_name, f.fid AS feature, f.name AS feature_name, f.shape AS feature_shape
FROM envdamof_ctd.ctd_observation o, envdamof_ctd.ctd_device p, envdamof_ctd.ctd_station f
WHERE o.procedure = p.fid AND o.feature_of_interest = f.fid
	AND o.result_time >= p.valid_time_start 
	AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time)



----------------
--- 2 Properties
----------------

-- Base Query

SELECT o.result_time, o.phenomenon_time, (s->>'sampling_geometry')::REAL AS height, 
                 (s->>'temperature_ITS90')::REAL AS temperature, (s->>'salinity')::REAL AS salinity,
                 p.fid AS procedure, p.name AS procedure_name, f.fid AS feature, f.name AS feature_name, f.shape AS feature_shape
FROM envdamof_ctd.ctd_observation o, envdamof_ctd.ctd_device p, envdamof_ctd.ctd_station f, jsonb_array_elements(subsamples) s(s)
WHERE o.procedure = p.fid AND o.feature_of_interest = f.fid
	AND o.result_time >= p.valid_time_start 
	AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time) 


-- Base query

SELECT o.result_time, o.phenomenon_time, (s->>'sampling_geometry')::REAL AS height, 
      (s->>'temperature_ITS90')::REAL AS temperature,
      p.fid AS procedure, p.name AS procedure_name, f.fid AS feature, f.name AS feature_name, f.shape AS feature_shape
FROM envdamof_ctd.ctd_observation o, envdamof_ctd.ctd_device p, envdamof_ctd.ctd_station f, jsonb_array_elements(subsamples) s(s)
WHERE o.procedure = p.fid AND o.feature_of_interest = f.fid
	AND o.result_time >= p.valid_time_start 
	AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time)

	
-- time period filter

   AND phenomenon_time >= '%s' AND phenomenon_time <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.shape , st_makeenvelope(%s, %s, %s, %s, 4326))
	
-- Spatial one point

   AND f.fid = %s

-- Height Range filter
	AND (s->>'sampling_geometry')::REAL >= %s
    AND (s->>'sampling_geometry')::REAL <= %s

-- Base Query to obtain just one depth (surface level)

SELECT o.result_time, o.phenomenon_time, (subsamples#>>'{0,sampling_geometry}')::REAL AS height, 
       (subsamples#>>'{0,temperature_ITS90}')::REAL AS temperature, (subsamples#>>'{0,salinity}')::REAL AS salinity,
       p.fid AS procedure, p.name AS procedure_name, f.fid AS feature, f.name AS feature_name, f.shape AS feature_shape
FROM envdamof_ctd.ctd_observation o, envdamof_ctd.ctd_device p, envdamof_ctd.ctd_station f
WHERE o.procedure = p.fid AND o.feature_of_interest = f.fid
	AND o.result_time >= p.valid_time_start 
	AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time)

----------------
--- 5 Properties
----------------

-- Base Query

SELECT o.result_time, o.phenomenon_time, (s->>'sampling_geometry')::REAL AS height, 
             (s->>'temperature_ITS90')::REAL AS temperature, (s->>'salinity')::REAL AS salinity,
             (s->>'pressure')::REAL AS pressure, (s->>'ph')::REAL AS ph,
             (s->>'oxigen')::REAL AS oxigen,
                 p.fid AS procedure, p.name AS procedure_name, f.fid AS feature, f.name AS feature_name, f.shape AS feature_shape
FROM envdamof_ctd.ctd_observation o, envdamof_ctd.ctd_device p, envdamof_ctd.ctd_station f, jsonb_array_elements(subsamples) s(s)
WHERE o.procedure = p.fid AND o.feature_of_interest = f.fid
  AND o.result_time >= p.valid_time_start 
  AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time)

	
-- time period filter

   AND phenomenon_time >= '%s' AND phenomenon_time <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.shape , st_makeenvelope(%s, %s, %s, %s, 4326))
	
-- Spatial one point

   AND f.fid = %s

-- Height Range filter
	AND (s->>'sampling_geometry')::REAL >= %s
    AND (s->>'sampling_geometry')::REAL <= %s

-- Base Query to obtain just one depth (surface level)

SELECT o.result_time, o.phenomenon_time, (subsamples#>>'{0,sampling_geometry}')::REAL AS height, 
      (subsamples#>>'{0,temperature_ITS90}')::REAL AS temperature, (subsamples#>>'{0,salinity}')::REAL AS salinity,
      (subsamples#>>'{0,pressure}')::REAL AS pressure, (subsamples#>>'{0,ph}')::REAL AS ph,
      (subsamples#>>'{0,oxigen}')::REAL AS oxigen,
       p.fid AS procedure, p.name AS procedure_name, f.fid AS feature, f.name AS feature_name, f.shape AS feature_shape
FROM envdamof_ctd.ctd_observation o, envdamof_ctd.ctd_device p, envdamof_ctd.ctd_station f
WHERE o.procedure = p.fid AND o.feature_of_interest = f.fid
	AND o.result_time >= p.valid_time_start 
	AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time)
