DROP INDEX IF EXISTS IX_SOH_SalesPersonID ON Sales.SalesOrderHeader;
DROP INDEX IF EXISTS IX_SOH_Covering ON Sales.SalesOrderHeader;
DROP INDEX IF EXISTS IX_SOH_FreightPositive ON Sales.SalesOrderHeader;

TRUNCATE TABLE SalesOpsSim.OrderRiskLog;
GO
