create database case1;
use case1;

create table STUDENT(
sID int not null unique PRIMARY KEY,
sName varchar(20),
GPA float,
sizeHS int
);

create table COLLEGE(
cName varchar(20) not null unique,
state varchar(20),
enrollment int,
primary key(cName)
);

create table Apply(
sID int not null unique,
cName varchar(20) not null unique,
major varchar(20),
decision varchar(1),
primary key(sID, cName)
);

insert into COLLEGE values ('Stanford', 'CA', '15000');
insert into COLLEGE values ('Berkeley', 'CA', '36000');
insert into COLLEGE values ('MIT', 'MA', '10000');
insert into COLLEGE values ('Cornell', 'NY', '21000');

insert into STUDENT values ('123', 'Amy', '3.9', '1000');
insert into STUDENT values ('234', 'Bob', '3.6', '1000');
insert into STUDENT values ('345', 'Craig', '3.5', '1000');
insert into STUDENT values ('456', 'Doris', '3.9', '1000');
insert into STUDENT values ('567', 'Edward', '2.9', '1000');
insert into STUDENT values ('678', 'Fay', '3.8', '1000');
insert into STUDENT values ('789', 'Gary', '3.4', '1000');
insert into STUDENT values ('987', 'Helen', '3.7', '1000');
insert into STUDENT values ('876', 'Irene', '3.9', '1000');
insert into STUDENT values ('765', 'Jay', '2.9', '1000');
insert into STUDENT values ('654', 'Amy', '3.9', '1000');
insert into STUDENT values ('543', 'Craig', '3.4', '1000');

insert into Apply values ('123', 'Stanford', 'CS', 'Y');
insert into Apply values ('123', 'Stanford', 'EE', 'N');
insert into Apply values ('123', 'Berkeley', 'CS', 'Y');
insert into Apply values ('123', 'Cornell', 'EE', 'Y');
insert into Apply values ('234', 'Berkeley', 'Biology', 'N');
insert into Apply values ('345', 'MIT', 'Bioengineering', 'Y');
insert into Apply values ('345', 'Cornell', 'Bioengineering', 'N');
insert into Apply values ('345', 'Cornell', 'CS', 'Y');
insert into Apply values ('345', 'Cornell', 'EE', 'N');
insert into Apply values ('678', 'Stanford', 'History', 'Y');
insert into Apply values ('987', 'Stanford', 'CS', 'Y');
insert into Apply values ('987', 'Berkeley', 'CS', 'Y');
insert into Apply values ('876', 'Stanford', 'CS', 'N');
insert into Apply values ('876', 'MIT', 'Biology', 'Y');
insert into Apply values ('876', 'MIT', 'marine biology', 'N');
insert into Apply values ('765', 'Stanford', 'History', 'Y');
insert into Apply values ('765', 'Cornell', 'History', 'N');
insert into Apply values ('765', 'Cornell', 'Psychology', 'Y');
insert into Apply values ('543', 'MIT', 'CS', 'N');



