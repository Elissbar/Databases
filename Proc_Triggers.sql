use "431z_Shulz";
GO

set DATEFORMAT dmy;

-- 1. ������� �������� ��������� ��� ����������, ������� �����
--    �������� ������ � ����� ���������� ���� ��������� �������������, ��������,
--    ���������� ��.
DROP PROCEDURE IF EXISTS GetInfo;
GO

CREATE PROCEDURE GetInfo AS
BEGIN
	SELECT 
		(s.last_name + ' ' + s.first_name + ' ' + s.middle_name) AS '��� ��������',
		e.estimate, e.semester
	FROM Estimates e 
	JOIN Students s ON e.student_code=s.id
	JOIN Lecturer_Discipline ld ON e.lecturer_discipline_code=ld.id
	JOIN Lecturers l ON l.id=ld.lecturer_code
	WHERE type_of_control='�������' AND l.last_name='��������';
END
GO

EXEC GetInfo;


-- 2. ������� ��������� � ������� ����������, ������� ����� ���������
--    ����, ��� � ����������, �� ��� ������������� ����� ���������� ���
--    ��������.

DROP PROCEDURE IF EXISTS GetInfoByLectorName;
GO

CREATE PROCEDURE GetInfoByLectorName 
	@lecturer_name VARCHAR(20)
AS
BEGIN
	SELECT 
		(s.last_name + ' ' + s.first_name + ' ' + s.middle_name) AS '��� ��������',
		e.estimate, e.semester
	FROM Estimates e 
	JOIN Students s ON e.student_code=s.id
	JOIN Lecturer_Discipline ld ON e.lecturer_discipline_code=ld.id
	JOIN Lecturers l ON l.id=ld.lecturer_code
	WHERE type_of_control='�������' AND l.last_name=@lecturer_name;
END
GO

EXEC GetInfoByLectorName '������';


-- 3. ������� ��������� � �������� ����������� � ���������� ��
--    ���������, ������� ����� �������� ������ � ����������� ��������� ���������
--    �������� � �������� �������.
DROP PROCEDURE IF EXISTS GetStudentInfo;
GO

CREATE PROCEDURE GetStudentInfo 
	@student_name VARCHAR(20) = '�������',
	@estimate INT = 4
AS
BEGIN
	SELECT 
		(s.last_name + ' ' + s.first_name + ' ' + s.middle_name) AS '��� ��������',
		e.estimate, e.semester
	FROM Estimates e 
	JOIN Students s ON e.student_code=s.id
	JOIN Lecturer_Discipline ld ON e.lecturer_discipline_code=ld.id
	JOIN Lecturers l ON l.id=ld.lecturer_code
	WHERE type_of_control='�������' AND s.last_name=@student_name AND e.estimate=@estimate;
END
GO

EXEC GetStudentInfo;


-- 4. ������� �������� ���������, ������� ����� ���������� ��������
--    ��������� ��������� @��������������� ��� ������� ��� �������.
DROP PROCEDURE IF EXISTS GetStudentPhoneNumber;
GO

CREATE PROCEDURE GetStudentPhoneNumber
	@last_name VARCHAR(20),
	@phone_number VARCHAR(16) OUTPUT
AS
BEGIN
	SELECT @phone_number = s.phone_number FROM Students s WHERE s.last_name=@last_name
END
GO

DECLARE @phone_number VARCHAR(16);
EXEC GetStudentPhoneNumber '��������', @phone_number OUTPUT;
PRINT @phone_number


-- 5. ������� �������� ���������, ������� ������������ � ������ �������������� ���������� �������������� �� �������� ��.�.�.� (��������� ����������� ����) ��� ����� �������, ��� ��� ������������ �������.
-- �������� ������ ������� � ������� ��������������
ALTER TABLE Lecturers
ADD academic_degree VARCHAR(20);

-- ��� ��������������, � ������� ID > 8, ����� ������ �������
UPDATE Lecturers
SET academic_degree = '�.�.�.'
WHERE id > 8;

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

UPDATE Lecturers
SET department = (id % 2) + 1

DROP PROCEDURE IF EXISTS GetCountLecturers;
GO

CREATE PROCEDURE GetCountLecturers 
	@department VARCHAR(20) = ''
AS
BEGIN
	SELECT COUNT(*)
	FROM Lecturers l JOIN Department d ON l.department=d.id
	WHERE academic_degree = '�.�.�.' AND d.name_department=@department
END					
GO

EXEC GetCountLecturers '���';
GO


-- 6. ������� �������� ��������� ��� ������������ ��������������� 
--    ��������� �� ������ �������� ��� ����� ������ � ������� ������.
DROP PROCEDURE IF EXISTS CreateStatement;
GO

CREATE PROCEDURE CreateStatement 
AS
BEGIN
	DECLARE @result table(lecturer_name varchar(20), student_name varchar(20), group_number varchar(15), type_control varchar(15), estimate INT, date_pass smalldatetime, name_discipline varchar(20))

	INSERT INTO @result (
		lecturer_name, 
		student_name, 
		group_number,
		type_control, 
		estimate, 
		date_pass, 
		name_discipline) 
	SELECT t.lecturer, t.student, t.number, t.type_of_control, t.estimate, t.date_pass, t.name_discipline 
	FROM 
	(
		SELECT 
			l.last_name AS lecturer, s.last_name AS student, g.number, e.type_of_control, e.estimate, e.date_pass, d.name_discipline
		FROM Estimates e JOIN Students s ON e.student_code=s.id
		JOIN Lecturer_Discipline ld ON e.lecturer_discipline_code=ld.id
		JOIN Lecturers l ON ld.lecturer_code=l.id
		JOIN Discipline d ON d.id=ld.discipline_code
		JOIN Groups g ON s.group_code=g.id
	) t

	SELECT * FROM @result
END					
GO

EXEC CreateStatement;
GO


-- 7. ������� �������, ������� ��������� ��� ����� ������� ��������� ������ � ������� ���������, ������ ��������������� ���������.
DROP TRIGGER IF EXISTS ChangeEstimate;
GO

CREATE TRIGGER ChangeEstimate
ON Estimates
INSTEAD OF UPDATE
AS
	IF (UPDATE(estimate))
		DECLARE @new_estimate INT, @row_id INT
		SELECT @new_estimate = estimate, @row_id = id FROM inserted
		PRINT '������� ��������� ������ �� ��������: ' + CAST(@new_estimate AS VARCHAR(5)) + CHAR(13) + 'ID ������: ' + CAST(@row_id AS VARCHAR(5));
GO

UPDATE Estimates
SET estimate = 7
WHERE id=6;

UPDATE Estimates
SET estimate = -1
WHERE id=1;

SELECT * FROM Estimates WHERE id=6 OR id=1;


-- 8. ������� �������, ������� ����� ������� ������� ���� ������� ������ ����� ���������� ������ � ������� ���������.
DROP TRIGGER IF EXISTS CountAVGEstimate;
GO

CREATE TRIGGER CountAVGEstimate
ON Estimates
AFTER INSERT
AS
	DECLARE @current_semester INT, @avg_estimate INT
	SELECT @current_semester = semester FROM inserted
	SELECT ROUND(AVG(CAST(estimate AS FLOAT)), 2) FROM Estimates WHERE semester=@current_semester
GO

INSERT INTO Estimates 
	(student_code, semester, date_pass, lecturer_discipline_code, type_of_control, estimate)
VALUES
	(3, 8, '15-05-2008', 1, '�������', 4)
 

 -- 9. ������� �������, ������� ����� �������� ������ ��������� �� ������� ����� �������� ��������� ������� ����� �� ������.
ALTER TABLE Students
ADD course varchar(10);

UPDATE s
SET course = SUBSTRING(g.number, 2, 1)
FROM Students s JOIN Groups g
ON s.group_code=g.id

DROP TRIGGER IF EXISTS GetStudentsByGroup
GO 

CREATE TRIGGER GetStudentsByGroup
ON Students
AFTER UPDATE
AS
	IF (UPDATE(course))
		DECLARE @new_value INT, @old_value INT
		SELECT @new_value = course FROM inserted
		SELECT @old_value = course FROM deleted
		IF (@old_value=1 AND @new_value = 2)
			SELECT g.number, s.last_name, s.first_name, s.middle_name 
			FROM Students s JOIN Groups g ON s.group_code=g.id
			GROUP BY g.number, s.last_name, s.first_name, s.middle_name
GO

UPDATE Students
SET course = 2
WHERE id=1

UPDATE Students
SET course = 3
WHERE id=2

SELECT * FROM Students WHERE id=1 OR id=2;


-- 10. ������� �������, ������� ����� ���������� ������ � ������� ��������, 
--      �������� ���������� ��������� � ������ ������ � ���������
--      ��������� � �������� �� ����� � � ����� ��������� ������ �� ������ � ������������ ����������� ���������.
DROP TRIGGER IF EXISTS MoveStudents
GO 

CREATE TRIGGER MoveStudents
ON Students
AFTER INSERT
AS
	INSERT INTO Groups (number, created_at, education_form, price, education_end)
	VALUES ('777', '01-09-2021', '�����', 120000, 0);

	DECLARE @id_new_group VARCHAR(30) = IDENT_CURRENT('Groups')

	PRINT N'New group id: ' + @id_new_group

	UPDATE Students
	SET group_code=@id_new_group
	WHERE group_code = (
		SELECT g.id AS group_code FROM Students s JOIN Groups g ON s.group_code=g.id
		GROUP BY g.id
		HAVING COUNT(s.last_name) = 
		(
			SELECT MAX(t.count_person) FROM 
			(
				SELECT g.number, COUNT(s.last_name) AS count_person FROM Students s JOIN Groups g ON s.group_code=g.id
				GROUP BY g.number
			) t
		)
	)
GO

INSERT INTO Students (last_name, first_name, middle_name, gender, date_of_birth, group_code, phone_number) 
VALUES ('Test', 'Test', 'Test', 'Test', '25.08.2000', 1, '+7 937 729 56 78');

SELECT * FROM Students
