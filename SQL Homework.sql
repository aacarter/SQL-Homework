use sakila;

-- 1a. display first and last name of actors
select first_name, last_name from actor;

-- add Actor Name as column
alter table actor 
add ActorName varchar(50);

-- turn off safe updates
set sql_safe_updates = 0;

-- 1b. update Actor Name column with values from first and last name columns using concatenate
update actor set ActorName = concat(first_name, '  ', last_name);
select * from actor;

-- 2a. find the ID number, first name, and last name of an actor with the first name Joe
select actor_id, first_name, last_name from actor
where first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN
select * from actor
where last_name like '%GEN%';

-- 2c. Find all actors whose last name contain the letters LI. Order rows by last name then first name
select * from actor
where last_name like '%LI%'
order by last_name, first_name asc;

-- 2d. use in to display country_id of Afghanistan, Bangladesh, and China
select country_id, country from country
where country in ("Afghanistan", "Bangladesh", "China");

-- 3a. add description column to actor table
alter table actor 
add description blob;

-- 3b. delete description column
alter table actor
drop column description;

-- 4a. List last names of actors and count of each last name
select last_name,  count(*) from actor  group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name,  count(*) 
from actor  
group by last_name
having count(*) > 1;

-- 4c. change groucho to harpo
update actor 
set first_name  = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';
select * from actor;

-- 4d. change harpo back to groucho
update actor
set first_name  = 'GROUCHO'
where first_name = 'HARPO' and last_name = 'WILLIAMS';
select * from actor;

-- 5a. re-create table
show create table address;


-- 6a. use address_id from staff and address tables to join first name, last name and address
select staff.address_id, staff.first_name, staff.last_name, address.address
from staff
inner join address on
staff.address_id = address.address_id;

-- 6b. display the total amount rung up by each staff member in August of 2005
select payment.staff_id, payment.amount, payment.payment_date, staff.first_name, staff.last_name
from payment
inner join staff on 
payment.staff_id = staff.staff_id
where payment_date like '2005-08%';

-- 6c. List each film and the number of actors who are listed for that film
select title,
(
select count(actor_id)
from film_actor 
where film_actor.film_id = film.film_id
) 
as 'Number of Actors'
from film;

-- 6d. find # of copies of Hunchback Impossible
select title,
(
select count(film_id)
from inventory 
where film.film_id = inventory.film_id
) 
as 'Number of Copies'
from film
where title = 'Hunchback Impossible';

-- 6e. list the total paid by each customer in alphabetical order by last name
select customer_id, first_name, last_name,
(
select sum(amount)
from payment
where customer.customer_id = payment.customer_id
)
as 'Sum of Payment by Customer'
from customer
order by last_name asc;

-- 7a. display names of movies beginning with K and Q whose language is English
-- if know language_id for English movies you can do it this way
select title
from film
where title like 'K%' 
or title like 'Q%'
and language_id = 1;

-- if don't know language_id for English movies you can do it this way
select title,
(
select language_id
from language
where film.language_id = language.language_id and name = 'English'
)
as 'English Language ID'
from film
where title like 'K%' 
or title like 'Q%';

-- 7b. use subqueries to display all actors that appeared in Alone Trip
select first_name, last_name
from actor
where actor_id in
(
	select actor_id
    from film_actor
    where film_id in
    (
		select film_id
        from film
        where title = 'Alone Trip'
	)
);

-- 7c. get names and email addresses of all Canadian customers
-- use country, city , address and customer tables
select first_name, last_name, email
from customer
where address_id in
(
	select address_id
    from address
    where city_id in
    (
		select city_id
        from city
        where country_id in
        (
			select country_id
			from country
			where country = 'Canada'
		)
	)
	
);

-- 7d. identify all movies categorized as family films
select * from film_category;
select * from category;

select title
from film
where film_id in
(
	select film_id
    from film_category
    where category_id in
    (
		select category_id
        from category
        where category_id = 8
	)
);

-- 7e. Display the most frequently rented movies in descending order.
select title, rental_rate
from film
order by rental_rate desc;

-- 7f. display how much business, in dollars, each store brought in
-- sum staff id which links to  rental then store

select * from payment;
select * from staff;
select * from address;

select address
from address
where address_id in
(
	select address_id
    from staff
    where staff_id in
    (
		select staff_id
        from payment
        where sum(payment) 
	)
);

select 

select payment.staff_id, payment.amount, staff.staff_id, staff.address_id, staff.store_id
from payment
inner join staff on 
payment.staff_id = staff.staff_id
select staff.address_id, payment.staff_id


SELECT payment.staff_id, SUM(payment.amount), staff.staff_id, staff.address_id, staff.store_id, address.address, address.address_id
FROM payment 
INNER JOIN staff
ON payment.staff_id = staff.staff_id 
-group by payment.staff_id
INNER JOIN address
ON staff.address_id =  address.address_id;
-- GROUP BY customer.customer_id
-- ORDER BY customer.last_name;



-- 7g. Write a query to display for each store its store ID, city, and country.
-- select * from store;
-- select * from address;
-- select * from city;



