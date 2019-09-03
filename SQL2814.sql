--______________________________________________________________________________________________________________________________________________________________________________​​
--Finding a Customer Based on a TaskID they have​
SELECT DISTINCT MULTISITECUSTOMERID FROM EBS_TASKING.EBS_WORKFLOW_MGR_VW WHERE EBSTASKID = :TASKID ORDER BY MULTISITECUSTOMERID;​
​--​​______________________________________________________________________________________________________________________________________________________________________________​

--Tasks and EBSTaskID's based on EBSOINO
SELECT DISTINCT MGR.EBSTASKID, ' ' AS BREAK, TS.DESCR FROM EBS_TASKING.EBS_WORKFLOW_MGR MGR INNER JOIN EBS_TASKING.EBS_TASKS TS ON TS.EBSTASKID = MGR.EBSTASKID WHERE MGR.EBSOINO = :EBSOINO ORDER BY EBSTASKID;

​​​--______________________________________________________________________________________________________________________________________________________________________________​

SELECT PR.PROCESSID, DC.DESCRIPTION, PR.LOCKSTATE, PR.USERNAME, PR.LOCKSTART, PR.LOCKEND FROM GM_MANAGER.EBS_PROCESSCONTROL PR INNER JOIN GM_VALIDSETS.EBS_PROCESSES DC ON DC.PROCESSID = PR.PROCESSID;​​​​

UPDATE GM_MANAGER.EBS_PROCESSCONTROL SET LOCKSTATE = :NEW_LOCKSTATE WHERE PROCESSID = :PROCESSID;
--______________________________________________________________________________________________________________________________________________________________________________​
​
--Finding an Elec Customer Due for Renewal
SELECT DISTINCT  multisitecontract, contract, mpancore, MULTISITECUSTOMERID, startdate, EARLIESTENDDATE, terminationdate, billstatus  FROM CONTRACTS.CONTRACTS_VW WHERE TRUNC(STARTDATE) BETWEEN SYSDATE -345 AND (SYSDATE+42)-345 AND (EARLIESTENDDATE > TO_DATE('2019','YYYY')) and TRUNC(EARLIESTENDDATE,'MM') BETWEEN SYSDATE AND SYSDATE+42 AND BILLSTATUS = LOWER('SUPPLYACTIVE_NORMAL') FETCH FIRST 5 ROWS ONLY;​

--Finding a Gas Customer Due for Renewal
SELECT DISTINCT multisitecontract, contract, upan, MULTISITECUSTOMERID, startdate, EARLIESTENDDATE, terminationdate, billstatus FROM GASCONTRACTS.CONTRACT_VW WHERE TRUNC(STARTDATE) BETWEEN SYSDATE -345 AND (SYSDATE+42)-345 AND (EARLIESTENDDATE > TO_DATE('2019','YYYY')) AND TRUNC(EARLIESTENDDATE,'MM') BETWEEN SYSDATE AND SYSDATE+42 AND BILLSTATUS = UPPER('REGISTRATION') FETCH FIRST 5 ROWS ONLY;​​​
​​--​______________________________________________________________________________________________________________________________________________________________________________​

--ELEC ONLY CUSTOMER
SELECT DISTINCT EC.CONTRACT, EC.MPANCORE, EC.MULTISITECUSTOMERID, EC.STARTDATE, EC.EARLIESTENDDATE, EC.BILLSTATUS, EC.MULTISITECONTRACT FROM CONTRACTS.CONTRACTS_VW EC WHERE EC.MULTISITECUSTOMERID NOT IN (SELECT MULTISITECUSTOMERID FROM GASCONTRACTS.CONTRACT_VW) AND EC.BILLSTATUS = LOWER('SUPPLYACTIVE_NORMAL') FETCH FIRST 5 ROWS ONLY;

--GAS ONLY CUSTOMER
SELECT DISTINCT  GC.CONTRACT, GC.UPAN, GC.MULTISITECUSTOMERID, GC.STARTDATE, GC.EARLIESTENDDATE, GC.BILLSTATUS, GC.MULTISITECONTRACT  FROM GASCONTRACTS.CONTRACT_VW GC WHERE GC.MULTISITECUSTOMERID NOT IN (SELECT MULTISITECUSTOMERID FROM CONTRACTS.CONTRACTS_VW) AND GC.BILLSTATUS = UPPER('REGISTRATION') FETCH FIRST 5 ROWS ONLY;
--____________________________________________________________________________________________________________________________________________________________________________​
​
​​--Changing Priority on a Workflow Task: 
UPDATE EBS_TASKING.EBS_WORKFLOW_MGR SET QUERYPRIORITY = :QUERYPRIORITY WHERE ID = :ID; 
COMMIT;
--______________________________________________________________________________________________________________________________________________________________________________
--Customer Payments History
SELECT * FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE MULTISITECONTRACT = :MULTISITECONTRACT ORDER BY PAYMENTDATE;
--______________________________________________________________________________________________________________________________________________________________________________​

--Looking for How Many Customers/ How Many of a Specific Task is Open in Workflow Manager
SELECT * FROM EBS_TASKING.EBS_WORKFLOW_MGR WHERE EBSOINO = :EBSOINO ORDER BY QUERYDATE DESC;
--______________________________________________________________________________________________________________________________________________________________________________
​
--Plain Old Workflow Manager
SELECT * FROM EBS_TASKING.EBS_WORKFLOW_MGR;
--______________________________________________________________________________________________________________________________________________________________________________

--Looking for Tasks which have a Common Description, Could be Used for Research/ Investigation Purposes
SELECT * FROM EBS_TASKING.EBS_TASKS WHERE DESCR LIKE '%'||:DESCR||'%' ORDER BY EBSTASKID DESC;
--______________________________________________________________________________________________________________________________________________________________________________

--Finding ​Customers Based on a Specific Task Being in a Certain State
SELECT DISTINCT EBSTASKID, EBSOINO, MULTISITECUSTOMERID, QUERYDATE, COMPLETEDATE FROM EBS_TASKING.EBS_WORKFLOW_MGR_VW 
WHERE QUERYSTATUS = :QUERYSTATUS AND QUERYDATE = :QUERYDATE AND EBSTASKID = :TASKID ORDER BY MULTISITECUSTOMERID
--______________________________________________________________________________________________________________________________________________________________________________

--If you need to find a Table Based on a Specific Column Name and you would also like to Filter on Table name
SELECT * FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME LIKE :COLUMN_NAME AND TABLE_NAME LIKE :TABLE_NAME;
--______________________________________________________________________________________________________________________________________________________________________________


--If you need to find a Table Based on a Specific Column Name
SELECT * FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME LIKE :COLUMN_NAME;
--______________________________________________________________________________________________________________________________________________________________________________


--When you need to find a Table Name and need to Filter on Owner
SELECT * FROM ALL_TABLES WHERE TABLE_NAME LIKE :TABLE_NAME AND OWNER LIKE :OWNER;
--______________________________________________________________________________________________________________________________________________________________________________

--When you need to find a Table Name
SELECT * FROM ALL_TABLES WHERE TABLE_NAME LIKE :TABLE_NAME;
--______________________________________________________________________________________________________________________________________________________________________________

​--When you need to Find a Specific Object and Filter on Owner
SELECT * FROM ALL_OBJECTS WHERE OBJECT_NAME LIKE :OBJECT_NAME AND OWNER LIKE :OWNER;
--______________________________________________________________________________________________________________________________________________________________________________

--When you need to Find a Specific Object 
SELECT * FROM ALL_OBJECTS WHERE OBJECT_NAME LIKE :OBJECT_NAME;

--Note some EBS Tables are Considered Objects, so if you Find an EBS Table name and Cannot find it using the TABLE_NAME Query, 
  It is likely That that table is an Object​
--______________________________________________________________________________________________________________________________________________________________________________

Alan Scott [8:51 AM]
QAs ...
If you supply this query with the ID of an instance of a task on the EBS workflow queue, it will tell you how many tasks are ahead of it in that queue.
Note that it is perfectly reasonable for that number to stay the same or even grow (tasks are being raised all the time and may have a higher priority than the task you are interested in) ...
-- How many tasks are in front of my task
SELECT COUNT(*) AS ThisManyTasksInFrontOfYou
FROM   ebs_tasking.ebs_workflow_mgr Mywfm,
       ebs_tasking.ebs_workflow_mgr wfm
WHERE  Mywfm.id = :MyTaskID
AND    wfm.auto = 'A'
AND    wfm.ebsappcode = Mywfm.ebsappcode
AND    wfm.querystatus = 'O'
AND    wfm.scheduledate <= SYSDATE
AND    (
    (wfm.querypriority < Mywfm.querypriority)
    OR
    (wfm.querypriority = Mywfm.querypriority AND wfm.id < Mywfm.id)
);
--______________________________________________________________________________________________________________________________________________________________________________

This query will show how many tasks have completed successfully on each EBS workflow queue within the current clock-hour.
You can use this as a check that tasks *are* being processed ...

-- Are tasks processing?
-- Tasks completed per queue in the current clock-hour
SELECT wfm.ebsappcode, COUNT(*)
FROM   ebs_tasking.ebs_workflow_mgr_changes wfmc,
       ebs_tasking.ebs_workflow_mgr wfm
WHERE  (
    (wfmc.old_status IS NULL)
    OR
    (wfmc.old_status != 'C')
)
AND    wfmc.new_status = 'C'
AND    wfmc.change_date >= TRUNC(SYSDATE,'HH24')
AND    wfm.id = wfmc.task_id
GROUP BY wfm.ebsappcode
ORDER BY wfm.ebsappcode;​
--______________________________________________________________________________________________________________________________________________________________________________

--Search for a Customer Based on a Specific Gas FLow
SELECT DISTINCT * FROM GASFLOWS.GASFLOWVIEWER WHERE A_TRANSACTION_UNIQUE_CODE = :GASFLOW ORDER BY A_PROCESSDATE DESC;
--______________________________________________________________________________________________________________________________________________________________________________

--Search for a Customer Based on a Specific DTC FLow

SELECT DISTINCT * FROM DTCFLOWS.DTCFLOWVIEWER WHERE A_TRANSACTION_UNIQUE_CODE = :DTCFLOW ORDER BY A_PROCESSDATE DESC;
--______________________________________________________________________________________________________________________________________________________________________________

--Find out If your Scheduled Job is Complete
SELECT * FROM all_scheduler_running_jobs;
--______________________________________________________________________________________________________________________________________________________________________________

--Find the Scheduled Job that you need to Run
SELECT * FROM SYS.ALL_SCHEDULER_JOBS WHERE JOB_NAME like '%'||:JOB_NAME||'%';​
--______________________________________________________________________________________________________________________________________________________________________________

--Enter the Name of the Scheduled Job into this Query to Run it
BEGIN
  DBMS_SCHEDULER.RUN_JOB(
    JOB_NAME            => :JOB_NAME,
    USE_CURRENT_SESSION => FALSE);
END;
--______________________________________________________________________________________________________________________________________________________________________________

--Finding Customers and Tasks Based on the Description of the EBSOINO
SELECT * FROM EBS_TASKING.EBS_WORKFLOW_MGR_VW WHERE EBSOIDESCR LIKE '%Direct Debit%';
--______________________________________________________________________________________________________________________________________________________________________________

--Finding all Workflow Tasks Associated with a Specific EBSOINO
SELECT EBSOINO, DESCR , EBSTASKID FROM EBS_TASKING.EBS_TASKS A WHERE A.EBSOINO = :EBSOINO;
--______________________________________________________________________________________________________________________________________________________________________________

--Finding EBSOINO's Based on the Descriptive Text of the EBSOI
SELECT EBSOINO, EBSOICODE, DESCR FROM EBS_TASKING.EBS_OPERATINGINSTRUCTIONS WHERE DESCR LIKE '%Direct Debit%';​
--______________________________________________________________________________________________________________________________________________________________________________

--CRDPAY FILE
SELECT * FROM( SELECT 1,'TRANID,TRANCDNM,TRANDATE,UPGAUTHCODE,ITEMPRICE,ITEMDESC,TRANAMNT' FROM DUAL UNION
SELECT 2, ''||:BILLINGPAYMENTID||','||(SELECT QUOTE.SURNAME FROM PRICINGCOMMON.QUOTECUSTOMERCONTACTS_VW QUOTE INNER JOIN BILLINGCOMMON.BILLINGPAYMENTS BP ON SUBSTR(BP.REFERENCE,0,8) = QUOTE.CUSTOMERID WHERE BP.BILLINGPAYMENT_ID = :BILLINGPAYMENTID)||','||TO_CHAR(SYSDATE,'DD/MM/YYYY')||' 09:00,14626,'||(SELECT PAYMENT FROM BILLINGCOMMON.BILLINGPAYMENTS  WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENTID)||','||(SELECT SUBSTR(REFERENCE, 0,8) 
FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENTID )||','||(SELECT PAYMENT FROM BILLINGCOMMON.BILLINGPAYMENTS  WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENTID)||''FROM DUAL);
​
TranID,TranCdNm,TranDate,UPGAuthCode,itemprice,Itemdesc,TranAmnt
52698658,english113979,23/12/2016 08:00,14626,97,GIRL09,97

CARDPAY FILENAME
SELECT 'CRDPAY_'||(SELECT SUBSTR(REFERENCE, 0,8) FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENTID )||'_'||TO_CHAR(SYSDATE,'YYYYMMDD')||'_'||SYS_GUID()||'.csv' FROM DUAL;​
--______________________________________________________________________________________________________________________________________________________________________________

--BNKPAY FILE
--Make sure to choose either DBT - Debit or CDT - Credit - Using the Paymentype Parameter
--DBT(Updates a Payment that already Exists), CDT(Adds another Payment to the Payment History)​
SELECT '"'||(SELECT TO_CHAR(PAYMENTDATE, 'YYYYMMDD') FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||
'","'||(SELECT PAYMENT FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||
'","'||:PAYMENTYPE||'​","'||(SELECT SUBSTR(REFERENCE, 0,8) FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||
'","C","F","308089","26768560"' FROM DUAL;​​

--"20190105","37","CDT","HUNT0598","C","F","308089","26768560"

--BNKPAY FILENAME
SELECT 'BNKPAY_'||:CUSTID||'_'||TO_CHAR(SYSDATE,'YYYYMMDD')||'_'||SYS_GUID()||'.TXT' FROM DUAL;

--______________________________________________________________________________________________________________________________________________________________________________

--NORDPAY FILE

--Credit
SELECT '"'||(SELECT TO_CHAR(PAYMENTDATE, 'DD/MM/YYYY') FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||'","'
||(SELECT PAYMENT FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||
'","14141","BACS CREDIT","'||:FUEL||' '||(SELECT SUBSTR(REFERENCE, 0,8) FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||''||'",""' FROM DUAL;​

--Debit
--NORDPAY FILE
SELECT '"'||(SELECT TO_CHAR(PAYMENTDATE, 'DD/MM/YYYY') FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||'","'
||(SELECT PAYMENT FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||
'","13131","DIRECT DEBITS","'||:FUEL||' '||(SELECT SUBSTR(REFERENCE, 0,8) FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||''||'",""' FROM DUAL;

​--CHOOSE 'ELEC' OR 'GAS' FOR TH​​​​EIR COMMODITY
--"DD/MM/YYCC","00","14141","BACS CREDITS","ELEC TEST0001",""

--​NORDPAY FILENAME
SELECT 'NORDEPAY_'||DBMS_RANDOM.STRING('u',4)||''||to_char(dbms_random.value(0000,9999),'fm0000')||'_'||TO_CHAR(SYSDATE,'YYYYMMDD')||'.TRN' FROM DUAL;​

--old one: SELECT 'NORDEPAY_'||:CUSTID||'_'||TO_CHAR(SYSDATE,'YYYYMMDD')||'_'||SYS_GUID()||'.TRN' FROM DUAL;​
--______________________________________________________________________________________________________________________________________________________________________________

--BACS PAYMENT FILE
SELECT '"'||(SELECT TO_CHAR(PAYMENTDATE, 'YYYYMMDD') FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||
'","'||(SELECT PAYMENT FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||
'","CDT","'||(SELECT SUBSTR(REFERENCE, 0,8) FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||
'","C","F","308089","26768560"' FROM DUAL;​
​
Example:
"20190105","37","CDT","HUNT0598","C","F","308089","26768560"

BACS PAYMENT FILENAME
SELECT 'BNKPAY_'||:CUSTID||'_'||TO_CHAR(SYSDATE,'YYYYMMDD')||'_'||SYS_GUID()||'.TXT' FROM DUAL;
--______________________________________________________________________________________________________________________________________________________________________________
--BACS CHARGE FILE REPORT
SELECT ''||(SELECT REFERENCE FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||
','||(SELECT SUBSTR(REFERENCE, 0,8) FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||
','||(SELECT ABS(PAYMENT) FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||','
||(SELECT SUBSTR(REFERENCE, 0,8) FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||','
||(SELECT TO_CHAR(PAYMENTDATE, 'DD/MM/YYYY') FROM BILLINGCOMMON.BILLINGPAYMENTS WHERE BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID)||',,'
FROM DUAL;​

SMIT13460000233325,english272461,1.00,SMIT1346,15/07/2018 06:00,,

--BACS CHARGE FILE REPORT​ FILENAME
​SELECT 'BACS_ELEC Charge File Report-'||TO_CHAR(SYSDATE,'YYYY-MM-DD')||'-'||:CUSTID||'.TXT' FROM DUAL

--______________________________________________________________________________________________________________________________________________________________________________

​--Finding Debt Customers with Active DD
select d.MULTISITECUSTOMERID
from BILLINGCOMMON.DIRECTDEBIT_PAYERCONTACTDET_VW d
join CONTRACTSCOMMON.CONTRACTMULTISITEs c on c.MULTISITECUSTOMERID = d.MULTISITECUSTOMERID
join billingcommon.DEBT_RECOVERY_FINALISED_ACC debt on debt.MULTISITECONTRACT = c.MULTISITECONTRACT
where d.CURRENT_STATE=10
and debt.arrangement_made='F' and debt.debt_status='L';​

--___________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

-- SQL Query to Help you when Debugging Tasks and finding out why they Errored:
SELECT C.QUERYNOTES, A.ID, A.EBSOINO, A.EBSTASKID, A.QUERYDATE, B.EBS_PARAM_TYPE, B.EBS_PARAM_VALUE, B.EBS_PARAM_NAME
FROM EBS_TASKING.EBS_WORKFLOW_MGR A
INNER JOIN EBS_TASKING.EBS_WORKFLOW_MGR_DETAILS C
ON A.ID = C.ID 
INNER JOIN EBS_TASKING.EBS_WORKFLOW_MGR_PARAMS B
ON B.ID = C.ID
WHERE A.EBSOINO = :EBSOINO
AND C.QUERYNOTES LIKE :TEXT
AND A.EBSTASKID = :EBSTASKID
AND ID = :ID
AND A.QUERYDATE > TRUNC(SYSDATE);

--___________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

--Table Where all of the ​DTC Market Roles are Displayed and Described
SELECT * FROM DTCFLOWS.D0269002GXMRO;

--___________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
--all DTC Flow names 
SELECT DISTINCT TABLE_NAME FROM ALL_TABLES WHERE OWNER = 'DTCFLOWS' AND TABLE_NAME LIKE 'D%' ORDER BY TABLE_NAME;
--___________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
--all Gas Flow names
SELECT DISTINCT TABLE_NAME FROM ALL_TABLES WHERE OWNER = 'GASFLOWS' AND TABLE_NAME LIKE '%_%' ORDER BY TABLE_NAME;
--________________________________________________________________________________________________________________________________________________________________________________

--Filenames for Flows and Files:
SELECT ''||DBMS_RANDOM.STRING('U',5)||''||TO_CHAR(DBMS_RANDOM.VALUE(00000,99999),'FM00000')||'_'||UPPER(:FLOW)||'.'||UPPER(:EXT)||'' FROM DUAL;

--________________________________________________________________________________________________________________________________________________________________________________

--Finding a Screenid using the Name of the View/Table
SELECT SCREEN_ID FROM EBS_MANAGER.EBS_SCREEN WHERE APP_DB_TABLE_NAME LIKE '%'||:VIEW_NAME||'%';
--________________________________________________________________________________________________________________________________________________________________________________

--Finding out if there are any DB Locks 
​SELECT DISTINCT * FROM DBA_LOCKS WHERE BLOCKING_OTHERS = 'BLOCKING';
--________________________________________________________________________________________________________________________________________________________________________________

--Finding Gasflow Information
SELECT * FROM ALL_TABLES WHERE TABLE_NAME LIKE 'D0269002GX'||UPPER(:GROUPID)||'';

Select a GroupID from the List below to find the table you are looking for:
https://dtc.mrasco.com/DataFlow.aspx?FlowCounter=0269&FlowVers=4&searchMockFlows=False
--________________________________________________________________________________________________________________________________________________________________________________

​--EBS_PARAMS_BY_EBSTASKID
SELECT * FROM EBS_TASKING.EBS_WORKFLOW_MGR_PARAMS WHERE ID IN 
(SELECT ID FROM EBS_TASKING.EB​S_WORKFLOW_MGR WHERE EBSTASKID = :EBSTASKID ) ORDER BY ID DESC;

--EBS_PARAMS BY ID
SELECT * FROM EBS_TASKING.EBS_WORKFLOW_MGR_PARAMS WHERE ID = :ID ORDER BY ID DESC;​
--________________________________________________________________________________________________________________________________________________________________________________

--ALL LOGS
SELECT * FROM EBS_MANAGER.ALL_LOGS;
​--________________________________________________________________________________________________________________________________________________________________________________

--ENTER THE DTCFLOW NUMBER IN THE PARAMETERS AND YOU WILL GET EXAMPLE DTCFLOW INFORMATION FOR THAT FLOW
SELECT * FROM DTCFLOWS.DTCFLOWVIEWER WHERE DTCFLOW LIKE ''||:DTCFLOW||'001';
--​________________________________________________________________________________________________________________________________________________________________________________

--SQL TO FIND INDEX TABLES
​SELECT * FROM ALL_OBJECTS WHERE OBJECT_NAME LIKE '%'||UPPER(:OBJECT_NAME)||'%' AND OBJECT_TYPE = 'INDEX';​
​--________________________________________________________________________________________________________________________________________________________________________________

--PROCESSID'S, DESCRIPTIONS AND STATE
SELECT A.PROCESSID, C.DESCRIPTION , A.LOCKSTATE, A.LOCKSTART, A.LOCKEND, A.USERNAME, A.PROCESS_CALLER FROM GM_MANAGER.EBS_PROCESSCONTROL A 
INNER JOIN GM_VALIDSETS.EBS_PROCESSES C ON A.PROCESSID = C.PROCESSID;
​--________________________________________________________________________________________________________________________________________________________________________________

Restarting all Gilmond Services in Powershell Admin Mode
​get-service   -displayname   'gilmond*' | restart-service

​--________________________________________________________________________________________________________________________________________________________________________________

--ALL DATABASE ERROR MESSAGES​
​SELECT * FROM DBA_ERRORS WHERE OWNER LIKE '%'||:OWNER||'%' AND NAME LIKE '%'||:NAME||'%';
​--________________________________________________________________________________________________________________________________________________________________________________

--Finding an Active Gas Customer from ~ 6 Months Ago
​select MULTISITECONTRACT, CONTRACT, UPAN, CUSTOMERID, STARTDATE, EARLIESTENDDATE, BILLSTATUS, ISPPM from GASCONTRACTS.CONTRACT_VW where BILLSTATUS = 'REGISTRATION' and STARTDATE between SYSDATE - 182 and SYSDATE - 120 order by STARTDATE desc, DBMS_RANDOM.value
FETCH FIRST 5 ROWS ONLY;

--Finding an Active Electric Customer from ~ 6 Months Ago
select MULTISITECONTRACT, CONTRACT, mpancore, CUSTOMERID, STARTDATE, EARLIESTENDDATE, BILLSTATUS, ISPPM from CONTRACTS.CONTRACTs_VW where BILLSTATUS = 'supplyactive_normal' and STARTDATE between SYSDATE - 182 and SYSDATE - 120 order by STARTDATE desc, DBMS_RANDOM.value
FETCH FIRST 5 ROWS ONLY;

​--________________________________________________________________________________________________________________________________________________________________________________

--Check all Running Locks:
SELECT VL.DESCRIPTION, VL.PROCESSID, PR.LOCKSTATE, PR.LOCKSTART, PR.LOCKEND, PR.USERNAME, PR.PROCESS_CALLER FROM GM_MANAGER.EBS_PROCESSCONTROL PR INNER JOIN GM_VALIDSETS.EBS_PROCESSES VL ON PR.PROCESSID = VL.PROCESSID;
​--________________________________________________________________________________________________________________________________________________________________________________

--Generating an SQL Query for the Refund Customer
select 1, 'transfer date	beneficary amount	beneficary details	beneficary name'  from DUAL union
SELECT 2, ''||TO_CHAR(BP.PAYMENTDATE,'DD/MM/YYYY')||'"	"'||ABS(BP.PAYMENT)||'"	"'||CMS.MULTISITECUSTOMERID||' '||SUBSTR(UPPER(CT.DESCRIPTION), 0,4)||'"	"'||QCC.TITLE||''||QCC.FIRSTNAME||' '||QCC.SURNAME||''
FROM PRICINGCOMMON.QUOTECUSTOMERCONTACTS QCC,
     CONTRACTSCOMMON.CONTRACTMULTISITES CMS,
     CONTRACTSCOMMON.CONTRACTMULTISITE CM,
     BILLINGCOMMON.BILLINGPAYMENTS BP,
     EBS_MANAGER.EBS_COMMODITY_TYPE CT
where CMS.CUSTOMERID = QCC.CUSTOMERID
AND   CM.MULTISITECONTRACT = CMS.MULTISITECONTRACT
AND   BP.MULTISITECONTRACT = CMS.MULTISITECONTRACT
AND   BP.BILLINGPAYMENT_ID = :BILLINGPAYMENT_ID
and   CT.COMMODITY_TYPE = CM.COMMODITY_TYPE;​

--Filename
SELECT 'NORDEREF_'||(SELECT TO_CHAR(SYSDATE, 'DDMMYYYY') FROM DUAL)||'_'||(SELECT TO_CHAR(DBMS_RANDOM.VALUE(0,9),'fm0') num from dual)||'.TXT' FROM DUAL;
--________________________________________________________________________________________________________________________________________________________________________________

--Finding a Gas PPMCustomer that is within 15 - 30 days after it's Startdate
SELECT CONTRACT, MULTISITECONTRACT, UPAN, CUSTOMERID, STARTDATE, EARLIESTENDDATE, BILLSTATUS FROM GASCONTRACTS.CONTRACT_VW WHERE BILLSTATUS = LOWER('NOT_REGISTERED') AND STARTDATE BETWEEN SYSDATE + 15 AND SYSDATE + 30 AND ISPPM = 'T' ORDER BY STARTDATE DESC;
--________________________________________________________________________________________________________________________________________________________________________________

--Find Customer with active Direct Debit:
SELECT SUBSTR(REFERENCE_NUMBER,0,8),COMMODITY_TYPE FROM BILLINGCOMMON.DIRECTDEBIT_PAYERCONTACTDET_VW WHERE CURRENT_STATE = '10';
--____________________________________________________________________________________________________________​____________________________________________________________________

--Find Customer with Inactive Direct Debit:
SELECT SUBSTR(REFERENCE_NUMBER,0,8),COMMODITY_TYPE FROM BILLINGCOMMON.DIRECTDEBIT_PAYERCONTACTDET_VW WHERE CURRENT_STATE = '11';
--________________________________________________________________________________________________________________________________________________________________________________
​
--FINDING PARAMETER VALUES
SELECT PR.ID, PR.EBS_PARAM_NAME, PR.EBS_PARAM_VALUE, WF.EBSTASKID, UPAN FROM EBS_TASKING.EBS_WORKFLOW_MGR_PARAMS PR INNER JOIN EBS_TASKING.EBS_WORKFLOW_MGR WF ON WF.ID = PR.ID WHERE WF.EBSTASKID = :EBSTASKID AND EBS_PARAM_NAME = :PARAM_VALUE;

--FINDING OARAMETER NAMES FOR TASKS
SELECT PR.ID, PR.EBS_PARAM_NAME, PR.EBS_PARAM_VALUE, WF.EBSTASKID, UPAN FROM EBS_TASKING.EBS_WORKFLOW_MGR_PARAMS PR INNER JOIN EBS_TASKING.EBS_WORKFLOW_MGR WF ON WF.ID = PR.ID WHERE WF.EBSTASKID = :EBSTASKID;

--CHECKING PARAMETER VALUES BY ID
SELECT PR.ID, PR.EBS_PARAM_NAME, PR.EBS_PARAM_VALUE, WF.EBSTASKID, UPAN FROM EBS_TASKING.EBS_WORKFLOW_MGR_PARAMS PR INNER JOIN EBS_TASKING.EBS_WORKFLOW_MGR WF ON WF.ID = PR.ID WHERE WF.ID = :ID;
--___________________________________________________________________________________________________________________________​_____________________________________________________

--FINDING PARAMETER_NAME, DATA_TYPES, AND DATA_TYPE_LENGTH BASED ON YOUR TASK NUMBER
​SELECT TASK.EBSTASKID, TASK.EBS_PARAM_NAME, PARAM.EBS_PARAM_TYPE, PARAM.EBS_PARAM_LENGTH FROM EBS_TASKING.EBS_TASK_PARAMS TASK INNER JOIN EBS_TASKING.EBS_PARAMS PARAM ON TASK.EBS_PARAM_NAME = PARAM.EBS_PARAM_NAME  WHERE EBSTASKID = :EBSTASKID;
--___________________________________________________________________________________________________________________________​_____________________________________________________

--FINDING A TARIFF
​SELECT * FROM PRICING.NHHPRICETARRIF__PRODUCTS_VW WHERE GSPGROUPID = :GSPGROUPID AND PROFILECLASSID = :PROFILECLASSID;
--___________________________________________________________________________________________________________________________​_____________________________________________________

--​​Find Parameter Details based on EBSTASKID
SELECT TASK.EBSTASKID, TASK.EBS_PARAM_NAME, PARAM.EBS_PARAM_TYPE, PARAM.EBS_PARAM_VALUE FROM EBS_TASKING.EBS_TASK_PARAMS TASK INNER JOIN EBS_TASKING.EBS_WORKFLOW_MGR_PARAMS PARAM ON TASK.EBS_PARAM_NAME = PARAM.EBS_PARAM_NAME  WHERE EBSTASKID = :EBSTASKID ORDER BY PARAM.ID;​

--Another Version of this:
SELECT * FROM EBS_TASKING.EBS_TASK_PARAMS WHERE EBSTASKID = :EBSTASKID;
--___________________________________________________________________________________________________________________________​_____________________________________________________

--FINDING CUSTOMER ADDRESSES
SELECT * FROM PRICINGCOMMON.CUSTOMERREGADDRESS WHERE MULTISITECUSTOMERID = UPPER(:CUSTID);
SELECT * FROM PRICINGCOMMON.QUOTECUSTOME​​RS WHERE CUSTOMERID = UPPER(:CUSTID);
---___________________________________________________________________________________________________________________________​_____________________________________________________

--All Gas Market Participants:
select * from GASFLOWCONFIG.MDDMARKETPARTICIPANT;
--___________________________________________________________________________________________________________________________​_____________________________________________________

--All Electric Market Participants:
SELECT * FROM DTCFLOWS.D0269002GXMAP;
--___________________________________________________________________________________________________________________________​_____________________________________________________​

--All Gasflows Named
SELECT FLOWCOUNTER, FLOWDESCRIPTION FROM GASFLOWCONFIG.GASCONFIGDATAFLOW;

--All DTC Flows Named and Described
SELECT 'D0'||FLOWCOUNTER||''||FLOWVERSION||'', FLOWNAME, FLOWDESCRIPTION FROM DTCFLOWCONFIG.CONFIGDATAFLOW ORDER BY FLOWCOUNTER ASC;
--___________________________________________________________________________________________________________________________​_____________________________________________________​

--Find Tariff Name/Details based on MPXN

--Gas
SELECT PRI.MPRN, PRI.NDMTARRIFID, RUN.TARIFFNAME FROM GASPRICING.QUOTEACTIONS_AUD PRI INNER JOIN GASPRICING.NDMPRICETARRIF__PRODUCTS_VW NDM ON PRI.NDMTARRIFID = NDM.NDMTARRIFID INNER JOIN GASPRICING.NDMPRICERUN RUN ON RUN.NDMPRICERUNID = NDM.NDMPRICERUNID WHERE PRI.MPRN = :MPRN; 

--Elec
SELECT PRI.MPANCORE, PRI.NHHTARRIFID, RUN.TARIFFNAME FROM PRICING.QUOTEACTIONS_AUD PRI INNER JOIN PRICING.NHHPRICETARRIF__PRODUCTS_VW NHH ON PRI.NHHTARRIFID = NHH.NHHTARRIFID INNER JOIN PRICING.NHHPRICERUN RUN ON RUN.NHHPRICERUNID = NHH.NHHPRICERUNID WHERE PRI.MPANCORE = :MPAN; 
--___________________________________________________________________________________________________________________________​_____________________________________________________

--Checking DTC Flow Versions
SELECT * FROM DTCFLOWCONFIG.CONFIGDATAFLOW;

--Checking NDM Flow Versions
SELECT * FROM GASFLOWCONFIG.GASCONFIGDATAFLOW;
--___________________________________________________________________________________________________________________________​_____________________________________________________​

--Billing Logs
SELECT * FROM BILLINGPROCESS.BILLING_LOGS;

--Cost Run Logs
SELECT * FROM PRICINGPROCESS.COST_RUN_LOGS;

--Quotation Logs
SELECT * FROM PRICINGPROCESS.QUOTATION_LOGS;

--All_Logs
SELECT * FROM EBS_MANAGER.ALL_LOGS ORDER BY A_DATE DESC;
--___________________________________________________________________________________________________________________________​_____________________________________________________

--Find all Relevant Task Relations to a task
select DISTINCT RE.EBSTASKID, RE.SUBEBSTASKID, RE.EBSRESULT, RE.CHILDORDER, MGR.EBSOINO, MGR.EBSAPPCODE from EBS_TASKING.EBS_TASK_RELATIONS RE INNER JOIN EBS_TASKING.EBS_WORKFLOW_MGR MGR ON MGR.EBSTASKID = RE.EBSTASKID WHERE RE.EBSTASKID = :EBSTASKID AND RE.ISVALID = 'T';
--___________________________________________________________________________________________________________________________​_____________________________________________________

--Find the Task ID and the Description Associated with it
select ''||:EBSTASKID||' - '||(select descr from EBS_TASKING.EBS_TASKS where EBSTASKID = :EBSTASKID)||'' from DUAL;
--___________________________________________________________________________________________________________________________​_____________________________________________________​

--Find the Tasks regarding a certain EBSOINO
SELECT DISTINCT MGR.EBSTASKID, MGR.EBSOINO, TASK.DESCR FROM EBS_TASKING.EBS_WORKFLOW_MGR MGR INNER JOIN EBS_TASKING.EBS_TASKS TASK ON TASK.EBSTASKID = MGR.EBSTASKID WHERE MGR.EBSOINO = :EBSOINO ORDER BY MGR.EBSTASKID;
--___________________________________________________________________________________________________________________________​_____________________________________________________​

--Is there a blocking lock in this DB?
SELECT * FROM dba_locks a
WHERE blocking_others = 'Blocking';
--___________________________________________________________________________________________________________________________​_____________________________________________________​

--The SESSION_ID column is the session that is causing the lock.--What is that session?
SELECT * FROM gv$session where sid in (529,
904) ;
--___________________________________________________________________________________________________________________________​_____________________________________________________​

--EBS Task Roles
select * from EBS_TASKING.EBS_TASK_ROLES;
--___________________________________________________________________________________________________________________________​____________________________________________________

create procedure DeviceWhiteListUpdate
@Device Varchar(25)
as 
update devices set Status = 1 where deviceid = @Device;
Go

declare @Device Varchar(25)
set @Device = ''
exec DeviceWhiteListUpdate @Device;
--___________________________________________________________________________________________________________________________​____________________________________________________​

--All QueryPriorities where we aren't the creators get moved to a 5
UPDATE EBS_TASKING.EBS_WORKFLOW_MGR SET QUERYPRIORITY = 5 WHERE USERNAME || USERNAMETOACTION NOT IN LOWER(('MARK.SILVERSTER', 'DILAN.ORMISIAR', 'JO MOLLOY', 'PETE.LUTHOR'));

--All QueryPriorities where we are the creators get moved to a 0
UPDATE EBS_TASKING.EBS_WORKFLOW_MGR SET QUERYPRIORITY = 0 WHERE USERNAME || USERNAMETOACTION IN LOWER(('MARK.SILVERSTER', 'DILAN.ORMISIAR', 'JO MOLLOY', 'PETE.LUTHOR'));
--___________________________________________________________________________________________________________________________​____________________________________________________​
