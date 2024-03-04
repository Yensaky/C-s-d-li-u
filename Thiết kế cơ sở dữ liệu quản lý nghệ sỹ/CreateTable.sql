DROP DATABASE IF EXISTS QuanLyNgheSi;
CREATE DATABASE QuanLyNgheSi;

USE QuanLyNgheSi;

DROP TABLE IF EXISTS NGHESI;
CREATE TABLE NGHESI 
( 
MaNghesi varchar (7) primary key, 
HovaTenNghesi nvarchar (50), 
Nghedanh nvarchar (50) unique, 
Ngaysinh date, 
Gioitinh nvarchar (5), 
Diachi nvarchar (50), 
Ngayramat date 
) 

CREATE TABLE HOPDONG  
( 
MaHopdong varchar (7) primary key, 
MaNghesi varchar (7), 
Ngaylap date, 
NgayBatdau date, 
NgayKetthuc date, 
foreign key (MaNghesi) references NGHESI 
)

CREATE TABLE TROLY  
( 
MaTroLy varchar (7) primary key, 
MaNghesi varchar (7), 
HovaTenTroLy nvarchar (50), 
Ngaysinh date, 
Gioitinh nvarchar (5), 
Diachi nvarchar (50), 
foreign key (MaNghesi) references NGHESI 
)

CREATE TABLE BAIHAT  
( 
MaBaihat varchar (7) primary key, 
MaNghesi varchar (7), 
TenBaihat nvarchar (50), 
NgayPhathanh date, 
ChiphiSanxuat float , 
Doanhthu float , 
foreign key (MaNghesi) references NGHESI  
) 

CREATE TABLE PHATHANH_BAIHAT  
( 
MaBaihat varchar (7), 
NentangPhathanh nvarchar (50), 
Luotxem int , 
foreign key (MaBaihat) references BAIHAT, 
PRIMARY KEY (MaBaihat, NentangPhathanh) 
)

CREATE TABLE HOATDONG  
( 
TenHoatdong nvarchar (50), 
ThoigianDienra varchar (20), 
Diadiem nvarchar (50), 
PRIMARY KEY (TenHoatdong, ThoigianDienra) 
)

CREATE TABLE NS_THAMGIA_HD  
( 
TenHoatdong nvarchar (50), 
ThoigianDienra varchar (20), 
MaNghesi varchar (7), 
ChiphiThamgia int , 
Catxe int , 
foreign key (MaNghesi) references NGHESI,  
foreign key (TenHoatdong, ThoigianDienra) references 
HOATDONG, 
PRIMARY KEY (TenHoatdong, ThoigianDienra, MaNghesi)       
) 

CREATE TABLE  GIAITHUONG  
( 
TenGiaithuong nvarchar (50), 
HangmucDecu nvarchar (50), 
MaNghesi varchar (7), 
MaBaihat varchar (7), 
Ketqua nvarchar (20), 
foreign key (MaNghesi) references NGHESI,  
foreign key (MaBaihat) references BAIHAT,  
PRIMARY KEY (TenGiaithuong, HangmucDecu) 
) 