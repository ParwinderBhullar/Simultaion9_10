CREATE INDEX IX_SOH_SalesPersonID
ON Sales.SalesOrderHeader (SalesPersonID);

CREATE INDEX IX_SOH_Covering
ON Sales.SalesOrderHeader (SalesOrderID)
INCLUDE (OrderDate, TotalDue, Freight, SalesPersonID);

CREATE INDEX IX_SOH_FreightPositive
ON Sales.SalesOrderHeader (Freight)
WHERE Freight > 0;
GO
