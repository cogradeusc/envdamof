-----------------------------------
--- Query Subsamples (1 Property)
-----------------------------------

-- Base query

SELECT o.result_time AS result_time, (s->>'phenomenon_time')::timestamp AS phenomenon_time,
                (s->>'sampling_geometry_height')::REAL AS height, (s->>'temperature')::REAL AS temperature,
                p.fid AS process, p.base_station_name AS name, st_geomfromewkt(s->>'sampling_geometry') AS sampling_geometry
FROM envdamof_radiosounding.radiosounding_trajectory o, 
	envdamof_radiosounding.radiosounding_process p,
	jsonb_array_elements(subsamples) s(s)
WHERE o.PROCEDURE = p.fid
  AND o.result_time >= p.valid_time_start 
  AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time) 

	
-- time period filter

  AND phenomenon_time_start <= '%s' AND phenomenon_time_end >= '%s'
  AND (s->>'phenomenon_time')::timestamp >= '%s'
  AND (s->>'phenomenon_time')::timestamp <= '%s'
  
-- Spatial Range filter

	AND st_intersects(o.shape, st_makeenvelope(%s, %s, %s, %s, 4326))
    AND st_intersects(st_geomfromewkt(s->>'sampling_geometry') , st_makeenvelope(%s, %s, %s, %s, 4326))

-- Height Range filter

	AND (s->>'sampling_geometry_height')::REAL >= %s AND (s->>'sampling_geometry_height')::REAL <= %s


-----------------------------------
--- Query Subsamples (2 Properties)
-----------------------------------

-- Base Query

SELECT o.result_time AS result_time, (s->>'phenomenon_time')::timestamp AS phenomenon_time,
        (s->>'sampling_geometry_height')::REAL AS height, (s->>'temperature')::REAL AS temperature, (s->>'humidity')::REAL AS humidity,
    p.fid AS process, p.base_station_name AS name, st_geomfromewkt(s->>'sampling_geometry') AS sampling_geometry
FROM envdamof_radiosounding.radiosounding_trajectory o, 
envdamof_radiosounding.radiosounding_process p,
jsonb_array_elements(subsamples) s(s)
WHERE o.PROCEDURE = p.fid
	AND o.result_time >= p.valid_time_start 
	AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time)

-- time period filter

  AND phenomenon_time_start <= '%s' AND phenomenon_time_end >= '%s'
  AND (s->>'phenomenon_time')::timestamp >= '%s'
  AND (s->>'phenomenon_time')::timestamp <= '%s'
  
-- Spatial Range filter

	AND st_intersects(o.shape, st_makeenvelope(%s, %s, %s, %s, 4326))
    AND st_intersects(st_geomfromewkt(s->>'sampling_geometry') , st_makeenvelope(%s, %s, %s, %s, 4326))

-- Height Range filter

	AND (s->>'sampling_geometry_height')::REAL >= %s AND (s->>'sampling_geometry_height')::REAL <= %s


--------------------------------------
--- Query Trajectory (All Properties)
--------------------------------------

SELECT o.result_time AS result_time, o.phenomenon_time_start, o.phenomenon_time_end, o.subsamples AS trajectory,
       p.fid AS process, p.base_station_name AS name, o.shape AS shape
FROM envdamof_radiosounding.radiosounding_trajectory o, 
	envdamof_radiosounding.radiosounding_process p
WHERE o.PROCEDURE = p.fid
	AND o.result_time >= p.valid_time_start 
	AND (p.valid_time_end IS NULL OR  p.valid_time_end >= o.result_time)
	AND phenomenon_time_start <= '%s' AND phenomenon_time_end >= '%s' 
	AND st_intersects(o.shape, st_makeenvelope(%s, %s, %s, %s, 4326))