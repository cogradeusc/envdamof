----------------
--- 1 Property
----------------

--Base query
SELECT prof.time AS result_time, prof.time AS phenomenon_time, dp.value AS height, dt.value AS temperature,
                   c.id AS PROCEDURE, c.name AS procedure_name, s.id AS feature, s.name AS feature_name, 
                   st_setsrid(st_makepoint(s.lon,s.lat),4326) AS feature_shape
FROM ctdcampaigns.data dt,  ctdcampaigns.measurement mt, ctdcampaigns.parameter pt, ctdcampaigns.profile prof, 
	 ctdcampaigns.ctddevice c, ctdcampaigns.station s, ctdcampaigns.data dp,  ctdcampaigns.measurement mp, ctdcampaigns.parameter pp
WHERE dt.measurement = mt.id AND mt.parameter = pt.id AND mt.profile = prof.id 
  AND prof.ctddevice = c.id AND prof.station = s.id 
  AND dp.measurement = mp.id AND mp.parameter = pp.id AND mp.profile = prof.id 
  AND dt.scan = dp.scan 
  AND pt.name = 'Temperatura' AND pp.name = 'Profundidad'

  
-- time period filter

  AND prof.time >= '%s' AND prof.time <= '%s'
    
-- Spatial Range filter

  AND st_intersects(st_setsrid(st_makepoint(s.lon,s.lat),4326) , st_makeenvelope(%s, %s, %s, %s, 4326))
  
-- Spatial one point
  AND s.id = %s
   
-- Height Range filter

  AND dp.value >= %s AND dp.value <= %s 
  
 
 -- Base Query to obtain just one depth (surface level)

SELECT prof.time AS result_time, prof.time AS phenomenon_time, 
          		(SELECT value FROM ctdcampaigns.data dp WHERE dp.measurement=mp.id ORDER BY dp.scan LIMIT 1) AS height, 
          		(SELECT value FROM ctdcampaigns.data dt WHERE dt.measurement=mt.id ORDER BY dt.scan LIMIT 1) AS temperaute,
                  c.id AS PROCEDURE, c.name AS procedure_name, s.id AS feature, s.name AS feature_name, 
                  st_setsrid(st_makepoint(s.lon,s.lat),4326) AS feature_shape
FROM   ctdcampaigns.measurement mt, ctdcampaigns.parameter pt, ctdcampaigns.profile prof, 
	 ctdcampaigns.ctddevice c, ctdcampaigns.station s,   ctdcampaigns.measurement mp, ctdcampaigns.parameter pp
WHERE mt.parameter = pt.id AND mt.profile = prof.id 
  AND prof.ctddevice = c.id AND prof.station = s.id 
  AND mp.parameter = pp.id AND mp.profile = prof.id 
  AND pt.name = 'Temperatura' AND pp.name = 'Profundidad' 
 
  
----------------
--- 2 Properties
----------------

--Base query
SELECT prof.time AS result_time, prof.time AS phenomenon_time, dp.value AS height, dt.value AS temperature, ds.value AS salinity,
                   c.id AS PROCEDURE, c.name AS procedure_name, s.id AS feature, s.name AS feature_name, 
                   st_setsrid(st_makepoint(s.lon,s.lat),4326) AS feature_shape
FROM ctdcampaigns.data dt,  ctdcampaigns.measurement mt, ctdcampaigns.parameter pt, ctdcampaigns.profile prof, 
	 ctdcampaigns.ctddevice c, ctdcampaigns.station s, ctdcampaigns.data dp,  ctdcampaigns.measurement mp, ctdcampaigns.parameter pp,
	 ctdcampaigns.data ds,  ctdcampaigns.measurement ms, ctdcampaigns.parameter ps
WHERE dt.measurement = mt.id AND mt.parameter = pt.id AND mt.profile = prof.id 
  AND prof.ctddevice = c.id AND prof.station = s.id 
  AND dp.measurement = mp.id AND mp.parameter = pp.id AND mp.profile = prof.id 
  AND ds.measurement = ms.id AND ms.parameter = ps.id AND ms.profile = prof.id
  AND dt.scan = dp.scan AND dt.scan = ds.scan
  AND pt.name = 'Temperatura' AND pp.name = 'Profundidad' AND ps.name = 'Salinidad'

  
-- time period filter

  AND prof.time >= '%s' AND prof.time <= '%s'
    
-- Spatial Range filter

  st_intersects(st_setsrid(st_makepoint(s.lon,s.lat),4326) , st_makeenvelope(%s, %s, %s, %s, 4326))
  
-- Spatial one point
  AND s.id = %s
   
-- Height Range filter

  AND dp.value >= %s AND dp.value <= %s 
  
 
 -- Base Query to obtain just one depth (surface level)

SELECT prof.time AS result_time, prof.time AS phenomenon_time, 
        		(SELECT value FROM ctdcampaigns.data dp WHERE dp.measurement=mp.id ORDER BY dp.scan LIMIT 1) AS height, 
        		(SELECT value FROM ctdcampaigns.data dt WHERE dt.measurement=mt.id ORDER BY dt.scan LIMIT 1) AS temperature,
        		(SELECT value FROM ctdcampaigns.data ds WHERE ds.measurement=ms.id ORDER BY ds.scan LIMIT 1) AS salinity,
                c.id AS PROCEDURE, c.name AS procedure_name, s.id AS feature, s.name AS feature_name, 
                st_setsrid(st_makepoint(s.lon,s.lat),4326) AS feature_shape
FROM   ctdcampaigns.measurement mt, ctdcampaigns.parameter pt, ctdcampaigns.profile prof, 
	 ctdcampaigns.ctddevice c, ctdcampaigns.station s,   ctdcampaigns.measurement mp, ctdcampaigns.parameter pp,
	 ctdcampaigns.measurement ms, ctdcampaigns.parameter ps
WHERE mt.parameter = pt.id AND mt.profile = prof.id 
	AND prof.ctddevice = c.id AND prof.station = s.id 
	AND mp.parameter = pp.id AND mp.profile = prof.id 
	AND ms.parameter = ps.id AND ms.profile = prof.id 
	AND pt.name = 'Temperatura' AND pp.name = 'Profundidad' AND ps.name = 'Salinidad'
  
  
