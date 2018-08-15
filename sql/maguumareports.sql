[getFarmersListByCommodity]
SELECT 
'BUKIDNON' AS provincename,
SUBSTR(pfi.`address_barangay_parent_objid`,1,3) AS provincecode,
pf.`objid` AS farmerobjid,
pf.`farmerid`,
pf.`farmer_objid`,
pf.`farmer_name` as farmername,
pf.`farmer_address_text` as farmeraddress,
pf.`spouse_objid`,
pf.`spouse_name` as spousename,
pfi.`objid` AS farmeritemobjid,
pfi.`address_text` AS farmeritemaddress,
pfi.`address_barangay_objid` AS farmeritembarangay,
pfi.`address_barangay_name` AS farmeritembarangayname,
pfi.`address_barangay_parent_objid` AS faremeritemmunicipality,
pfi.`address_barangay_parent_name` AS faremeritemmunicipalityname,
c.`name` AS commodityname, 
c.`code` AS commoditycode,
ct.`name` AS commoditytypename,
ct.`code` AS commoditytypecode,
ct.`unit` AS unit,
cts.`name` AS commoditysubtypename,
cts.`code` AS commoditysubtypecode,
pfi.`tenurialstatus`,
pfi.`qty`,
pfi.`maintainer`,
pfi.`remarks`
FROM test_pagrifarmer pf
    INNER JOIN test_pagrifarmeritems pfi ON pfi.parentid = pf.`objid`
    INNER JOIN test_pagricommodity c ON c.`objid` = pfi.`commodity_objid`
    INNER JOIN test_pagricommodity_type ct ON ct.`objid` = pfi.`commoditytype_objid`
    LEFT JOIN test_pagricommodity_subtype cts ON cts.`objid` = pfi.`commoditysubtype_objid`
WHERE ${filter}

[getFarmersListByCommodity2]
SELECT 
pf.`objid` AS farmerobjid,
pf.`farmerid`,
pf.`farmer_objid`,
pf.`farmer_name` as farmername,
pf.`farmer_address_text` as farmeraddress,
pf.`spouse_objid`,
pf.`spouse_name` as spousename,
pfi.`objid` AS farmeritemobjid,
pfi.`address_text` AS farmeritemaddress,
pfi.`address_barangay_objid` AS farmeritembarangay,
pfi.`address_barangay_name` AS farmeritembarangayname,
pfi.`address_barangay_parent_objid` AS faremeritemmunicipality,
pfi.`address_barangay_parent_name` AS faremeritemmunicipalityname,
c.`name` AS commodityname, 
c.`code` AS commoditycode,
ct.`name` AS commoditytypename,
ct.`code` AS commoditytypecode,
ct.`unit` AS unit,
cts.`name` AS commoditysubtypename,
cts.`code` AS commoditysubtypecode,
pfi.`tenurialstatus`,
SUM(pfi.`qty`) AS qty,
pfi.`maintainer`,
pfi.`remarks`
FROM test_pagrifarmer pf
    INNER JOIN test_pagrifarmeritems pfi ON pfi.parentid = pf.`objid`
    INNER JOIN test_pagricommodity c ON c.`objid` = pfi.`commodity_objid`
    INNER JOIN test_pagricommodity_type ct ON ct.`objid` = pfi.`commoditytype_objid`
    LEFT JOIN test_pagricommodity_subtype cts ON cts.`objid` = pfi.`commoditysubtype_objid`
WHERE ${filter}
GROUP BY pf.`farmerid`,pfi.`commodity_objid`

[getCommodity]
SELECT * FROM test_pagricommodity ORDER BY name;

[getCommodityType]
SELECT * FROM test_pagricommodity_type WHERE parentid = $P{objid} ORDER BY name;

[getCommoditySubType]
SELECT * FROM test_pagricommodity_subtype WHERE parentid = $P{objid} ORDER BY name;

[getTenurialstatus]
SELECT DISTINCT tenurialstatus FROM test_pagrifarmeritems ORDER BY tenurialstatus;

[getCommodityList]
SELECT 
pc.`name` AS commodityname,
pc.`code` AS commoditycode,
pc.`description` AS commoditydescription,
pct.`name` AS commoditytypename,
pct.`code` AS commoditytypecode,
pct.`description` AS commoditytypedescription,
pct.`unit` AS commoditytypeunit,
(SELECT SUM(qty) FROM test_pagrifarmeritems WHERE commodity_objid = pc.objid AND commoditytype_objid = pct.`objid`
    AND address_barangay_parent_objid LIKE $P{lguid}
    AND address_barangay_objid LIKE $P{barangayid}
    AND tenurialstatus LIKE $P{tsid}
) AS totalqty,
(SELECT COUNT(*) FROM test_pagrifarmeritems WHERE commodity_objid = pc.objid AND commoditytype_objid = pct.`objid`
    AND address_barangay_parent_objid LIKE $P{lguid}
    AND address_barangay_objid LIKE $P{barangayid}
    AND tenurialstatus LIKE $P{tsid}
) AS farmeritemcount
FROM test_pagricommodity pc
INNER JOIN test_pagricommodity_type pct ON pct.parentid = pc.`objid`
WHERE pc.objid LIKE $P{commodityid} 
AND pct.objid LIKE $P{commoditytypeid}
ORDER BY pc.`name`,pct.`name`

[getFarmersList]
SELECT 
farmer_objid AS farmerobjid,
farmerid,
farmer_name AS farmername,
farmer_address_text AS farmeraddress,
spouse_name AS spousename
FROM test_pagrifarmer pf
WHERE pf.`farmer_address_municipalityid` LIKE $P{lguid}
AND pf.`farmer_address_barangayid` LIKE $P{barangayid}

[findEntity]
SELECT objid,lastname,firstname,middlename,birthdate,gender FROM entityindividual WHERE objid = $P{objid}


[getCommoditySummary]
SELECT pfi.objid,
pfi.`address_text` AS addresstext,
pfi.`address_barangay_objid` AS addressbarangayobjid,
CASE WHEN pfi.`address_barangay_name` IS NULL THEN "OTHERS" ELSE pfi.`address_barangay_name` END AS addressbarangayname,
pfi.`address_barangay_parent_objid` AS addressbarangayparentobjid,
CASE WHEN pfi.`address_barangay_parent_name` IS NULL THEN "OTHERS" ELSE pfi.`address_barangay_parent_name` END  AS addressbarangayparentname,
pfi.`commodity_objid` AS commodityobjid,
pfi.`commodity_name` AS commodityname,
pfi.`commoditytype_objid` AS `commoditytypeobjid`,
CASE WHEN pfi.`commoditytype_name` IS NULL THEN "OTHERS" ELSE pfi.`commoditytype_name` END AS `commoditytypename`, 
pfi.`commoditysubtype_objid` AS `commoditysubtypeobjid`,
CASE WHEN pfi.`commoditysubtype_name` IS NULL THEN "OTHERS" ELSE pfi.`commoditysubtype_name` END AS `commoditysubtypename`, 
pfi.`qty` AS qty,
ct.unit,
COUNT(pfi.objid) AS commoditycount FROM test_pagrifarmeritems pfi
INNER JOIN testpagri.test_pagricommodity_type ct ON ct.`objid` = pfi.`commoditytype_objid`
WHERE ${filter}
GROUP BY pfi.`address_barangay_parent_objid`,pfi.`address_barangay_objid`,pfi.`commodity_objid`,pfi.`commoditytype_objid`,pfi.`commoditysubtype_objid`