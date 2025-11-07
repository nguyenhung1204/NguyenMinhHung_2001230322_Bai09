/* ===========================
   TẠO CSDL QLBanSach (SQL Server)
   =========================== */

-- Xoá CSDL cũ (nếu có) để tạo lại


CREATE DATABASE QLBanSach;
GO
USE QLBanSach;
GO

/*======== BẢNG KHÁCH HÀNG ========*/
CREATE TABLE dbo.tbl_KhachHang
(
    MaKhachHang   INT IDENTITY(1,1) PRIMARY KEY,
    TenKH         NVARCHAR(100) NOT NULL,
    DiaChi        NVARCHAR(200) NULL,
    SoDienThoai   VARCHAR(20)   NULL,
    MatKhau       NVARCHAR(50)  NOT NULL,  -- demo đơn giản (thực tế nên hash)
    NgayTao       DATETIME2(0)  NOT NULL CONSTRAINT DF_tbl_KhachHang_NgayTao DEFAULT SYSUTCDATETIME()
);
GO

/*======== BẢNG SẢN PHẨM ========*/
CREATE TABLE dbo.tbl_SanPham
(
    MaSanPham   INT IDENTITY(1,1) PRIMARY KEY,
    TenSP       NVARCHAR(200) NOT NULL,
    DonGia      DECIMAL(12,2) NOT NULL CONSTRAINT CK_SanPham_DonGia CHECK (DonGia >= 0),
    HinhAnh     NVARCHAR(255) NULL,
    MoTa        NVARCHAR(500) NULL,
    SoLuongTon  INT NOT NULL CONSTRAINT DF_SanPham_SoLuongTon DEFAULT(0)
                 CONSTRAINT CK_SanPham_SoLuongTon CHECK (SoLuongTon >= 0),
    TrangThai   TINYINT NOT NULL CONSTRAINT DF_SanPham_TrangThai DEFAULT(1)  -- 1: còn bán; 0: ẩn
);
GO

/*======== BẢNG HÓA ĐƠN ========*/
CREATE TABLE dbo.tbl_HoaDon
(
    MaHoaDon    INT IDENTITY(1,1) PRIMARY KEY,
    NgayHoaDon  DATETIME2(0) NOT NULL CONSTRAINT DF_HoaDon_Ngay DEFAULT SYSUTCDATETIME(),
    NgayGiao    DATE NULL,
    MaKH        INT NOT NULL
        CONSTRAINT FK_HoaDon_KhachHang
        REFERENCES dbo.tbl_KhachHang(MaKhachHang)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

/*======== BẢNG CHI TIẾT HÓA ĐƠN ========*/
CREATE TABLE dbo.tbl_ChiTiet
(
    MaHoaDon  INT NOT NULL,
    MaSP      INT NOT NULL,
    SoLuong   INT NOT NULL CONSTRAINT CK_ChiTiet_SoLuong CHECK (SoLuong > 0),
    DonGia    DECIMAL(12,2) NOT NULL CONSTRAINT CK_ChiTiet_DonGia CHECK (DonGia >= 0),
    CONSTRAINT PK_ChiTiet PRIMARY KEY (MaHoaDon, MaSP),
    CONSTRAINT FK_ChiTiet_HoaDon FOREIGN KEY (MaHoaDon)
        REFERENCES dbo.tbl_HoaDon(MaHoaDon)
        ON UPDATE NO ACTION ON DELETE CASCADE,  -- xoá hoá đơn sẽ xoá chi tiết
    CONSTRAINT FK_ChiTiet_SanPham FOREIGN KEY (MaSP)
        REFERENCES dbo.tbl_SanPham(MaSanPham)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

/*======== INDEX PHỤ TRUY VẤN NHANH ========*/
CREATE INDEX IX_ChiTiet_MaSP ON dbo.tbl_ChiTiet(MaSP);
GO

/*======== DỮ LIỆU MẪU ========*/

-- 1 khách hàng demo để đăng nhập (TenKH=An, MatKhau=123)
INSERT INTO dbo.tbl_KhachHang (TenKH, DiaChi, SoDienThoai, MatKhau)
VALUES (N'An', N'Tân Phú', '0909123123', N'123');

-- Sản phẩm demo (ảnh đặt trong /Content/images/ theo đúng tên nếu bạn dùng web mẫu)
INSERT INTO dbo.tbl_SanPham (TenSP, DonGia, HinhAnh, MoTa, SoLuongTon) VALUES
(N'Đạo tình',          77000,  N'DaoTinh.jpg',       N'Tiểu thuyết', 50),
(N'Kỷ án ánh trăng',   115500, N'KyAnAnhTrang.jpg',  N'Truyện trinh thám', 40),
(N'Yêu',                52200, N'Yeu.jpg',           N'Truyện', 30),
(N'Em là nhà',          58800, N'EmLaNha.jpg',       N'Truyện', 20),
(N'Khu vườn ngôn từ',   71250, N'KhuVuonNgonTu.jpg', N'Truyện', 25);

-- (Tuỳ chọn) Tạo 1 hoá đơn mẫu cho khách hàng trên
DECLARE @MaHD INT;
INSERT INTO dbo.tbl_HoaDon (NgayHoaDon, NgayGiao, MaKH)
VALUES (SYSUTCDATETIME(), DATEADD(day, 3, CAST(GETDATE() AS DATE)), 1);
SET @MaHD = SCOPE_IDENTITY();

INSERT INTO dbo.tbl_ChiTiet (MaHoaDon, MaSP, SoLuong, DonGia)
SELECT @MaHD, MaSanPham, 1, DonGia
FROM dbo.tbl_SanPham WHERE MaSanPham IN (1,2);
GO

/*======== VIEW TỔNG TIỀN HOÁ ĐƠN (tham khảo) ========*/
CREATE OR ALTER VIEW dbo.v_HoaDonTongTien AS
SELECT  hd.MaHoaDon,
        hd.NgayHoaDon,
        hd.NgayGiao,
        hd.MaKH,
        SUM(ct.SoLuong * ct.DonGia) AS TongTien
FROM dbo.tbl_HoaDon hd
JOIN dbo.tbl_ChiTiet ct ON ct.MaHoaDon = hd.MaHoaDon
GROUP BY hd.MaHoaDon, hd.NgayHoaDon, hd.NgayGiao, hd.MaKH;
GO

/*======== CÂU LỆNH TEST NHANH ========*/
SELECT * FROM dbo.tbl_SanPham;
 SELECT * FROM dbo.tbl_KhachHang;

 SELECT * FROM dbo.v_HoaDonTongTien;
