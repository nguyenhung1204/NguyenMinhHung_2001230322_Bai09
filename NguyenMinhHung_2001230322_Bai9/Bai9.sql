CREATE DATABASE QL_WEBSACH;
GO

USE QL_WEBSACH;
GO

-- 1. Bảng CHUDE
CREATE TABLE CHUDE (
    MaChuDe CHAR(10) PRIMARY KEY,
    TenChuDe NVARCHAR(100)
);

-- 2. Bảng NHAXUATBAN
CREATE TABLE NHAXUATBAN (
    MaNXB CHAR(10) PRIMARY KEY,
    TenNXB NVARCHAR(100),
    DiaChi NVARCHAR(200),
    DienThoai CHAR(15)
);

-- 3. Bảng TACGIA
CREATE TABLE TACGIA (
    MaTacGia CHAR(10) PRIMARY KEY,
    TenTacGia NVARCHAR(100),
    DiaChi NVARCHAR(200),
    TieuSu NVARCHAR(500),
    DienThoai CHAR(15)
);

-- 4. Bảng SACH
CREATE TABLE SACH (
    MaSach CHAR(10) PRIMARY KEY,
    TenSach NVARCHAR(200),
    GiaBan DECIMAL(12,2),
    MoTa NVARCHAR(500),
    NgayCapNhat DATE,
    AnhBia NVARCHAR(200),
    SoLuongTon INT,
    MaChuDe CHAR(10),
    MaNXB CHAR(10),
    Moi BIT,
    FOREIGN KEY (MaChuDe) REFERENCES CHUDE(MaChuDe),
    FOREIGN KEY (MaNXB) REFERENCES NHAXUATBAN(MaNXB)
);

-- 5. Bảng THAMGIA (liên kết nhiều-nhiều giữa SACH và TACGIA)
CREATE TABLE THAMGIA (
    MaSach CHAR(10),
    MaTacGia CHAR(10),
    VaiTro NVARCHAR(50),
    ViTri NVARCHAR(50),
    PRIMARY KEY (MaSach, MaTacGia),
    FOREIGN KEY (MaSach) REFERENCES SACH(MaSach),
    FOREIGN KEY (MaTacGia) REFERENCES TACGIA(MaTacGia)
);

-- 6. Bảng KHACHHANG
CREATE TABLE KHACHHANG (
    MaKH CHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100),
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    DienThoai CHAR(15),
    TaiKhoan NVARCHAR(50),
    MatKhau NVARCHAR(50),
    Email NVARCHAR(100),
    DiaChi NVARCHAR(200)
);

-- 7. Bảng DONHANG
CREATE TABLE DONHANG (
    MaDonHang CHAR(10) PRIMARY KEY,
    NgayGiao DATE,
    NgayDat DATE,
    DaThanhToan BIT,
    TinhTrangGiaoHang NVARCHAR(100),
    MaKH CHAR(10),
    FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH)
);

-- 8. Bảng CHITIETDONHANG
CREATE TABLE CHITIETDONHANG (
    MaDonHang CHAR(10),
    MaSach CHAR(10),
    SoLuong INT,
    DonGia DECIMAL(12,2),
    PRIMARY KEY (MaDonHang, MaSach),
    FOREIGN KEY (MaDonHang) REFERENCES DONHANG(MaDonHang),
    FOREIGN KEY (MaSach) REFERENCES SACH(MaSach)
);
GO

INSERT INTO CHUDE VALUES
('CD01', N'Âm nhạc'),
('CD02', N'Công nghệ thông tin'),
('CD03', N'Danh nhân'),
('CD04', N'Du lịch'),
('CD05', N'Khoa học kỹ thuật'),
('CD06', N'Khoa học vật lý'),
('CD07', N'Khoa học xã hội');



INSERT INTO NHAXUATBAN VALUES
('NXB01', N'Đại học Quốc Gia', N'268 Lý Thường Kiệt, Q.10, TP.HCM', '02838351234'),
('NXB02', N'Khoa học & Kỹ thuật', N'1 Đại Cồ Việt, Hà Nội', '02438541234'),
('NXB03', N'Kim Đồng', N'55 Quang Trung, Hà Nội', '02438567890'),
('NXB04', N'Nhà xuất bản Trẻ', N'161 Lý Chính Thắng, Q.3, TP.HCM', '02838299999'),
('NXB05', N'NXB Hồng Đức', N'58 Nguyễn Du, Q.1, TP.HCM', '02838226677'),
('NXB06', N'NXB Lao động - Xã hội', N'175 Giải Phóng, Hà Nội', '02438645555'),
('NXB07', N'NXB Phụ nữ', N'39 Hàng Chuối, Hà Nội', '02438221234');


INSERT INTO TACGIA VALUES
('TG01', N'Nguyễn Nhật Ánh', N'Quảng Nam', N'Tác giả nổi tiếng với các tác phẩm tuổi học trò', '0909123456'),
('TG02', N'Paulo Coelho', N'Brazil', N'Tác giả cuốn Nhà Giả Kim', '0909876543'),
('TG03', N'Trần Đăng Khoa', N'Hải Dương', N'Nhà thơ và nhà văn Việt Nam', '0909111222');




INSERT INTO SACH VALUES
('S01', N'Mắt biếc', 85000, N'Truyện dài nổi tiếng của Nguyễn Nhật Ánh', '2024-01-12', N'matbiec.jpg', 120, 'CD02', 'NXB01', 1),
('S02', N'Nhà giả kim', 95000, N'Tác phẩm triết lý nổi tiếng của Paulo Coelho', '2023-12-20', N'nha_gia_kim.jpg', 80, 'CD02', 'NXB02', 1),
('S03', N'Hạt giống tâm hồn', 105000, N'Truyện truyền cảm hứng về cuộc sống', '2024-02-14', N'hatgiong.jpg', 60, 'CD04', 'NXB02', 1),
('S04', N'Tiếng Việt 5', 45000, N'Sách giáo khoa Tiếng Việt lớp 5', '2023-08-10', N'tv5.jpg', 300, 'CD03', 'NXB03', 0),
('S05', N'Đắc nhân tâm', 98000, N'Sách kỹ năng sống nổi tiếng toàn cầu', '2024-03-01', N'dacnhantam.jpg', 100, 'CD04', 'NXB02', 1),
('S06', N'Không gia đình', 89000, N'Tiểu thuyết cảm động về tuổi thơ lang thang', '2023-11-25', N'khonggiadinh.jpg', 75, 'CD01', 'NXB04', 1),
('S07', N'Tôi thấy hoa vàng trên cỏ xanh', 92000, N'Tác phẩm văn học Việt Nam được chuyển thể thành phim', '2024-04-20', N'hoavang.jpg', 85, 'CD02', 'NXB01', 1),
('S08', N'Trên đường băng', 87000, N'Sách truyền cảm hứng dành cho giới trẻ', '2024-01-30', N'trendb.jpg', 95, 'CD04', 'NXB02', 1),
('S09', N'Sống chậm lại rồi mọi chuyện sẽ ổn', 88000, N'Sách chia sẻ giá trị sống hiện đại', '2024-02-10', N'songcham.jpg', 60, 'CD04', 'NXB05', 1),
('S10', N'Harry Potter và hòn đá phù thủy', 135000, N'Tập đầu tiên trong series Harry Potter nổi tiếng', '2024-01-15', N'harry1.jpg', 120, 'CD01', 'NXB06', 1);

INSERT INTO THAMGIA VALUES
('S01', 'TG01', N'Tác giả chính', N'Trang đầu'),
('S02', 'TG02', N'Tác giả chính', N'Trang đầu'),
('S03', 'TG03', N'Đồng tác giả', N'Trang cuối');

INSERT INTO KHACHHANG VALUES
('KH01', N'Lê Thị Hoa', '2002-07-15', N'Nữ', '0909123123', N'lehoa', N'123456', N'lehoa@gmail.com', N'Quận 1, TP.HCM'),
('KH02', N'Nguyễn Văn An', '2000-04-20', N'Nam', '0909555666', N'ngan', N'an2024', N'ngan@gmail.com', N'Đà Nẵng'),
('KH03', N'Trần Bảo Long', '1999-12-10', N'Nam', '0909777888', N'tblong', N'long999', N'long@gmail.com', N'Hà Nội');

INSERT INTO DONHANG VALUES
('DH01', '2025-01-15', '2025-01-10', 1, N'Đã giao', 'KH01'),
('DH02', '2025-01-20', '2025-01-18', 0, N'Chờ giao', 'KH02'),
('DH03', '2025-01-25', '2025-01-22', 1, N'Đang xử lý', 'KH03');

INSERT INTO CHITIETDONHANG VALUES
('DH01', 'S01', 2, 85000),
('DH01', 'S02', 1, 95000),
('DH02', 'S03', 3, 105000),
('DH03', 'S04', 2, 45000);

DELETE FROM CHUDE;
GO



DROP TABLE CHITIETDONHANG;
DROP TABLE THAMGIA;
DROP TABLE DONHANG;
DROP TABLE KHACHHANG;
DROP TABLE SACH;
DROP TABLE TACGIA;
DROP TABLE NHAXUATBAN;
DROP TABLE CHUDE;


SELECT * FROM SACH;
SELECT * FROM KHACHHANG;
SELECT * FROM DONHANG;
SELECT * FROM CHITIETDONHANG;
SELECT *FROM CHUDE