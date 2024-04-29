-------------------
--- 1 Property
------------------

-- Base query

SELECT  o.sampling_time_start, o.sampling_time_start, o.value_quantity AS flow, p.procedure_id AS process, 
        p.identifier AS name, f.feature_id AS feature, f.geom  AS shape
FROM sos_traffic.observation o, sos_traffic.dataset d, sos_traffic.phenomenon ph,
	 sos_traffic.procedure p, sos_traffic.feature f 
WHERE o.dataset_id = d.dataset_id AND d.phenomenon_id = ph.phenomenon_id 
  AND d.procedure_id = p.procedure_id AND d.feature_id = f.feature_id 
  AND ph.identifier = 'sensor_traffic-flow'

-- time instant filter

	AND  o.sampling_time_start = '%s'
	
-- time period filter

 AND o.sampling_time_start >= '%s' AND o.sampling_time_start <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.geom, st_makeenvelope(%s, %s, %s , %s, 4326)) 

-- Spatial Point filter

 AND f.feature_id = %s
 
	 
	 
---------------------
--- 2 Properties
--------------------

-- Base query

SELECT  of.sampling_time_start, of.sampling_time_start, of.value_quantity AS flow, ooc.value_quantity AS occupancy, p.procedure_id AS process, 
		                    p.identifier AS name, f.feature_id AS feature, f.geom  AS shape
FROM sos_traffic.observation of, sos_traffic.dataset df, sos_traffic.phenomenon phf,
	sos_traffic.observation ooc, sos_traffic.dataset doc, sos_traffic.phenomenon phoc,
	sos_traffic.procedure p, sos_traffic.feature f 
WHERE of.dataset_id = df.dataset_id AND df.phenomenon_id = phf.phenomenon_id 
	AND ooc.dataset_id = doc.dataset_id AND doc.phenomenon_id = phoc.phenomenon_id
	AND df.procedure_id = p.procedure_id AND df.feature_id = f.feature_id
	AND doc.procedure_id = p.procedure_id AND doc.feature_id = f.feature_id
	AND phf.identifier = 'sensor_traffic-flow'
	AND phoc.identifier = 'sensor_traffic-occupancy'
	AND of.sampling_time_start = ooc.sampling_time_start


-- time instant filter

	 AND  of.sampling_time_start = '%s'
	
-- time period filter

	 AND of.sampling_time_start >= '%s' AND of.sampling_time_start <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.geom, st_makeenvelope(%s, %s, %s , %s, 4326))

-- Spatial Point filter

	AND f.feature_id = %s
 

