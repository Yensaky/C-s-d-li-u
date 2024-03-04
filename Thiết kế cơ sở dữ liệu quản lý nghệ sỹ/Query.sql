USE QuanLyNgheSi;

-- 1. Thống kê tất cả các hợp đồng còn thời hạn, số ngày còn thời hạn của hợp đồng đó của nghệ sĩ ra mắt vào năm 2018
SELECT  
	HOPDONG.MaHopdong,  
	HOPDONG.MaNghesi,  
	HOPDONG.NgayBatdau, 
	HOPDONG.NgayKetthuc,  
	DATEDIFF(day,'2022-05-06',NgayKetthuc) AS SongayConHopdong 
FROM HOPDONG 
	INNER JOIN NGHESI ON HOPDONG.MaNghesi = NGHESI.MaNghesi 
WHERE  NGHESI.Ngayramat LIKE '2018%' 
	AND DATEDIFF(day, getdate(),NgayKetthuc) > 0; 

-- 2. Cho biết họ và tên, địa chỉ của các trợ lý mà nghệ sĩ thuộc sự quản lý của họ đã từng tham gia ít nhất 2 hoạt động
SELECT HovaTenTroly, Diachi  
FROM TROLY  
WHERE MaNghesi IN (SELECT MaNghesi  
FROM NS_Thamgia_HD    
GROUP BY MaNghesi  
HAVING COUNT(MaNghesi) >= 2)

-- 3. Thống kê danh sách các bài hát Lãi hay Lỗ biết khi doanh thu lớn hơn chi phí sản xuất thì Lãi, còn khi doanh thu nhỏ hơn chi phí sản xuất thì Lỗ và khi doanh thu bằng chi phí sản xuất thì Hoà vốn
SELECT  
	TenBaihat, Doanhthu, ChiphiSanxuat,  
	(Doanhthu - ChiphiSanxuat) AS Loinhuan, 
	CASE    
		WHEN (Doanhthu - ChiphiSanxuat)  > 0 THEN 'Lai'   
		WHEN (Doanhthu - ChiphiSanxuat) = 0 THEN 'Hoa_von'   
		WHEN (Doanhthu - ChiphiSanxuat) < 0 THEN 'Lo'   
		END AS [Lai/Lo] 
	FROM BAIHAT

-- 4. Đưa ra Mã nghệ sĩ, Tên nghệ sĩ, Tên bài hát và Chi phí sản xuất của bài hát mà nghệ sĩ thể hiện đã từng nhận được giải thưởng và chi phí sản xuất bài hát nằm trong khoảng từ 200 đến 300 triệu VND
SELECT   
	NGHESI.MaNghesi, HovaTenNghesi,  
	TenBaihat, 
	ChiphiSanxuat  
FROM BAIHAT  
	JOIN NGHESI ON BAIHAT.MaNghesi = NGHESI.MaNghesi  
	JOIN GIAITHUONG ON NGHESI.MaNghesi = GIAITHUONG.MaNghesi  
WHERE  
	GIAITHUONG.Ketqua = 'DAT' 
	AND ChiphiSanxuat BETWEEN 200 AND 300 
GROUP BY NGHESI.MaNghesi, HovaTenNghesi, TenBaihat, ChiphiSanxuat; 

-- 5. Đưa ra danh sách Nghệ sĩ chưa từng nhận được giải thưởng nào trong quá trình hoạt động ở công ty
SELECT*  
FROM NGHESI  
WHERE NGHESI.MaNghesi  
	NOT IN	(SELECT GIAITHUONG.MaNghesi	
			FROM NGHESI JOIN GIAITHUONG  
			ON NGHESI.MaNghesi = GIAITHUONG.MaNghesi   
			WHERE Ketqua = 'DAT'  
			GROUP BY GIAITHUONG.MaNghesi);

-- 6. Thống kê số lượng các bài hát mà mỗi nghệ sĩ phát hành trong năm 2020 theo thứ tự giảm dần
SELECT  
	BAIHAT.MaNghesi, 
	NGHESI.HovaTenNghesi,  
	COUNT (BAIHAT.MaNghesi) AS SL_Baihat  
FROM BAIHAT, NGHESI  
WHERE  BAIHAT.MaNghesi = NGHESI.MaNghesi  
	AND NgayPhathanh LIKE '2020%' 
GROUP BY BAIHAT.MaNghesi, NGHESI.HovaTenNghesi, NgayPhathanh  
ORDER BY SL_Baihat DESC; 

-- 7. Đưa ra Mã nghệ sĩ, Họ và tên, tên hoạt động của những nghệ sĩ nữ đã tham gia hoạt động có địa điểm tại Nam Định
SELECT  
	NGHESI.MaNghesi, HovaTenNghesi,  
	HOATDONG.TenHoatdong, Diadiem  
FROM NGHESI 
	JOIN NS_THAMGIA_HD ON NGHESI.MaNghesi = NS_THAMGIA_HD.MaNghesi  
	JOIN HOATDONG ON NS_THAMGIA_HD.ThoigianDienra = HOATDONG.ThoigianDienra  
WHERE Gioitinh = 'Nu' AND Diadiem = 'Nam Dinh'; 

-- 8. Đưa ra Mã số, Tên bài hát và lượt xem trên Youtube theo thứ tự tăng dần của bài hát do nữ nghệ sĩ thể hiện
SELECT 
	NGHESI.MaNghesi,  
	TenBaihat,  
	NentangPhathanh,  
	Luotxem  
FROM PHATHANH_BAIHAT  
	JOIN BAIHAT 
	ON PHATHANH_BAIHAT.MaBaihat = BAIHAT.MaBaihat  
	JOIN NGHESI ON BAIHAT.MaNghesi = NGHESI.MaNghesi  
WHERE Gioitinh = 'Nu'  AND NentangPhathanh = 'Youtube' 
ORDER BY Luotxem ASC; 

-- 9. Đưa ra mã nghệ sĩ, nghệ danh, tên hoạt động, cát-xê, chi phí tham gia và lợi nhuận của 3 hoạt động đem lại nhiều lợi nhuận nhất cho công ty: 
SELECT TOP 3 PERCENT
	NGHESI.MaNghesi, Nghedanh,  
	TenHoatdong, 
	Catxe,  
	ChiphiThamgia,  
	(Catxe - ChiphiThamgia) AS LOINHUAN 
FROM NS_THAMGIA_HD  
	JOIN NGHESI  
	ON NS_THAMGIA_HD.MaNghesi = NGHESI.MaNghesi  
ORDER BY LOINHUAN DESC;  

-- 10. Cho biết những nghệ sĩ có từ 3 trợ lý trở lên và có địa chỉ hoặc ở Hải Phòng hoặc ở Thái Bình: 
SELECT * 
FROM NGHESI 
WHERE  
	MaNghesi  
	IN   (SELECT TROLY.MaNghesi 
FROM NGHESI  
	JOIN TROLY ON NGHESI.MaNghesi = TROLY.MaNghesi 
WHERE NGHESI.DIACHI = 'Hai Phong'  
	OR  NGHESI.DIACHI = 'Thai Binh' 
GROUP BY TROLY.MaNghesi 
HAVING COUNT (TROLY.MaNghesi) >=3); 
