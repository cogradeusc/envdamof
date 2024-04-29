------------------
--- 1 Property
------------------

--Base query
SELECT o.datetime, o.datetime, o.flow , st.id AS process, st.id AS name, st.id AS feature, st.geom  AS shape
FROM trafair.sensor_traffic st, trafair.sensor_traffic_observation o
WHERE st.id = o.id_sensor_traffic

-- time instant filter

 AND o.datetime = '%s'
  
-- time period filter

 AND o.datetime >= '%s' AND o.datetime <= '%s'
    
-- Spatial Range filter

 AND st_intersects(st.geom, st_makeenvelope(%s, %s, %s, %s, 4326))
  

-- Spatial Point filter

 AND st.id = '%s' 
  
  
  
-------------------
--- 2 Properties)
------------------

-- Base query

SELECT o.datetime, o.datetime, o.flow , o.occupancy, st.id AS process, st.id AS name, st.id AS feature, st.geom  AS shape
FROM trafair.sensor_traffic st, trafair.sensor_traffic_observation o
WHERE st.id = o.id_sensor_traffic

-- time instant filter

  AND o.datetime = '%s'
  
-- time period filter

  AND o.datetime >= '%s' AND o.datetime <= '%s'
    
-- Spatial Range filter

  AND st_intersects(st.geom, st_makeenvelope(%s, %s, %s, %s, 4326))
  
-- Spatial Point filter

 AND st.id = '%s'
  
  