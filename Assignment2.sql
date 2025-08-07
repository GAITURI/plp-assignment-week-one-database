/* Check if the database exists and create it if not */
IF DB_ID('salesDB') IS NULL
BEGIN
    CREATE DATABASE salesDB;
END
GO

/* Switch to the salesDB database */
USE salesDB;
GO

/* Drop existing tables if they exist */
DROP TABLE IF EXISTS orderdetails;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS offices;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS productlines;
GO

/* Create the tables */
CREATE TABLE productlines (
  productLine varchar(50) PRIMARY KEY,
  textDescription varchar(4000) DEFAULT NULL,
  htmlDescription nvarchar(max),
  image varbinary(max)
);
GO

CREATE TABLE products (
  productCode varchar(15) PRIMARY KEY,
  productName varchar(70) NOT NULL,
  productLine varchar(50) NOT NULL,
  productScale varchar(10) NOT NULL,
  productVendor varchar(50) NOT NULL,
  productDescription nvarchar(max) NOT NULL,
  quantityInStock smallint NOT NULL,
  buyPrice decimal(10,2) NOT NULL,
  MSRP decimal(10,2) NOT NULL,
  FOREIGN KEY (productLine) REFERENCES productlines (productLine)
);
GO

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
GO

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
GO

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
GO

CREATE TABLE payments (
  customerNumber int,
  checkNumber varchar(50) NOT NULL,
  paymentDate date NOT NULL,
  amount decimal(10,2) NOT NULL,
  PRIMARY KEY (customerNumber,checkNumber),
  FOREIGN KEY (customerNumber) REFERENCES customers (customerNumber)
);
GO

CREATE TABLE orders (
  orderNumber int PRIMARY KEY,
  orderDate date NOT NULL,
  requiredDate date NOT NULL,
  shippedDate date DEFAULT NULL,
  status varchar(15) NOT NULL,
  comments nvarchar(max),
  customerNumber int NOT NULL,
  FOREIGN KEY (customerNumber) REFERENCES customers (customerNumber)
);
GO

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
GO

/* The INSERT statements will need to be written in a compatible format for SQL Server.
   For example, you would use:
   INSERT INTO productlines (productLine, textDescription, htmlDescription, image)
   VALUES ('Classic Cars', '...', NULL, NULL);
   And so on for each table. */