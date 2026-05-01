create database rikkei_store;
use rikkei_store;

create table users(
    user_id int primary key auto_increment,
    full_name varchar(100),
    email varchar(100),
    address varchar(255),
    created_at datetime default current_timestamp
);

create table categories(
    category_id int primary key auto_increment,
    category_name varchar(100)
);

create table products(
    product_id int primary key auto_increment,
    product_name varchar(100),
    category_id int,
    price decimal(10,2),
    stock int,
    foreign key (category_id) references categories(category_id)
);

create table orders(
    order_id int primary key auto_increment,
    user_id int,
    customer_name varchar(100),
    customer_address varchar(255),
    order_date datetime default current_timestamp,
    status enum('pending','paid','cancelled'),
    total_money decimal(12,2),
    foreign key (user_id) references users(user_id)
);

create table order_details(
    order_detail_id int primary key auto_increment,
    order_id int,
    product_id int,
    price decimal(10,2),
    quantity int,
    subtotal decimal(12,2),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

insert into users(full_name, email, address)
values
	('Nguyễn Văn A','a@gmail.com','Hà Nội'),
	('Trần Thị B','b@gmail.com','TP. HCM'),
	('Lê Văn C','c@gmail.com','Đà Nẵng'),
	('Nguyễn Thị D','d@gmail.com','Hải Phòng'),
	('Trịnh Văn E','e@gmail.com','Cần Thơ');

insert into categories(category_name)
values
	('Electronics'),
	('Clothes'),
	('Food');

insert into products(product_name, category_id, price, stock)
values
	('Phone', 1, 1000, 10),
	('Laptop', 1, 2000, 5),
	('Shirt', 2, 50, 20),
	('Cake', 3, 10, 50),
	('TV', 1, 1500, 3);

insert into orders(user_id, customer_name, customer_address, status, total_money)
values
	(1, 'Nguyễn Văn A', 'Hà Nội', 'Paid', 1000),
	(2, 'Trần Thị B', 'TP. HCM', 'Paid', 2000),
	(3, 'Lê Văn C', 'Đà Nẵng', 'Pending', 500),
	(1, 'Nguyễn Thị D', 'Hà Nội', 'Paid', 1500),
	(4, 'Nguyễn Thị D', 'Hải Phòng', 'Cancelled', 300);

insert into order_details(order_id, product_id, price, quantity, subtotal)
values
	(1, 1, 1000, 1, 1000),
	(2, 2, 2000, 1, 2000),
	(3, 3, 50, 10, 500),
	(4, 5, 1500, 1, 1500),
	(5, 4, 10, 30, 300);

-- q1
select o.order_id, o.order_date, o.customer_name,
sum(od.subtotal) as total_money
from orders o
join order_details od on o.order_id = od.order_id
group by o.order_id;

-- q2
select * from products p
join categories c on p.category_id = c.category_id
where c.category_name = 'Electronics';

-- q3
select user_id, full_name, email
from users;

-- q4
select sum(total_money)
from orders;

-- q5
select p.product_id, p.product_name,
sum(od.quantity) as total_quantity
from order_details od
join products p on p.product_id = od.product_id
group by p.product_id;

-- q6
select product_id
from (
    select product_id, sum(quantity) as total
    from order_details
    group by product_id
) t
order by total desc
limit 1;

-- q7
select o.order_id, o.customer_name,
sum(od.subtotal) as total_money,
sum(od.quantity) as total_items
from orders o
join order_details od on o.order_id = od.order_id
group by o.order_id;

-- q8
select p.*
from products p
left join order_details od on p.product_id = od.product_id
where od.product_id is null;

-- q9
select u.user_id, u.full_name,
count(o.order_id) as total_orders
from users u
join orders o on u.user_id = o.user_id
group by u.user_id;

-- q10
select * from products
where price > (
	select avg(price)
    from products
);

-- q11
select user_id
from(
    select user_id, sum(total_money) as total_spent
    from orders
    group by user_id
) t
where total_spent > (
    select avg(total_money) from orders
);

-- q12
select * from orders
order by total_money desc
limit 1;

-- q13
select c.category_name, sum(od.subtotal) as revenue
from order_details od
join products p on p.product_id = od.product_id
join categories c on c.category_id = p.category_id
group by c.category_id
order by revenue desc
limit 1;

-- q14
select p.product_id, p.product_name, sum(od.quantity) as quantity
from order_details od
join products p on p.product_id = od.product_id
group by p.product_id
order by quantity desc, p.product_id asc
limit 3;

-- q15
select u.*
from users u
left join orders o on u.user_id = o.user_id
where o.user_id is null;