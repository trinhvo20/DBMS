drop database if exists StudentdbW21;
create database StudentdbW21;
use StudentdbW21;

#------------------------------------------------------------------------------------#
# TABLES:

CREATE TABLE STUDENT(
SID varchar(10) not null PRIMARY KEY,
Name varchar(45),
Address varchar(45));

create table PROFESSOR(
PID varchar(10) not null,
Name varchar(45),
Office varchar(10),
DateofBirth date,
DepartmentName varchar(45),
primary key (PID));

create table COURSE ( 
CourseNum INTEGER not null, 
DeptName varchar(45) not null, 
CourseName varchar(45), 
ClassRoom varchar(45), 
Enrollment INT, 
primary key(CourseNum,DeptName)
);

create table DEPARTMENT ( 
DeptName varchar(45) not null, 
ChairmanID varchar(45), 
primary key(DeptName) 
);

#----------------------------------------------------------------------------------------#
# RELATIONSHIP:

CREATE TABLE PreReq( 
CourseNum Integer not null, 
DeptName varchar(45) not null, 
PreReqNumber INT, 
PreReqDeptName varchar(45), 
primary key(CourseNum, DeptName)
);

CREATE TABLE Teach ( 
PID VARCHAR(10) not null, 
CourseNum INT not null, 
DeptName VARCHAR(45) not null, 
CONSTRAINT PIDFKey FOREIGN KEY (PID) REFERENCES PROFESSOR (PID), 
CONSTRAINT CourseNumFKey FOREIGN KEY (CourseNum) REFERENCES COURSE (CourseNum), 
CONSTRAINT DeptNameFKey FOREIGN KEY (DeptName) REFERENCES DEPARTMENT (DeptName) 
);

CREATE TABLE Take ( 
SID VARCHAR(10) not null, 
CourseNum INT not null, 
DeptName VARCHAR(45) not null, 
Grade Decimal(4,2), 
ProfessorEval Decimal(4,2), 
CONSTRAINT SIDFKey2 FOREIGN KEY (SID) REFERENCES STUDENT (SID), 
CONSTRAINT CourseNumFKey2 FOREIGN KEY (CourseNum) REFERENCES COURSE (CourseNum), 
CONSTRAINT DeptNameFKey2 FOREIGN KEY (DeptName) REFERENCES DEPARTMENT (DeptName) 
);

#-------------------------------------------------------------------------------------#
# Insert:
insert into STUDENT(SID,Name,Address) 
values('S001','Amy o`Brian','NY');

insert into STUDENT(SID,Name,Address)
values('S002','Bob Catillo','Texas')
,('S003','Candice DeMello','Louisiana')
,('S004','Darrel West','Michigan');

insert into PROFESSOR
values('P001','Dr. John Smith','NH101','19651231',null);

insert into PROFESSOR
values('P002','Dr. Mary Smith','NH102','19700101',null),
('P003','Dr. Ardella Ayres','NH103','19700501',null),
('P004','Dr. David Dennett','NH104','19750204',null);

insert into DEPARTMENT
values('Engineering and Science','Dr. John Smith'),
('Education','Dr. Ralph Ahner'),
('Business','Dr. Kelley Gade');

insert into COURSE
values(101,'Engineering and Science','Software Programming','NH150',30),
(102,'Engineering and Science','Introduction to Datamining', 'NH150',25),
(103,'Education','Education 101','BH101',30),
(104,'Business','Business 101','BH101',20),
(200,'Business','Introduction to Administration','BH102',15),
(300,'Business','Advanced Administration','BH103',20);

insert into PreReq
values(101,'Engineering and Science',100,'Engineering and Science'),
(103,'Education',102,'Engineering and Science'),
(104,'Business',103,'Education'),
(300,'Business',200,'Business');


insert into Teach
values('P003',101,'Engineering and Science'),
('P003',101,'Education'),
('P003',101,'Business');

insert into Take values('S001',101,'Engineering and Science',3.9,3.9);
insert into Take values('S002',101,'Education',3.5,3.3);
insert into Take values('S003',101,'Business',3.4,3.6);
insert into Take values('S004',101,'Engineering and Science',2.9,2.5);

#------------------------------------------------------------------------------------------#
# QUERY:

/* Example 1:	Joining multiple tables: Using natural join of 
the Students, Take, Teach and Professor tables */
select STUDENT.*, Take.*, Teach.*, PROFESSOR.*
from STUDENT, Take, Teach, PROFESSOR
where STUDENT.SID = Take.SID and PROFESSOR.PID = Teach.PID and 
		Take.CourseNum = Teach.CourseNum and Take.DeptName = Teach.DeptName;

/* Example 2:	Using Aliasing: List all students who took courses 
from the Department of Engineering and Science */
select S.*, T.*
from STUDENT S, Take T
where S.SID = T.SID and T.DeptName = 'Engineering and Science';

/* Example 3: Write a SQL query that lists the names and ages (in days) of Professors 
ordered in the descending order.
Using the Arithmetic operator DATEDIFF that takes two input values e.g DATEDIFF('2013-12-19', DateofBirth) 
and returns difference of the dates in DAYS */
select p1.name, p1.DateofBirth, DATEDIFF('2021-01-23', p1.DateofBirth) as age
from PROFESSOR p1
order by DateofBirth desc;

/* Example 4:	Using Set Operator - UNION */
select  coursenum 
from    PreReq
UNION
select  coursenum 
from    Take;

/* Example 5: Using Set Operator – UNION ALL (include duplicate) */
select  courseNum 
from    PreReq
UNION ALL
select  coursenum 
from   Take;

/* Example 6:	Using Subqueries in WHERE clause 
List the course numbers of those pre-requisites that have been taken by students. */
select PreReq.CourseNum
from PreReq
where PreReq.CourseNum IN (select Take.CourseNum from Take);

/* Example 7:	Using NOT EXISTS 
Query: List of courses that do not have a pre-requisite */
select *
from COURSE C
where NOT EXISTS (select * 
				  from PreReq P 
                  where C.CourseNum = P.CourseNum);
		
/* Example 8:	Using Operator ALL
Query: Find the course that has the highest enrollment */
select max(C1.enrollment)
from COURSE C1;

select *
from COURSE C2
where C2.enrollment >= ALL (select C1.enrollment
							from COURSE C1);

/* Example 9:	Using Operator ANY
Query: List all courses EXCEPT those with the highest enrollment */
select *
from COURSE C1
where C1.enrollment < ANY (select C2.enrollment
						   from COURSE C2);

/* Example 10:	Using Subqueries in the FROM clause
Query: Obtain the names of students who took course number 101 
from the Department of Engineering and Science, and obtained a grade >= 3.40 */
select s.Name
from STUDENT s, (select * from Take where Grade >= 3.4) t
where s.SID = t.SID AND t.CourseNum = '101' AND t.DeptName = 'Engineering and Science';

/* Example 11: Using Subqueries in the SELECT clause
Query: Obtain a list of courses and the names of the professors that teach them. */
select T.* , (select P.Name
			  from PROFESSOR P
              where P.PID = T.PID) as 'ProfName'
from Teach T;

/* ---------------------------------------------------------------------------------------- */
/* Lab 2 */

/* Question 1: Using aliasing, select the names and grades 
of students with Grade greater than 3.0. */
select s.Name, t.Grade
from STUDENT s, Take t 
where s.sid = t.sid and t.grade > 3.0;

/* Question 2: For each student compute the average between their grade and their ProfessorEval and
sort the result in ascending order.  */
select t.sid, ((Grade + ProfessorEval)/2) as average
from Take t
order by average asc;

/* Question 3: Use a subquery in the FROM clause to find those students belonging to the ‘Education
Department’ who have taken course numbered 101.  */
select s.*
from STUDENT s, (select * from Take where CourseNum = 101) t
where s.sid = t.sid and t.DeptName = 'Education';

/* Question 4: Find those courses that were taken by student that do not have any perquisites */
select c.*
from Take t, COURSE c
where t.CourseNum = c. CourseNum and t.CourseNum NOT IN (select p.CourseNum from PreReq p);

/* Question 5: List all the courses that have prerequisites (using EXISTS)  */
select *
from COURSE c
where EXISTS (select *
			  from PreReq p
              where c.CourseNum = p.CourseNum);
              
/* -------------------------------------------------------------------------------------- */
