--Implementation: EXECUTE TESTING.SMETS2GASCUSTOMER;
create or replace
procedure TESTING.SMETS2GASCUSTOMER as

    VMPXN SMARTMETERS.SUMMARY_INFORMATION.MPXN%TYPE;
    SMROW SMARTMETERS.SUMMARY_INFORMATION.SMETSVERSION%type;
    VFUEL SMARTMETERS.SUMMARY_INFORMATION.COMMODITYTYPE%type;
    VCUST GASCONTRACTS.CONTRACT_VW.CUSTOMERID%type;
    ADDR PRICINGCOMMON.QUOTECUSTOMERS.ADDRESSLINE1%type;
    ADD2 PRICINGCOMMON.QUOTECUSTOMERS.ADDRESSLINE2%type;
    POST PRICINGCOMMON.QUOTECUSTOMERS.POSTCODE%type;
    GUID INT;
begin
    select TO_CHAR(DBMS_RANDOM.VALUE(00000,99999),'FM00000') INTO GUID from dual;
    SELECT MPXN INTO VMPXN FROM SMARTMETERS.SUMMARY_INFORMATION WHERE ISSMARTENABLED = 'T' AND SMETSVERSION = 'SMETS1' AND ROWNUM = 1 AND COMMODITYTYPE = 'G' ORDER BY DBMS_RANDOM.VALUE;
    update SMARTMETERS.SUMMARY_INFORMATION set SMETSVERSION = 'SMETS2' where ISSMARTENABLED = 'T' and MPXN = VMPXN;
    update PRICINGCOMMON.QUOTECUSTOMERS set ADDRESSLINE1 = '42 HUNTFIELD ROAD', ADDRESSLINE2 = 'BOURNEMOUTH', POSTCODE = 'BH9 3HN' where CUSTOMERID = VCUST;
    select SMETSVERSION into SMROW from SMARTMETERS.SUMMARY_INFORMATION where MPXN = VMPXN;
    select COMMODITYTYPE into VFUEL from SMARTMETERS.SUMMARY_INFORMATION where MPXN = VMPXN;
    SELECT CUSTOMERID INTO VCUST FROM GASCONTRACTS.CONTRACT_VW WHERE UPAN = VMPXN AND ROWNUM = 1;
    update PRICINGCOMMON.QUOTECUSTOMERS set ADDRESSLINE1 = '42 HUNTFIELD ROAD', ADDRESSLINE2 = 'BOURNEMOUTH', POSTCODE = 'BH9 3HN' where CUSTOMERID = VCUST;
    select ADDRESSLINE1 into ADDR from PRICINGCOMMON.QUOTECUSTOMERS where CUSTOMERID = upper(VCUST);
    SELECT ADDRESSLINE2 INTO ADD2 FROM PRICINGCOMMON.QUOTECUSTOMERS WHERE CUSTOMERID = UPPER(VCUST);
    select POSTCODE into POST from PRICINGCOMMON.QUOTECUSTOMERS where CUSTOMERID = upper(VCUST);
delete from SMARTMETERS.SMETS1_METER_HISTORY where MPXN = VMPXN;

    DBMS_OUTPUT.put_line('{' ||chr(10)|| '    "deviceId": "BF-B0-91-0B-83-0D-45-A6",'  ||chr(10)|| '    "mpxn": "'||VMPXN||'",'   ||chr(10)|| '    "secondaryMpan": null,'   ||chr(10)|| '    "paymentMode": "Credit",'     ||chr(10)|| '    "deviceType": "GSME",'    ||chr(10)|| '    "property": {'
    ||chr(10)|| '      "uprn": 10034525421,'   ||chr(10)|| '      "address": "'||ADDR||'",'   ||chr(10)|| '      "postcode": "'||POST||'"'   ||chr(10)|| '    },'   ||chr(10)|| '    "status": "Whitelisted",'     ||chr(10)|| '    "deviceVersion": "V2.0",'
    ||chr(10)|| '    "firmwareVersionStatus": "Active",'   ||chr(10)|| '    "cplStatus": "Active",'   ||chr(10)|| '    "manufacturer": "Gilmond",'   ||chr(10)|| '    "model": "A55A0001",'     ||chr(10)|| '    "cspRegion": "North",'
    ||chr(10)|| '    "variant": null,'     ||chr(10)|| '    "dateCommissioned": "2019-04-24T10:31:13.7926167",'   ||chr(10)|| '    "firmwareVersion": "7.1.0.8",'    ||chr(10)|| '    "installCode": "77DD9808D3964C9D9E744103ED0CDC8B"'
    ||chr(10)|| '  }'  ||chr(10)|| ' ' );
    DBMS_OUTPUT.put_line('{' ||chr(10)|| '    "deviceId": "E4-4A-D3-DE-C0-4B-44-1A",'  ||chr(10)|| '    "mpxn": "'||VMPXN||'",'   ||chr(10)|| '    "secondaryMpan": null,'   ||chr(10)|| '    "paymentMode": "Credit",'     ||chr(10)|| '    "deviceType": "CHF",'     ||chr(10)|| '    "property": {'
    ||chr(10)|| '      "uprn": 10034525421,'   ||chr(10)|| '      "address": "'||ADDR||'",'   ||chr(10)|| '      "postcode": "'||POST||'"'   ||chr(10)|| '    },'   ||chr(10)|| '    "status": "Whitelisted",'     ||chr(10)|| '    "deviceVersion": "V2.0",'
    ||chr(10)|| '    "firmwareVersionStatus": "Active",'   ||chr(10)|| '    "cplStatus": "Active",'   ||chr(10)|| '    "manufacturer": "Gilmond",'   ||chr(10)|| '    "model": "A55A0001",'     ||chr(10)|| '    "cspRegion": "North",'
    ||chr(10)|| '    "variant": null,'     ||chr(10)|| '    "dateCommissioned": "2019-04-24T10:31:13.7926167",'   ||chr(10)|| '    "firmwareVersion": "7.1.0.8",'    ||chr(10)|| '    "installCode": "77DD9808D3964C9D9E744103ED0CDC8B"'
    ||chr(10)|| '  }'  ||chr(10)|| ' ' );
    DBMS_OUTPUT.put_line( ADDR  ||chr(10)|| ADD2   ||chr(10)|| POST   ||chr(10)|| VCUST  ||chr(10)||  VMPXN     ||chr(10)||  SMROW     ||chr(10)||  VFUEL );
commit;
end;
