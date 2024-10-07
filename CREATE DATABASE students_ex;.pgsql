CREATE DATABASE students_ex;


CREATE TABLE courses (
    id_course SERIAL PRIMARY KEY,        
    title VARCHAR(255) NOT NULL,        
    description TEXT,                    
    hours INT CHECK (hours > 0)         
);


CREATE TABLE students (
    id_stud SERIAL PRIMARY KEY,          
    name VARCHAR(100) NOT NULL,          
    surname VARCHAR(100) NOT NULL,       
    birthday DATE NOT NULL,            
    phone_number VARCHAR(15),            
    "group" VARCHAR(50),                 
    gender CHAR(1) CHECK (gender IN ('M', 'F')),  
    entered_at DATE,                 
    department VARCHAR(100)             
);


CREATE TABLE exams (
    id_stud INT REFERENCES Students(id_stud) ON DELETE CASCADE,   
    id_course INT REFERENCES Courses(id_course) ON DELETE CASCADE,
    mark INT CHECK (mark >= 0 AND mark <= 100),                  
    PRIMARY KEY (id_stud, id_course)  
);


INSERT INTO courses (title, description, hours)
VALUES
('Mathematics', 'Basic mathematics course', 120),
('Physics', 'Introduction to physics', 100),
('Computer Science', 'Fundamentals of programming', 150);


INSERT INTO students (name, surname, birthday, phone_number, "group", gender, entered_at, department)
VALUES
('John', 'Doe', '2001-05-14', '1234567890', 'CS-01', 'M', '2020-09-01', 'Computer Science'),
('Jane', 'Smith', '2000-08-22', '0987654321', 'CS-02', 'F', '2019-09-01', 'Physics'),
('Alice', 'Johnson', '2002-11-30', '5678901234', 'CS-03', 'F', '2021-09-01', 'Mathematics');


INSERT INTO exams (id_stud, id_course, mark)
VALUES
(1, 1, NULL),  
(1, 2, NULL),  
(2, 2, 85),    
(3, 3, NULL); 

-----------------------
SELECT * FROM courses;

SELECT * FROM students;

SELECT * FROM exams;
----------------------


-- 1 Відобразити, коли відбувся перший набір (мінімальний рік ступу)

SELECT MIN(EXTRACT(YEAR FROM entered_at)) AS first_year_of_enrollment
FROM students;

-- 2 Відобразити кількість студентів, які навчаються у кожній групі.
SELECT "group", COUNT(*) AS student_count
FROM students
GROUP BY "group";

-- 3 Відобразити загальну кількість студентів, які вступили 2018 року.
SELECT COUNT(*) AS student_count
FROM students
WHERE EXTRACT(YEAR FROM entered_at) = 2018;


-- 4 Відобразити середній вік студентів жіночої статі кожного факультету. Список впорядкувати за зменшенням віку. Стовпчик із середнім віком назвати avg_age.
SELECT department, AVG(EXTRACT(YEAR FROM AGE(birthday))) AS avg_age
FROM students
WHERE gender = 'F'
GROUP BY department
ORDER BY avg_age DESC;

-- 5 Відобразити імена та прізвища студентів та назви курсів, що ними вивчаються.
SELECT s.name, s.surname, c.title
FROM students s
JOIN exams e ON s.id_stud = e.id_stud
JOIN courses c ON e.id_course = c.id_course;

-- 6 Відобразити бали студента Петра Петренка з дисципліни «Основи програмування» (припускаємо, що ім'я та прізвище мають конкретні значення):
SELECT e.mark
FROM students s
JOIN exams e ON s.id_stud = e.id_stud
JOIN courses c ON e.id_course = c.id_course
WHERE s.name = 'Петро' AND s.surname = 'Петренко' AND c.title = 'Основи програмування';

-- 7 Відобразити студентів, які мають бали нижче 3.5.
SELECT s.name, s.surname, e.mark
FROM students s
JOIN exams e ON s.id_stud = e.id_stud
WHERE e.mark < 35;

-- 8 Відобразити студентів, які прослухали дисципліну «Основи програмування» та мають за неї оцінку.
SELECT s.name, s.surname, e.mark
FROM students s
JOIN exams e ON s.id_stud = e.id_stud
JOIN courses c ON e.id_course = c.id_course
WHERE c.title = 'Основи програмування' AND e.mark IS NOT NULL;

-- 9 Відобразити середній бал та кількість курсів, які відвідав кожен студент.
SELECT s.name, s.surname, AVG(e.mark) AS average_mark, COUNT(e.id_course) AS course_count
FROM students s
JOIN exams e ON s.id_stud = e.id_stud
GROUP BY s.id_stud;

-- 10 Відобразити студентів, які мають середній бал вище 4.0.
SELECT s.name, s.surname, AVG(e.mark) AS average_mark
FROM students s
JOIN exams e ON s.id_stud = e.id_stud
GROUP BY s.id_stud
HAVING AVG(e.mark) > 40;

-- =====================================================================================================================================================================

-- Отримати список студентів, у яких день народження збігається із днем народження Петра Петренка.
SELECT name, surname, birthday
FROM students
WHERE birthday = (SELECT birthday FROM Students WHERE name = 'Петро' AND surname = 'Петренко');

-- Відобразити студентів, які мають середній бал вище, ніж Петро Петренко.
SELECT s.name, s.surname, AVG(e.mark) AS avg_mark
FROM students s
JOIN exams e ON s.id_stud = e.id_stud
GROUP BY s.id_stud
HAVING AVG(e.mark) > (
    SELECT AVG(e2.mark) 
    FROM Students s2
    JOIN Exams e2 ON s2.id_stud = e2.id_stud
    WHERE s2.name = 'Петро' AND s2.surname = 'Петренко'
);


-- Отримати список предметів, у яких кількість годин більше, ніж у "Information Technologies".
SELECT title, hours
FROM courses
WHERE hours > (SELECT hours FROM Courses WHERE title = 'Information Technologies');

-- Отримати список
-- студент | предмет | оцінка
-- де оцінка має бути більшою за будь-яку оцінку Петра Петренка.
SELECT s.name, s.surname, c.title, e.mark
FROM Students s
JOIN Exams e ON s.id_stud = e.id_stud
JOIN Courses c ON e.id_course = c.id_course
WHERE e.mark > (
    SELECT MAX(e2.mark) 
    FROM Exams e2
    JOIN Students s2 ON e2.id_stud = s2.id_stud
    WHERE s2.name = 'Петро' AND s2.surname = 'Петренко'
);

-- *Отримати перелік студентів, які ще не вивчали жодного предмету (спробуйте це зробити різними способами).
SELECT name, surname
FROM students
WHERE id_stud NOT IN (SELECT id_stud FROM Exams);

SELECT s.name, s.surname
FROM students s
LEFT JOIN exams e ON s.id_stud = e.id_stud
WHERE e.id_stud IS NULL;

-- Вивести
-- студент | предмет | оцінка
-- щоб оцінка виводилася у літерному вигляді "відмінно", "добре" або "задовільно".
-- (за шкалою переведення, наприклад, 
-- 	0-59 – незадовільно	
--  60-74 б – задовідно
--  75-89 б – добре
--  90-100 б – відмінно)
SELECT s.name, s.surname, c.title, 
       CASE
           WHEN e.mark >= 90 THEN 'відмінно'
           WHEN e.mark >= 75 THEN 'добре'
           WHEN e.mark >= 60 THEN 'задовільно'
           ELSE 'незадовільно'
       END AS grade
FROM students s
JOIN exams e ON s.id_stud = e.id_stud
JOIN courses c ON e.id_course = c.id_course;
