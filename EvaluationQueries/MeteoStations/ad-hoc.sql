-------------------------------------------
--- wind_10minutes_process (1 Property)
-------------------------------------------


--Base query
SELECT d.time AS result_time, d.time AS phenomenon_time, d.value AS wind_speed, s.id AS process, st.id AS feature, 
       st.name AS station_name, st_setsrid(st_makepoint(st.longitude, st.latitude),4326) AS feature_shape
FROM meteostations.tenminutesdata d, meteostations.measurement m,
	 meteostations.parameter p, meteostations.sensor s, meteostations.station st
WHERE d.measurement = m.id AND m.parameter = p.id AND m.sensor = s.id AND s.station = st.id 
   AND p.code = 'VV'
   AND st.id <> 50500
   AND s.height IS NOT NULL 
   AND s.description <> 'VV-Ornytion'
   AND m.interval = 1
   AND split_part(s.description,'-',1) IN ('DV', 'VV', 'VV1', 'VV2','VI')

-- time instant filter

  AND d.time = '%s'
  
-- time period filter

  AND d.time >= '%s' AND d.time <= '%s'
    
-- Spatial Range filter

  AND st_intersects(st_setsrid(st_makepoint(st.longitude, st.latitude),4326), st_makeenvelope(%s, %s, %s, %s, 4326))
  

-- Spatial Point filter

  AND st.id = %s  
  
  
  
-------------------------------------------
--- wind_10minutes_process  (2 Properties)
-------------------------------------------

-- Base query

SELECT ds.time AS result_time, ds.time AS phenomenon_time, ds.value AS wind_speed, dd.value AS wind_direction, 
       ss.id AS process_speed, sd.id AS process_direction, st.id AS feature, 
       st.name AS station_name, st_setsrid(st_makepoint(st.longitude, st.latitude),4326) AS feature_shape
FROM meteostations.tenminutesdata ds, meteostations.measurement ms, meteostations.parameter ps, 
	 meteostations.tenminutesdata dd, meteostations.measurement md, meteostations.parameter pd,
	 meteostations.sensor ss, meteostations.sensor sd,
	 meteostations.station st
WHERE ds.measurement = ms.id AND ms.parameter = ps.id AND ms.sensor = ss.id  
   AND dd.measurement = md.id AND md.parameter = pd.id AND md.sensor = sd.id
   AND ps.code = 'VV'
   AND pd.code = 'DV'
   AND ds.time =dd.time 
   AND ss.station = st.id AND sd.station = st.id
   AND st.id <> 50500
   AND ss.height IS NOT NULL AND sd.height IS NOT null
   AND ss.description <> 'VV-Ornytion' AND sd.description <> 'DV-Ornytion'
   AND ms.interval = 1 AND md.interval =1
   AND split_part(ss.description,'-',1) IN ('DV', 'VV', 'VV1', 'VV2','VI')
   AND split_part(sd.description,'-',1) IN ('DV', 'VI')


-- time instant filter

  AND ds.time = '%s'
  
-- time period filter

  AND ds.time >= '%s' AND ds.time <= '%s'
    
-- Spatial Range filter

  AND st_intersects(st_setsrid(st_makepoint(st.longitude, st.latitude),4326), st_makeenvelope(%s, %s, %s, %s, 4326))
  

-- Spatial Point filter

  AND st.id = %s  
  
  
  