use AdventureWorks2016;
WITH DirectReports(ManagerID, EmployeeID, Title, EmployeeLevel, FirstName, LastName ) AS   
(  
    SELECT ManagerID, EmployeeID, Title,  1 AS EmployeeLevel, FirstName, LastName  
    FROM dbo.MyEmployees   
    WHERE ManagerID IS NULL  
    UNION ALL  
    SELECT e.ManagerID, e.EmployeeID, e.Title, EmployeeLevel + 1, e.FirstName, e.LastName  
    FROM dbo.MyEmployees AS e  
        INNER JOIN DirectReports AS d  
        ON e.ManagerID = d.EmployeeID   
)  
SELECT EmployeeID, Title, EmployeeLevel, FirstName, LastName   
FROM DirectReports  
WHERE EmployeeLevel <= 4 ;  
GO
