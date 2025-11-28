TRUNCATE TABLE SalesOpsSim.OrderRiskLog;

INSERT INTO SalesOpsSim.OrderRiskLog (
    EmployeeID, SalesOrderID, LoadFactor, DaysOutstanding, RiskScore)
SELECT
    soh.SalesPersonID,
    soh.SalesOrderID,
    CAST(soh.TotalDue / soh.Freight AS DECIMAL(18,5)),
    DATEDIFF(DAY, soh.OrderDate, GETDATE()),
    CAST((soh.TotalDue / soh.Freight) * 
         DATEDIFF(DAY, soh.OrderDate, GETDATE()) AS DECIMAL(18,5))
FROM Sales.SalesOrderHeader soh
WHERE soh.SalesPersonID IS NOT NULL
  AND soh.Freight > 0;
GO
