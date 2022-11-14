use "431z_Shulz";


--��-3 ������� SELECT ��� �������:
--1. ������� ������ SQL, ������� �������� �������� �������� ��� ���� �������, ������������ ��������������� � ��������� ���, ��� �������������, ��� � ��������.
SELECT 
	(l.Last_name + ' ' +  l.First_name + ' ' + l.Middle_name) AS '��� �������������',
	(s.Last_name + ' ' +  s.First_name + ' ' + s.Middle_name) AS '��� ��������',
	e.estimate AS '������'
FROM Estimates e 
	JOIN Students s ON e.student_code=s.id 
	JOIN Lecturer_Discipline ld ON e.lecturer_discipline_code=ld.id 
	JOIN Lecturers l ON ld.lecturer_code=l.id
ORDER BY '��� �������������';
--SELECT 
--	(l.Last_name + ' ' +  l.First_name + ' ' + l.Middle_name) AS '��� �������������',
--	(s.Last_name + ' ' +  s.First_name + ' ' + s.Middle_name) AS '��� ��������',
--	e.estimate AS '������'
--FROM Estimates e, Lecturer_Discipline ld, Lecturers l, Students s
--WHERE e.student_code=s.id AND e.lecturer_discipline_code=ld.id AND ld.lecturer_code=l.id
--ORDER BY '��� �������������';


--2. �������� ������ �� ������� ���� ���������� ��������� �� ����������.
SELECT 
	(s.last_name + ' ' +  s.first_name+ ' ' + s.middle_name) AS '��� ��������',
	d.name_discipline,
	e.estimate
FROM Estimates e 
	JOIN Students s ON s.id=e.student_code
	JOIN Lecturer_Discipline ld ON e.lecturer_discipline_code=ld.id
	JOIN Discipline d ON ld.discipline_code=d.id
WHERE 
	d.Name_Discipline='���.������' AND (s.Last_name='������' OR s.Last_name='��������');
--SELECT 
--	(s.last_name + ' ' +  s.first_name+ ' ' + s.middle_name) AS '��� ��������', e.estimate
--FROM Estimates e, Students s, Lecturer_Discipline ld, Discipline d
--WHERE 
--	e.student_code=s.id AND e.lecturer_discipline_code=ld.id AND ld.discipline_code=d.id AND
--	d.Name_Discipline='���.������' AND (s.Last_name='������' OR s.Last_name='��������');


--3. �������� ������, ��� �� ��������� �� ������ ������� �� ����������.
SELECT 
	(s.last_name + ' ' +  s.first_name + ' ' + s.middle_name) AS '��� ��������',
	d.name_discipline,
	e.type_of_control,
	e.estimate
FROM Estimates e 
	JOIN Students s ON s.id=e.student_code
	JOIN Lecturer_Discipline ld ON e.lecturer_discipline_code=ld.id
	JOIN Discipline d ON ld.discipline_code=d.id
WHERE 
	d.name_discipline='���.������' AND
	e.estimate=0 AND
	e.type_of_control='�������';
--SELECT (s.last_name + ' ' +  s.first_name + ' ' + s.middle_name) AS '��� ��������', d.name_discipline, e.estimate
--FROM Estimates e, Students s, Lecturer_Discipline ld, Discipline d
--WHERE
--	e.student_code=s.id AND 
--	e.lecturer_discipline_code=ld.id AND 
--	ld.discipline_code=d.id AND
--	d.name_discipline='���.������' AND 
--	e.estimate=0 AND
--	e.type_of_control='�������';


--4. ������� ������ ���������, �� ������� ������� �� ����������� � 2008 �.
SELECT 
	(s.last_name + ' ' +  s.first_name + ' ' + s.middle_name) AS '��� ��������', 
	e.estimate
FROM Estimates e, Students s, Lecturer_Discipline ld, Discipline d
WHERE
	e.student_code=s.id AND 
	e.lecturer_discipline_code=ld.id AND 
	ld.discipline_code=d.id AND
	d.name_discipline='�����������' AND
	e.type_of_control='�������' AND
	e.estimate<3 AND
	YEAR(e.date_pass)=2008;
	


--5. �������� ������ � ��������� 1989 �.�. �� ������� ��������.
SELECT * FROM Students WHERE YEAR(date_of_birth) = 2000 and phone_number is null; 


--6. ���������� ���������� ���������, ������� ������ ���������.
SELECT s.last_name, COUNT(e.estimate) AS Exam_Count FROM Estimates e, Students s
WHERE 
	e.student_code=s.id AND
	e.type_of_control='�������' AND
	e.estimate>2 
GROUP BY s.last_name;


--7. ���������� ���������� ������� ��� ������� ��������.
SELECT s.last_name, COUNT(e.estimate) FROM Estimates e, Students s
WHERE e.student_code=s.id AND e.estimate=5
GROUP BY s.last_name;


--8. ���������� ������� ���� �� ������� ��������.
SELECT d.name_discipline, AVG(e.estimate) AS Estimate_AVG FROM Estimates e, Lecturer_Discipline ld, Discipline d
WHERE e.lecturer_discipline_code=ld.id AND ld.discipline_code=d.id
GROUP BY d.name_discipline;


--9. ����� ���������� � ������������ ����������� ���������� �����.

SELECT 
	d.name_discipline, 
	COUNT(e.estimate) AS num_estimate 
FROM Estimates e, Lecturer_Discipline ld, Discipline d
WHERE 
	e.lecturer_discipline_code=ld.id AND 
	ld.discipline_code=d.id AND 
	e.estimate=2 
GROUP BY d.name_discipline
HAVING COUNT(e.estimate)=(
	SELECT MAX(t.num_estimate)
	FROM (	
		SELECT COUNT(e.estimate) AS num_estimate 
		FROM Estimates e, Lecturer_Discipline ld, Discipline d
		WHERE e.lecturer_discipline_code=ld.id AND ld.discipline_code=d.id AND e.estimate=2 
		GROUP BY d.name_discipline
	) t)

--GO
--CREATE VIEW bad_estimates (num_estimate) AS 
--	SELECT MAX(t.num_estimate)
--	FROM (
--		SELECT COUNT(e.estimate) AS num_estimate 
--		FROM Estimates e, Lecturer_Discipline ld, Discipline d
--		WHERE e.lecturer_discipline_code=ld.id AND ld.discipline_code=d.id AND e.estimate=2 
--		GROUP BY d.name_discipline
--		) t
--GO

--SELECT 
--	d.name_discipline, 
--	COUNT(e.estimate) AS num_estimate 
--FROM Estimates e, Lecturer_Discipline ld, Discipline d
--WHERE 
--	e.lecturer_discipline_code=ld.id AND 
--	ld.discipline_code=d.id AND 
--	e.estimate=2 
--GROUP BY d.name_discipline
--HAVING COUNT(e.estimate)=(SELECT * FROM bad_estimates)


--10. ��� �� �������������� �� ����� � ������� ��������?
select * from Lecturers l JOIN Lecturer_Discipline ld ON l.id=ld.lecturer_code WHERE discipline_code is null; 


--11. ��������� �������������� ������� ���, ���������� ��� �������� � ������� ������� ����, �� ������� ������.
--������ ������� � ���������
CREATE TABLE Department (
	id int IDENTITY(1, 1) primary key,
	name_department varchar(10) NOT NULL
);
INSERT INTO Department (name_department)
	VALUES ('������'), ('���');

--� ������� �������������� �������� ���� �������
ALTER TABLE Lecturers
ADD department int foreign key references Department(id);

select * from Lecturers;



--��������� �������������� ������� ���
UPDATE Lecturers
SET department = 2

select * from Lecturers;

--����� �������
UPDATE l
SET l.department = (SELECT id FROM Department WHERE name_department='������')
FROM Lecturers l JOIN Lecturer_Discipline ld ON l.id=ld.lecturer_code 
WHERE discipline_code is null; 

select * from Lecturers;



--12. ���� ���������, �� ������� ��������� ���������, ��������� �� ��������� ����, � ��������� 4-�� ����� � ������ �����������.
--�������� � ������� ��������� ���� ����
ALTER TABLE Students
ADD course varchar(10);

--�������� �������, � �������� ������ ����� ���� ����� �� �������� �� ������ ������ (��������: 421 = 2 ����)
UPDATE s
SET course = SUBSTRING(g.number, 2, 1)
FROM Students s JOIN Groups g
ON s.group_code=g.id

UPDATE Students
SET course = CASE
				WHEN course = 4 THEN '������' ELSE CAST(course + 1 AS varchar)
			END
WHERE id in (
	SELECT s.id
	FROM 
		Estimates e JOIN Students s ON e.student_code=s.id
	WHERE estimate not in (-1, 0, 2)
	GROUP BY s.id
	HAVING COUNT(e.estimate) = 4
)


SELECT * FROM Students;
