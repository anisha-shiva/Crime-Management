create database Crime_Management;
use Crime_Management;

1)-- Create table Crime
CREATE TABLE Crime (
 CrimeID INT PRIMARY KEY,
 IncidentType VARCHAR(255),
 IncidentDate DATE,
 Location VARCHAR(255),
 Description TEXT,
 Status VARCHAR(20)
 );
 
2)--Create table Victim
CREATE TABLE Victim (
 VictimID INT PRIMARY KEY,
 CrimeID INT,
 Name VARCHAR(255),
 ContactInfo VARCHAR(255),
 Injuries VARCHAR(255),
 FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

3)--Create table Suspect
CREATE TABLE Suspect (
 SuspectID INT PRIMARY KEY,
 CrimeID INT,
 Name VARCHAR(255),
 Description TEXT,
 CriminalHistory TEXT,
 FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

1)Inserting values into Crime table
INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status)
VALUES
 (1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
 (2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under 
Investigation'),
 (3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed');
 
 2)Inserting values into Victim table
INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries)
VALUES
 (1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'),
 (2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'),
 (3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None');
 
 3)Inserting values into Suspect table
 INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory)
VALUES
 (1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'),
 (2, 2, 'Unknown', 'Investigation ongoing', NULL),
 (3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests');
 
 alter table Victim add age int;
 desc Victim;
 
 update Victim set age='30' WHERE VictimID='1';
 update Victim set age='40' WHERE VictimID='2';
 update Victim set age='50' WHERE VictimID='3';
  select*from Victim;
  select*from Crime;
  
alter table Suspect add SAge int;
desc Suspect;
update Suspect set SAge='60' WHERE SuspectID='1';
update Suspect set SAge='70' WHERE SuspectID='2';
update Suspect set SAge='80' WHERE SuspectID='3';
  select *from Suspect;
  
QUERIES:
1)Select all open incidents
 select*from Crime WHERE Status='Open';
 
2)Find the total number of incidents
 select COUNT(*) AS TotalIncidents FROM Crime;
 
3)List all unique incident types
 select DISTINCT IncidentType FROM Crime;
 
4)Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'
 SELECT * FROM Crime
 WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';

5)List persons involved in incidents in descending order of age
 select VictimId,CrimeID,Name,Age from Victim order by Age desc;

6)Find the average age of persons involved in incidents
 select avg(Age) as Average_Age from Victim;

7)List incident types and their counts, only for open cases
  SELECT IncidentType, COUNT(*) AS IncidentCount
  FROM Crime
  WHERE Status = 'Open'
  GROUP BY IncidentType;

8)Find persons with names containing 'Doe'
  SELECT * FROM Victim
  WHERE name LIKE '%Doe%';

9)Retrieve the names of persons involved in open cases and closed cases
SELECT DISTINCT V.Name
FROM Victim V
JOIN Crime C ON V.CrimeID = C.CrimeID
WHERE C.Status IN ('Open', 'Closed');

10)List incident types where there are persons aged 30 or 35 involved
SELECT DISTINCT IncidentType
FROM Crime
JOIN Victim ON Crime.CrimeID = Victim.CrimeID
WHERE age IN (30, 35);

11)Find persons involved in incidents of the same type as 'Robbery'
SELECT DISTINCT V.Name
FROM Victim V
JOIN Crime C ON V.CrimeID = C.CrimeID
WHERE C.IncidentType = 'Robbery';

12)List incident types with more than one open case
SELECT IncidentType, COUNT(*) AS OpenCasesCount
FROM Crime
WHERE Status = 'Open'
GROUP BY IncidentType
HAVING COUNT(*) > 1;

13)List all incidents with suspects whose names also appear as victims in other incidents
SELECT C.*
FROM Crime C
JOIN (
 SELECT S.CrimeID
 FROM Suspect S
 WHERE EXISTS (
 SELECT 1
 FROM Victim V
 WHERE V.CrimeID = S.CrimeID
 AND V.Name = S.Name
 )
) AS Subquery ON C.CrimeID = Subquery.CrimeID;

14)Retrieve all incidents along with victim and suspect details
SELECT c.*, v.Name AS VictimName, v.ContactInfo AS VictimContactInfo,
v.Injuries AS VictimInjuries,
 s.Name AS SuspectName, s.Description AS SuspectDescription,
s.CriminalHistory AS SuspectCriminalHistory
FROM Crime c
LEFT JOIN Victim v ON c.CrimeID = v.CrimeID
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;

15)Find incidents where the suspect is older than any victim
select c.CrimeID, v.Age, s.SAge from Crime c join Victim v on
c.CrimeID=v.CrimeID join Suspect s on v.crimeID=s.CrimeID where Sage>age;

16)Find suspects involved in multiple incidents
SELECT Name, COUNT(DISTINCT CrimeID) AS IncidentCount
FROM Suspect
GROUP BY Name
HAVING COUNT(DISTINCT CrimeID) > 1;

17)List incidents with no suspects involved
SELECT C.*
FROM Crime C
LEFT JOIN Suspect S ON C.CrimeID = S.CrimeID
WHERE S.SuspectID IS NULL;

18)List all cases where at least one incident is of type 'Homicide' and all other incidents are 
of type 'Robbery

SELECT C.*
FROM Crime C
WHERE EXISTS (
 SELECT 1
 FROM Crime
 WHERE CrimeID = C.CrimeID AND IncidentType = 'Homicide'
)
AND NOT EXISTS (
 SELECT 1
 FROM Crime
 WHERE CrimeID = C.CrimeID AND IncidentType != 'Robbery'
 );
 

19)Retrieve a list of all incidents and the associated suspects, showing suspects for 
each incident, or 'No Suspect' if there are none

SELECT C.*, COALESCE(S.Name, 'No Suspect') AS SuspectName
FROM Crime C
LEFT JOIN Suspect S ON C.CrimeID = S.CrimeID;
 
20)List all suspects who have been involved in incidents with incident types
'Robbery' or 'Assault'.
SELECT DISTINCT Name
FROM Suspect
WHERE CrimeID IN (
 SELECT CrimeID
 FROM Crime
 WHERE IncidentType IN ('Robbery', 'Assault')
 );
  