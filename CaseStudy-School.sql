Create table CourseMaster (
CID Integer Primary Key,
CourseName Varchar(40) NOT NULL,
Category Char(1) NULL CHECK(Category='B' or Category='M' or Category='A'),
Fee Smallmoney NOT NULL CHECK(Fee>=0)
);
insert into CourseMaster values(1,'SQL','M',10000)
insert into CourseMaster values(6,'Java','M',15000)
insert into CourseMaster values(7,'Power BI','A',30000)
insert into CourseMaster values(8,'Oracle','A',30000)
insert into CourseMaster values(9,'MySQL','B',15000)
insert into CourseMaster values(5,'aptitude','B',15000)
select*from CourseMaster

create table StudentMaster (
SID TinyInt Primary key,
StudentName varchar(40) NOT NULL,
Origin char(1) NOT NULL CHECK(Origin='L' OR Origin='F'),
Type char(1) NOT NULL CHECK(Type='UG' OR Type='G')
);
insert into StudentMaster values(101,'siddu','L','UG')
insert into StudentMaster values(103,'venu','F','G')
insert into StudentMaster values(104,'pasha','L','UG')
insert into StudentMaster values(105,'mohan','F','G')
insert into StudentMaster values(106,'roshan','L','UG')
insert into StudentMaster values(107,'Abhi','L','G')
select*from StudentMaster

create table EnrollmentMaster(
CID Integer NOT NULL FOREIGN KEY REFERENCES CourseMaster(CID),
SID TinyInt NOT NULL FOREIGN KEY REFERENCES StudentMaster(SID),
DOE DateTime NOT NULL,
FWF Bit NOT NULL,
Grade char(1) NULL CHECK(Grade='O' OR Grade='A' OR Grade='B' OR Grade='C')
);



insert into EnrollmentMaster values(1,101,'2023-12-1',1,'A')
insert into EnrollmentMaster values(2, 105, '2023-02-20', 0, 'B')
insert into EnrollmentMaster values(1, 103, '2023-01-15', 1, 'C')
insert into EnrollmentMaster values(3, 104, '2023-03-10', 1, 'A')
insert into EnrollmentMaster values(5, 106, '2023-12-02', 0, 'B')
insert into EnrollmentMaster values(2, 104, '2023-02-20', 0, 'O')
select *from EnrollmentMaster 


--1
 SELECT EM.CID, COUNT(EM.SID) AS Total_Enrollments FROM EnrollmentMaster EM
 JOIN StudentMaster SM ON EM.SID = SM.SID WHERE SM.Origin = 'F' 
 GROUP BY EM.CID HAVING COUNT(EM.SID) > 10;
--2
  SELECT SM.StudentName FROM StudentMaster SM
  WHERE SM.SID NOT IN (SELECT EM.SID FROM EnrollmentMaster EM 
  WHERE EM.CID = (SELECT CID FROM CourseMaster WHERE CourseName = 'Java'));
--3
 SELECT CM.CourseName FROM CourseMaster CM
 JOIN EnrollmentMaster EM ON CM.CID = EM.CID
JOIN StudentMaster SM ON EM.SID = SM.SID
WHERE CM.Category = 'Advanced' AND SM.Origin = 'F'
GROUP BY CM.CourseName ORDER BY COUNT(EM.SID) DESC LIMIT 1;
--4
SELECT DISTINCT SM.StudentName FROM StudentMaster SM
INNER JOIN EnrollmentMaster EM ON SM.SID = EM.SID
INNER JOIN CourseMaster CM ON EM.CID = CM.CID                                       
WHERE CM.Category = 'B' AND MONTH(EM.DOE) = MONTH(GETDATE()) AND YEAR(EM.DOE) = YEAR(GETDATE());
--5
SELECT DISTINCT SM.StudentName FROM StudentMaster SM
INNER JOIN EnrollmentMaster EM ON SM.SID = EM.SID
INNER JOIN CourseMaster CM ON EM.CID = CM.CID
WHERE CM.Category = 'Basic'
AND SM.Origin = 'L' AND SM.Type = 'UG'
AND EM.Grade = 'C';
--6
SELECT CM.CourseName FROM CourseMaster CM
WHERE CM.CID NOT IN (SELECT DISTINCT EM.CID FROM EnrollmentMaster EM
                                              WHERE MONTH(EM.DOE) = 5 AND YEAR(EM.DOE) = 2020);
--7
SELECT CM.CourseName, COUNT(EM.SID) AS Number_of_Enrollments,
    CASE 
        WHEN COUNT(EM.SID) > 50 THEN 'High'
        WHEN COUNT(EM.SID) >= 20 AND COUNT(EM.SID) <= 50 THEN 'M'
        ELSE 'L'
    END AS Popularity
FROM CourseMaster CM
LEFT JOIN EnrollmentMaster EM ON CM.CID = EM.CID
GROUP BY CM.CourseName;
--8
SELECT SM.StudentName, CM.CourseName, DATEDIFF(DAY, EM.DOE, GETDATE()) AS Age_of_Enrollment_Days
FROM EnrollmentMaster EM
INNER JOIN CourseMaster CM ON EM.CID = CM.CID
INNER JOIN StudentMaster SM ON EM.SID = SM.SID
WHERE EM.DOE = (SELECT MAX(DOE) FROM EnrollmentMaster WHERE CID = EM.CID);
--9
SELECT SM.StudentName FROM StudentMaster SM
INNER JOIN EnrollmentMaster EM ON SM.SID = EM.SID
INNER JOIN CourseMaster CM ON EM.CID = CM.CID
WHERE SM.Origin = 'L' AND CM.Category = 'B'
GROUP BY SM.StudentName
HAVING COUNT(DISTINCT CM.CID) = 3;
 


--10
SELECT CM.CourseName FROM CourseMaster CM
CROSS JOIN StudentMaster SM
WHERE NOT EXISTS (
    SELECT * FROM StudentMaster WHERE NOT EXISTS (SELECT * FROM EnrollmentMaster EM
                                                                                              WHERE EM.CID = CM.CID AND EM.SID = SM.SID)
);
--11
select StudentName,grade
from StudentMaster SM
inner join EnrollmentMaster EM on SM.sid=EM.sid
where EM.Grade='O' and FWF = 1 ;
--12
select StudentName,Origin,Type,Grade,Category
from CourseMaster as CM
inner join EnrollmentMaster as EM ON CM.CID=EM.CID
inner join StudentMaster as SM ON SM.SID=EM.SID
where SM.Origin='F' and SM.Type='UG' and EM.Grade='C' and
CM.Category='B';
--13
select CourseName,count(*) as Total_No_of_Enroll
from CourseMaster as cm
inner join EnrollMaster as em on cm.cid=em.cid
where datediff(mm,DOE,getdate())=0
group by cm.CourseName
