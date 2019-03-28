use AdventureWorks2016;
WITH DirectReports(ManagerID, EmployeeID, Title, EmployeeLevel, FirstName, LastName, Fullname1   ) AS   
(  
    SELECT ManagerID, EmployeeID, Title,  1 AS EmployeeLevel, FirstName, LastName, (FirstName + LastName) AS Fullname 
    FROM dbo.MyEmployees   
    WHERE ManagerID IS NULL  
    UNION ALL  
    SELECT e.ManagerID, e.EmployeeID, e.Title, EmployeeLevel + 1, e.FirstName, e.LastName, ((e.FirstName + e.LastName)+ 'I')  AS Fullname1 
    FROM dbo.MyEmployees AS e  
        INNER JOIN DirectReports AS d  
        ON e.ManagerID = d.EmployeeID   
)  
SELECT EmployeeID, Title, EmployeeLevel,   ( 'I' + Fullname1)   
FROM DirectReports  
WHERE EmployeeLevel <= 4 ;  
GO
