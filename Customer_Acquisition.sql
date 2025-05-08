select * from customer_acquisition_data


-- STEP 1: Create Tables
-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    AcquisitionDate DATE,
    AcquisitionCost DECIMAL(10, 2)
);

-- Create Transactions Table
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    CustomerID INT,
    PurchaseDate DATE,
    TransactionAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


-- STEP 2: Insert Sample Data
 -- Insert Sample Customers
INSERT INTO Customers (CustomerID, AcquisitionDate, AcquisitionCost) VALUES
(1, '2023-01-10', 100.00),
(2, '2023-02-15', 150.00),
(3, '2023-03-05', 120.00),
(4, '2023-04-20', 80.00);

-- Insert Sample Transactions
INSERT INTO Transactions (TransactionID, CustomerID, PurchaseDate, TransactionAmount) VALUES
(101, 1, '2023-01-15', 200.00),
(102, 1, '2023-02-15', 250.00),
(103, 2, '2023-03-01', 300.00),
(104, 2, '2023-04-01', 400.00),
(105, 3, '2023-03-10', 150.00),
(106, 3, '2023-03-20', 100.00),
(107, 3, '2023-04-15', 200.00),
(108, 4, '2023-05-01', 90.00);



SELECT * FROM Customers;
SELECT * FROM Transactions;


-- STEP 3: Total Revenue per Customer
SELECT CustomerID, SUM(TransactionAmount) AS TotalRevenue
FROM Transactions
GROUP BY CustomerID




-- STEP 4: Purchase Frequency
SELECT CustomerID, COUNT(*) AS PurchaseFrequency
FROM Transactions
GROUP BY CustomerID;

 -- STEP 5: Average Purchase Value
SELECT CustomerID, AVG(TransactionAmount) AS AvgPurchaseValue
FROM Transactions
GROUP BY CustomerID;


-- STEP 6: Calculate CLV

SELECT 
   T. CustomerID,
    AVG(TransactionAmount) AS AvgPurchaseValue,
    COUNT(*) AS PurchaseFrequency,
    (AVG(TransactionAmount) * COUNT(*)) - MIN(AcquisitionCost) AS CLV
FROM 
       Transactions T
JOIN 
   Customers C ON T.CustomerID = C.CustomerID
GROUP BY 
    T.CustomerID;


	
-- STEP 7: Segment Customers Based on CLV

WITH CLV_Calculation AS (
    SELECT 
        T.CustomerID,
        ROUND((AVG(T.TransactionAmount) * COUNT(*) - MIN(C.AcquisitionCost)), 2) AS CLV
    FROM 
        Transactions T
    JOIN 
        Customers C ON T.CustomerID = C.CustomerID
    GROUP BY 
        T.CustomerID
)
SELECT 
    CustomerID,
    CLV,
    CASE
        WHEN CLV >= 1000 THEN 'High Value'
        WHEN CLV BETWEEN 500 AND 999.99 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS CLVSegment
FROM 
    CLV_Calculation;
	--
	