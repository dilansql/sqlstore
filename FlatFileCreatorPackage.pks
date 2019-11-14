create or replace package                            FLATFILECREATOR AS

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--GAS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

FUNCTION GAS_M96 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
function GAS_NOSI (PMPRN in number) return GM_MANAGER.TABLEOFVARCHAR2;

FUNCTION GAS_ONJOB_EXCHANGE (PMPRN IN NUMBER, PINSTALLEDSERIAL IN VARCHAR2, PREMOVEDSERIAL IN VARCHAR2) RETURN GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_ONJOB_INSTALL (PMPRN IN NUMBER, PINSTALLEDSERIAL IN VARCHAR2) RETURN GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_ONJOB_REMOVE (PMPRN IN NUMBER, PREMOVEDSERIAL IN VARCHAR2) RETURN GM_MANAGER.TABLEOFVARCHAR2;
function GAS_ONUPD (PMPRN in number) return GM_MANAGER.TABLEOFVARCHAR2;
--FUNCTION GAS_ORJOB (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;

FUNCTION GAS_RD1 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_REJFL (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
function GAS_RNAGE (PMPRN in number) return GM_MANAGER.TABLEOFVARCHAR2;

FUNCTION GAS_RS1 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_RS2 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
function GAS_RS3 (PMPRN in number) return GM_MANAGER.TABLEOFVARCHAR2;

FUNCTION GAS_S07 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_S08 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
function GAS_S10 (PMPRN in number) return GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_S12 (PMPRN IN NUMBER, OUTCOME IN VARCHAR2) RETURN GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_S13 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_S14 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_S15 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_S16 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_S26 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_S30 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_S63 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
FUNCTION GAS_S65 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
function GAS_S88 (PMPRN in number) return GM_MANAGER.TABLEOFVARCHAR2;

FUNCTION GAS_T06 (PMPRN IN NUMBER, OUTCOME_CODE IN VARCHAR2) RETURN GM_MANAGER.TABLEOFVARCHAR2;
function GAS_T07 (PMPRN in number) return GM_MANAGER.TABLEOFVARCHAR2;

FUNCTION GAS_U02 (PMPRN IN NUMBER) RETURN GM_MANAGER.TABLEOFVARCHAR2;
function GAS_U03 (PMPRN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function GAS_U04 (PMPRN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function GAS_U06 (PMPRN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function GAS_U10 (PMPRN in number) return GM_MANAGER.TABLEOFVARCHAR2;

function GAS_RET (PMPRN in number, METER_READING in number) return GM_MANAGER.TABLEOFVARCHAR2;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ELEC
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--function ELEC_D0010 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0011B (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0011D (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0011M (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0036 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0057 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0058 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0065 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0066 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0067 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0068 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0090 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0091 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0092 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0093 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0149 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0150 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0171 (PMPAN in number, SPX IN VARCHAR) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0217 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0217_58M (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
--function ELEC_D0260 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0359 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0360 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0361 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
function ELEC_D0367 (PMPAN in number) return GM_MANAGER.TABLEOFVARCHAR2;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--PAY
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function CRDPAY (BILLINGPAYMENTID in number) return GM_MANAGER.TABLEOFVARCHAR2;
function BNKPAY (BILLINGPAYMENTID in number, PAYMENTYPE IN VARCHAR2) return GM_MANAGER.TABLEOFVARCHAR2;
function NORDPAY_DEBIT (BILLINGPAYMENT_ID in number, FUEL in char) return GM_MANAGER.TABLEOFVARCHAR2;
function NORDPAY_CREDIT (BILLINGPAYMENT_ID in number, FUEL in char) return GM_MANAGER.TABLEOFVARCHAR2;
function BACSPAY (BILLINGPAYMENTID in number) return GM_MANAGER.TABLEOFVARCHAR2;
function BACSCHRG (BILLINGPAYMENTID in number) return GM_MANAGER.TABLEOFVARCHAR2;
function NORDREF (BILLINGPAYMENTID in number) return GM_MANAGER.TABLEOFVARCHAR2;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

end FLATFILECREATOR;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------