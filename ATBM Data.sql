-- TAO DU LIEU CHO BAN NHAN VIEN
CREATE OR REPLACE PROCEDURE SCHEMA_USER.THEM_DU_LIEU_NV AS
BEGIN
  FOR i IN 1..300 LOOP
    INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan)
    VALUES ('N'||LPAD(i,3,'0'), 'Nguoi dung ' || i, 'Nam', DATE '1990-01-01', 'Dia Chi so ' || i, '0123456789', 10000000, 0, 'NV', NULL, NULL);
  END LOOP;
  COMMIT;
END;
/

BEGIN
    SCHEMA_USER.THEM_DU_LIEU_NV;
END;
/
-- THEM QUAN LY
CREATE OR REPLACE PROCEDURE SCHEMA_USER.THEM_DU_LIEU_QL AS
BEGIN
  FOR i IN 301..321 LOOP
    INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan)
    VALUES ('N'||LPAD(i,3,'0'), 'Nguoi dung ' || i, 'Nam', DATE '1990-01-01', 'Dia Chi so ' || i, '0123456789', 10000000, 0, 'QL', NULL, NULL);
  END LOOP;
  COMMIT;
END;
/
BEGIN
    SCHEMA_USER.THEM_DU_LIEU_QL;
END;
/
-- CAP NHAT NHAN VIEN QUANLY
CREATE OR REPLACE PROCEDURE SCHEMA_USER.CAPNHAT_QUANLY
AS
  -- Tính toán s? nhân viên m?i qu?n lý d?a trên t?ng s? nhân viên và s? l??ng qu?n lý
  
  soNhanVienMoiQuanLy NUMBER(3) := 15;

  -- C?p nh?t thông tin qu?n lý c?a t?ng nhân viên trong b?ng Nhân viên
  CURSOR curNhanVien IS SELECT MANV FROM SCHEMA_USER.NHANVIEN WHERE VaiTro = 'NV' ORDER BY MaNV; 
  CURSOR curQuanLy IS SELECT MANV FROM SCHEMA_USER.NHANVIEN WHERE VaiTro = 'QL' ORDER BY MaNV;
  CNT INT := 0;
  N SCHEMA_USER.NHANVIEN.MANV%TYPE; -- Khai báo bi?n n'
  Q SCHEMA_USER.NHANVIEN.MANV%TYPE;
BEGIN
    OPEN curQuanLy;
    OPEN curNhanVien;
    LOOP
        FETCH  curQuanLy INTO Q;
        EXIT WHEN curQuanLy%NOTFOUND; 
        CNT := 0;
     -- M? cursor curNhanVien
        LOOP
          FETCH curNhanVien INTO N;
          EXIT WHEN curNhanVien%NOTFOUND; -- Thoát vòng l?p khi không còn d? li?u ?? duy?t
          IF CNT < soNhanVienMoiQuanLy - 1 THEN
            UPDATE SCHEMA_USER.NHANVIEN SET QuanLy = Q WHERE MaNV = N;
            CNT := CNT + 1; 
          ELSE
            UPDATE SCHEMA_USER.NHANVIEN SET QuanLy = Q WHERE MaNV = N;
            
            EXIT;
          END IF;
        END LOOP;
    --CLOSE curNhanVien; -- ?óng cursor curNhanVien
    END LOOP;
  COMMIT;
END; 
/
BEGIN
    SCHEMA_USER.CAPNHAT_QUANLY;
END;
/
-- CAP NHAT DU LIEU CHO PHONG BAN
INSERT INTO SCHEMA_USER.PHONGBAN (MaPB, TenPB) VALUES ('PB01', 'Phong Ke toan');
INSERT INTO SCHEMA_USER.PHONGBAN (MaPB, TenPB) VALUES ('PB02', 'Phong Nhan su');
INSERT INTO SCHEMA_USER.PHONGBAN (MaPB, TenPB) VALUES ('PB03', 'Phong Kinh doanh');
INSERT INTO SCHEMA_USER.PHONGBAN (MaPB, TenPB) VALUES ('PB04', 'Phong Ky thuat');
INSERT INTO SCHEMA_USER.PHONGBAN (MaPB, TenPB) VALUES ('PB05', 'Phong Khoa hoc');
INSERT INTO SCHEMA_USER.PHONGBAN (MaPB, TenPB) VALUES ('PB06', 'Phong Marketing');
INSERT INTO SCHEMA_USER.PHONGBAN (MaPB, TenPB) VALUES ('PB07', 'Phong Hanh chnh');
INSERT INTO SCHEMA_USER.PHONGBAN (MaPB, TenPB) VALUES ('PB08', 'Phong Tai chinh');
/
-- THONG TIN TRUONG PHONG
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N322', 'Bui Hoang Vu-8680', 'Nu', TO_DATE('1969-12-25', 'YYYY-MM-DD'), 'DaNang', '0941141321', 1444, 192, 'TRPG', NULL, NULL);
INSERT INTO SCHEMA_USER.NHANVIEN  (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N323', 'Bui Hoang Vu-8679', 'Nam', TO_DATE('1996-10-03', 'YYYY-MM-DD'), 'HaNoi', '0913185572', 1103, 116, 'TRPG', NULL, NULL);
INSERT INTO SCHEMA_USER.NHANVIEN  (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N324', 'Bui Hoang Vu-8678', 'Nam', TO_DATE('1989-04-20', 'YYYY-MM-DD'), 'HaNoi', '0963780488', 1127, 161, 'TRPG', NULL, NULL);
INSERT INTO SCHEMA_USER.NHANVIEN  (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N325', 'Bui Hoang Vu-8677', 'Nam', TO_DATE('1995-05-24', 'YYYY-MM-DD'), 'HaNoi', '0984433446', 1795, 136, 'TRPG', NULL, NULL);
INSERT INTO SCHEMA_USER.NHANVIEN  (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N326', 'Bui Hoang Vu-8676', 'Nu', TO_DATE('1971-04-12', 'YYYY-MM-DD'), 'CanTho', '0933526202', 1763, 187, 'TRPG', NULL, NULL);
INSERT INTO SCHEMA_USER.NHANVIEN  (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N327', 'Bui Hoang Vu-8675', 'Nam', TO_DATE('1991-07-28', 'YYYY-MM-DD'), 'HaiPhong', '0988710518', 1996, 149, 'TRPG', NULL, NULL);
INSERT INTO SCHEMA_USER.NHANVIEN  (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N328', 'Bui Hoang Vu-8674', 'Nu', TO_DATE('1977-11-28', 'YYYY-MM-DD'), 'HaiPhong', '0922403307', 1838, 169, 'TRPG', NULL, NULL);
INSERT INTO SCHEMA_USER.NHANVIEN  (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N329', 'Bui Hoang Vu-8673', 'Nu', TO_DATE('1966-06-09', 'YYYY-MM-DD'), 'CanTho', '0925408127', 1890, 185, 'TRPG', NULL, NULL);
/
--- CAP NHAT THONG TIN TRUONG PHONG
UPDATE SCHEMA_USER.PHONGBAN
SET TruongPhong = 'N322'
WHERE MaPB = 'PB01';
/
UPDATE SCHEMA_USER.PHONGBAN
SET TruongPhong = 'N323'
WHERE MaPB = 'PB02';
/
UPDATE SCHEMA_USER.PHONGBAN
SET TruongPhong = 'N324'
WHERE MaPB = 'PB03';
/
UPDATE SCHEMA_USER.PHONGBAN
SET TruongPhong = 'N325'
WHERE MaPB = 'PB04';
/
UPDATE SCHEMA_USER.PHONGBAN
SET TruongPhong = 'N326'
WHERE MaPB = 'PB05';
/
UPDATE SCHEMA_USER.PHONGBAN
SET TruongPhong = 'N327'
WHERE MaPB = 'PB06';
/
UPDATE SCHEMA_USER.PHONGBAN
SET TruongPhong = 'N328'
WHERE MaPB = 'PB07';
/
UPDATE SCHEMA_USER.PHONGBAN
SET TruongPhong = 'N329'
WHERE MaPB = 'PB08';
/
-- 
UPDATE SCHEMA_USER.NHANVIEN
SET PhongBan = 'PB' || TO_CHAR(MOD(TO_NUMBER(SUBSTR(MaNV, 2)), 8) + 1, 'FM00')
WHERE MaNV BETWEEN 'N301' AND 'N321';
/
-- CAP NHAT PHONG BAN CHO NHAN VIEN
UPDATE SCHEMA_USER.NHANVIEN NV
SET PHONGBAN = (
    SELECT PHONGBAN FROM SCHEMA_USER.NHANVIEN QL WHERE NV.QUANLY = QL.MANV) WHERE VAITRO = 'NV';
/
-- CAP NHAT TRUONG PHONG
UPDATE SCHEMA_USER.NHANVIEN NV
SET PHONGBAN = (SELECT MAPB FROM SCHEMA_USER.PHONGBAN WHERE TRUONGPHONG = NV.MANV) WHERE VAITRO = 'TRPG';

/
-- CAP NHAT NHAN VIEN TAI CHINH
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N330', 'Buttefly Tran-8650', 'Nu', TO_DATE('1985-11-01', 'YYYY-MM-DD'), 'CanTho', '0947021019', 1557, 174, 'TC', 'N329', 'PB08');
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N331', 'Buttefly Tran-8649', 'Nu', TO_DATE('1975-02-25', 'YYYY-MM-DD'), 'TPHCM', '0930293475', 1091, 154, 'TC', 'N329', 'PB08');
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N332', 'Buttefly Tran-8648', 'Nu', TO_DATE('1989-08-06', 'YYYY-MM-DD'), 'DaNang', '0953659577', 1698, 134, 'TC', 'N329', 'PB08');
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N333', 'Buttefly Tran-8647', 'Nam', TO_DATE('1969-12-11', 'YYYY-MM-DD'), 'TPHCM', '0994950907', 1098, 172, 'TC', 'N329', 'PB08');
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N334', 'Buttefly Tran-8646', 'Nu', TO_DATE('1976-10-27', 'YYYY-MM-DD'), 'HaiPhong', '0948009217', 1206, 122, 'TC', 'N329', 'PB08');
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N335', 'Buttefly Tran-8645', 'Nam', TO_DATE('1972-07-25', 'YYYY-MM-DD'), 'HaiPhong', '0945578413', 1083, 175, 'TC', 'N329', 'PB08');
-- CAP NHAT NV NHAN SU
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N336', 'Buttefly Tran-8644', 'Nam', TO_DATE('1973-08-22', 'YYYY-MM-DD'), 'HaiPhong', '0952665689', 1134, 193, 'NS', 'N323', 'PB02');
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N337', 'Buttefly Tran-8643', 'Nu', TO_DATE('1979-12-06', 'YYYY-MM-DD'), 'DaNang', '0934923523', 1997, 183, 'NS', 'N323', 'PB02');
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N338', 'Buttefly Tran-8642', 'Nam', TO_DATE('1982-01-25', 'YYYY-MM-DD'), 'CanTho', '0922960970', 1304, 191, 'NS', 'N323', 'PB02');
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N339', 'Buttefly Tran-8641', 'Nam', TO_DATE('1962-08-17', 'YYYY-MM-DD'), 'HaNoi', '0938530471', 1767, 199, 'NS', 'N323', 'PB02');
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N340', 'Buttefly Tran-8640', 'Nam', TO_DATE('1993-12-26', 'YYYY-MM-DD'), 'CanTho', '0999868496', 1816, 104, 'NS', 'N323', 'PB02');
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N341', 'Buttefly Tran-8639', 'Nam', TO_DATE('1961-12-05', 'YYYY-MM-DD'), 'HaiPhong', '0950319989', 1492, 125, 'NS', 'N323', 'PB02');
-- CAP NHAT NV TRUONG DE AN
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N342', 'Hong Khanh-8671', 'Nu', TO_DATE('1961-09-23', 'YYYY-MM-DD'), 'DaNang', '0926452652', 1785, 189, 'TRDA', NULL, NULL);
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N343', 'Hong Khanh-8670', 'Nu', TO_DATE('1969-02-26', 'YYYY-MM-DD'), 'DaNang', '0914024433', 1212, 104, 'TRDA', NULL, NULL);
INSERT INTO SCHEMA_USER.NHANVIEN (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N344', 'Hong Khanh-8669', 'Nam', TO_DATE('1964-11-20', 'YYYY-MM-DD'), 'CanTho', '0953563259', 1134, 179, 'TRDA', NULL, NULL);
-- CAP NHAT GIAM DOC
INSERT INTO SCHEMA_USER.NHANVIEN  (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N345', 'Buttefly Tran-8638', 'Nu', TO_DATE('1987-01-21', 'YYYY-MM-DD'), 'HaNoi', '0972939159', 1791, 165, 'GD', NULL, 'PB01');
INSERT INTO SCHEMA_USER.NHANVIEN  (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N346', 'Buttefly Tran-8637', 'Nam', TO_DATE('1970-12-14', 'YYYY-MM-DD'), 'DaNang', '0934930344', 1885, 185, 'GD', NULL, 'PB03');
INSERT INTO SCHEMA_USER.NHANVIEN  (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N347', 'Buttefly Tran-8636', 'Nam', TO_DATE('1979-06-04', 'YYYY-MM-DD'), 'HaNoi', '0963185611', 1425, 148, 'GD', NULL, 'PB05');
INSERT INTO SCHEMA_USER.NHANVIEN  (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N348', 'Buttefly Tran-8635', 'Nam', TO_DATE('1998-07-22', 'YYYY-MM-DD'), 'DaNang', '0938286591', 1200, 173, 'GD', NULL, 'PB06');
INSERT INTO SCHEMA_USER.NHANVIEN  (MaNV, TenNV, Phai, NgaySinh, DiaChi, SoDT, Luong, PhuCap, VaiTro, QuanLy, PhongBan) VALUES ('N349', 'Buttefly Tran-8634', 'Nu', TO_DATE('1999-08-18', 'YYYY-MM-DD'), 'CanTho', '0928452011', 1926, 155, 'GD', NULL, 'PB08');

-- CAP NHAT TAI KHOAN
INSERT INTO SCHEMA_USER.TAIKHOAN (MaNV, MatKhau)
SELECT MaNV, '1234' FROM SCHEMA_USER.NHANVIEN;

-- BANG DE AN 
INSERT INTO SCHEMA_USER.DEAN (MaDA, TenDA, NgayBD, PhongBan, TruongDA)
SELECT 
    'DA' || LPAD(ROWNUM, 2, '0') AS MaDA,
    'DE AN ' || ROWNUM AS TenDA,
    TRUNC(SYSDATE) - MOD(ROWNUM, 1000) AS NgayBD,
    'PB' || LPAD(MOD(ROWNUM, 8) + 1, 2, '0') AS PhongBan,
    'N3' || LPAD(MOD(ROWNUM, 3) + 42, 2, '0') AS TruongDA
FROM 
    dual
CONNECT BY 
    ROWNUM <= 10;
/ 
DECLARE
    v_maNV VARCHAR2(4);
BEGIN
    FOR i IN 1..300 LOOP
    v_maNV := 'N' || LPAD(i, 3, '0');
    INSERT INTO SCHEMA_USER.PhanCong (MaNV, MaDA, ThoiGian) VALUES (v_maNV, (SELECT MaDA FROM SCHEMA_USER.DEAN ORDER BY dbms_random.value FETCH FIRST 1 ROWS ONLY), SYSDATE);
END LOOP;
END;
/
-- cap nhat pb
update SCHEMA_USER.PHANCONG
set PHONGBAN = (
    select PHONGBAN 
    from SCHEMA_USER.NHANVIEN n
    where PHANCONG.MaNV = n.MaNV
)
/
-- cap nhat ql
update SCHEMA_USER.PHANCONG
set QUANLY = (
    select QUANLY 
    from SCHEMA_USER.NHANVIEN n
    where PHANCONG.MaNV = n.MaNV
)


