
CREATE DATABASE IF NOT EXISTS sales;


/* Switch to the salesDB database */
USE sales;


/* Drop existing tables if they exist */
DROP TABLE IF EXISTS orderdetails;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS offices;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS productlines;


/* Create the tables */
CREATE TABLE productlines (
  productLine varchar(50) PRIMARY KEY,
  textDescription varchar(4000) DEFAULT NULL,
  htmlDescription MEDIUMTEXT NOT NULL,
  image mediumblob
);


CREATE TABLE products (
  productCode varchar(15) PRIMARY KEY,
  productName varchar(70) NOT NULL,
  productLine varchar(50) NOT NULL,
  productScale varchar(10) NOT NULL,
  productVendor varchar(50) NOT NULL,
  productDescription MEDIUMTEXT NOT NULL,
  quantityInStock smallint NOT NULL,
  buyPrice decimal(10,2) NOT NULL,
  MSRP decimal(10,2) NOT NULL,
  FOREIGN KEY (productLine) REFERENCES productlines (productLine)
);


CREATE TABLE offices (
  officeCode varchar(10) PRIMARY KEY,
  city varchar(50) NOT NULL,
  phone varchar(50) NOT NULL,
  addressLine1 varchar(50) NOT NULL,
  addressLine2 varchar(50) DEFAULT NULL,
  state varchar(50) DEFAULT NULL,
  country varchar(50) NOT NULL,
  postalCode varchar(15) NOT NULL,
  territory varchar(10) NOT NULL
);


CREATE TABLE employees (
  employeeNumber int PRIMARY KEY,
  lastName varchar(50) NOT NULL,
  firstName varchar(50) NOT NULL,
  extension varchar(10) NOT NULL,
  email varchar(100) NOT NULL,
  officeCode varchar(10) NOT NULL,
  reportsTo int DEFAULT NULL,
  jobTitle varchar(50) NOT NULL,
  FOREIGN KEY (reportsTo) REFERENCES employees (employeeNumber),
  FOREIGN KEY (officeCode) REFERENCES offices (officeCode)
);


CREATE TABLE customers (
  customerNumber int PRIMARY KEY,
  customerName varchar(50) NOT NULL,
  contactLastName varchar(50) NOT NULL,
  contactFirstName varchar(50) NOT NULL,
  phone varchar(50) NOT NULL,
  addressLine1 varchar(50) NOT NULL,
  addressLine2 varchar(50) DEFAULT NULL,
  city varchar(50) NOT NULL,
  state varchar(50) DEFAULT NULL,
  postalCode varchar(15) DEFAULT NULL,
  country varchar(50) NOT NULL,
  salesRepEmployeeNumber int DEFAULT NULL,
  creditLimit decimal(10,2) DEFAULT NULL,
  FOREIGN KEY (salesRepEmployeeNumber) REFERENCES employees (employeeNumber)
);


CREATE TABLE payments (
  customerNumber int,
  checkNumber varchar(50) NOT NULL,
  paymentDate date NOT NULL,
  amount decimal(10,2) NOT NULL,
  PRIMARY KEY (customerNumber,checkNumber),
  FOREIGN KEY (customerNumber) REFERENCES customers (customerNumber)
);


CREATE TABLE orders (
  orderNumber int PRIMARY KEY,
  orderDate date NOT NULL,
  requiredDate date NOT NULL,
  shippedDate date DEFAULT NULL,
  status varchar(15) NOT NULL,
  comments mediumtext not null ,
  customerNumber int NOT NULL,
  FOREIGN KEY (customerNumber) REFERENCES customers (customerNumber)
);


CREATE TABLE orderdetails (
  orderNumber int,
  productCode varchar(15) NOT NULL,
  quantityOrdered int NOT NULL,
  priceEach decimal(10,2) NOT NULL,
  orderLineNumber smallint NOT NULL,
  PRIMARY KEY (orderNumber,productCode),
  FOREIGN KEY (orderNumber) REFERENCES orders (orderNumber),
  FOREIGN KEY (productCode) REFERENCES products (productCode)
);
INSERT INTO productlines (productLine, textDescription, htmlDescription) VALUES
('Classic Cars', 'A collection of classic cars from various eras.', '<h3>Classic Cars</h3><p>Detailed replicas of classic automobiles.</p>'),
('Motorcycles', 'High-quality motorcycle models.', '<h3>Motorcycles</h3><p>Scale models of iconic motorcycles.</p>'),
('Planes', 'Detailed replicas of historical and modern aircraft.', '<h3>Planes</h3><p>Die-cast planes with realistic features.</p>');
INSERT INTO products (productCode, productName, productLine, productScale, productVendor, productDescription, quantityInStock, buyPrice, MSRP) VALUES
('S18_1001', '1969 Ford Mustang', 'Classic Cars', '1:18', 'Autoart', 'A classic muscle car model.', 100, 50.00, 100.00),
('S18_1002', '1957 Vespa GS150', 'Motorcycles', '1:18', 'Min Lin Diecast', 'A vintage scooter replica.', 50, 30.50, 60.00),
('S18_1003', 'P-51-D Mustang', 'Planes', '1:72', 'Gearbox Collectibles', 'World War II fighter plane.', 200, 75.00, 150.00),
('S18_1004', '2001 Ferrari Enzo', 'Classic Cars', '1:18', 'Second Gear', 'A modern classic sports car.', 75, 120.00, 240.00),
('S18_1005', '1936 Mercedes-Benz', 'Classic Cars', '1:18', 'Studio M Art Models', 'A beautiful vintage roadster.', 80, 85.00, 170.00);
INSERT INTO offices (officeCode, city, phone, addressLine1, country, postalCode, territory) VALUES
('1', 'San Francisco', '1-650-219-4782', '100 Market Street', 'USA', '94080', 'NA'),
('2', 'Boston', '1-617-555-5555', '123 Fake Street', 'USA', '02108', 'NA'),
('3', 'London', '+44 (0)20 7886 9100', '25 Old Broad Street', 'UK', 'EC2N 1HN', 'EMEA');
INSERT INTO employees (employeeNumber, lastName, firstName, extension, email, officeCode, jobTitle, reportsTo) VALUES
(1002, 'Murphy', 'Diane', 'x5800', 'dmurphy@classicmodelcars.com', '1', 'President', NULL),
(1056, 'Patterson', 'Mary', 'x4611', 'mpatterso@classicmodelcars.com', '1', 'VP Sales', 1002),
(1076, 'Jones', 'Jeff', 'x1000', 'jjones@classicmodelcars.com', '2', 'Sales Rep', 1056),
(1088, 'Nash', 'Peter', 'x2000', 'pnash@classicmodelcars.com', '3', 'Sales Rep', 1056),
(1100, 'Kato', 'Yoshimi', 'x3000', 'ykato@classicmodelcars.com', '3', 'Sales Rep', 1056);
INSERT INTO customers (customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, city, country, postalCode, salesRepEmployeeNumber, creditLimit) VALUES
(101, 'Atelier graphique', 'Schmitt', 'Carine ', '40.32.2555', '54, rue Royale', 'Nantes', 'France', '44000', 1088, 21000.00),
(102, 'Signal Gift Stores', 'King', 'Jean', '7025551838', '8489 Strong St.', 'Las Vegas', 'USA', '83030', 1076, 71800.00),
(103, 'Australian Collectors, Co.', 'Ferguson', 'Peter', '03 9520 4555', '636 St Kilda Road', 'Melbourne', 'Australia', '3004', 1088, 117300.00);
INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber) VALUES
(10100, '2023-01-20', '2023-01-25', '2023-01-23', 'Shipped', 'First order, shipped quickly.', 101),
(10101, '2023-01-25', '2023-02-01', NULL, 'In Process', 'Order is being processed.', 102),
(10102, '2023-02-05', '2023-02-10', '2023-02-08', 'Shipped', 'Shipped on time.', 103);
INSERT INTO payments (customerNumber, checkNumber, paymentDate, amount) VALUES
(101, 'HQ336336', '2023-01-23', 5000.00),
(102, 'QM556556', '2023-01-26', 10000.00),
(103, 'GH667667', '2023-02-09', 2500.00);
INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber) VALUES
(10100, 'S18_1001', 5, 50.00, 1),
(10100, 'S18_1002', 3, 30.50, 2),
(10101, 'S18_1003', 10, 75.00, 1),
(10102, 'S18_1004', 2, 120.00, 1),
(10102, 'S18_1005', 4, 85.00, 2);



-- Retrieve payment details:
SELECT checkNumber, paymentDate, amount FROM payments;
-- Retrieve "In Process" orders:
SELECT orderDate, requiredDate, status FROM orders WHERE status = 'In Process' ORDER BY orderDate DESC;
-- Retrieve 'Sales Rep' employee details:
SELECT firstName, lastName, email FROM employees WHERE jobTitle = 'Sales Rep' ORDER BY employeeNumber DESC;
-- Retrieve all office information:
SELECT * FROM offices;
-- Retrieve specific product information with sorting and limit:
SELECT productName, quantityInStock FROM products ORDER BY buyPrice ASC LIMIT 5;

 