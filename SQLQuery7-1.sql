
--#TABLE
IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
BEGIN
DROP TABLE #TempTable
end;

set statistics time on
select 
IL.InvoiceID,
I.InvoiceDate,
C.CustomerName,
IL.Quantity*IL.UnitPrice as [Sale Amount],
(select sum(ILInner.Quantity*ILInner.UnitPrice)
from [Sales].[InvoiceLines] as ILInner
join [Sales].[Invoices] as IInner on IInner.InvoiceID = ILInner.InvoiceID
where IInner.InvoiceDate >= '2015-01-01' and IInner.InvoiceDate <= eomonth(I.InvoiceDate)
) as [Sale Amount by Month]
into #TempTable
from [Sales].[InvoiceLines] as IL
join [Sales].[Invoices] as I on I.InvoiceID = IL.InvoiceID
join [Sales].[Customers] as C on C.CustomerID = I.CustomerID

SELECT * from #TempTable
where #TempTable.InvoiceDate >= '2015-01-01'
order by #TempTable.InvoiceDate, [Sale Amount], #TempTable.InvoiceID, #TempTable.CustomerName;


--Table Variable
DECLARE @TableVar TABLE(InvoiceId INT NOT NULL,
							InvoiceDate DATE NOT NULL,
								CustomerName NVARCHAR(100) NOT NULL,
									SaleAmount Decimal(18,2) NOT NULL,
										TotalSumm Decimal(18,2) NOT NULL )
								
INSERT INTO @TableVar (InvoiceId,
							InvoiceDate,
								CustomerName,
									SaleAmount,
										TotalSumm)
SELECT 
I.InvoiceID, 
S.InvoiceDate, 
C.CustomerName,
I.Quantity*I.UnitPrice as [Sale Amount],
SUM(I.Quantity*I.UnitPrice) OVER (ORDER BY YEAR(S.InvoiceDate), MONTH(S.InvoiceDate) RANGE UNBOUNDED PRECEDING) AS TotalSumm  		
FROM Sales.Invoices AS S
JOIN Sales.InvoiceLines AS I ON S.InvoiceID=I.InvoiceID
JOIN Sales.Customers AS C ON S.CustomerID=C.CustomerID
where InvoiceDate >= '2015-01-01' and InvoiceDate <= eomonth(InvoiceDate)
SELECT * from @TableVar
order by InvoiceDate, SaleAmount, InvoiceID, CustomerName;
