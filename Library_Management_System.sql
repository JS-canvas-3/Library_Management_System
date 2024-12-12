

-- Creating the database
CREATE DATABASE Library_Management_System;
USE Library_Management_System;

-- Creating Branch table
CREATE TABLE Branch (
    Branch_no INT PRIMARY KEY,
    Manager_Id INT,
    Branch_address VARCHAR(255),
    Contact_no VARCHAR(15)
);

-- Creating Employee table
CREATE TABLE Employee (
    Emp_Id INT PRIMARY KEY,
    Emp_name VARCHAR(100),
    Position VARCHAR(50),
    Salary DECIMAL(10,2),
    Branch_no INT,
    FOREIGN KEY (Branch_no) REFERENCES Branch(Branch_no)
);

-- Creating Books table
CREATE TABLE Books (
    ISBN INT PRIMARY KEY,
    Book_title VARCHAR(255),
    Category VARCHAR(100),
    Rental_Price DECIMAL(10,2),
    Status VARCHAR(3),
    Author VARCHAR(100),
    Publisher VARCHAR(100)
);

-- Creating Customer table
CREATE TABLE Customer (
    Customer_Id INT PRIMARY KEY,
    Customer_name VARCHAR(100),
    Customer_address VARCHAR(255),
    Reg_date DATE
);

-- Creating IssueStatus table
CREATE TABLE IssueStatus (
    Issue_Id INT PRIMARY KEY,
    Issued_cust_Id INT,
    Issued_book_name VARCHAR(255),
    Issue_date DATE,
    Isbn_book INT,
    FOREIGN KEY (Issued_cust_Id) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book) REFERENCES Books(ISBN)
);

-- Creating ReturnStatus table
CREATE TABLE ReturnStatus (
    Return_Id INT PRIMARY KEY,
    Return_cust INT,
    Return_book_name VARCHAR(255),
    Return_date DATE,
    Isbn_book2 INT,
    FOREIGN KEY (Return_cust) REFERENCES Customer(Customer_Id),
    FOREIGN KEY (Isbn_book2) REFERENCES Books(ISBN)
);


-- Inserting values into Branch table
INSERT INTO Branch (Branch_no, Manager_Id, Branch_address, Contact_no) VALUES
(1, 101, 'Gandhinagar Street, City Center, Bangalore', '0482125682'),
(2, 102, 'Avenue Park Road, Delhi', '497581235'),
(3, 103, 'Srinagar,Vellaptti Road, Erode', '04825425682'),
(4, 104, 'Kamaraja ,Kasani Road , AndhraPradesh', '9547581235');

-- Inserting values into Employee table
INSERT INTO Employee (Emp_Id, Emp_name, Position, Salary, Branch_no) VALUES
(101, 'Vishwanadhan', 'Manager', 75000, 1),
(102, 'Kamerash Pillai', 'Manager', 72000, 2),
(103, 'Hemanth Swami', 'Librarian', 50000, 1),
(104, 'Arjun Pandai', 'Assistant Librarian', 40000, 2);

-- Inserting values into Books table
INSERT INTO Books (ISBN, Book_title, Category, Rental_Price, Status, Author, Publisher) VALUES
(1001, 'The Great Gatsby', 'Fiction', 15.50, 'yes', 'F. Scott Fitzgerald', 'Scribner'),
(1002, 'To Kill a Mockingbird', 'Fiction', 12.75, 'no', 'Harper Lee', 'J.B. Lippincott & Co.'),
(1003, '1984', 'Dystopian', 10.00, 'yes', 'George Orwell', 'Secker & Warburg'),
(1004, 'A Brief History of Time', 'Science', 20.00, 'yes', 'Stephen Hawking', 'Bantam Books');

-- Inserting values into Customer table
INSERT INTO Customer (Customer_Id, Customer_name, Customer_address, Reg_date) VALUES
(201, 'Hari Krishnan', '123 Elm Street', '2021-11-15'),
(202, 'Mathew david', '456 Oak Avenue', '2022-02-20'),
(203, 'Parkashan', '789 Pine Road', '2020-07-30');

-- Inserting values into IssueStatus table
INSERT INTO IssueStatus (Issue_Id, Issued_cust_Id, Issued_book_name, Issue_date, Isbn_book) VALUES
(301, 201, 'The Great Gatsby', '2023-06-10', 1001),
(302, 202, '1984', '2023-06-15', 1003);

-- Inserting values into ReturnStatus table
INSERT INTO ReturnStatus (Return_Id, Return_cust, Return_book_name, Return_date, Isbn_book2) VALUES
(401, 201, 'The Great Gatsby', '2023-07-10', 1001),
(402, 202, '1984', '2023-07-20', 1003);

--  1. Retrieve the book title, category, and rental price of all available books.
SELECT Book_title, Category, Rental_Price 
FROM Books 
WHERE Status = 'yes';

-- 2. List the employee names and their respective salaries in descending order of salary.
SELECT Emp_name, Salary 
FROM Employee 
ORDER BY Salary DESC;

-- 3. Retrieve the book titles and the corresponding customers who have issued those books.
SELECT B.Book_title, C.Customer_name 
FROM IssueStatus ISS
JOIN Books B ON ISS.Isbn_book = B.ISBN
JOIN Customer C ON ISS.Issued_cust_Id = C.Customer_Id;

-- 4. Display the total count of books in each category.
SELECT Category, COUNT(*) AS Total_Books 
FROM Books 
GROUP BY Category;

-- 5. Retrieve the employee names and their positions for the employees whose salaries are above Rs.50,000.
SELECT Emp_name, Position 
FROM Employee 
WHERE Salary > 50000;

-- 6. List the customer names who registered before 2022-01-01 and have not issued any books yet.
SELECT C.Customer_name 
FROM Customer C
LEFT JOIN IssueStatus ISS ON C.Customer_Id = ISS.Issued_cust_Id
WHERE C.Reg_date < '2022-01-01' AND ISS.Issue_Id IS NULL;

-- 7. Display the branch numbers and the total count of employees in each branch.
SELECT Branch_no, COUNT(*) AS Total_Employees 
FROM Employee 
GROUP BY Branch_no;

-- 8. Display the names of customers who have issued books in the month of June 2023.
SELECT C.Customer_name 
FROM IssueStatus ISS
JOIN Customer C ON ISS.Issued_cust_Id = C.Customer_Id
WHERE MONTH(ISS.Issue_date) = 6 AND YEAR(ISS.Issue_date) = 2023;

-- 9. Retrieve book_title from book table containing 'history'.
SELECT Book_title 
FROM Books 
WHERE Book_title LIKE '%history%';

-- 10. Retrieve the branch numbers along with the count of employees for branches having more than 5 employees.
SELECT Branch_no, COUNT(*) AS Total_Employees 
FROM Employee 
GROUP BY Branch_no 
HAVING COUNT(*) > 5;

-- 11. Retrieve the names of employees who manage branches and their respective branch addresses.
SELECT E.Emp_name, B.Branch_address 
FROM Branch B
JOIN Employee E ON B.Manager_Id = E.Emp_Id;

-- 12: Display the names of customers who have issued books with a rental price higher than Rs. 25.
SELECT DISTINCT C.Customer_name 
FROM IssueStatus ISS
JOIN Books B ON ISS.Isbn_book = B.ISBN
JOIN Customer C ON ISS.Issued_cust_Id = C.Customer_Id
WHERE B.Rental_Price > 25;
