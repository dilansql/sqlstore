CREATE OR REPLACE FUNCTION TESTING.CreateFile (
   pIdentifier    IN VARCHAR2,
   FILECONTENTS   in GM_MANAGER.TABLEOFVARCHAR2,
   FILEEXTENSION  in varchar2 default 'txt')
RETURN VARCHAR2 IS
   vFile       UTL_FILE.file_type;
   VFILENAME   varchar2 (60);
   DBNAME 	   varchar2(10);
begin
	
   DBNAME:= UPPER(sys_context('USERENV','DB_NAME'));
   
   DBMS_OUTPUT.put_line ('testing');

   SELECT    pIdentifier
          || '_'
          || TO_CHAR (SYSTIMESTAMP, 'HH24MISS')
          || '_'
          || TO_CHAR (SYSDATE, 'yyyyMMdd')
		  || '.'
          || FileExtension
     INTO vFileName
     FROM DUAL;

   vFile :=
      UTL_FILE.fopen ('APP_LOGS_DIR',
                      vFileName,
                      'W',
                      32767);

   FOR I IN 1..FileContents.COUNT
   LOOP
      UTL_FILE.put_line (vFile, FileContents(I));
   END LOOP;

   UTL_FILE.FCLOSE (VFILE);
   RETURN 'File  created  as  '||VFILENAME||'   in  \\GILMOND-'||DBNAME||'\Application_logs';
END CreateFile;