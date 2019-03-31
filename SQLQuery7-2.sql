
WITH DirectReports(ManagerID, EmployeeID, Title, EmployeeLevel, FullName) AS   
(  
    SELECT 
		ManagerID, 
		EmployeeID, 
		Title, 
		1 AS EmployeeLevel, 
		(FirstName+LastName) AS FullName    
    FROM dbo.MyEmployees   
    WHERE ManagerID IS NULL  
    UNION ALL  
    SELECT 
		e.ManagerID, 
		e.EmployeeID, 
		e.Title, 
		EmployeeLevel + 1,   
		(FirstName+LastName) 
    FROM dbo.MyEmployees AS e  
    INNER JOIN DirectReports AS d  ON e.ManagerID = d.EmployeeID   
)  
SELECT EmployeeID, REPLICATE('|	', EmployeeLevel) + FullName AS [Name], Title, EmployeeLevel 
FROM DirectReports;  


