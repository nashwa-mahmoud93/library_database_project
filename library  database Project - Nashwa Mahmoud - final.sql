/******************* In the Library *********************/

-- 1- find the number of availalbe copies of the book (Dracula)
SELECT COUNT(*) as avail_copies_of_Dracula FROM books 
WHERE Title = 'Dracula' AND BookID NOT IN (
SELECT BookID FROM loans WHERE ReturnedDate IS NULL
);

-- 2- check total copies of the book 
SELECT COUNT(*) as total_copies FROM books
WHERE Title = 'Dracula';

-- OR --

SELECT * FROM books
WHERE Title = 'Dracula';

-- 3- current total loans of the book 
SELECT COUNT(*) AS total_loans_of_Dracula FROM loans l
JOIN books b ON l.BookID = b.BookID
WHERE b.Title = 'Dracula' AND l.ReturnedDate IS NULL;

-- OR --
SELECT * FROM loans l
JOIN books b ON l.BookID = b.BookID
WHERE b.Title = 'Dracula' AND l.ReturnedDate IS NULL;

-- 4- total available books of dracula */
-- your code
SELECT COUNT(*) AS avaialble_dracula_books FROM books
WHERE Title = 'Dracula' AND BookID NOT IN (
SELECT BookID FROM loans WHERE ReturnedDate IS NULL
);

-- OR --

SELECT * FROM books
WHERE Title = 'Dracula' AND BookID NOT IN (
SELECT BookID FROM loans WHERE ReturnedDate IS NULL
);

-- 5- Add new books to the library
INSERT INTO books (BookID, Title, Author, Published, Barcode) VALUES
(2001, 'Don Quixote', 'Miguel de Cervantes', 1860, 9780141439846),
(2002, 'Alice Adventures in Wonderland', 'Lewis Carroll', 1900, 9780199564095),
(2003, 'Treasure Island', '	Robert Louis Stevenson', 1897, 9780141045227),
(2004, 'Frankenstein', 'Mary Shelley', 1818, 9780486282114),
(2005, 'The Shining', 'Stephen King', 1977, 9780307743657);
 -- check all the books in the list to find the new added books
SELECT * FROM books;

-- 6- Check out Books: books(4043822646, 2855934983) whose patron_email(jvaan@wisdompets.com), loandate=2020-08-25, duedate=2020-09-08, loanid=by_your_choice*/
-- your code
SELECT BookID, PatronID, '2020-08-25', '2020-09-08' FROM Books, Patrons
WHERE Email = 'jvaan@wisdompets.com' AND Barcode IN (4043822646, 2855934983);

-- 7- Check books for Due back
SELECT l.LoanID, b.Title, p.FirstName, p.LastName, p.Email, l.LoanDate, l.DueDate FROM loans l
JOIN books b ON l.BookID = b.BookID
JOIN patrons p ON l.PatronID = p.PatronID
WHERE l.ReturnedDate IS NULL;

-- 8- generate a report of books due back on July 13, 2020 */
SELECT l.LoanID, b.Title, b.BookID, l.LoanDate, l.DueDate FROM loans l
JOIN books b ON l.BookID = b.BookID
JOIN patrons p ON l.PatronID = p.PatronID
WHERE l.DueDate = '2020-07-13' 
AND l.ReturnedDate IS NULL;

-- 9- generate a report of books due back on July 13, 2020 with patron contact information 
SELECT l.LoanID, b.Title, b.BookID, p.FirstName, p.LastName, p.Email, l.LoanDate, l.DueDate FROM loans l
JOIN books b ON l.BookID = b.BookID
JOIN patrons p ON l.PatronID = p.PatronID
WHERE l.DueDate = '2020-07-13' AND l.ReturnedDate IS NULL;

-- 10- Return books to the library (which have barcode=6435968624) and return this book at this date(2020-07-05)                    */
SET SQL_SAFE_UPDATES = 0;
--
UPDATE loans 
SET ReturnedDate = '2020-07-05'
WHERE BookID = (SELECT BookID FROM books WHERE Barcode = 6435968624)
AND ReturnedDate IS NULL;
--
SELECT * FROM loans 
WHERE BookID = (SELECT BookID FROM books WHERE Barcode = 6435968624);

-- 11- Encourage Patrons to check out books
-- a code to check patrons that didn't check out any books for the last 3 months 
SELECT FirstName, LastName, Email FROM Patrons
WHERE PatronID NOT IN (
SELECT DISTINCT PatronID FROM Loans
WHERE LoanDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
);
-- a code to check the 10 books with the most numbers of loans that can be reccommended to the patrons
SELECT b.Title, MIN(b.Author) AS Author, COUNT(l.BookID) AS loans_count FROM Loans l
JOIN Books b ON l.BookID = b.BookID
GROUP BY b.Title
ORDER BY loans_count DESC
LIMIT 10;

-- 12- generate a report of showing 10 patrons who have checked out the fewest books.                          */
SELECT p.PatronID, p.FirstName, p.LastName, p.Email, COUNT(l.LoanID) AS total_checkouts_by_patrons FROM patrons p
LEFT JOIN loans l ON p.PatronID = l.PatronID
GROUP BY p.PatronID, p.FirstName, p.LastName, p.Email
ORDER BY total_checkouts_by_patrons ASC
LIMIT 10;

-- 13- Find books to feature for an event   create a list of books from 1890s that are currently available                                    */
-- your code
SELECT BookID, Title, Author, Published, Barcode FROM books
WHERE Published BETWEEN 1890 AND 1899 AND BookID NOT IN (
SELECT BookID FROM loans WHERE ReturnedDate IS NULL
);

-- 14- create a report to show how many books were published each year.          
SELECT Published, COUNT(BookID) as total_books_published FROM books 
GROUP BY Published
ORDER BY Published ASC;				

-- 15- create a report to show 5 most popular Books to check out

SELECT b.BookID, b.Title, b.Author, COUNT(l.LoanID) AS loans_count FROM books b
JOIN loans l ON b.BookID = l.BookID
GROUP BY b.BookID, b.Title, b.Author
ORDER BY loans_count DESC
LIMIT 5;