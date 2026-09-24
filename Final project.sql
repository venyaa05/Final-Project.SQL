CREATE DATABASE UniversityDB;
USE UniversityDB;

CREATE TABLE Departments(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE Students(
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(30),
    LastName VARCHAR(30),
    Email VARCHAR(50),
    BirthDate DATE,
    EnrollmentDate DATE
);

CREATE TABLE Instructors(
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(30),
    LastName VARCHAR(30),
    Email VARCHAR(50),
    DepartmentID INT,
    Salary INT,
    FOREIGN KEY(DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Courses(
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY(DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Enrollments(
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY(CourseID) REFERENCES Courses(CourseID)
);


INSERT INTO Departments VALUES
(1,'Computer Science'),(2,'Mathematics');

INSERT INTO Students VALUES
(1,'John','Doe','john@email.com','2000-01-15','2022-08-01'),
(2,'Jane','Smith','jane@email.com','1999-05-25','2021-08-01'),
(3,'Mike','Brown','mike@email.com','2001-03-12','2023-08-01'),
(4,'Emily','Davis','emily@email.com','2000-07-20','2022-08-01'),
(5,'David','Wilson','david@email.com','1999-11-10','2020-08-01'),
(6,'Sarah','Taylor','sarah@email.com','2001-09-18','2024-08-01');

INSERT INTO Instructors VALUES
(1,'Alice','Johnson','alice@univ.com',1,75000),
(2,'Bob','Lee','bob@univ.com',2,68000);

INSERT INTO Courses VALUES
(101,'Introduction to SQL',1,3),
(102,'Data Structures',2,4),
(103,'Database Management',1,3);

INSERT INTO Enrollments VALUES
(1,1,101,'2022-08-01'),
(2,2,102,'2021-08-01'),
(3,3,101,'2023-08-01'),
(4,4,101,'2022-08-01'),
(5,5,101,'2020-08-01'),
(6,6,101,'2024-08-01'),
(7,1,102,'2022-08-01'),
(8,2,101,'2021-08-01');

INSERT INTO Students VALUES
(7,'Alex','Patel','alex@email.com','2001-01-01','2025-08-01');

SELECT * FROM Students;

UPDATE Students
SET Email='alex@univ.com'
WHERE StudentID=7;

DELETE FROM Students
WHERE StudentID=7;

-- 4. STUDENTS AFTER 2022

SELECT * FROM Students
WHERE EnrollmentDate > '2022-12-31';

-- 5. MATHEMATICS COURSES

SELECT CourseName
FROM Courses
WHERE DepartmentID=2
LIMIT 5;

-- 6. COURSES WITH MORE THAN 5 STUDENTS

SELECT CourseID,COUNT(*) AS Students
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(*)>5;

-- 7. STUDENTS IN BOTH COURSES

SELECT StudentID
FROM Enrollments
WHERE CourseID IN(101,102)
GROUP BY StudentID
HAVING COUNT(DISTINCT CourseID)=2;

-- 8. STUDENTS IN EITHER COURSE

SELECT DISTINCT StudentID
FROM Enrollments
WHERE CourseID IN(101,102);

-- 9. AVERAGE CREDITS

SELECT AVG(Credits) AS AverageCredits
FROM Courses;

-- 10. MAXIMUM CS SALARY

SELECT MAX(Salary) AS MaximumSalary
FROM Instructors
WHERE DepartmentID=1;

-- 11. STUDENTS IN EACH DEPARTMENT

SELECT c.DepartmentID,COUNT(DISTINCT e.StudentID) AS Students
FROM Courses c
JOIN Enrollments e ON c.CourseID=e.CourseID
GROUP BY c.DepartmentID;

-- 12. INNER JOIN

SELECT s.FirstName,c.CourseName
FROM Students s
JOIN Enrollments e ON s.StudentID=e.StudentID
JOIN Courses c ON e.CourseID=c.CourseID;

-- 13. LEFT JOIN

SELECT s.FirstName,c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID=e.StudentID
LEFT JOIN Courses c ON e.CourseID=c.CourseID;

-- 14. SUBQUERY

SELECT StudentID
FROM Enrollments
WHERE CourseID IN(
    SELECT CourseID
    FROM Enrollments
    GROUP BY CourseID
    HAVING COUNT(*)>10
);

-- 15. YEAR

SELECT StudentID,YEAR(EnrollmentDate) AS Year
FROM Students;

-- 16. CONCATENATE NAME

SELECT CONCAT(FirstName,' ',LastName) AS InstructorName
FROM Instructors;

-- 17. RUNNING TOTAL

SELECT EnrollmentID,
COUNT(*) OVER(ORDER BY EnrollmentID) AS RunningTotal
FROM Enrollments;

-- 18. SENIOR / JUNIOR

SELECT StudentID,FirstName,
CASE
    WHEN EnrollmentDate < DATE_SUB(CURDATE(),INTERVAL 4 YEAR)
    THEN 'Senior'
    ELSE 'Junior'
END AS Status
FROM Students;