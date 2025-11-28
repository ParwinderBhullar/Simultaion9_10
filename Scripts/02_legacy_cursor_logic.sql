TRUNCATE TABLE SalesOpsSim.OrderRiskLog;

DECLARE @EmpID INT;
DECLARE @SalesOrderID INT, @OrderDate DATE, @TotalDue MONEY, @Freight MONEY;

DECLARE employee_cursor CURSOR FOR
SELECT DISTINCT SalesPersonID
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL;

OPEN employee_cursor;
FETCH NEXT FROM employee_cursor INTO @EmpID;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE orders_cursor CURSOR FOR
    SELECT SalesOrderID, OrderDate, TotalDue, Freight
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID = @EmpID;

    OPEN orders_cursor;
    FETCH NEXT FROM orders_cursor INTO @SalesOrderID, @OrderDate, @TotalDue, @Freight;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @Freight IS NULL OR @Freight = 0 OR @TotalDue IS NULL
        BEGIN
            FETCH NEXT FROM orders_cursor INTO @SalesOrderID, @OrderDate, @TotalDue, @Freight;
            CONTINUE;
        END;

        DECLARE @LoadFactor DECIMAL(18,5) = @TotalDue / @Freight;
        DECLARE @DaysOutstanding INT = DATEDIFF(DAY, @OrderDate, GETDATE());
        DECLARE @RiskScore DECIMAL(18,5) = @LoadFactor * @DaysOutstanding;

        INSERT INTO SalesOpsSim.OrderRiskLog (
            EmployeeID, SalesOrderID, LoadFactor, DaysOutstanding, RiskScore)
        VALUES (@EmpID, @SalesOrderID, @LoadFactor, @DaysOutstanding, @RiskScore);

        FETCH NEXT FROM orders_cursor INTO @SalesOrderID, @OrderDate, @TotalDue, @Freight;
    END

    CLOSE orders_cursor;
    DEALLOCATE orders_cursor;

    FETCH NEXT FROM employee_cursor INTO @EmpID;
END

CLOSE employee_cursor;
DEALLOCATE employee_cursor;
GO
