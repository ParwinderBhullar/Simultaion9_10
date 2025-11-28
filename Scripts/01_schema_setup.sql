USE AdventureWorks2022;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'SalesOpsSim')
    EXEC ('CREATE SCHEMA SalesOpsSim');
GO

DROP TABLE IF EXISTS SalesOpsSim.OrderReviewQueue;
DROP TABLE IF EXISTS SalesOpsSim.EmployeeOrderLoad;
DROP TABLE IF EXISTS SalesOpsSim.OrderRiskLog;

CREATE TABLE SalesOpsSim.OrderReviewQueue (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    SalesOrderID INT NOT NULL,
    EmployeeID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalDue MONEY,
    Freight MONEY,
    IsReady BIT DEFAULT 0,
    Notes NVARCHAR(255)
);

CREATE TABLE SalesOpsSim.EmployeeOrderLoad (
    EmpLoadID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    TotalOrders INT NOT NULL,
    AvgFreight MONEY,
    AvgTotalDue MONEY,
    LastUpdated DATETIME DEFAULT GETDATE()
);

CREATE TABLE SalesOpsSim.OrderRiskLog (
    RiskLogID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    SalesOrderID INT NOT NULL,
    LoadFactor DECIMAL(18,5),
    DaysOutstanding INT,
    RiskScore DECIMAL(18,5),
    LoggedAt DATETIME DEFAULT GETDATE()
);
GO
