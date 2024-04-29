----------------
--- 1 Property
----------------

-- Base query

SELECT o.result_time, o.sampling_time_start, o.vertical_from AS height, o.value_quantity AS temperature, 
             	   p.procedure_id AS PROCEDURE, p.name AS procedure_name, f.feature_id AS feature, f.name AS feature_name, f.geom AS feature_shape
FROM sos_ctd.observation o, sos_ctd.dataset d, sos_ctd.phenomenon ph, sos_ctd.procedure p, sos_ctd.feature f 
WHERE o.dataset_id = d.dataset_id 
  AND d.phenomenon_id = ph.phenomenon_id 
  AND d.procedure_id = p.procedure_id 
  AND d.feature_id = f.feature_id 
  AND o.value_type = 'quantity'
  AND ph.identifier = 'ctd_device-temperature_ITS90'
	
-- time period filter

  AND o.sampling_time_start >= '%s' AND o.sampling_time_start <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.geom , st_makeenvelope(%s, %s, %s, %s, 4326))  
	
-- Spatial one point
  AND f.feature_id = %s

-- Height Range filter

 AND o.vertical_from >= %s AND o.vertical_from <= %s
 
-- Base Query to obtain just one depth (surface level)

SELECT o.result_time, o.sampling_time_start, 
       (SELECT oh.vertical_from FROM sos_ctd.observation oh WHERE oh.parent_observation_id = o.observation_id ORDER BY oh.vertical_from LIMIT 1) AS height, 
       (SELECT ot.value_quantity FROM sos_ctd.observation ot WHERE ot.parent_observation_id = o.observation_id ORDER BY ot.vertical_from LIMIT 1) AS temperature, 
       p.procedure_id AS PROCEDURE, p.name AS procedure_name, f.feature_id AS feature, f.name AS feature_name, f.geom AS feature_shape
FROM sos_ctd.observation o, sos_ctd.dataset d, sos_ctd.phenomenon ph, sos_ctd.procedure p, sos_ctd.feature f 
WHERE o.dataset_id = d.dataset_id 
  AND d.phenomenon_id = ph.phenomenon_id 
  AND d.procedure_id = p.procedure_id 
  AND d.feature_id = f.feature_id 
  AND o.value_type = 'profile'
  AND ph.identifier = 'ctd_device-temperature_ITS90'	 
  
  
	 
----------------
--- 2 Properties
----------------

-- Base query

SELECT ot.result_time, ot.sampling_time_start, ot.vertical_from AS height, ot.value_quantity AS temperature, os.value_quantity AS salinity,
             	   p.procedure_id AS PROCEDURE, p.name AS procedure_name, f.feature_id AS feature, f.name AS feature_name, f.geom AS feature_shape
FROM sos_ctd.observation ot, sos_ctd.dataset dt, sos_ctd.phenomenon pht, 
	sos_ctd.procedure p, sos_ctd.feature f,
	 sos_ctd.observation os, sos_ctd.dataset ds, sos_ctd.phenomenon phs
WHERE ot.dataset_id = dt.dataset_id 
  AND dt.phenomenon_id = pht.phenomenon_id 
  AND dt.procedure_id = p.procedure_id 
  AND dt.feature_id = f.feature_id 
  AND ot.value_type = 'quantity'
  AND pht.identifier = 'ctd_device-temperature_ITS90'
  AND os.dataset_id = ds.dataset_id 
  AND ds.procedure_id = p.procedure_id 
  AND ds.feature_id = f.feature_id 
  AND ds.phenomenon_id = phs.phenomenon_id
  AND phs.identifier = 'ctd_device-salinity'
  AND os.value_type = 'quantity'
  AND os.sampling_time_start = ot.sampling_time_start 
  AND os.vertical_from = ot.vertical_from
	
-- time period filter

  AND os.sampling_time_start >= '%s' AND os.sampling_time_start <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.geom , st_makeenvelope(%s, %s, %s, %s, 4326))  
	
-- Spatial one point
  AND f.feature_id = %s

-- Height Range filter

 AND os.vertical_from >= %s AND os.vertical_from <= %s
 
-- Base Query to obtain just one depth (surface level)

SELECT otp.result_time, otp.sampling_time_start, 
             (SELECT oh.vertical_from FROM sos_ctd.observation oh WHERE oh.parent_observation_id = otp.observation_id ORDER BY oh.vertical_from LIMIT 1) AS height, 
             (SELECT ot.value_quantity FROM sos_ctd.observation ot WHERE ot.parent_observation_id = otp.observation_id ORDER BY ot.vertical_from LIMIT 1) AS temperature, 
             (SELECT os.value_quantity FROM sos_ctd.observation os WHERE os.parent_observation_id = osp.observation_id ORDER BY os.vertical_from LIMIT 1) AS salinity, 
             p.procedure_id AS PROCEDURE, p.name AS procedure_name, f.feature_id AS feature, f.name AS feature_name, f.geom AS feature_shape
FROM sos_ctd.observation otp, sos_ctd.dataset dtp, sos_ctd.phenomenon phtp, 
 sos_ctd.procedure p, sos_ctd.feature f, 
 sos_ctd.observation osp, sos_ctd.dataset dsp, sos_ctd.phenomenon phsp
WHERE otp.dataset_id = dtp.dataset_id 
  AND dtp.phenomenon_id = phtp.phenomenon_id 
  AND dtp.procedure_id = p.procedure_id 
  AND dtp.feature_id = f.feature_id 
  AND otp.value_type = 'profile'
  AND phtp.identifier = 'ctd_device-temperature_ITS90'
  AND osp.dataset_id = dsp.dataset_id 
  AND dsp.phenomenon_id = phsp.phenomenon_id 
  AND dsp.procedure_id = p.procedure_id 
  AND dsp.feature_id = f.feature_id 
  AND osp.value_type = 'profile'
  AND phsp.identifier = 'ctd_device-salinity'
  AND otp.sampling_time_start = osp.sampling_time_start 	 
 
----------------
--- 5 Properties
----------------


-- Base query

SELECT ot.result_time, ot.sampling_time_start, ot.vertical_from AS height, ot.value_quantity AS temperature, os.value_quantity AS salinity,
                op.value_quantity AS pressure, oph.value_quantity AS ph, ox.value_quantity AS oxigen,
                p.procedure_id AS PROCEDURE, p.name AS procedure_name, f.feature_id AS feature, f.name AS feature_name, f.geom AS feature_shape
FROM sos_ctd.procedure p, sos_ctd.feature f,
 sos_ctd.observation ot, sos_ctd.dataset dt, sos_ctd.phenomenon pht,
 sos_ctd.observation os, sos_ctd.dataset ds, sos_ctd.phenomenon phs,
 sos_ctd.observation op, sos_ctd.dataset dp, sos_ctd.phenomenon php,
 sos_ctd.observation oph, sos_ctd.dataset dph, sos_ctd.phenomenon phph,
 sos_ctd.observation ox, sos_ctd.dataset dx, sos_ctd.phenomenon phx
 
WHERE ot.dataset_id = dt.dataset_id 
	AND dt.phenomenon_id = pht.phenomenon_id 
	AND dt.procedure_id = p.procedure_id 
	AND dt.feature_id = f.feature_id 
	AND ot.value_type = 'quantity'
	AND pht.identifier = 'ctd_device-temperature_ITS90'
	AND os.dataset_id = ds.dataset_id 
	AND ds.procedure_id = p.procedure_id 
	AND ds.feature_id = f.feature_id 
	AND ds.phenomenon_id = phs.phenomenon_id
	AND phs.identifier = 'ctd_device-salinity'
	AND os.value_type = 'quantity'
	AND op.dataset_id = dp.dataset_id 
	AND dp.procedure_id = p.procedure_id 
	AND dp.feature_id = f.feature_id 
	AND dp.phenomenon_id = php.phenomenon_id
	AND php.identifier = 'ctd_device-pressure'
	AND op.value_type = 'quantity'
	AND oph.dataset_id = dph.dataset_id 
	AND dph.procedure_id = p.procedure_id 
	AND dph.feature_id = f.feature_id 
	AND dph.phenomenon_id = phph.phenomenon_id
	AND phph.identifier = 'ctd_device-ph'
	AND oph.value_type = 'quantity'
	AND ox.dataset_id = dx.dataset_id 
	AND dx.procedure_id = p.procedure_id 
	AND dx.feature_id = f.feature_id 
	AND dx.phenomenon_id = phx.phenomenon_id
	AND phx.identifier = 'ctd_device-oxigen'
	AND ox.value_type = 'quantity'
	AND os.sampling_time_start = ot.sampling_time_start 
	AND os.vertical_from = ot.vertical_from
	AND op.sampling_time_start = ot.sampling_time_start 
	AND op.vertical_from = ot.vertical_from
	AND oph.sampling_time_start = ot.sampling_time_start 
	AND oph.vertical_from = ot.vertical_from
	AND ox.sampling_time_start = ot.sampling_time_start 
	AND ox.vertical_from = ot.vertical_from 
	
-- time period filter

  AND os.sampling_time_start >= '%s' AND os.sampling_time_start <= '%s'
  
-- Spatial Range filter

	AND st_intersects(f.geom , st_makeenvelope(%s, %s, %s, %s, 4326))  
	
-- Spatial one point
  AND f.feature_id = %s

-- Height Range filter

 AND os.vertical_from >= %s AND os.vertical_from <= %s
 
-- Base Query to obtain just one depth (surface level)

SELECT otp.result_time, otp.sampling_time_start, 
	 (SELECT oh.vertical_from FROM sos_ctd.observation oh WHERE oh.parent_observation_id = otp.observation_id ORDER BY oh.vertical_from LIMIT 1) AS height, 
	 (SELECT ot.value_quantity FROM sos_ctd.observation ot WHERE ot.parent_observation_id = otp.observation_id ORDER BY ot.vertical_from LIMIT 1) AS temperature, 
	 (SELECT os.value_quantity FROM sos_ctd.observation os WHERE os.parent_observation_id = osp.observation_id ORDER BY os.vertical_from LIMIT 1) AS salinity, 
	 (SELECT op.value_quantity FROM sos_ctd.observation op WHERE op.parent_observation_id = opp.observation_id ORDER BY op.vertical_from LIMIT 1) AS pressure, 
	 (SELECT oph.value_quantity FROM sos_ctd.observation oph WHERE oph.parent_observation_id = ophp.observation_id ORDER BY oph.vertical_from LIMIT 1) AS ph,
	 (SELECT ox.value_quantity FROM sos_ctd.observation ox WHERE ox.parent_observation_id = oxp.observation_id ORDER BY ox.vertical_from LIMIT 1) AS oxigen, 
	 p.procedure_id AS PROCEDURE, p.name AS procedure_name, f.feature_id AS feature, f.name AS feature_name, f.geom AS feature_shape
FROM sos_ctd.procedure p, sos_ctd.feature f, 
 sos_ctd.observation otp, sos_ctd.dataset dtp, sos_ctd.phenomenon phtp,
 sos_ctd.observation osp, sos_ctd.dataset dsp, sos_ctd.phenomenon phsp,
 sos_ctd.observation opp, sos_ctd.dataset dpp, sos_ctd.phenomenon phpp,
 sos_ctd.observation ophp, sos_ctd.dataset dphp, sos_ctd.phenomenon phphp,
 sos_ctd.observation oxp, sos_ctd.dataset dxp, sos_ctd.phenomenon phxp
WHERE otp.dataset_id = dtp.dataset_id 
  AND dtp.phenomenon_id = phtp.phenomenon_id 
  AND dtp.procedure_id = p.procedure_id 
  AND dtp.feature_id = f.feature_id 
  AND otp.value_type = 'profile'
  AND phtp.identifier = 'ctd_device-temperature_ITS90'
  AND osp.dataset_id = dsp.dataset_id 
  AND dsp.phenomenon_id = phsp.phenomenon_id 
  AND dsp.procedure_id = p.procedure_id 
  AND dsp.feature_id = f.feature_id 
  AND osp.value_type = 'profile'
  AND phsp.identifier = 'ctd_device-salinity'
  AND opp.dataset_id = dpp.dataset_id 
  AND dpp.phenomenon_id = phpp.phenomenon_id 
  AND dpp.procedure_id = p.procedure_id 
  AND dpp.feature_id = f.feature_id 
  AND opp.value_type = 'profile'
  AND phpp.identifier = 'ctd_device-pressure'
  AND ophp.dataset_id = dphp.dataset_id 
  AND dphp.phenomenon_id = phphp.phenomenon_id 
  AND dphp.procedure_id = p.procedure_id 
  AND dphp.feature_id = f.feature_id 
  AND ophp.value_type = 'profile'
  AND phphp.identifier = 'ctd_device-ph'
  AND oxp.dataset_id = dxp.dataset_id 
  AND dxp.phenomenon_id = phxp.phenomenon_id 
  AND dxp.procedure_id = p.procedure_id 
  AND dxp.feature_id = f.feature_id 
  AND oxp.value_type = 'profile'
  AND phxp.identifier = 'ctd_device-oxigen'
  AND otp.sampling_time_start = osp.sampling_time_start
  AND otp.sampling_time_start = opp.sampling_time_start  
  AND otp.sampling_time_start = ophp.sampling_time_start  	
  AND otp.sampling_time_start = oxp.sampling_time_start 