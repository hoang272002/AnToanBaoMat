BEGIN
    sa_sysdba.drop_policy(policy_name => 'region_policy', drop_column => true);
END; 
/
BEGIN
    sa_sysdba.create_policy(policy_name => 'region_policy', column_name => 'region_label', default_options => 'read_control, update_control'
    );
END; 
/ 
EXEC SA_SYSDBA.ENABLE_POLICY ('region_policy');
/
--- TAO LEVEL
EXECUTE SA_COMPONENTS.CREATE_LEVEL('region_policy',60,'GD','GIAM DOC'); 
/
EXECUTE SA_COMPONENTS.CREATE_LEVEL('region_policy',40,'TP','TRUONG PHONG'); 
/
EXECUTE SA_COMPONENTS.CREATE_LEVEL('region_policy',20,'NV','NHAN VIEN'); 
/
--- COMPARTMENT
EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('region_policy',100,'MB','MUA BAN'); 
/
EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('region_policy',120,'SX','SAN XUAT');
/
EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('region_policy',140,'GC','GIA CONG');
/
--- TAO GROUP 
EXECUTE SA_COMPONENTS.CREATE_GROUP('region_policy',20,'R20','REGION NORTH'); 
/
EXECUTE SA_COMPONENTS.CREATE_GROUP('region_policy',40,'R40','REGION SOUTH'); 
/
EXECUTE SA_COMPONENTS.CREATE_GROUP('region_policy',60,'R60','REGION CENTRAL');
/
EXECUTE SA_USER_ADMIN.SET_USER_PRIVS('region_policy','ols_test1','FULL,PROFILE_ACCESS'); 
/
BEGIN
    EXECUTE sa_policy_admin.remove_table_policy('REGION_POLICY', 'OLS_TEST1', 'THONGBAO');
    EXECUTE sa_policy_admin.apply_table_policy(policy_name => 'REGION_POLICY', schema_name => 'OLS_TEST1', table_name => 'THONGBAO', table_options => 'READ_CONTROL,WRITE_CONTROL,CHECK_CONTROL');
END;
/ 
--- CHON GIAM DOC
--- GIAM DOC MA N345

BEGIN
    sa_policy_admin.enable_table_policy(policy_name => 'REGION_POLICY', schema_name => 'OLS_TEST1', table_name => 'THONGBAO');
END;

BEGIN
    sa_user_admin.set_user_labels('region_policy', 'N345', 'GD:MB,SX,GC:R20,R40,R60'); --- GIAM DOC MOI CHI NHANH MOI LINH VUC MOI MIEN

    sa_user_admin.set_user_labels('region_policy', 'N325', 'TP:SX:R40'); -- TRUONG PHONG SAN XUAT O CHI NHANH MIEN NAM
    sa_user_admin.set_user_labels('region_policy', 'N349', 'GD:MB,SX,GC:R20'); -- GIAM DOC QUAN LY MUA BAN-SAN XUAT-GIA CONG O MIEN BAC
    sa_user_admin.set_user_labels('region_policy', 'N324', 'TP:SX:R60'); -- TRUONG PHONG LINH VUC SAN XUAT MIEN TRUNG
    sa_user_admin.set_user_labels('region_policy', 'N323', 'TP:SX:R40'); -- TRUONG PHONG LINH VUC SAN XUAT MIEN NAM
    sa_user_admin.set_user_labels('region_policy', 'N004', 'NV:SX:R40'); -- NHAN VIEN SAN XUAT MIEN NAM   
    sa_user_admin.set_user_labels('region_policy', 'N005', 'NV:MB:R40'); -- NHAN VIEN MUA BAN MIEN NAM
    sa_user_admin.set_user_labels('region_policy', 'N006', 'NV:GC:R40'); -- NHAN VIEN GIA CONG MIEN NAM
END;
/ 

BEGIN 
sa_user_admin.set_user_labels('region_policy', 'N324', 'TP:SX:R60'); -- TRUONG PHONG LINH VUC SAN XUAT MIEN TRUNG
END;
BEGIN 
        sa_user_admin.set_user_labels('region_policy', 'N322', 'TP:SX:R40'); -- NHAN VIEN GIA CONG MIEN NAM
END;

/
BEGIN
   SA_USER_ADMIN.SET_USER_PRIVS (
      policy_name => 'region_policy',
      user_name   => 'N345',
      privileges  => 'READ');
END;

EXECUTE SA_USER_ADMIN.SET_USER_PRIVS('region_policy','OLS_TEST1','FULL,PROFILE_ACCESS'); 
INSERT INTO OLS_TEST1.THONGBAO(THONGBAO) VALUES('Helladad');
INSERT INTO OLS_TEST1.THONGBAO(THONGBAO, NGAYTB, REGION_LABEL) VALUES('CAC02', TO_CHAR(sysdate), CHAR_TO_LABEL('region_policy', 'TP'));
INSERT INTO SCHEMA_USER.THONGBAO(THONGBAO, NGAYTB, MANV) VALUES('HELLOWORLD', TO_CHAR(sysdate), 'N325' );
UPDATE SCHEMA_USER.THONGBAO SET REGION_LABEL = CHAR_TO_LABEL('region_policy', 'TP' ) WHERE MATB = 32;
INSERT INTO SCHEMA_USER.THONGBAO(THONGBAO, NGAYTB, MANV, REGION_LABEL) VALUES('Hello world adadad', TO_CHAR(sysdate), 'N325', CHAR_TO_LABEL('region_policy', 'GD::'));
INSERT INTO SCHEMA_USER.THONGBAO(THONGBAO, NGAYTB, MANV, REGION_LABEL) VALUES('Hello world adadad', TO_CHAR(sysdate), 'N325', CHAR_TO_LABEL('region_policy', 'GD:SX: R40'));
SELECT THONGBAO,LABEL_TO_CHAR(REGION_LABEL) FROM OLS_TEST1.THONGBAO;
commit;