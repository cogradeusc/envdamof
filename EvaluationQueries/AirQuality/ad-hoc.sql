-------------------------------------------
--- CALIBRATED OBSERVATIONS (1 Property)
-------------------------------------------

--Base query
SELECT o.result_time,o.phenomenon_time, o.no2, sc.note, f.code, f.geom 
FROM trafair.sensor_calibrated_observation o,
	 trafair.sensor_calibration sc 
	 LEFT JOIN 
	 trafair.sensor_calibration_algorithm no2a 
	           ON  no2a.id = sc.no2_algorithm,
	 trafair.sensor_low_cost_status s,
	 trafair.sensor_low_cost_feature f
WHERE o.id_sensor_calibration = sc.id 
  AND sc.id_sensor_low_cost = s.id_sensor_low_cost 
  AND s.datetime = (SELECT max(datetime) 
					FROM trafair.sensor_low_cost_status s2 
					WHERE s2.datetime < o.phenomenon_time 
					  AND s2.id_sensor_low_cost = s.id_sensor_low_cost)
  AND s.id_sensor_low_cost_feature = f.id 

-- time instant filter

  AND  phenomenon_time = '%s'
  
-- time period filter

  AND phenomenon_time >= '%s'
  AND phenomenon_time <= '%s'
    
-- Spatial Range filter

  AND st_intersects(f.geom, st_makeenvelope(%s, %s, %s, %s, 4326))
  

-- Spatial Point filter

  AND f.id = %s  
  
  
  
-------------------------------------------
--- CALIBRATED OBSERVATIONS (2 Properties)
-------------------------------------------

-- Base query

SELECT o.result_time,o.phenomenon_time, o.no2, o.o3, sc.note, f.code, f.geom 
FROM trafair.sensor_calibrated_observation o,
	 trafair.sensor_calibration sc 
	 LEFT JOIN 
	 trafair.sensor_calibration_algorithm no2a 
	           ON  no2a.id = sc.no2_algorithm,
	 trafair.sensor_low_cost_status s,
	 trafair.sensor_low_cost_feature f
WHERE o.id_sensor_calibration = sc.id 
  AND sc.id_sensor_low_cost = s.id_sensor_low_cost 
  AND s.datetime = (SELECT max(datetime) 
					FROM trafair.sensor_low_cost_status s2 
					WHERE s2.datetime < o.phenomenon_time 
					  AND s2.id_sensor_low_cost = s.id_sensor_low_cost)
  AND s.id_sensor_low_cost_feature = f.id 

-- time instant filter

  AND  phenomenon_time = '%s'
  
-- time period filter

  AND phenomenon_time >= '%s'
  AND phenomenon_time <= '%s'
    
-- Spatial Range filter

  AND st_intersects(f.geom, st_makeenvelope(%s, %s, %s, %s, 4326))
  

-- Spatial Point filter

  AND f.id = %s  
  
  
  

-------------------------------------------
--- RAW OBSERVATIONS (3 Properties)
-------------------------------------------  

-- Base query

SELECT o.datetime, o.datetime, o.no2_aux, o.no2_we, o.no2_concentration, p.model, p.trademark, f.code, f.geom
FROM trafair.sensor_raw_observation o,
 trafair.sensor_low_cost p,
 trafair.sensor_low_cost_status s,
 trafair.sensor_low_cost_feature f
WHERE o.id_sensor_low_cost_status = s.id 
	AND s.id_sensor_low_cost = p.id 
	AND s.id_sensor_low_cost_feature = f.id 
	
-- time period filter

	AND o.datetime >= '%s'
	AND o.datetime <= '%s'  
  
-- Spatial Range filter

	AND st_intersects(f.geom, st_makeenvelope(%s, %s, %s, %s, 4326))

	
-- Spatial Point filter	

	AND f.id = %s
