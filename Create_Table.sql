--DOWN
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_feedback_rental_record_id')
            ALTER TABLE Feedback DROP CONSTRAINT fk_feedback_rental_record_id

DROP TABLE if exists Feedback

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='pk_payment_payment_id')
            ALTER TABLE Payments DROP CONSTRAINT pk_payment_payment_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_payment_rental_record_id')
            ALTER TABLE Payments DROP CONSTRAINT fk_payment_rental_record_id

DROP TABLE if exists Payments


if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='pk_posting_posting_id')
            ALTER TABLE Postings DROP CONSTRAINT pk_posting_posting_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_posting_posting_user_id')
            ALTER TABLE Postings DROP CONSTRAINT fk_posting_posting_user_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_posting_posting_book_id')
            ALTER TABLE Postings DROP CONSTRAINT fk_posting_posting_book_id

DROP TABLE if exists Postings


if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='pk_rental_record_rental_record_id')
            ALTER TABLE Rental_Records DROP CONSTRAINT pk_rental_record_rental_record_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_rental_record_rental_user_id')
            ALTER TABLE Rental_Records DROP CONSTRAINT fk_rental_record_rental_user_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_rental_record_rental_book_id')
            ALTER TABLE Rental_Records DROP CONSTRAINT fk_rental_record_rental_book_id

DROP TABLE if exists Rental_Records 


if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='pk_book_book_id')
            ALTER TABLE Books DROP CONSTRAINT pk_book_book_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_book_book_category')
            ALTER TABLE Books DROP CONSTRAINT fk_book_book_category

DROP TABLE if exists Books 

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='pk_category_category_id')
            ALTER TABLE Category DROP CONSTRAINT pk_category_category_id

DROP TABLE if exists Category 

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='pk_users_user_id')
            ALTER TABLE USERS DROP CONSTRAINT pk_users_user_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='uk_users_user_email')
            ALTER TABLE USERS DROP CONSTRAINT uk_users_user_email

DROP TABLE if exists Users 


--UP
create table Users (
    user_id int not NULL identity(100,1),
    user_firstname varchar(20) not null,
    user_lastname varchar(20) not null,
    user_zipcode int not null,
    user_city char(20) not null,
    user_email varchar(20) not null
    CONSTRAINT pk_users_user_id primary key (user_id),
    CONSTRAINT uk_users_user_email unique (user_email)
)

create table Category(
    category_id int not null identity,
    category_code varchar(10) not null UNIQUE,
    category_name varchar(50) not null
    CONSTRAINT pk_category_category_id primary key (category_id)
)

create table Books(
    book_id int not null identity(200,1),
    book_isbn varchar(10) not null unique,
    book_name varchar(100) not null,
    book_author varchar(50),
    book_category varchar(10) not null,
    book_rating FLOAT,
    book_description varchar(1000),
    book_location varchar(50) not null
    CONSTRAINT pk_book_book_id primary key (book_id),
    CONSTRAINT fk_book_book_category foreign key (book_category) references Category(category_code)
)


create table Rental_Records(
    rental_record_id int not null identity(300,1),
    rental_user_id int not null,
    rental_book_id int not null,
    rental_book_isbn varchar(20),
    rental_start_date date not null,
    rental_due_date date not null,
    rental_price money not null,
    rental_location varchar(20) not null,
    CONSTRAINT pk_rental_record_rental_record_id primary key (rental_record_id),
    CONSTRAINT fk_rental_record_rental_user_id foreign key (rental_user_id) references USERS(user_id),
    CONSTRAINT fk_rental_record_rental_book_id foreign key (rental_book_id) references Books(book_id)
)

create table Postings(
    posting_id int not null identity,
    posting_user_id int not null,
    posting_book_id int not null,
    posting_loc_zipcode int not null,
    posting_loc_city varchar(20)
    CONSTRAINT pk_posting_posting_id primary key(posting_id),
    CONSTRAINT fk_posting_posting_user_id foreign key (posting_user_id) references USERS(user_id),
    CONSTRAINT fk_posting_posting_book_id foreign key (posting_book_id) references Books(book_id)
)

create table Payments(
    payment_id int not null identity(400,1), 
    rental_record_id int not null,
    payment_mode varchar(20) not null,
    payment_amount money not null
    CONSTRAINT pk_payment_payment_id primary key(payment_id),
    CONSTRAINT fk_payment_rental_record_id foreign key(rental_record_id) references Rental_Records(rental_record_id)
)

create table Feedback(
    feedback_rental_record_id int not null,
    feedback_bookname varchar(50) not null,
    feedback_book_id int not null,
    feedback_rating float not null,
    feedback_description varchar(1000)
    CONSTRAINT fk_feedback_rental_record_id foreign key(feedback_rental_record_id) references Rental_Records(rental_record_id)
)