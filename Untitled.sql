/********* A. BASIC QUERY *********/
-- 1. Liệt kê danh sách sinh viên sắp xếp theo thứ tự:
--      a. id tăng dần
SELECT *
FROM student
ORDER BY id;
--      b. giới tính
SELECT *
FROM student
ORDER BY gender;
--      c. ngày sinh TĂNG DẦN và học bổng GIẢM DẦN
SELECT *
FROM student
ORDER BY birthday, scholarship DESC;
-- 2. Môn học có tên bắt đầu bằng chữ 'T'
SELECT *
FROM subject
WHERE name LIKE 'T%';
-- 3. Sinh viên có chữ cái cuối cùng trong tên là 'i'
SELECT *
FROM student
WHERE name LIKE '%i';
--4. Những khoa có ký tự thứ hai của tên khoa có chứa chữ 'n'
SELECT *
FROM faculty
WHERE name LIKE '_n%';
-- 5. Sinh viên trong tên có từ 'Thị'
SELECT *
FROM student
WHERE name LIKE '%Thị%';
-- 6. Sinh viên có ký tự đầu tiên của tên nằm trong khoảng từ 'a' đến 'm', sắp xếp theo họ tên sinh viên
SELECT *
FROM student
WHERE name BETWEEN 'A' AND 'M'
ORDER BY name;
-- 7. Sinh viên có học bổng lớn hơn 100000, sắp xếp theo mã khoa giảm dần
SELECT *
FROM student
WHERE scholarship > 100000
ORDER BY faculty_id DESC;
-- 8. Sinh viên có học bổng từ 150000 trở lên và sinh ở Hà Nội
SELECT *
FROM student
WHERE scholarship > 150000
      AND hometown = 'Hà Nội';
--9. Những sinh viên có ngày sinh từ ngày 01/01/1991 đến ngày 05/06/1992
SELECT *
FROM student
WHERE birthday BETWEEN TO_DATE('01/01/1991', 'dd/mm/yyyy') AND TO_DATE('05/06/1992', 'dd/mm/yyyy');
-- 10. Những sinh viên có học bổng từ 80000 đến 150000
SELECT *
FROM student
WHERE scholarship BETWEEN 80000 AND 150000;
-- 11. Những môn học có số tiết lớn hơn 30 và nhỏ hơn 45
SELECT *
FROM subject
WHERE lesson_quantity BETWEEN 30 AND 45;

/********* B. CALCULATION QUERY *********/
-- 1. Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Giới tính, Mã 
		-- khoa, Mức học bổng. Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao” nếu giá trị 
		-- của học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”.

SELECT id, name, gender, scholarship, CASE
                                          WHEN scholarship > 500000 THEN
                                              'Học bổng cao'
                                          ELSE
                                              'Mức trung bình'
                                      END AS "Mức học bổng"
FROM student
where scholarship IS not  Null;
-- 2. Tính tổng số sinh viên của toàn trường
SELECT COUNT(*) "Tổng sinh viên"
FROM student;
-- 3. Tính tổng số sinh viên nam và tổng số sinh viên nữ.
SELECT gender, COUNT(*) "Tổng sinh viên"
FROM student
GROUP BY gender;
-- 4. Tính tổng số sinh viên từng khoa
SELECT faculty_id AS "Khoa", COUNT(*) "Tổng sinh viên"
FROM student
GROUP BY faculty_id;
-- 5. Tính tổng số sinh viên của từng môn học
SELECT su.name, COUNT(*)
FROM student s
LEFT JOIN exam_management ex ON s.id = ex.student_id
RIGHT JOIN subject        su ON su.id = ex.subject_id
GROUP BY su.name;
-- 6. Tính số lượng môn học mà sinh viên đã học
SELECT COUNT(*) "Tong mon"
FROM   (SELECT subject_id
       FROM exam_management
       GROUP BY subject_id);

-- 7. Tổng số học bổng của mỗi khoa
SELECT faculty_id AS "Khoa", COUNT(*) "Số học bổng"
FROM student
WHERE scholarship IS NOT NULL
GROUP BY faculty_id;
-- 8. Cho biết học bổng cao nhất của mỗi khoa
SELECT faculty_id "Khoa", MAX(scholarship) AS "Học bổng cao nhất"
FROM student
WHERE scholarship IS NOT NULL
GROUP BY faculty_id;
-- 9. Cho biết tổng số sinh viên nam và tổng số sinh viên nữ của mỗi khoa
SELECT faculty_id AS "Khoa", gender, COUNT(*)   AS "Học bổng cao nhất"
FROM student
GROUP BY faculty_id, gender;
-- 10. Cho biết số lượng sinh viên theo từng độ tuổi
--CURRENT_TIMESTAMP tra ve thoi gian hien tai
-- EXTRACT cat year
SELECT ( EXTRACT(YEAR FROM current_timestamp) - EXTRACT(YEAR FROM birthday) ) AS "Tuoi"
, COUNT(*) AS "So luong"
FROM student
GROUP BY ( EXTRACT(YEAR FROM current_timestamp) - EXTRACT(YEAR FROM birthday) );
-- 11. Cho biết những nơi nào có ít nhất 2 sinh viên đang theo học tại trường
SELECT hometown, COUNT(*) AS "Số lượng"
FROM student
GROUP BY hometown
HAVING COUNT(*) > 1;
-- 12. Cho biết những sinh viên thi lại ít nhất 2 lần
SELECT s.name, ex.number_of_exam_taking
FROM student s
JOIN exam_management ex ON s.id = ex.student_id
WHERE ex.number_of_exam_taking > 1
GROUP BY s.name, ex.number_of_exam_taking;
-- 13. Cho biết những sinh viên nam có điểm trung bình lần 1 trên 7.0
SELECT s.name, ROUND(Avg(ex.mark),2)
FROM student s
JOIN exam_management ex ON s.id = ex.student_id
WHERE ex.number_of_exam_taking = 1
GROUP BY s.name
HAVING   Avg(ex.mark) > 7.0 ;
-- 14. Cho biết danh sách các sinh viên rớt ít nhất 2 môn ở lần thi 1 (rớt môn là điểm thi của môn không quá 4 điểm)
SELECT s.name, COUNT(*) AS "SỐ MÔN RỚT"
FROM student s
JOIN exam_management ex ON s.id = ex.student_id
WHERE ex.number_of_exam_taking = 1
      AND ex.mark < 4
GROUP BY s.name
HAVING COUNT(*) > 1;
-- 15. Cho biết danh sách những khoa có nhiều hơn 2 sinh viên nam
SELECT f.name,count(*)
FROM student s
JOIN faculty f ON s.faculty_id = f.id
WHERE s.gender = 'Nam'
GROUP BY f.name
HAVING count(*) >1 ;
-- 16. Cho biết những khoa có 2 sinh viên đạt học bổng từ 200000 đến 300000
SELECT f.name
FROM student s
JOIN faculty f ON s.faculty_id = f.id
WHERE scholarship BETWEEN 200000 AND 300000
GROUP BY f.name
HAVING COUNT(*) > 1;
-- 17. Cho biết sinh viên nào có học bổng cao nhất
SELECT *
FROM student
WHERE scholarship = (
    SELECT MAX(scholarship)
    FROM student
);
/********* C. DATE/TIME QUERY *********/
-- 1. Sinh viên có nơi sinh ở Hà Nội và sinh vào tháng 02
SELECT *
FROM student
WHERE hometown = 'Hà Nội'
      AND EXTRACT(MONTH FROM birthday) = 2;
-- 2. Sinh viên có tuổi lớn hơn 20
SELECT *
FROM student
WHERE ( EXTRACT(YEAR FROM current_timestamp) - EXTRACT(YEAR FROM birthday) ) > 20;
-- 3. Sinh viên sinh vào mùa xuân năm 1990
SELECT *
FROM student
WHERE EXTRACT(YEAR FROM birthday) = 1990
      AND ( EXTRACT(MONTH FROM birthday) BETWEEN 1 AND 4 );
/********* D. JOIN QUERY *********/
-- 1. Danh sách các sinh viên của khoa ANH VĂN và khoa VẬT LÝ
SELECT s.id, s.name, s.birthday, s.scholarship, f.name
FROM student s
JOIN faculty f ON s.faculty_id = f.id
WHERE f.name = 'Anh - Văn'
      OR f.name = 'Vật lý';
-- 2. Những sinh viên nam của khoa ANH VĂN và khoa TIN HỌC
SELECT s.id, s.name, s.birthday, s.scholarship, s.gender, f.name
FROM student s
JOIN faculty f ON s.faculty_id = f.id
WHERE gender = 'Nam'
      AND ( f.name = 'Anh - Văn'
            OR f.name = 'Vật lý' );
-- 3. Cho biết sinh viên nào có điểm thi lần 1 môn cơ sở dữ liệu cao nhất
SELECT s.id, s.name, s.birthday, s.scholarship, s.gender, ex.mark
FROM student s
JOIN exam_management ex ON s.id = ex.student_id
JOIN subject         su ON su.id = ex.subject_id
WHERE ex.number_of_exam_taking = 1
      AND su.name = 'Cơ sở dữ liệu'
      AND ex.mark = (
    SELECT MAX(mark)
    FROM exam_management ex
    JOIN subject su ON su.id = ex.subject_id
    WHERE su.name = 'Cơ sở dữ liệu'
);

-- 4. Cho biết sinh viên khoa anh văn có tuổi lớn nhất.
SELECT s.id, s.name, s.birthday, s.scholarship, s.gender, f.name
FROM student s
JOIN faculty f ON s.faculty_id = f.id
WHERE f.name = 'Anh - Văn'
      AND EXTRACT(YEAR FROM birthday) = EXTRACT(YEAR FROM(
    SELECT MIN(birthday)
    FROM student
));
-- 5. Cho biết khoa nào có đông sinh viên nhất
WITH t1 AS (
-- LAY RA SO LUONG SINH VIEN TRONG KHOA
    SELECT COUNT(*) AS "SO_LUONG"
    FROM student s
    JOIN faculty f ON s.faculty_id = f.id
    GROUP BY f.name
)
SELECT ff.name, COUNT(*) AS "SỐ LƯỢNG"
FROM student ss
JOIN faculty ff ON ss.faculty_id = ff.id
GROUP BY ff.name
HAVING COUNT(*) = (
    SELECT MAX(so_luong)
    FROM t1
);
-- 6. Cho biết khoa nào có đông nữ nhất
WITH t1 AS (
-- LAY RA SO LUONG SINH VIEN TRONG KHOA
    SELECT f.name, COUNT(*) AS "SO_LUONG"
    FROM student s
    JOIN faculty f ON s.faculty_id = f.id
    WHERE s.gender = 'Nữ'
    GROUP BY f.name
    ORDER by "SO_LUONG" DESC
)
SELECT name,SO_LUONG
FROM t1
where "SO_LUONG" = (SELECT Max(SO_LUONG)
                    FROM t1);
-- 7. Cho biết những sinh viên đạt điểm cao nhất trong từng môn
WITH t1 AS (
    SELECT su.id, MAX(ex.mark) AS "max"
    FROM subject su
    JOIN exam_management ex ON su.id = ex.subject_id
    GROUP BY su.id
)
SELECT s.name, su.name AS "Môn", t."max"
FROM student s
JOIN exam_management ex ON s.id = ex.student_id
JOIN subject         su ON su.id = ex.subject_id
JOIN t1               t ON ex.subject_id = t.id
WHERE ex.mark = t."max";
-- 8. Cho biết những khoa không có sinh viên học
SELECT f.name, COUNT(*)
FROM faculty f
JOIN student s ON s.faculty_id = f.id
GROUP BY f.name
HAVING COUNT(*) = 0;
-- 9. Cho biết sinh viên chưa thi môn cơ sở dữ liệu
WITH t1 AS (
    SELECT s.name
    FROM student s
    LEFT JOIN exam_management ex ON s.id = ex.student_id
    RIGHT JOIN subject        su ON su.id = ex.subject_id
    where su.name = 'Cơ sở dữ liệu'
    GROUP BY s.name
)
SELECT name
FROM student
WHERE name not IN  (SELECT name FROM t1);
-- 10. Cho biết sinh viên nào không thi lần 1 mà có dự thi lần 2
WITH t1 AS (
-- lọc ra tên và môn học số lần thi nhỏ có trong nhóm
    SELECT s.name, ex.subject_id, MIN(ex.number_of_exam_taking) AS "lan thi"
    FROM student s
    JOIN exam_management ex ON s.id = ex.student_id
    GROUP BY s.name, ex.subject_id
    HAVING COUNT(*) < 2
-- có hơn 2 lần thi không hợp lệ
)
SELECT name
FROM t1
WHERE t1."lan thi" = 2;
-- chỉ lọc ra lần thi 2