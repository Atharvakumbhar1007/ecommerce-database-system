-- ==========================================================
--   E-COMMERCE DATABASE SYSTEM
--   Author: Atharva Kumbhar
--   Description: Complete database for an online store
-- ==========================================================

-- drop and recreate if needed
drop database if exists ecommerce_db;
create database ecommerce_db;
use ecommerce_db;

-- ==========================================================
-- 1. CATEGORY TABLE (NORMALIZED, WITH CONSTRAINTS)
-- ==========================================================
create table category (
	categoryId int auto_increment,
	categoryName varchar(50) not null,
    description varchar(255),
	constraint pk_category_categoryId primary key (categoryId),
	constraint uq_category_categoryName unique (categoryName)
);

-- ==========================================================
-- 2. PRODUCT TABLE
-- ==========================================================
create table product (
	productId int auto_increment,
    productName varchar(100) not null,
    description text,
    price decimal(10 , 2) not null,
    quantity int not null,
    categoryId int not null,
    constraint pk_product_productId primary key (productId),
    constraint fk_product_category foreign key (categoryId) references category(categoryId)
		on delete cascade -- Child records deleted when parent is deleted
        on update cascade -- Child foreign keys updated when parent key changes
);

-- ==========================================================
-- 3. USER PROFILE
-- ==========================================================
create table userprofile (
	userId int auto_increment,
    firstName varchar(50) not null,
    lastName varchar(50) not null,
    email varchar(100) unique not null,
    phone varchar(15),
    createdAt datetime default current_timestamp,
    updatedAt datetime default current_timestamp on update current_timestamp,
    constraint pk_userprofile_userId primary key (userId)
);

-- ==========================================================
-- 4. ADDRESS TABLE
-- ==========================================================
create table address(
	addressId int auto_increment,
    userId int not null,
    street varchar(255) not null,
    city varchar(50) not null,
    state varchar(50) not null,
    zipcode varchar(10) not null,
    isShippingAddress BIT not null default 1, -- indicate whether it's a shipping address
	createdAt datetime default current_timestamp,
    updatedAt datetime default current_timestamp on update current_timestamp,
    constraint pk_address_addressId primary key (addressId),
    constraint fk_address_userprofile foreign key (userId) references userprofile(userId)
		on delete cascade 
        on update cascade
);

-- ==========================================================
-- 5. ORDERS TABLE
-- ==========================================================
create table orders (
	orderId int auto_increment,
    userId int not null,
    shippingAddressId int,
    orderdate datetime default current_timestamp,
    totalamount decimal(10 , 2) not null default 0.00,
    status enum('pending','shipped','completed','failed') default 'pending',
    createdAt datetime default current_timestamp,
    updatedAt datetime default current_timestamp on update current_timestamp,
    constraint pk_order_orderId primary key (orderId),
    constraint fk_order_userprofile foreign key (userId) references userprofile(userId)
		on delete cascade
        on update cascade,
    constraint fk_order_address foreign key (shippingAddressId) references address(addressId)
		on delete set null
        on update cascade
);

-- ==========================================================
-- 6. ORDER ITEMS
-- ==========================================================
create table orderitem(
	orderitemId int auto_increment,
    orderId int not null,
    productId int not null,
    quantity int not null,
    price decimal(10 , 2) default 0.00,
    discount decimal(10 , 2) default 0.00,
    tax decimal(10 , 2) default 0.00,
    subtotal decimal(10 , 2) default 0.00,
    createdAt datetime default current_timestamp,
    updatedAt datetime default current_timestamp on update current_timestamp,
    constraint pk_orderitem_orderitemId primary key (orderitemId),
    constraint fk_orderitem_orders foreign key (orderId) references orders(orderId)
		on delete cascade 
        on update cascade,
    constraint fk_orderitem_product foreign key (productId) references product(productId)
		on delete cascade 
        on update cascade
);

-- ==========================================================
-- 7. PAYMENT INFORMATION
-- ==========================================================
create table paymentInformation (
	paymentId int auto_increment,
    orderId int not null,
    paymentAmount decimal(10 , 2) not null,
    paymentMethod enum('COD','credit_card','debit_card','UPI','net_banking') not null default 'COD',
    paymentstatus enum('pending','completed','failed') default 'pending',
    transactionId varchar(100) unique,
    createdAt datetime default current_timestamp,
    updatedAt datetime default current_timestamp on update current_timestamp,
    constraint pk_paymentinformation_paymentId primary key (paymentId),
    constraint fk_paymentinformation_orders foreign key (orderId) references orders(orderId)
		on delete cascade 
        on update cascade
);

-- ==========================================================
-- 8. ORDER STATUS
-- ==========================================================
create table orderstatus (
	statusId int auto_increment,
    orderId int not null,
    statusName varchar(50) not null,
    updatedBy varchar (50) default 'system',
    remarks varchar(255),
    createdAt datetime default current_timestamp,
    constraint pk_orderstatus_statusId primary key (statusId),
    constraint fk_orderstatus_orders foreign key (orderId) references orders(orderId)
		on delete cascade 
        on update cascade
);

-- ==========================================================
-- 9. PRODUCT REVIEW
-- ==========================================================
create table productreview (
reviewId int auto_increment,
productId int not null,
userId int not null,
rating enum('1','2','3','4','5') not null,
reviewText TEXT,
reviewdate datetime default current_timestamp,
createdAt datetime default current_timestamp,
updatedAt datetime default current_timestamp on update current_timestamp,
constraint pk_productreview primary key (reviewId),
constraint fk_productreview_product foreign key (productId) references product(productId)
		on delete cascade 
        on update cascade,
constraint fk_productreview_userprofile foreign key (userId) references userprofile(userId)
		on delete cascade 
        on update cascade
);

-- ==========================================================
-- 10. PRODUCT IMAGE
-- ==========================================================
create table productimage (
	imageId int auto_increment,
    productId int not null,
    imageUrl varchar(255) not null,
    constraint pk_productImage_imageId primary key (imageId),
    constraint fk_productImage_product foreign key (productId) references product(productId)
		on delete cascade 
        on update cascade
);

-- ==========================================================
-- 11. COUPON
-- ==========================================================
create table coupon (
    couponId int auto_increment,
    couponcode varchar(20) not null unique,
    discountamount decimal(10 , 2) not null,
    expirydate datetime not null,
    productId int null,
    categoryId int null,
    constraint pk_coupon_couponId primary key (couponId),
    constraint fk_coupon_product foreign key (productId) references product(productId)
        on delete cascade 
        on update cascade,
    constraint fk_coupon_category foreign key (categoryId) references category(categoryId)
        on delete cascade 
        on update cascade
);

-- ==========================================================
-- 12. ORDER COUPON
-- ==========================================================
create table ordercoupon (
	ordercouponId int auto_increment,
	orderId int not null,
	couponId int not null,
    constraint up_order_coupon unique(orderId, couponId),
	constraint pk_ordercoupon_ordercouponId primary key (ordercouponId),
    constraint fk_ordercoupon_order foreign key (orderId) references orders(orderId)
        on delete cascade 
        on update cascade,
    constraint fk_ordercoupon_coupon foreign key (couponId) references coupon(couponId)
        on delete cascade 
        on update cascade
);

-- ==========================================================
-- 13. CART 
-- ==========================================================
create table cart (
	cartId int auto_increment,
    userId int not null,
    productId int not null,
    quantity int not null,
    constraint pk_cart_cartId primary key (cartId),
    constraint fk_cart_userId foreign key (userId) references userprofile(userId)
        on delete cascade 
        on update cascade,
    constraint fk_cart_product foreign key (productId) references product(productId)
        on delete cascade 
        on update cascade,
        constraint uq_cart_user_product
        unique (userId, productId)
); 

-- ==========================================================
-- 14. WISHLIST
-- ==========================================================

create table wishlist (
	wishlistId int auto_increment,
    userId int not null,
    productId int not null,
    constraint pk_wishlist_wishlistId primary key (wishlistId),
    constraint fk_wishlist_userprofile foreign key (userId) references userprofile(userId)
        on delete cascade 
        on update cascade,
    constraint fk_wishlist_product foreign key (productId) references product(productId)
        on delete cascade 
        on update cascade,
        constraint uq_wishlist_user_product
		unique (userId, productId)

);

-- ==========================================================
-- FUNCTION
-- ==========================================================

DELIMITER $$

create function
fn_order_total(p_orderId INT)
returns decimal(10,2)
deterministic
begin
	declare total decimal(10,2);
    select sum(subtotal) into total
    from orderitem
    where orderId = p_orderId;
    return ifnull(total,0);
    end $$
    
DELIMITER ;

-- ==========================================================
-- TRIGGERS
-- ==========================================================

DELIMITER $$

create trigger trg_check_stock
before insert on orderitem
for each row 
begin
    declare currentStock int;
    select quantity into currentStock
    from product
    where productId = NEW.productId;
    if currentStock < NEW.quantity then
        signal sqlstate '45000'
        set message_text = 'Insufficient stock';
    end if;
end $$

create trigger trg_reduce_stock
after insert on orderitem
for each row
begin
    update product
    set quantity = quantity - NEW.quantity
    where productId = NEW.productId;
    update orders
    set totalamount = fn_order_total(NEW.orderId)
    where orderId = NEW.orderId;
end $$

create trigger trg_restore_stock
after delete on orderitem
for each row
begin
    update product
    set quantity = quantity + OLD.quantity
    where productId = OLD.productId;
    update orders
    set totalamount = fn_order_total(OLD.orderId)
    where orderId = OLD.orderId;
end $$

DELIMITER ;

-- ==========================================================
-- VIEWS
-- ==========================================================

create view view_user_orders as
select 
    u.userId,
    CONCAT(u.firstName,' ',u.lastName) as customerName,
    o.orderId,
    o.orderdate,
    o.status,
    o.totalamount
from userprofile u
join orders o on u.userId = o.userId;

create view view_order_details as
select 
    o.orderId,
    p.productName,
    oi.quantity,
    oi.price,
    oi.subtotal
from orders o
join orderitem oi on o.orderId = oi.orderId
join product p on oi.productId = p.productId;

create view view_product_category as
select 
    p.productId,
    p.productName,
    c.categoryName,
    p.price,
    p.quantity
from product p
join category c on p.categoryId = c.categoryId;

SELECT * FROM product;
SELECT * FROM userprofile;
SELECT * FROM orders;
SELECT * FROM orderitem;
SELECT * FROM paymentInformation;
SELECT * FROM orderstatus;
SELECT * FROM productreview;
SELECT * FROM productimage;
SELECT * FROM coupon;
SELECT * FROM ordercoupon;
SELECT * FROM cart;
SELECT * FROM wishlist;


