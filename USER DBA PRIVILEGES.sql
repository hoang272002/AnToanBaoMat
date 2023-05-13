--- TAO ROLE PHAN HE 01
CREATE ROLE QUANTRI;
CREATE USER U_DBA IDENTIFIED BY 123456;
GRANT CREATE SESSION TO U_DBA;
GRANT QUANTRI TO U_DBA;
GRANT DBA TO U_DBA;
GRANT SELECT, UPDATE, DELETE, INSERT ON SCHEMA_USER.NHANVIEN TO U_DBA WITH GRANT OPTION;
GRANT SELECT, UPDATE, DELETE, INSERT ON SCHEMA_USER.PHONGBAN TO U_DBA WITH GRANT OPTION;
GRANT SELECT, UPDATE, DELETE, INSERT ON SCHEMA_USER.DEAN TO U_DBA WITH GRANT OPTION;
GRANT SELECT, UPDATE, DELETE, INSERT ON SCHEMA_USER.PHANCONG TO U_DBA WITH GRANT OPTION;
/
-------------------------------------------------------------
--- XEM DANH SACH NGUOI DUNG TRONG HE THONG
CREATE OR REPLACE PROCEDURE U_DBA.LIST_USERS 
(C_LIST OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN C_LIST FOR 
        SELECT username as MANV,created FROM all_users;
END;
/

---------------------------------------

--
GRANT SELECT ON DBA_ROLES TO U_DBA;
/
-- XEM DANH SACH ROLE TRONG HE THONG
CREATE OR REPLACE PROCEDURE U_DBA.LIST_ROLES 
(R_LIST OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN R_LIST FOR 
        SELECT ROLE, ROLE_ID, COMMON, INHERITED, IMPLICIT FROM SYS.DBA_ROLES;
END;
/
---------------------------------------

/
--------------------------------------------------------------------------
--- THONG TIN VE QUYEN CUA ROLE TREN CAC DOI TUONG DU LIEU
CREATE OR REPLACE PROCEDURE U_DBA.ROLE_PRIVILEGES_TAB 
(ROLE_NAME IN VARCHAR2, R_LSTS OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN R_LSTS FOR
        SELECT * FROM ROLE_TAB_PRIVS WHERE ROLE = ROLE_NAME;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ROLE ' || ROLE_NAME || ' NOT FOUND');
END;
/
--------------------------------------------------------------------------
--- [THONG TIN VE QUYEN CUA USER TREN CAC DOI TUONG DU LIEU] 
-- THONG TIN VE QUYEN ROLE CUA USER TREN CAC DOI TUONG DL 
GRANT SELECT ON dba_role_privs TO U_DBA;
/
CREATE OR REPLACE PROCEDURE U_DBA.ROLE_USER_TAB 
(MANV IN CHAR, R_LISTS OUT SYS_REFCURSOR)
IS

BEGIN 
    OPEN R_LISTS FOR
        SELECT GRANTEE, GRANTED_ROLE, ADMIN_OPTION,DEFAULT_ROLE, ROLE, TABLE_NAME, COLUMN_NAME, PRIVILEGE
        FROM dba_role_privs R,  ROLE_TAB_PRIVS P
        WHERE R.grantee = MANV AND R.GRANTED_ROLE = P.ROLE; 
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
         NULL;
END;
/
-- THONG TIN VE QUYEN RIENG BIET CUA USER
GRANT SELECT ON DBA_TAB_PRIVS TO U_DBA;
/
CREATE OR REPLACE PROCEDURE U_DBA.PR_USER_TAB 
(MANV IN CHAR, R_LISTS OUT SYS_REFCURSOR)
IS

BEGIN 
    OPEN R_LISTS FOR
        SELECT * 
        FROM DBA_TAB_PRIVS 
        WHERE GRANTEE = MANV; 
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
         NULL;
END;
/
---------------------------------------------------------------------------------------
-- HAM KIEM TRA MA SO NHAN VIEN
CREATE OR REPLACE FUNCTION U_DBA.check_valid_string(p_string IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
  IF LENGTH(p_string) != 4 THEN
    RETURN FALSE;
  END IF;
  
  FOR i IN 1..LENGTH(p_string) LOOP
    IF NOT REGEXP_LIKE(SUBSTR(p_string, i, 1), '^\d+$') THEN
      RETURN FALSE;
    END IF;
  END LOOP;
  
  RETURN TRUE;
END;
/

-- TAO USER
CREATE OR REPLACE PROCEDURE U_DBA.CREATE_USER
(
    MANV IN CHAR,
    NEW_PASS IN VARCHAR2,
    RE_VAL OUT INT -- KET QUA TRA VE
)
IS 
    user_exists INT;
BEGIN 
    SELECT COUNT(*) INTO user_exists FROM DBA_USERS WHERE USERNAME = MANV;
    
    IF(user_exists > 0 OR LENGTH(NEW_PASS) = 0) THEN
        RE_VAL := 0; -- TAI KHOAN DA TON TAI
    ELSE
        IF(U_DBA.CHECK_VALID_STRING(MANV)) THEN
            IF(CHECK_VALID_STRING(NEW_PASS)) THEN
                EXECUTE IMMEDIATE 'CREATE USER ' || '"' || MANV || '"' || ' IDENTIFIED BY ' || '"' ||  NEW_PASS || '"';
            ELSE 
                EXECUTE IMMEDIATE 'CREATE USER ' || '"' || MANV || '"' || ' IDENTIFIED BY ' ||  NEW_PASS;
            END IF;
            
         ELSE 
            IF(CHECK_VALID_STRING(NEW_PASS)) THEN
                EXECUTE IMMEDIATE 'CREATE USER ' || MANV || '"' || ' IDENTIFIED BY ' ||  NEW_PASS || '"';
            ELSE 
                EXECUTE IMMEDIATE 'CREATE USER ' || MANV || ' IDENTIFIED BY ' ||  NEW_PASS;
            END IF;
        END IF;
        RE_VAL := 1;
    END IF;
END;
/
GRANT SELECT ON DBA_USERS TO U_DBA;
/
---- XOA USER
CREATE OR REPLACE PROCEDURE U_DBA.DELETE_USER
(
    MANV IN CHAR,
    DEL_VAL OUT INT -- KET QUA TRA VE
)
IS 
    l_user_exists NUMBER;
BEGIN 
    SELECT COUNT(*) INTO l_user_exists FROM DBA_USERS WHERE USERNAME = MANV;
    IF l_user_exists > 0 THEN
        EXECUTE IMMEDIATE 'DROP USER ' || MANV  || ' CASCADE';
        DEL_VAL := 1;
    ELSE
        DEL_VAL := 0;
    END IF;
END;
/
---- DOI PASSWORD
CREATE OR REPLACE PROCEDURE U_DBA.CHANGE_PASSWORD(
    p_username IN VARCHAR2,
    p_new_password IN VARCHAR2,
    p_user_role IN VARCHAR2 DEFAULT 'USER'
) IS
BEGIN
    IF p_user_role = 'USER' THEN
        EXECUTE IMMEDIATE 'ALTER USER ' || p_username || ' IDENTIFIED BY ' || p_new_password;
    ELSIF p_user_role = 'ROLE' THEN
        EXECUTE IMMEDIATE 'ALTER ROLE ' || p_username || ' IDENTIFIED BY ' || p_new_password;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Invalid user role specified');
    END IF;
END;
/
-----------------------------------------------------------------------------------------------
/*
--- CAP QUYEN CHO USER/ROLE
CREATE OR REPLACE PROCEDURE U_DBA.GRANT_PRIVILEGE(
    p_grantee IN VARCHAR2, -- USER HOAC ROLE NHAN QUYEN
    p_privilege IN VARCHAR2, -- QUYEN DUOC CAP (SELECT, INSERT, UPDATE, DELETE)
    p_object IN VARCHAR2, -- TEN CUA BANG, VIEW HOAC PROCEDURE
    p_columns IN VARCHAR2 DEFAULT NULL, --DANH SACH CAC COT UPDATE <UPDATE, SELECT>
    p_grant_option IN BOOLEAN DEFAULT FALSE -- CHO PHEP CAP QUYEN NGUOI KHAC HAY KHONG
    )
    IS
        sql_stmt VARCHAR2(200);
    BEGIN
    IF p_privilege = 'SELECT' THEN
        -- Create view with specified columns
        sql_stmt := 'CREATE OR REPLACE VIEW ' || p_object || p_grantee|| '_VIEW AS SELECT ' || p_columns || ' FROM ' || p_object;
            EXECUTE IMMEDIATE (sql_stmt);
        -- Grant select privilege to grantee
        sql_stmt := 'GRANT SELECT ON ' || p_object || p_grantee || '_VIEW' || ' TO ' || '"' || p_grantee || '"' || 
            CASE WHEN p_grant_option THEN ' WITH GRANT OPTION' ELSE '' END;
        EXECUTE IMMEDIATE (sql_stmt);
    ELSIF p_privilege = 'UPDATE' THEN
        sql_stmt := 'GRANT ' || p_privilege || '(' || p_columns || ')' || ' ON ' || p_object || ' TO ' || '"' || p_grantee || '"' ||
            CASE WHEN p_grant_option THEN ' WITH GRANT OPTION' ELSE '' END;
        EXECUTE IMMEDIATE (sql_stmt);
    ELSE
        sql_stmt := 'GRANT ' || p_privilege || ' ON ' || p_object || ' TO ' || '"' || p_grantee || '"' ||
            CASE WHEN p_grant_option THEN ' WITH GRANT OPTION' ELSE '' END;
        EXECUTE IMMEDIATE (sql_stmt);
    END IF;
END;
*/
/
CREATE OR REPLACE PROCEDURE U_DBA.GRANT_PRIVILEGE(
    p_grantee IN VARCHAR2, -- USER HOAC ROLE NHAN QUYEN
    p_privilege IN VARCHAR2, -- QUYEN DUOC CAP (SELECT, INSERT, UPDATE, DELETE)
    p_object IN VARCHAR2, -- TEN CUA BANG, VIEW HOAC PROCEDURE
    p_columns IN VARCHAR2 DEFAULT NULL, --DANH SACH CAC COT UPDATE <UPDATE, SELECT>
    p_grant_option IN BOOLEAN DEFAULT FALSE -- CHO PHEP CAP QUYEN NGUOI KHAC HAY KHONG
    )
    IS
        sql_stmt VARCHAR2(200);
    BEGIN
    IF p_privilege = 'SELECT' THEN
        -- Create view with specified columns
        sql_stmt := 'CREATE OR REPLACE VIEW ' || p_object || p_grantee|| '_VIEW AS SELECT ' || p_columns || ' FROM ' || p_object;
            EXECUTE IMMEDIATE (sql_stmt);
        -- Grant select privilege to grantee
        sql_stmt := 'GRANT SELECT ON ' || p_object || p_grantee || '_VIEW' || ' TO ' || '"' || p_grantee || '"' || 
            CASE WHEN p_grant_option THEN ' WITH GRANT OPTION' ELSE '' END;
        EXECUTE IMMEDIATE (sql_stmt);
    ELSIF p_privilege = 'UPDATE' THEN
        sql_stmt := 'GRANT ' || p_privilege || '(' || p_columns || ')' || ' ON ' || p_object || ' TO ' || '"' || p_grantee || '"' ||
            CASE WHEN p_grant_option THEN ' WITH GRANT OPTION' ELSE '' END;
        EXECUTE IMMEDIATE (sql_stmt);
    ELSE
        sql_stmt := 'GRANT ' || p_privilege || ' ON ' || p_object || ' TO ' || '"' || p_grantee || '"' ||
            CASE WHEN p_grant_option THEN ' WITH GRANT OPTION' ELSE '' END;
        EXECUTE IMMEDIATE (sql_stmt);
    END IF;
END;
/
--- GRANT ROLE CHO USER
CREATE OR REPLACE PROCEDURE U_DBA.GRANT_ROLE_TO_USER(
  p_user IN VARCHAR2,
  p_role IN VARCHAR2,
  p_grant_option IN BOOLEAN DEFAULT FALSE
) IS
BEGIN
  EXECUTE IMMEDIATE 'GRANT ' || p_role || ' TO ' || '"' || p_user  || '"' ||
                    CASE WHEN p_grant_option THEN ' WITH ADMIN OPTION' ELSE '' END;
END;
/
CREATE OR REPLACE PROCEDURE U_DBA.REVOKE_PRIVILEGE(
  p_revokee IN VARCHAR2, -- user hoac role bi thu hoi
  p_privilege IN VARCHAR2, -- quyen bi thu hoi (SELECT, INSERT, UPDATE, DELETE)
  p_object IN VARCHAR2 -- ten cua bang hoac procedure
) IS
BEGIN
  EXECUTE IMMEDIATE 'REVOKE ' || p_privilege || ' ON ' || p_object || ' FROM ' || '"' || p_revokee || '"';
END;
/
---- SELECT ROLE
CREATE OR REPLACE PROCEDURE U_DBA.GET_ALL_ROLES(p_roles OUT SYS_REFCURSOR) AS
BEGIN
  OPEN p_roles FOR SELECT ROLE FROM dba_roles WHERE INHERITED = 'NO'; 
END;

/
------- CAP QUYEN THUC THI 
GRANT DROP USER TO QUANTRI;
GRANT CREATE SESSION TO QUANTRI;
GRANT CREATE SESSION TO U_DBA;
/
CREATE OR REPLACE PROCEDURE U_DBA.get_column_names(
  p_table_name IN VARCHAR2,
  p_column_names OUT SYS_REFCURSOR
)
AS
  l_query VARCHAR2(4000);
BEGIN
  l_query := 'SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME = :table_name';
  OPEN p_column_names FOR l_query USING p_table_name;
END;
/
GRANT GRANT ANY OBJECT PRIVILEGE TO U_DBA;
/
GRANT SELECT ON SCHEMA_USER.PHONGBAN TO U_DBA WITH GRANT OPTION;
/


/
GRANT SELECT ON SCHEMA_USER.NHANVIEN TO U_DBA WITH GRANT OPTION;

/
GRANT SELECT ON SCHEMA_USER.DEAN TO U_DBA WITH GRANT OPTION;

/
GRANT SELECT ON SCHEMA_USER.PHANCONG TO U_DBA WITH GRANT OPTION;

/

CREATE OR REPLACE PROCEDURE U_DBA.REVOKE_PRIVILEGE(
  p_revokee IN VARCHAR2, -- user hoac role bi thu hoi
  p_privilege IN VARCHAR2, -- quyen bi thu hoi (SELECT, INSERT, UPDATE, DELETE)
  p_object IN VARCHAR2 -- ten cua bang hoac procedure
) IS
BEGIN
  EXECUTE IMMEDIATE 'REVOKE ' || p_privilege || ' ON ' || p_object || ' FROM ' || '"' || p_revokee || '"';
END;
/
---- TAO USER
---
-- Th?c thi procedure t?o user

GRANT CREATE USER TO U_DBA;
GRANT DROP USER TO U_DBA;
GRANT SELECT ON DBA_USERS TO U_DBA;
/
-- THONG TIN VE QUYEN RIENG BIET THEO COT
-- THONG TIN VE QUYEN RIENG BIET CUA USER
GRANT SELECT ON DBA_COL_PRIVS TO U_DBA;
/
CREATE OR REPLACE PROCEDURE U_DBA.PR_USER_TAB_COL 
(MANV IN CHAR, R_LISTS OUT SYS_REFCURSOR)
IS

BEGIN 
    OPEN R_LISTS FOR
        SELECT * 
        FROM DBA_COL_PRIVS 
        WHERE GRANTEE = MANV; 
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
         NULL;
END;
/

--XEM THONG TIN CAC BANG TRONG HE THONG
CREATE OR REPLACE PROCEDURE U_DBA.LIST_TABLES(p_cursor OUT SYS_REFCURSOR) IS
BEGIN
    OPEN p_cursor FOR SELECT TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME FROM user_tables;
END LIST_TABLES;
/
--XEM THONG TIN CAC VIEW TRONG HE THONG
CREATE OR REPLACE PROCEDURE U_DBA.LIST_VIEWS(p_cursor OUT SYS_REFCURSOR) IS
BEGIN
    OPEN p_cursor FOR SELECT view_name, text_length, read_only, container_data, origin_con_id FROM user_views;
END LIST_VIEWS;

