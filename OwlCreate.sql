-- Ensure the database exists before switching to it
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'owl')
BEGIN
    CREATE DATABASE owl;
END
GO

USE owl;
GO

-- Create the TYPE table
CREATE TABLE Type (
    TypeName VARCHAR(255) PRIMARY KEY,
    Description VARCHAR(255) NOT NULL
);

-- Create the SIZE table
CREATE TABLE Size (
    SizeName VARCHAR(10) PRIMARY KEY,
    Description VARCHAR(255) NOT NULL
);

-- Create the COLOR table
CREATE TABLE Color (
    ColorName VARCHAR(20) PRIMARY KEY,
    Description VARCHAR(255) NOT NULL
);

-- Create the ITEM table
CREATE TABLE Item (
    Id INT PRIMARY KEY,
    TypeName VARCHAR(255) REFERENCES Type(TypeName),
    SizeName VARCHAR(10) REFERENCES Size(SizeName),
    ColorName VARCHAR(20) REFERENCES Color(ColorName),
    Price DECIMAL(10, 2) NOT NULL
);

-- Create the PERIOD table
CREATE TABLE Period (
    Id INT PRIMARY KEY,
    Description VARCHAR(255) NOT NULL,
    Date DATE NOT NULL
);

-- Create the DISCOUNT table
CREATE TABLE Discount (
    ItemId INT REFERENCES Item(Id),
    PeriodId INT REFERENCES Period(Id),
    Discount DECIMAL(5, 4) NOT NULL
);

-- Create the ORDER table with TotalAmount
CREATE TABLE Order1 (
    Id INT PRIMARY KEY,
    Date DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) DEFAULT 0 -- To store the total amount of the order
);

-- Create the ORDER_ITEM table
CREATE TABLE OrderLine (
    Id INT PRIMARY KEY,
    OrderId INT REFERENCES Order1(Id),
    ItemId INT REFERENCES Item(Id),
    Quantity INT NOT NULL
);

-- Separate CREATE TRIGGER into its own batch
GO

-- Create the trigger (it must be the first statement in this batch)
CREATE TRIGGER BeforeInsertOrderLine
ON OrderLine
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @itemPrice DECIMAL(10, 2);
    DECLARE @discountRate DECIMAL(5, 4);
    DECLARE @totalAmount DECIMAL(10, 2);
    DECLARE @discountExists INT;

    DECLARE @itemId INT;
    DECLARE @quantity INT;
    DECLARE @orderId INT;

    DECLARE cur CURSOR FOR
    SELECT ItemId, Quantity, OrderId FROM inserted;

    OPEN cur;
    FETCH NEXT FROM cur INTO @itemId, @quantity, @orderId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @itemPrice = Price FROM Item WHERE Id = @itemId;

        SELECT @discountExists = COUNT(*), @discountRate = MAX(d.Discount)
        FROM Discount d
        JOIN Period p ON d.PeriodId = p.Id
        WHERE d.ItemId = @itemId
        AND GETDATE() BETWEEN p.Date AND DATEADD(DAY, 1, p.Date);

        IF @discountExists > 0
        BEGIN
            SET @totalAmount = @quantity * @itemPrice * (1 - @discountRate);
        END
        ELSE
        BEGIN
            SET @totalAmount = @quantity * @itemPrice;
        END

        UPDATE Order1
        SET TotalAmount = ISNULL(TotalAmount, 0) + @totalAmount
        WHERE Id = @orderId;

        FETCH NEXT FROM cur INTO @itemId, @quantity, @orderId;
    END

    CLOSE cur;
    DEALLOCATE cur;
END
GO

-- Insert data into tables
INSERT INTO Size (SizeName, Description) VALUES
    ('L', 'Large size'),
    ('S', 'Small size'),
    ('XL', 'Extra Large size'),
    ('XS', 'Extra Small size'),
    ('XXL', 'Double Extra Large size');

INSERT INTO Type (TypeName, Description) VALUES
    ('Sweatshirt', 'A warm sweatshirt for colder weather'),
    ('Tee Shirt', 'A standard T-shirt');

INSERT INTO Color (ColorName, Description) VALUES
    ('Black', 'Black color'),
    ('Blue', 'Blue color'),
    ('Gray', 'Gray color'),
    ('Red', 'Red color'),
    ('White', 'White color');

INSERT INTO Item (Id, TypeName, SizeName, ColorName, Price) VALUES
    (1, 'Tee Shirt', 'XL', 'Blue', 10.00),
    (2, 'Sweatshirt', 'XL', 'Red', 18.00),
    (3, 'Tee Shirt', 'L', 'Blue', 14.40),
    (4, 'Sweatshirt', 'L', 'Red', 30.60),
    (5, 'Sweatshirt', 'XXL', 'Red', 21.00);

-- Insert data into Period table
INSERT INTO Period (Id, Description, Date) VALUES
    (1, 'BackToSchool', '2024-09-01'),
    (2, 'Day After Back To School', '2024-09-02');

-- Insert data into Discount table
INSERT INTO Discount (ItemId, PeriodId, Discount) VALUES
    (1, 1, 0.80),
    (3, 2, 0.50);

-- Insert into Order1 table
INSERT INTO Order1 (Id, Date) VALUES
    (1, '2024-09-01'),
    (2, '2024-10-01');

-- Start a transaction to insert into OrderLine table
BEGIN TRANSACTION;

INSERT INTO OrderLine (Id, OrderId, ItemId, Quantity) VALUES
    (1, 2, 1, 1),
    (2, 1, 3, 1);

COMMIT;
GO
