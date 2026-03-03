--create database
CREATE DATABASE OnlineBookstore;

--Switch to the database
--"\c" OnlineBookstore;

--create table
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
   Book_id SERIAL PRIMARY KEY,
   Title VARCHAR(100),
   Author VARCHAR(100),
   Genre VARCHAR(50),
   Published_year INT,
   Price NUMERIC(10,2),
   Stock INT
);

COPY
Books( Book_id, Title, Author, Genre, Published_year, Price, Stock)
FROM 'C:/Users/admin/Downloads/Books.csv'
DELIMITER','
CSV HEADER;

SELECT * FROM Books;

DROP TABLE IF EXISTS customers;
CREATE TABLE customers(
    Customer_id SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);


SELECT * FROM customers;

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders(
    Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);

SELECT * FROM Orders;

--Basics Queries
--Q1.Retrive all books in the "Fiction"genre
SELECT * FROM Books
WHERE Genre='Fiction';

-- Find books published after the year 1950:
SELECT * FROM Books
WHERE published_year>1950;

-- List all customers from the canada:
SELECT * FROM Customers
WHERE country='Canada';

--Show orders placed in november 2023
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--Retrive the total stock of books available
SELECT SUM(stock)AS stock_total
FROM Books;

--Find the details of the most expensive book:
SELECT * FROM Books ORDER BY price desc;

--Q7 Show all custoers who ordered than 1 quanity of a book
SELECT * FROM Orders
WHERE quantity>1;

-- Q8 Retrive all orders where the total amount exceeds $20:
SELECT * FROM Orders
WHERE total_amount>20;

--Q9 Retrive all genres available in the books table
SELECT DISTINCT genre FROM Books;

--Q10 find the book with the lowest stock;
SELECT * FROM Books 
ORDER BY stock 
LIMIT 1;

--Calculate the total revenue generated from all orders;
 SELECT SUM(total_amount) AS Revenue
 FROM Orders;

--Adavance Questions :

--Q1 Retrive the total number of books sold for each genre:
SELECT b.Genre, SUM(o.Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.Genre;

--Q2 Find the average price of books in the "Fantasy" genre:
SELECT AVG(price)AS Average_price
FROM Books
WHERE Genre = 'Fantasy';

--Q3 list customers who have placed at least 2 orders:
SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id 
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id)>=2;

--Q4 find the most frequently ordered book:
SELECT O.Book_id, b.title, COUNT(order_id)AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.Book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;


--Q5 show the top 3most expensive books of 'Fantasy'Genre:
SELECT * FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC LIMIT 3;

--Q6 Retrive the total quantity of books sold by each outhor:
SELECT b.author, SUM(o.quantity)AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;

--Q7 list the cities where customer who spend over $30 are locked
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;

--Q8 find the customer who spend the most on orders
SELECT c.customer_id, c.name, SUM(o.total_amount)AS Total_Spend
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_Spend DESC LIMIT 1;

--Q9 calculate the stock ramaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(quantity),0)AS Order_quantity,
b.stock-COALESCE(SUM(quantity),0) AS Remaining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;













