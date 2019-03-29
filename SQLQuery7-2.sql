
--Запрос с рекурсией который выполняется.

WITH DirectReports(ManagerID, EmployeeID, Title, EmployeeLevel, FullName) AS   
(  
    SELECT ManagerID, EmployeeID, Title, 1 AS EmployeeLevel, (FirstName+LastName) AS FullName    
    FROM dbo.MyEmployees   
    WHERE ManagerID IS NULL  
    UNION ALL  
    SELECT e.ManagerID, e.EmployeeID, e.Title, EmployeeLevel + 1,   FullName  
    FROM dbo.MyEmployees AS e  
        INNER JOIN DirectReports AS d  
        ON e.ManagerID = d.EmployeeID   
)  
SELECT ManagerID, FullName , EmployeeID, Title, EmployeeLevel   
FROM DirectReports  
WHERE EmployeeLevel <= 4   

GO 

--Если добавить + I

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

--Выдает ошибку Msg 240, Level 16, State 1, Line 2
-- ошибка Types don't match between the anchor and the recursive part in column "Fullname1" of recursive query "DirectReports"


