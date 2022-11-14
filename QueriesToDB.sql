use "431z_Shulz";


--ПЗ-3 Деканат SELECT все запросы:
--1. Создать запрос SQL, который позволит получить сведения обо всех оценках, выставленных преподавателями с указанием ФИО, как преподавателя, так и студента.
SELECT 
	(l.Last_name + ' ' +  l.First_name + ' ' + l.Middle_name) AS 'ФИО Преподавателя',
	(s.Last_name + ' ' +  s.First_name + ' ' + s.Middle_name) AS 'ФИО Студента',
	e.estimate AS 'Оценка'
FROM Estimates e 
	JOIN Students s ON e.student_code=s.id 
	JOIN Lecturer_Discipline ld ON e.lecturer_discipline_code=ld.id 
	JOIN Lecturers l ON ld.lecturer_code=l.id
ORDER BY 'ФИО Преподавателя';
--SELECT 
--	(l.Last_name + ' ' +  l.First_name + ' ' + l.Middle_name) AS 'ФИО Преподавателя',
--	(s.Last_name + ' ' +  s.First_name + ' ' + s.Middle_name) AS 'ФИО Студента',
--	e.estimate AS 'Оценка'
--FROM Estimates e, Lecturer_Discipline ld, Lecturers l, Students s
--WHERE e.student_code=s.id AND e.lecturer_discipline_code=ld.id AND ld.lecturer_code=l.id
--ORDER BY 'ФИО Преподавателя';


--2. Получить данные по оценкам двух конкретных студентов по математике.
SELECT 
	(s.last_name + ' ' +  s.first_name+ ' ' + s.middle_name) AS 'ФИО Студента',
	d.name_discipline,
	e.estimate
FROM Estimates e 
	JOIN Students s ON s.id=e.student_code
	JOIN Lecturer_Discipline ld ON e.lecturer_discipline_code=ld.id
	JOIN Discipline d ON ld.discipline_code=d.id
WHERE 
	d.Name_Discipline='Мат.анализ' AND (s.Last_name='Мичуев' OR s.Last_name='Курбанов');
--SELECT 
--	(s.last_name + ' ' +  s.first_name+ ' ' + s.middle_name) AS 'ФИО Студента', e.estimate
--FROM Estimates e, Students s, Lecturer_Discipline ld, Discipline d
--WHERE 
--	e.student_code=s.id AND e.lecturer_discipline_code=ld.id AND ld.discipline_code=d.id AND
--	d.Name_Discipline='Мат.анализ' AND (s.Last_name='Мичуев' OR s.Last_name='Курбанов');


--3. Получить данные, кто из студентов не сдавал экзамен по математике.
SELECT 
	(s.last_name + ' ' +  s.first_name + ' ' + s.middle_name) AS 'ФИО Студента',
	d.name_discipline,
	e.type_of_control,
	e.estimate
FROM Estimates e 
	JOIN Students s ON s.id=e.student_code
	JOIN Lecturer_Discipline ld ON e.lecturer_discipline_code=ld.id
	JOIN Discipline d ON ld.discipline_code=d.id
WHERE 
	d.name_discipline='Мат.анализ' AND
	e.estimate=0 AND
	e.type_of_control='Экзамен';
--SELECT (s.last_name + ' ' +  s.first_name + ' ' + s.middle_name) AS 'ФИО Студента', d.name_discipline, e.estimate
--FROM Estimates e, Students s, Lecturer_Discipline ld, Discipline d
--WHERE
--	e.student_code=s.id AND 
--	e.lecturer_discipline_code=ld.id AND 
--	ld.discipline_code=d.id AND
--	d.name_discipline='Мат.анализ' AND 
--	e.estimate=0 AND
--	e.type_of_control='Экзамен';


--4. Вывести список студентов, не сдавших экзамен по информатике в 2008 г.
SELECT 
	(s.last_name + ' ' +  s.first_name + ' ' + s.middle_name) AS 'ФИО Студента', 
	e.estimate
FROM Estimates e, Students s, Lecturer_Discipline ld, Discipline d
WHERE
	e.student_code=s.id AND 
	e.lecturer_discipline_code=ld.id AND 
	ld.discipline_code=d.id AND
	d.name_discipline='Информатика' AND
	e.type_of_control='Экзамен' AND
	e.estimate<3 AND
	YEAR(e.date_pass)=2008;
	


--5. Получить данные о студентах 1989 г.р. не имеющих телефона.
SELECT * FROM Students WHERE YEAR(date_of_birth) = 2000 and phone_number is null; 


--6. Подсчитать количество экзаменов, сданных каждым студентом.
SELECT s.last_name, COUNT(e.estimate) AS Exam_Count FROM Estimates e, Students s
WHERE 
	e.student_code=s.id AND
	e.type_of_control='Экзамен' AND
	e.estimate>2 
GROUP BY s.last_name;


--7. Подсчитать количество пятерок для каждого студента.
SELECT s.last_name, COUNT(e.estimate) FROM Estimates e, Students s
WHERE e.student_code=s.id AND e.estimate=5
GROUP BY s.last_name;


--8. Подсчитать средний балл по каждому предмету.
SELECT d.name_discipline, AVG(e.estimate) AS Estimate_AVG FROM Estimates e, Lecturer_Discipline ld, Discipline d
WHERE e.lecturer_discipline_code=ld.id AND ld.discipline_code=d.id
GROUP BY d.name_discipline;


--9. Найти дисциплину с максимальным количеством полученных двоек.

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


--10. Кто из преподавателей не занят в текущем семестре?
select * from Lecturers l JOIN Lecturer_Discipline ld ON l.id=ld.lecturer_code WHERE discipline_code is null; 


--11. Перевести преподавателей кафедры КИС, оставшихся без нагрузки в текущем учебном году, на кафедру ИТиЕНД.
--Создаю таблицу с кафедрами
CREATE TABLE Department (
	id int IDENTITY(1, 1) primary key,
	name_department varchar(10) NOT NULL
);
INSERT INTO Department (name_department)
	VALUES ('ИТиЕНД'), ('КИС');

--В таблицу преподавателей добавляю поле кафедры
ALTER TABLE Lecturers
ADD department int foreign key references Department(id);

select * from Lecturers;



--Записываю преподавателям кафедру КИС
UPDATE Lecturers
SET department = 2

select * from Lecturers;

--Меняю кафедру
UPDATE l
SET l.department = (SELECT id FROM Department WHERE name_department='ИТиЕНД')
FROM Lecturers l JOIN Lecturer_Discipline ld ON l.id=ld.lecturer_code 
WHERE discipline_code is null; 

select * from Lecturers;



--12. Всех студентов, не имеющих несданных дисциплин, перевести на следующий курс, а студентов 4-го курса в группу дипломников.
--Добавляю в таблицу студентов поле курс
ALTER TABLE Students
ADD course varchar(10);

--Обновляю таблицу, в качестве номера курса беру число по середине из номера группы (Например: 421 = 2 курс)
UPDATE s
SET course = SUBSTRING(g.number, 2, 1)
FROM Students s JOIN Groups g
ON s.group_code=g.id

UPDATE Students
SET course = CASE
				WHEN course = 4 THEN 'Диплом' ELSE CAST(course + 1 AS varchar)
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
