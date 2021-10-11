drop database if exists flight;
create database flight;

use flight;
#--------------------------------------------------------------------
# TABLE:
create table COMPANY(
cid varchar(10) not null unique primary key,
cname varchar(40),
headquater varchar(20)
);

create table PASSENGER(
pSSN varchar(10) not null unique,
pname varchar(20) not null unique,
pdob date,
paddress varchar(20),
pgender varchar(1),
primary key(pSSN, pname)
);

create table ROUTE(
rid varchar(10) not null unique primary key,
departure varchar(20),
destination varchar(20)
);

create table FLIGHT(
fid varchar(10) not null unique primary key,
dateofdeparture date,
ftime time		# total time of the fight = end-start
);

create table AIRPLANE(
apid varchar(10) not null unique primary key,
capacity int
);

create table EMPLOYEE(
eid varchar(10) not null unique,
eSSN varchar(10) not null unique,
ename varchar(20),
edob date,
job varchar(20),
primary key(eid, eSSN)
);
#--------------------------------------------------------------------
# RELATIONSHIPS:
create table Own(
apid varchar(10) not null unique,
cid varchar(10) not null,
foreign key (apid) references AIRPLANE (apid),
foreign key (cid) references COMPANY (cid)
);

create table Workfor(
eid varchar(10) not null unique,
cid varchar(10) not null,
foreign key (eid) references EMPLOYEE (eid),
foreign key (cid) references COMPANY (cid)
);

create table CreateRoute(
rid varchar(10) not null unique,
cid varchar(10) not null,
foreign key (rid) references ROUTE (rid),
foreign key (cid) references COMPANY (cid)
);

create table Follow(
fid varchar(10) not null unique,
rid varchar(10) not null,
apid varchar(10) not null,
foreign key (fid) references FLIGHT (fid),
foreign key (rid) references ROUTE (rid),
foreign key (apid) references AIRPLANE (apid)
);

create table Take(
pname varchar(20) not null, 
fid varchar(10) not null,
foreign key (pname) references PASSENGER (pname),
foreign key (fid) references FLIGHT (fid)
);

create table Workon(
eid varchar(10) not null,
fid varchar(10) not null,
foreign key (eid) references EMPLOYEE (eid),
foreign key (fid) references FLIGHT (fid)
);

#------------------------------------------------------------------------------------
# INSERT:
insert into COMPANY values 
('C001', 'American Airline', 'CA'),
('C002', 'Korean Airline', 'Seoul'),
('C003', 'Delta Airline', 'NY'),
('C004', 'JetBlue Airline', 'MN');

insert into PASSENGER values
('123456780', 'Amy', '19950204', 'Ruston', 'F'),
('123456781', 'Bob', '19780520', 'Bossier', 'M'),
('123456782', 'Clint', '19860418', 'Bossier', 'M'),
('123456783', 'Diana', '19920807', 'Monroe', 'F');

insert into ROUTE values
('R234','New York','Iowa'),
('R345','Austin','Chicago'),
('R456','Denver','Seattle'),
('R567','San Francisco','D.C.'),
('R678','Los Angeles','Boston'),
('R789','Atlanta','Seoul'),
('R890','Seoul','Los Angeles');

insert into FLIGHT values
('F001','20210118','3:30:00'),
('F002','20210119','4:25:00'),
('F003','20210120','5:40:00'),
('F004','20210121','12:39:00'),
('F005','20210121','3:30:00');

insert into AIRPLANE values
('A987', 30),
('A876', 20),
('A765', 50),
('A654', 40),
('A543', 30);

insert into EMPLOYEE values
('E001','223456789','Anna','19640615','Flight Attendant'),
('E002','323456789','Zach','19760217','Pilot'),
('E003','423456789','Ken','19931104','Pilor'),
('E004','523456789','Maria','19890216','Flight Attendant'),
('E005','623456789','Nancy','19840828','Flight Attendant');

insert into Own values
('A987','C001'),
('A876','C001'),
('A765','C003'),
('A654','C003'),
('A543','C002');

insert into Workfor values
('E001','C003'),
('E002','C001'),
('E003','C004'),
('E004','C002'),
('E005','C003');

insert into CreateRoute values
('R234','C004'), #C004 no airplane
('R345','C003'),
('R456','C003'),
('R567','C002'),
('R678','C001'),
('R789','C003'),
('R890','C002');

insert into Follow values
('F001','R678','A987'), #C001
('F002','R678','A876'),	#C001
('F003','R890','A543'),	#C002
('F004','R789','A654'),	#C003
('F005','R345','A654');	#C003

insert into Take values
('Amy','F002'),
('Amy','F004'),
('Bob','F001'),
('Bob','F004'),
('Clint','F002'),
('Clint','F005'),
('Diana','F001'),
('Diana','F002');

insert into Workon values
('E001','F004'),
('E001','F005'),
('E002','F001'),
('E002','F002'),
('E004','F003'),
('E005','F004'),
('E005','F005');
#---------------------------------------------------------------------------------------------
# VIEW:
create view FlightInf as
	select *
    from FLIGHT natural join ROUTE natural join AIRPLANE natural join Follow natural join COMPANY natural join CreateRoute;
    
#drop view FlightInf;

create view FlightInf2 as
	select E.*, W.fid
    from Workon W, EMPLOYEE E
    where W.eid = E.eid;

#drop view FlightInf2;

#----------------------------------------------------------------------------------------------
# TRIGGER: age of EMPLOYEE cannot under 18
DELIMITER $$
create trigger EmployeeAge
before insert on EMPLOYEE for each row
BEGIN
	declare msg varchar(255);
    if (DateDiff(Now(),NEW.edob)/365 < 18) then
		set msg = 'Age has to be above 18';
        signal sqlstate '45000' set message_text = msg;
	end if;
END $$
DELIMITER ;