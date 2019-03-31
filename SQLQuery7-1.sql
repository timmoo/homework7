
--#TABLE
IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
BEGIN
DROP TABLE #TempTable
end;

SET STATISTICS TIME ON
SELECT
IL.InvoiceID,
I.InvoiceDate,
C.CustomerName,
IL.Quantity*IL.UnitPrice AS [Sale Amount],
(SELECT SUM(ILInner.Quantity*ILInner.UnitPrice)
FROM [Sales].[InvoiceLines] AS ILInner
JOIN [Sales].[Invoices] AS IInner ON IInner.InvoiceID = ILInner.InvoiceID
WHERE IInner.InvoiceDate >= '2015-01-01' AND IInner.InvoiceDate <= EOMONTH(I.InvoiceDate)) AS [Sale Amount by Month]
INTO #TempTable
FROM [Sales].[InvoiceLines] AS IL
JOIN [Sales].[Invoices] AS I ON I.InvoiceID = IL.InvoiceID
JOIN [Sales].[Customers] AS C ON C.CustomerID = I.CustomerID
SELECT * FROM #TempTable
WHERE #TempTable.InvoiceDate >= '2015-01-01'
ORDER BY #TempTable.InvoiceDate, [Sale Amount], #TempTable.InvoiceID, #TempTable.CustomerName;


--Table Variable
DECLARE @TableVar 
TABLE
(
InvoiceId INT NOT NULL,
InvoiceDate DATE NOT NULL,
CustomerName NVARCHAR(100) NOT NULL,
SaleAmount Decimal(18,2) NOT NULL,
TotalSumm Decimal(18,2) NOT NULL 
)			
INSERT INTO @TableVar 
(
InvoiceId,
InvoiceDate,
CustomerName,
SaleAmount,
TotalSumm
)
SELECT 
I.InvoiceID, 
S.InvoiceDate, 
C.CustomerName,
I.Quantity*I.UnitPrice AS [Sale Amount],
SUM(I.Quantity*I.UnitPrice) OVER (ORDER BY YEAR(S.InvoiceDate), MONTH(S.InvoiceDate) RANGE UNBOUNDED PRECEDING) AS TotalSumm  		
FROM Sales.Invoices AS S
JOIN Sales.InvoiceLines AS I ON S.InvoiceID=I.InvoiceID
JOIN Sales.Customers AS C ON S.CustomerID=C.CustomerID
WHERE InvoiceDate >= '2015-01-01' AND InvoiceDate <= EOMONTH(InvoiceDate)
SELECT * FROM @TableVar
ORDER BY InvoiceDate, SaleAmount, InvoiceID, CustomerName;
