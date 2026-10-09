CREATE DATABASE IF NOT EXISTS ecommerce_exp2;
USE ecommerce_exp2;

-- Drop tables in child-to-parent order for reruns
DROP TABLE IF EXISTS Delivery;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS OrderItem;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS Seller;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Customer;

-- 1. CUSTOMER
CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(100) NOT NULL,
    Date_of_Registration DATE NOT NULL
);

-- 2. CATEGORY
CREATE TABLE Category (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL UNIQUE
);

-- 3. SELLER
CREATE TABLE Seller (
    Seller_ID INT PRIMARY KEY,
    Seller_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);

-- 4. ADDRESS
CREATE TABLE Address (
    Address_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Street VARCHAR(150) NOT NULL,
    City VARCHAR(80) NOT NULL,
    State VARCHAR(80) NOT NULL,
    Postal_Code VARCHAR(15) NOT NULL,

    CONSTRAINT fk_address_customer
        FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID)
        ON DELETE CASCADE
);

-- 5. PRODUCT
CREATE TABLE Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL DEFAULT 0,
    Category_ID INT NOT NULL,
    Seller_ID INT NULL,

    CONSTRAINT chk_product_price CHECK (Price >= 0),
    CONSTRAINT chk_product_stock CHECK (Stock >= 0),

    CONSTRAINT fk_product_category
        FOREIGN KEY (Category_ID)
        REFERENCES Category(Category_ID)
        ON DELETE CASCADE,

    CONSTRAINT fk_product_seller
        FOREIGN KEY (Seller_ID)
        REFERENCES Seller(Seller_ID)
        ON DELETE SET NULL
);

-- 6. ORDERS
CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Order_Date DATE NOT NULL,
    Order_Status VARCHAR(30) NOT NULL DEFAULT 'Pending',

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID)
        ON DELETE CASCADE
);

-- 7. ORDER ITEM
CREATE TABLE OrderItem (
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (Order_ID, Product_ID),

    CONSTRAINT chk_orderitem_quantity CHECK (Quantity > 0),
    CONSTRAINT chk_orderitem_price CHECK (Unit_Price >= 0),

    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID)
        ON DELETE CASCADE,

    CONSTRAINT fk_orderitem_product
        FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID)
        ON DELETE CASCADE
);

-- 8. PAYMENT
CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY,
    Order_ID INT NOT NULL UNIQUE,
    Payment_Date DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Payment_Method VARCHAR(40) NOT NULL,

    CONSTRAINT chk_payment_amount CHECK (Amount >= 0),

    CONSTRAINT fk_payment_order
        FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID)
        ON DELETE CASCADE
);

-- 9. DELIVERY
CREATE TABLE Delivery (
    Delivery_ID INT PRIMARY KEY,
    Order_ID INT NULL UNIQUE,
    Delivery_Date DATE NULL,
    Delivery_Status VARCHAR(40) NOT NULL DEFAULT 'Processing',

    CONSTRAINT fk_delivery_order
        FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID)
        ON DELETE SET NULL
);

-- INSERT SAMPLE DATA

INSERT INTO Customer VALUES
(1, 'Aarav Sharma', 'aarav@example.com', 'pass101', '2026-01-10'),
(2, 'Priya Verma', 'priya@example.com', 'pass102', '2026-01-12'),
(3, 'Rahul Singh', 'rahul@example.com', 'pass103', '2026-01-15');

INSERT INTO Category VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Accessories');

INSERT INTO Seller VALUES
(1, 'Tech World', 'tech@example.com'),
(2, 'Book House', 'books@example.com');

INSERT INTO Address VALUES
(101, 1, 'Sector 15', 'Gurugram', 'Haryana', '122001'),
(102, 2, 'Sector 22', 'Chandigarh', 'Chandigarh', '160022'),
(103, 3, 'Civil Lines', 'Delhi', 'Delhi', '110054');

INSERT INTO Product VALUES
(201, 'Laptop', 55000.00, 10, 1, 1),
(202, 'SQL Fundamentals', 650.00, 50, 2, 2),
(203, 'Wireless Mouse', 799.00, 25, 3, 1),
(204, 'Database Systems', 850.00, 30, 2, NULL);

INSERT INTO Orders VALUES
(301, 1, '2026-02-01', 'Confirmed'),
(302, 2, '2026-02-03', 'Pending'),
(303, 3, '2026-02-05', 'Shipped');

INSERT INTO OrderItem VALUES
(301, 201, 1, 55000.00),
(301, 203, 2, 799.00),
(302, 202, 1, 650.00),
(303, 204, 2, 850.00);

INSERT INTO Payment VALUES
(401, 301, '2026-02-01', 56598.00, 'Card'),
(402, 302, '2026-02-03', 650.00, 'UPI'),
(403, 303, '2026-02-05', 1700.00, 'Net Banking');

INSERT INTO Delivery VALUES
(501, 301, '2026-02-04', 'Delivered'),
(502, 302, NULL, 'Processing'),
(503, 303, '2026-02-08', 'Delivered');

-- VERIFY INSERTED DATA

SELECT * FROM Customer;
SELECT * FROM Category;
SELECT * FROM Seller;
SELECT * FROM Address;
SELECT * FROM Product;
SELECT * FROM Orders;
SELECT * FROM OrderItem;
SELECT * FROM Payment;
SELECT * FROM Delivery;

-- TEST REFERENTIAL INTEGRITY VIOLATIONS
-- Uncomment and execute ONE statement at a time.
-- Each statement should fail because of a constraint violation.

-- Violation 1: Duplicate primary key
-- INSERT INTO Customer VALUES
-- (1, 'Duplicate Customer', 'duplicate@example.com',
--  'pass999', '2026-03-01');

-- Violation 2: Duplicate unique email
-- INSERT INTO Customer VALUES
-- (4, 'Test Customer', 'aarav@example.com',
--  'pass104', '2026-03-01');

-- Violation 3: Foreign key references a customer that does not exist
-- INSERT INTO Address VALUES
-- (104, 999, 'Unknown Street', 'Delhi', 'Delhi', '110001');

-- Violation 4: Foreign key references a category that does not exist
-- INSERT INTO Product VALUES
-- (205, 'Unknown Product', 100.00, 5, 999, NULL);

-- Violation 5: NOT NULL constraint
-- INSERT INTO Customer VALUES
-- (5, NULL, 'nullname@example.com',
--  'pass105', '2026-03-01');

-- Violation 6: CHECK constraint
-- INSERT INTO Product VALUES
-- (206, 'Invalid Price Product', -100.00, 5, 1, 1);

-- Violation 7: Duplicate order-product composite primary key
-- INSERT INTO OrderItem VALUES
-- (301, 201, 2, 55000.00);

-- DEMONSTRATE ON DELETE SET NULL
-- The product remains, but its Seller_ID becomes NULL.
-- Run separately if you want to test this:
-- DELETE FROM Seller WHERE Seller_ID = 2;
-- SELECT * FROM Product WHERE Product_ID = 202;

-- DEMONSTRATE ON DELETE CASCADE
-- Deleting a customer also deletes their addresses and orders.
-- Cascading from orders also deletes their order items,
-- payments and associated delivery records.
-- Run separately because this modifies sample data:
-- DELETE FROM Customer WHERE Customer_ID = 1;

-- FINAL CHECK
SELECT
    (SELECT COUNT(*) FROM Customer) AS Total_Customers,
    (SELECT COUNT(*) FROM Product) AS Total_Products,
    (SELECT COUNT(*) FROM Orders) AS Total_Orders,
    (SELECT COUNT(*) FROM OrderItem) AS Total_Order_Items;
```