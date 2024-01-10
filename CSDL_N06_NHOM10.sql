create database QuanLyThuVien;
use QuanLyThuVien2;

create table sinhvien(
	masinhvien nvarchar(50) not null,
	ho nvarchar(15),
	ten nvarchar(20) not null,
	diachi nvarchar(50),
	lop nvarchar(50),
	khoa nvarchar(50),
	email nvarchar(50),
	sodienthoai nchar(10),
	ngaysinh date,
	-- PK
	constraint pk_sinhvien primary key(masinhvien)
);

create table thuthu(
	mathuthu nvarchar(50) not null,
	hoten nvarchar(50) not null,
	ngaysinh date,
	diachi nvarchar(50),
	sodienthoai nchar(10),
	-- PK
	constraint pk_thuthu primary key(mathuthu)
);

create table phieumuon(
	maphieu nvarchar(50) not null,
	thoigian date,
	masinhvien nvarchar(50),
	mathuthu nvarchar(50),
	-- PK
	constraint fk_phieumuon primary key(maphieu),
	-- FK
	constraint fk_phieumuon_masinhvien foreign key(masinhvien) references sinhvien(masinhvien),
	constraint fk_phieumuon_mathuthu foreign key(mathuthu) references thuthu(mathuthu),
);

create table theloai(
	matheloai nvarchar(50) not null,
	tentheloai nvarchar(50) not null,
	-- PK
	constraint pk_theloai_matheloai primary key(matheloai)
);

create table nhaxuatban(
	maxuatban nvarchar(50) not null,
	tennhaxuatban nvarchar(50),
	diachi nvarchar(50),
	-- PK
	constraint pk_nhaxuatban primary key(maxuatban)
);
create table tacgia(
	matacgia nvarchar(50) not null,
	tentacgia nvarchar(50),
	-- PK
	constraint pk_tacgia primary key(matacgia)
);

create table sach(
	masach nvarchar(50) not null,
	tensach nvarchar(50) not null,
	matacgia nvarchar(50),
	maxuatban nvarchar(50),
	namxuatban int,
	matheloai nvarchar(50),
	soluongcon int,
	-- PK
	constraint pk_sach_masach primary key(masach),
	-- FK
	constraint fk_sach_matacgia foreign key(matacgia) references tacgia(matacgia),
	constraint fk_sach_matheloai foreign key(matheloai) references theloai(matheloai),
	constraint fk_sach_maxuatban foreign key(maxuatban) references nhaxuatban(maxuatban),	
);
alter table sach
add 
	constraint fk_sach_matacgia foreign key(matacgia) references tacgia(matacgia);

create table chitietphieumuon
(
	maphieu nvarchar(50) not null,
	masach nvarchar(50) not null,
	soluong int,
	-- FK
	constraint fk_chitietphieumuon_maphieu foreign key(maphieu) references phieumuon(maphieu),
	constraint fk_chitietphieumuon_masach foreign key(masach) references sach(masach), 
);

	
-- RB1: Mỗi sinh viên không mượn quá 5 quyển sách
alter table chitietphieumuon
add 
    constraint chk_chitietphieumuon_soluong
    check(soluong <= 5);

-- RB2: Một phiếu mượn chỉ được cấp cho 1 sinh viên
alter table phieumuon
add
constraint uniq_phieumuon_masinhvien
unique(masinhvien);

-- RB3: Mỗi sách chỉ có 1 thể loại
alter table sach
add
constraint uniq_sach_matheloai
unique(matheloai);

-- RB4: Mỗi cuốn sách phải được viết ít nhất bởi 1 tác giả
alter table sach
add 
constraint chk_sach_matacgia
check(matacgia IS NOT NULL);

-- RB5: Nếu không có thông tin về số lượng sách còn lại trong thư viện thì mặc định là 0
alter table sach
add
constraint df_sach_soluongcon
default (0) for soluongcon;

-- Quy tắc RB6: Năm xuất bản phải nhỏ hơn hoặc bằng năm hiện tại
alter table sach
add
    constraint chk_sach_namxuatban
    check(namxuatban <= year(getdate()));

-- sinhvien
insert into sinhvien(masinhvien, ho, ten, diachi, lop, khoa, email, sodienthoai, ngaysinh)
values
('SV001', 'Do', 'Xuan Trang', 'Ha Noi', 'K62', 'CNTT', 'trang@gmail.com', '0123456789', '2003-02-26'),
('SV002', 'Ta', 'Quoc Viet', 'Thai Binh', 'K62', 'CNTT', 'viet@gmail.com', '0987654321', '2003-11-02'),
('SV003', 'Nguyen', 'Trung Dung', 'Bac Ninh', 'K61', 'Marketing', 'dung@gmail.com', '0123456789', '1999-03-03'),
('SV004', 'Mai', 'Tien Manh', 'Nam Dinh', 'K63', 'QTKD', 'manh@gmail.com', '0987654321', '2002-04-04'),
('SV005', 'Nguyen', 'Viet Hoang', 'Hai Phong', 'K63', 'CNTT', 'hoang@gmail.com', '0123456789', '2003-05-05');

update sinhvien
set lop = 'CNTT5', khoa = 'K62'
where masinhvien in ( 'SV001', 'SV002','SV003'); 

update sinhvien
set lop = 'QTKD1', khoa = 'K63'
where masinhvien in ( 'SV004', 'SV005'); 


-- thuthu
insert into thuthu(mathuthu, hoten, ngaysinh, diachi, sodienthoai)
values
('TT001', 'Nguyen Van B', '1990-01-01', 'Ha Noi', '0123456789'),
('TT002', 'Tran Thi C', '1992-02-02', 'Ho Chi Minh', '0987654321'),
('TT003', 'Le Van D', '1994-03-03', 'Da Nang', '0123456789'),
('TT004', 'Pham Thi E', '1996-04-04', 'Can Tho', '0987654321'),
('TT005', 'Hoang Van F', '1998-05-05', 'Hai Phong', '0123456789');

-- phieumuon
insert into phieumuon(maphieu, thoigian, masinhvien, mathuthu)
values
('PM001', '2023-03-08', 'SV001', 'TT001'),
('PM002', '2022-03-09', 'SV002', 'TT002'),
('PM003', '2022-03-03', 'SV003', 'TT003'),
('PM004', '2022-04-04', 'SV004', 'TT004'),
('PM005', '2023-03-13', 'SV005', 'TT005');

-- theloai
insert into theloai(matheloai, tentheloai)
values
('TL001', N'Khoa học'),
('TL002', N'Văn học'),
('TL003', N'Lịch sử'),
('TL004', N'Kinh tế'),
('TL005', N'Thiếu nhi'),
('TL006', N'Toán cao cấp');

-- nhaxuatban
INSERT INTO nhaxuatban (maxuatban, tennhaxuatban, diachi)
VALUES ('NXB001', N'Kim Đồng', 'Ha Noi'),
       ('NXB002', N'NXB Nhóm 10', 'Da Nang'),
       ('NXB003', N'Nhã Nam', 'Hai Phong'),
       ('NXB004', N'Kim Đồng', 'Ho Chi Minh'),
       ('NXB005', N'Thế giới', 'Can Tho');

-- tacgia
INSERT INTO tacgia (matacgia, tentacgia)
VALUES 
('001', 'Dan Brown'),
('002', 'Victor Hugo'),
('003', 'Nguyen Du'),
('004', 'IT-Trang,Viet,Dung'),
('005', 'Ngo Tat To'),
('006', 'IT-TienManh')

-- sach
INSERT INTO sach (masach, tensach, matacgia, maxuatban, namxuatban, matheloai, soluongcon)
VALUES 
('S001', N'Người khốn khổ', '002', 'NXB001', 2005, 'TL004', 10),
('S002', N'Hủy Diệt', '004', 'NXB002', 2023, 'TL002', 5),
('S003', N'Truyện Kiều', '003', 'NXB003', 2002, 'TL005', 3),
('S004', N'Nguồn cội', '001', 'NXB002', 2010, 'TL003', 8),
('S005', N'Tắt đèn', '005', 'NXB005', 2003, 'TL001', 2),
('S006', N'Giải tích 2', '004', 'NXB004', 2003, 'TL006', 6),

('S007', N'Giải tích 1', '006', 'NXB002', 2003, 'TL006', 3)

-- chitietphieumuon
INSERT INTO chitietphieumuon (maphieu, masach, soluong)
VALUES 
('PM001', 'S002', 1),
('PM002', 'S003', 3),
('PM003', 'S002', 2),
('PM004', 'S005', 4),
('PM005', 'S006', 5);


-- 1. Cho biết các nhà xuất bản của sách trong thư viện
select* from nhaxuatban

-- 2. Tìm tên và số điện thoại của tất cả các thủ thư của thư viện.
select hoten, sodienthoai from thuthu

-- 3. Đưa ra mã sách, tên sách có số lượng còn lại > 6 quyển
select masach, tensach from sach where soluongcon>6;

-- 4. Đưa ra các sinh viên có địa chỉ ở Nam Định
select masinhvien, ho, ten from sinhvien where diachi = 'Nam Dinh';

-- 5. Tìm tất cả các sách thuộc thể loại “Văn học” và được xuất bản bởi “NXB Nhóm 10”.
select * from (sach inner join theloai on sach.matheloai = theloai.matheloai) 
inner join nhaxuatban on sach.maxuatban = nhaxuatban.maxuatban
where tentheloai = N'Văn học' and tennhaxuatban = N'NXB Nhóm 10';

-- 6. Đưa ra thông tin các sinh viên đang mượn sách của lớp CNTT5-K62
select sinhvien.masinhvien,ho,ten,email,sodienthoai from (sinhvien inner join phieumuon 
on sinhvien.masinhvien = phieumuon.masinhvien)
where lop = 'CNTT5' and khoa = 'K62'

-- 7. Đưa ra các thông tin sinh viên đã mượn sách ngày 8/3/2023
select * from (sinhvien inner join phieumuon on sinhvien.masinhvien = phieumuon.masinhvien)
where thoigian= '2023-03-08'

-- 8. Cho biết thông tin tác giả của cuốn sách Hủy Diệt.
select * from (sach inner join tacgia on sach.matacgia = tacgia.matacgia)
where tensach like N'Hủy Diệt'

-- 9. Đưa ra mã các sách chưa từng được mượn.
select sach.masach from sach
except
select chitietphieumuon.masach from chitietphieumuon 

-- 10. Đưa ra tất cả các sách đã được mượn từ ngày 9/3/2023.
select sach.masach,tensach from sach
except
select sach.masach,tensach from (sach inner join chitietphieumuon on sach.masach = chitietphieumuon.masach 
inner join phieumuon on chitietphieumuon.maphieu = phieumuon.maphieu)
where thoigian < '2023-03-03'

-- 11. Thống kê số lượng sách của các nhà xuất bản > năm 2003
select nhaxuatban.maxuatban,tennhaxuatban, count(sach.maxuatban) as 'Số lượng sản xuất'
from(nhaxuatban inner join sach on nhaxuatban.maxuatban = sach.maxuatban)
where namxuatban > 2003
group by nhaxuatban.maxuatban,tennhaxuatban

-- 12. Thống kê danh sách các sách và số lượng đã mượn từ ngày 13/03/2022.
select sach.masach, tensach, thoigian, sum(soluong) as 'Số lượng mượn'
from(sach inner join chitietphieumuon on sach.masach = chitietphieumuon.masach 
inner join phieumuon on phieumuon.maphieu = chitietphieumuon.maphieu )
where phieumuon.thoigian >= '2022-03-13'
group by sach.masach, tensach, thoigian


-- 13. Cho biết thông tin sách có số lượng còn trong thư viện nhiều nhất
select sach.masach, tensach, soluongcon from sach
where soluongcon =  (select max(soluongcon) from sach)


-- 14. Tìm thông tin sách có số lượng mượn ít nhất 
select sach.masach, tensach, sum(soluong) as 'Số lượng mượn' 
from (sach inner join chitietphieumuon on sach.masach = chitietphieumuon.masach)
group by sach.masach,tensach
having sum(soluong) <= all(select sum(soluong) 
						   from (sach inner join chitietphieumuon on sach.masach = chitietphieumuon.masach)
							group by sach.masach,tensach)


-- 15. Cho biết sinh viên nào mượn nhiều sách nhất năm 2022
select sinhvien.masinhvien,ho,ten, sum(soluong) as N'Số lượng mượn'
from (chitietphieumuon inner join phieumuon on chitietphieumuon.maphieu = phieumuon.maphieu
inner join sinhvien on sinhvien.masinhvien = phieumuon.masinhvien)
where thoigian between '2022-01-01' and '2022-12-31'
group by sinhvien.masinhvien,ho,ten
having sum(soluong) >= all(select sum(soluong)
					   from( chitietphieumuon inner join phieumuon on chitietphieumuon.maphieu = phieumuon.maphieu
					   inner join sinhvien on sinhvien.masinhvien = phieumuon.masinhvien)
					   where thoigian between '2022-01-01' and '2022-12-31'
					   group by sinhvien.masinhvien,ho,ten)

-- 16. Cho biết nhà xuất bản nào xuất bản nhiều sách nhất
select nhaxuatban.maxuatban, tennhaxuatban, count(masach)
from(sach inner join nhaxuatban on nhaxuatban.maxuatban = sach.maxuatban)
group by nhaxuatban.maxuatban, tennhaxuatban
having count(masach) >= all(select count(masach)
							from(sach inner join nhaxuatban on nhaxuatban.maxuatban = sach.maxuatban)
							group by nhaxuatban.maxuatban, tennhaxuatban)


							-- Truy vấn thống kê số sinh viên mượn sách mỗi tháng
SELECT
    MONTH(thoigian) AS ThangMuon,
    COUNT(DISTINCT masinhvien) AS SoSinhVienMuon
FROM
    phieumuon
GROUP BY
    MONTH(thoigian)
ORDER BY
    ThangMuon;
