----1 Display different payments methods used by users while paying the rental payment and the total amount of money spent by each user on 
----each payment method
with user_payment_record as (
    select u.user_firstname + ' ' + u.user_lastname as USER_NAME, u.user_email as User_Email, r.rental_user_id as User_Id, r.rental_price as Rental_Price, p.payment_mode as Payment_Mode
    from users as u 
    join Rental_Records as r on u.user_id = r.rental_user_id
    join Payments as p on r.rental_record_id = p.rental_record_id 
)
select * from user_payment_record
PIVOT(sum(rental_price) for Payment_Mode in ("Apple Pay","Google Pay","Credit Card","Debit Card")) as pivot_payment

----2 Most Popular authors in the Rental Records and the Number of Books which are rented 

select TOP 3 b.book_author, count(b.book_author) as Number_of_Books_Rented
from Rental_Records r join Books b on r.rental_book_id = b.book_id
group by b.book_author
order by Number_of_Books_Rented DESC

----3 Average ratings of the posted books rented by users
select distinct(feedback_bookname), AVG(feedback_rating)over (PARTITION by feedback_bookname) as Average_Rating, count(feedback_bookname) 
over (PARTITION by feedback_bookname)as Book_Count
from Feedback
ORDER by Average_Rating DESC




----4 Which book in Los Angeles has maximum copies?
with view_book as(SELECT book_id,book_name,book_location, COUNT(book_name) as number_of_books
    from Books
    join Rental_Records on rental_book_id = book_id
    WHERE book_location = 'Los Angeles'
    GROUP by book_id,book_name,book_location)

select Top 1 book_name, MAX(number_of_books)
    over (PARTITION by book_name order by book_id) as max_books, book_location 
    from view_book 

----5 Top 3 book categories in NYC
select TOP 3 Category.category_name, COUNT(book_category) as Categories, book_location
    from Books
    join Category on Books.book_category = Category.category_code
    GROUP by book_category , category_name, book_location
    having book_location = 'New York City'
    order by CATEGORIES DESC    
    
    


----6 Top 5 highest rented books. Show their average prices
    SELECT TOP 5 rental_book_id, book_name, book_location ,COUNT(rental_book_id) as total_books, AVG(rental_price) as average_price
    from Rental_Records
    JOIN Books on Books.book_id = rental_book_id
    GROUP by rental_book_id, book_name, book_location
    order by total_books DESC






----7 How many people are actually using the app and how many people have rented using the app in each city
select t1.user_city, t1.num_of_application_users, t2.num_of_users_who_rent from (
    select COUNT(user_id) as num_of_application_users, user_city from Users
    GROUP by user_city
    )
 as t1,
( 
    select COUNT(rental_user_id) as num_of_users_who_rent, rental_location from Rental_Records
    GROUP by rental_location
    ) 
 as t2
 where t1.user_city = t2.rental_location


----8 Trigger for adding the ratings in book table as in the feedback table

DROP TRIGGER if exists ratingAvgBooks
GO
CREATE TRIGGER ratingAvgBooks
on Feedback
AFTER INSERT, UPDATE 
AS BEGIN 
    UPDATE Books
    set book_rating = feedback_rating
    from Books join Feedback on book_id=feedback_book_id 
END
GO

select * from Rental_Records
select * from Books