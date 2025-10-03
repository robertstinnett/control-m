SELECT PROCID as "Job ID",
CMR_AJF.ORDERNO as "Order ID",
SCHEDTAB as "Parent Table",
JOBNAME as "Job Name",
ODATE as "Order Date",

CASE
WHEN STARTRUN = '' THEN STARTRUN
ELSE
Substring(STARTRUN, 9, 2) || ':' ||
Substring(STARTRUN, 11, 2) || ':' ||
Substring(STARTRUN, 13, 2) || ' ' ||
Substring(STARTRUN, 5, 2) || '/' ||
Substring(STARTRUN, 7, 2) || '/' ||
Substring(STARTRUN, 1, 4)
END as "Time Started",
-- 
CASE
WHEN NEXTTIME = '' THEN NEXTTIME
ELSE
Substring(NEXTTIME, 9, 2) || ':' ||
Substring(NEXTTIME, 11, 2) || ':' ||
Substring(NEXTTIME, 13, 2) || ' ' ||
Substring(NEXTTIME, 5, 2) || '/' ||
Substring(NEXTTIME, 7, 2) || '/' ||
Substring(NEXTTIME, 1, 4)
END as "Next Run Time",

NODEID as "Server",
NODEGRP as "Node Group",
JOBNO as "Job Number - Primary Key"
FROM CMR_AJF
WHERE HOLDFLAG = 'Y'
ORDER BY ODATE
