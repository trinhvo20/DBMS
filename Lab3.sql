drop database if exists Lab3;
create database Lab3;
use Lab3;

#------------------------------------------------------------------------------------#
# TABLES:

create table STUDENT(
SID varchar(10) not null primary key,
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
# JOIN:
/* Example 1: Using INNER JOIN and ON:
Question: Write an SQL query that joins the COURSES with the PREREQ relation with the condition that
their corresponding CourseNum match.*/
SELECT * 
FROM COURSE c natural JOIN PREREQ p;

select *
from COURSE c JOIN PREREQ p ON c.CourseNum = p.CourseNum;

/* Example 2: Using INNER JOIN and ON with additional conditions:
Question: Write an SQL query that joins the COURSES with the PREREQ relation with a condition 
that their corresponding CourseNum match AND the enrollment > 25 */
SELECT * 
FROM COURSE c JOIN PREREQ p ON c.CourseNum = p.CourseNum
							AND c.enrollment > 25;
					
/* Example 3: Natural Join:
Question: Write an SQL for the NATURAL JOIN of PROFESSORS and TEACH relations */
select *
from PROFESSOR p natural join Teach t;

/* Example 4: INNER JOIN and USING:
Question: Write an SQL that matches COURSES and PREREQ relations USING CourseNum and
DeptName attributes to join these relations. */
select *
from COURSE c JOIN PreReq p USING (Coursenum, DeptName);

#------------------------------------------------------------------------------------------#
# Lab 3:
/* 1.	Using INNER JOIN and ON, select all details from joining the STUDENT and TAKE tables 
with the condition that their corresponding SID match. */
select *
from STUDENT s JOIN Take t ON s.sid = t.sid;

/* 2.	Write an SQL query that selects all details from the NATURAL JOIN 
of the STUDENT and TAKE relations */
select *
from STUDENT s NATURAL JOIN Take t;

/* 3.	Write an SQL query with INNER JOIN and USING, to match the STUDENTS and TAKE relations 
with the condition that SID attributes match. */
select *
from STUDENT s JOIN Take t USING (sid);

/* 4.	Write an SQL query with LEFT OUTER JOIN and ON to select all details from 
the COURSES relation and the matching details from the PREREQ relation 
whether or not there exists a CourseNum in the PREREQ relation. */
select *
from COURSE c LEFT OUTER JOIN PreReq p ON c.CourseNum = p.CourseNum;

/* 5.	Select the deptname and average of their enrollments from the COURSES relation 
and GROUP the result BY deptname. Note: Use the SQL avg(enrollments) function to get the average value */
select DeptName, avg(Enrollment) AvgEnrl
from COURSE 
group by DeptName;

