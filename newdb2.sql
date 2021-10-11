drop database if exists newdb2;
create database newdb2;

# 'use' to let the workbench know which BD you intend to use.
use newdb2; 

# Table will not null and primary key constraint
CREATE TABLE STUDENT(
SID varchar(10) not null PRIMARY KEY,
NAME varchar(45),
SADDRESS varchar(45));

create table PROFESSOR(
PID varchar(10) not null,
Name varchar(45),
Office varchar(10),
Age Int,
primary key (PID));

# Alter existing table
ALTER TABLE PROFESSOR CHANGE COLUMN  Age DataOfBirth DATE NULL;
ALTER TABLE PROFESSOR ADD NewDate DATE;
ALTER TABLE PROFESSOR DROP NewDate;

# Table will not null and more than oe primary key constraints
create table COURSE ( 
CourseNum INTEGER not null, 
DeptName varchar(45) not null, 
CourseName varchar(45), 
ClassRoom DateTime, 
Enrollment INT, 
primary key(CourseNum,DeptName)
);

create table DEPARTMENT ( 
DeptName varchar(45) not null, 
ChairmanID varchar(45), 
primary key(DeptName) 
);

CREATE TABLE PreReq( 
CourseNum Integer not null, 
DeptName varchar(45), 
PreReqNumber INT, 
PreReqDeptName varchar(45), 
primary key(CourseNum, DeptName)
);

/* Drop a Table  */
Drop table PreReq;

/* Tables with not null and foreign key constraint */
CREATE TABLE PreReq( 
CourseNum Integer not null, 
DeptName varchar(45), 
PreReqNumber INT, 
PreReqDeptName varchar(45), 
FOREIGN KEY (CourseNum) REFERENCES COURSE (CourseNum),
FOREIGN KEY (DeptName) REFERENCES DEPARTMENT (DeptName)
);

CREATE TABLE Teach ( 
PID VARCHAR(10), 
CourseNum INT, 
DeptName VARCHAR(45), 
FOREIGN KEY (PID) REFERENCES PROFESSOR (PID), 
FOREIGN KEY (CourseNum) REFERENCES COURSE (CourseNum), 
FOREIGN KEY (DeptName) REFERENCES DEPARTMENT (DeptName) 
);

CREATE TABLE Take ( 
SID VARCHAR(10), 
CourseNum INT, 
DeptName VARCHAR(45), 
Grade Decimal(4,2), 
ProfessorEval int, 
FOREIGN KEY (SID) REFERENCES STUDENT (SID), 
FOREIGN KEY (CourseNum) REFERENCES COURSE (CourseNum), 
FOREIGN KEY (DeptName) REFERENCES DEPARTMENT (DeptName) 
);

create table CLIENT(
clientID INT NOT NULL ,
name VARCHAR(45) NULL ,
Age INT NULL ,
PRIMARY KEY (clientID) 
);

CREATE TABLE users (
username VARCHAR(45) NOT NULL ,
email VARCHAR(45) NOT NULL ,
password VARCHAR(45) NULL ,
PRIMARY KEY (username,email) 
);

CREATE TABLE users_logs (
username VARCHAR(45) NOT NULL ,
oldpassword VARCHAR(45) NULL ,
newpassword VARCHAR(45) NULL
);

#-------------------------------------------------------------------------------------
# try out TRIGGER:

# trigger 1: when address is null, fill with Ruston
DELIMITER $$
create trigger studentAddress
BEFORE INSERT ON STUDENT FOR EACH ROW
BEGIN
	IF (NEW.SADDRESS is null) THEN
		SET New.SADDRESS = 'Ruston';
	end if;
END $$
DELIMITER ;

#show triggers;

insert into STUDENT values ('101', 'Ana', 'Bossier');
insert into STUDENT values ('102', 'Kyle', NULL); 
select * from STUDENT; 

# trigger 2: age can't be under 18, if under 18, the client’s information is discarded.
DELIMITER $$
create trigger age18
before insert on CLIENT for each row
BEGIN
	declare msg varchar(255);
    if (NEW.Age < 18) then
		set msg = 'Age has to be above 18';
        signal sqlstate '45000' set message_text = msg;
	end if;
END $$
DELIMITER ;

INSERT INTO client (clientID, name, Age) VALUES (1, 'client1', 21);
INSERT INTO client (clientID, name, Age) VALUES (3, 'client3', 18);
INSERT INTO client (clientID, name, Age) VALUES (4, 'client4', 13); 
select * from CLIENT;


#insert into users values('user1','user1@mail.com',123);
#UPDATE users SET password='475' WHERE username='user1';
select * from users_logs;
#-------------------------------------------------------------------------------------
# VIEW:

/* Example 1: Write a view that returns all columns (without duplicating column names) 
and all rows from the join of PROFESSOR, TEACH and COURSE tables. */
CREATE VIEW professorDetails AS
	SELECT p.*, th.CourseNum,th.DeptName , c.CourseName, c.ClassRoom, c.Enrollment 
	FROM PROFESSOR p, TEACH th, COURSE c 
	WHERE p.pid = th.pid and th.CourseNum = c.CourseNum;
# DROP VIEW professorDetails;

/* Example 2: Write a view that returns all attributes/columns from 
the join of the professorDetails view and DEPARTMENTS tables. */
CREATE VIEW professorChair AS 
	SELECT pd.*, d.ChairmanID
	FROM professorDetails pd, DEPARTMENT d
	WHERE pd.DeptName = d.DeptName;

/* Example 3: Create an UPDATABLE view that returns all rows and only 
the SID and GRADE columns from the TAKE table. */
CREATE VIEW takeGrade AS 
	SELECT sid, grade
	FROM TAKE;
    
/* Example 4: Alter the view above to make it NON-UPDATABLE. */
ALTER VIEW takeGrade AS
    SELECT DISTINCT sid, grade 
    FROM TAKE;
    
/* Example 5: Create a view that returns all rows from the PROFESSORS table
 and 2 columns, the name renamed as Pname and office renamed as RoomNumber. */
CREATE VIEW professorsOffice (Pname, RoomNumber) AS 
	SELECT name, office 
    FROM PROFESSOR; 
    

