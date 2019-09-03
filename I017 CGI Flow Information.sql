
--I017

--Elec
select BILL.STATEMENTNUMBER ,SM.MPXN as MPAN, SM.COMMODITYTYPE, con.MULTISITECUSTOMERID, BILL.STATEMENTSTARTDATE, BILL.STATEMENTENDDATE, SM.ISSMARTENABLED, SM.ISSMARTCAPABLE, SM.SMETSVERSION, con.BILLSTATUS from BILLINGCOMMON.BILLINGSTATEMENT BILL inner join CONTRACTS.CONTRACTS_VW con on con.MULTISITECONTRACT = BILL.MULTISITECONTRACT inner join SMARTMETERS.SUMMARY_INFORMATION SM on SM.MPXN = con.MPANCORE where BILL.STATEMENTENDDATE < SYSDATE and BILL.STATEMENTSTARTDATE > SYSDATE - 80 and SM.ISSMARTENABLED = 'T' and con.BILLSTATUS = lower('supplyactive_normal') and SM.SMETSVERSION = 'SMETS1';

--Gas
SELECT BILL.STATEMENTNUMBER , SM.MPXN AS MPRN, SM.COMMODITYTYPE, CON.MULTISITECUSTOMERID, BILL.STATEMENTSTARTDATE, BILL.STATEMENTENDDATE, SM.ISSMARTENABLED, SM.ISSMARTCAPABLE, SM.SMETSVERSION, CON.BILLSTATUS FROM BILLINGCOMMON.BILLINGSTATEMENT BILL INNER JOIN GASCONTRACTS.CONTRACT_VW CON ON CON.MULTISITECONTRACT = BILL.MULTISITECONTRACT INNER JOIN SMARTMETERS.SUMMARY_INFORMATION SM ON SM.MPXN = CON.UPAN WHERE BILL.STATEMENTENDDATE < SYSDATE AND BILL.STATEMENTSTARTDATE > SYSDATE - 80 AND SM.ISSMARTENABLED = 'T' AND CON.BILLSTATUS = UPPER('REGISTRATION') AND SM.SMETSVERSION = 'SMETS1';

--Statement Start Date
SELECT STATEMENTSTARTDATE FROM BILLINGCOMMON.BILLINGSTATEMENT WHERE STATEMENTNUMBER = :STATEMENTNUMBER;

--Electricity for the +5 days meter reading test
select 0, '<registerReads exportDateTime="'||(select TO_CHAR(SYSDATE, 'YYYY-MM-DD') from DUAL)||'T00:00:00Z" participantCode="COOP" roleDescription="Supplier">' from DUAL union
select 1, '<meterPoint supplierCode="COOP">' from DUAL union
select 2, '<mpxn>'||:MPXN||'</mpxn>' from DUAL union
select 3, '<meterSerialNo>'||(select METERID from MPANCORES.ALLMPANCORES_MOD where MPANCORE = :MPXN and rownum = 1)||'</meterSerialNo>' from DUAL union
select 5, '<commodity>Electricity</commodity>' from DUAL union
select 6, '<reads registerID="RATE_1" UOM="kWh">' from DUAL union
select 7, '<read>' from DUAL union
select 8, '<readDateTime>'||(select STATEMENTSTARTDATE from BILLINGCOMMON.BILLINGSTATEMENT WHERE STATEMENTNUMBER = :STATEMENTNUMBER)||'T00:00:00Z</readDateTime>' from DUAL union
select 9, '<readValue>'||:reading||'</readValue>' from DUAL union
select 10,'<readType>R</readType>' from DUAL union
select 11,'</read>' from DUAL union
select 12,'</reads>' from DUAL union
select 13,'</meterPoint>' from DUAL union
select 14,'</registerReads>' from DUAL;

--Gas
select 0, '<registerReads exportDateTime="'||(select TO_CHAR(SYSDATE, 'YYYY-MM-DD') from DUAL)||'T00:00:00Z" participantCode="COOP" roleDescription="Supplier">' from DUAL union
select 1, '<meterPoint supplierCode="COOP">' from DUAL union
select 2, '<mpxn>'||:MPXN||'</mpxn>' from DUAL union
select 3, '<meterSerialNo>'||(select MSN from GASBILLING.ESTIMATEDMETERREADINGS_VW where MPRN = :MPXN AND ROWNUM = 1)||'</meterSerialNo>' from DUAL UNION
select 4, '<commodity>Gas</commodity>' from DUAL union
select 5, '<reads registerID="TOTAL" UOM="kWh">' from DUAL union
select 6, '<read>' from DUAL union
select 7, '<readDateTime>'||(select STATEMENTSTARTDATE from BILLINGCOMMON.BILLINGSTATEMENT WHERE STATEMENTNUMBER = :STATEMENTNUMBER)||'T00:00:00Z</readDateTime>' from DUAL UNION
select 8, '<readValue>'||:Meterreading||'</readValue>' from DUAL union
select 9,'<readType>R</readType>' from DUAL union
select 10,'</read>' from DUAL union
select 11,'</reads>' from DUAL union
select 12,'</meterPoint>' from DUAL union
select 13,'</registerReads>' from DUAL;

--Filename
SELECT 'LCMG_COOP_I017_'||TO_CHAR(SYSDATE,'YYYYMMDDHH')||'0'||TO_CHAR(DBMS_RANDOM.VALUE(000,999),'FM000')||'.XML' FROM DUAL;

--Check the Meter Reading is in the Table:

--ELECTRICITY
select * from BILLING.NHHESTIMATEDMETERREADINGS where MPANCORE = :MPXN;

SELECT * FROM CONTRACTS.CONTRACTS_VW WHERE MPANCORE = :MPXN;

--GAS
select * from GASBILLING.ESTIMATEDMETERREADINGS_VW where MPRN = :MPRN;

select * from GASCONTRACTS.CONTRACT_VW where UPAN = :MPRN;

