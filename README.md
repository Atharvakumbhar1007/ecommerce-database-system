# E-Commerce Database System (MySQL)

A structured and normalized MySQL database project that models real-world e-commerce workflows such as product management, order processing, payments, and inventory control.

---

## Overview

This project implements a MySQL-based E-Commerce Database System focusing on relational database design, data integrity, and automation.

The database schema is designed to support common e-commerce operations including product and category management, user profiles, order processing, payments, cart and wishlist handling, coupons, reviews, and inventory control.

Advanced SQL features such as triggers, stored functions, and views are used to automate business logic and simplify reporting.

---

## Key Features

- Fully normalized relational database design (3NF)
- User, product, category, and order management
- Cart and wishlist functionality
- Coupon and discount handling
- Product reviews and ratings
- Automated stock validation and inventory updates
- Dynamic order total calculation using stored functions
- Reporting-ready views for analytics

---

## Database Components

### Core Tables
- Category
- Product
- UserProfile
- Address

### Order Management
- Orders
- OrderItem
- OrderStatus
- PaymentInformation

### User Interaction
- Cart
- Wishlist
- ProductReview
- ProductImage

### Discounts and Promotions
- Coupon
- OrderCoupon

Each table is created with appropriate primary keys, foreign keys, and constraints to ensure data consistency and integrity.

---

## Business Logic Implementation

### Stored Function
fn_order_total(orderId)  
Calculates the total amount of an order by aggregating item subtotals, discounts, and taxes.

### Triggers

Stock Validation Trigger  
Prevents placing an order when product stock is insufficient.

Stock Reduction Trigger  
Automatically reduces product quantity after an order is placed.

Stock Restoration Trigger  
Restores product quantity when an order item is deleted or cancelled.

Order Total Update Trigger  
Automatically recalculates the order total when order items are inserted or removed.

---

## Views (Reporting)

view_user_orders  
Displays user-wise order summaries.

view_order_details  
Shows detailed order information including product details.

view_product_category  
Displays product information along with category details.

These views simplify reporting and analytical queries.

---

## Technologies Used

- MySQL 8+
- SQL (DDL and DML)
- Foreign Key Constraints
- Triggers
- Stored Functions
- Views

---

## How to Run the Project

1. Install MySQL 8.0 or higher.
2. Open MySQL Workbench or MySQL Command Line Interface.
3. Execute the provided SQL script.
4. The database ecommerce_db will be created with all tables, triggers, functions, and views.

---

## Learning Outcomes

- Practical experience with real-world database modeling.
- Strong understanding of normalization and relational integrity.
- Hands-on use of triggers, stored functions, and views.
- Experience designing scalable database schemas.
- Improved SQL querying and structuring skills.

---

## Future Enhancements

- Add stored procedures for complete order processing.
- Implement indexing for performance optimization.
- Introduce role-based user access.
- Integrate with backend APIs such as Java, Spring Boot, or Node.js.
- Generate ER diagrams for better documentation.

---

## Project Structure

/schema        – Table creation scripts  
/triggers      – Trigger definitions  
/functions     – Stored functions  
/views         – Reporting views  
README.md      – Project documentation
