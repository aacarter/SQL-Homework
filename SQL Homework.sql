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
select address, sum(amount) 
from address
join staff on address.address_id = staff.address_id
join payment on staff.staff_id = payment.staff_id
group by staff.staff_id;


-- 7g. Write a query to display for each store its store ID, city, and country.
select address, store_id, city, country 
from address
join store on store.address_id = address.address_id
join city on address.city_id = city.city_id
join country on country.country_id = city.country_id;

-- 7h. List the top five genres in gross revenue in descending order
-- category, film_category, inventory, payment, and rental
select name, sum(amount)
from category
join film_category on category.category_id = film_category.category_id
join inventory on film_category.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on rental.rental_id = payment.rental_id
group by category.name
order by sum(amount) desc
limit 5;

-- 8a. create a view of the top 5 grossing genres
create view top_grossing_genres as
select name, sum(amount)
from category
join film_category on category.category_id = film_category.category_id
join inventory on film_category.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on rental.rental_id = payment.rental_id
group by category.name
order by sum(amount) desc
limit 5;

-- 8b. display the view
select * from sakila.top_grossing_genres;

-- 8c. delete the view
drop view sakila.top_grossing_genres;



