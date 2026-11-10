-- Лабораторна робота 3. Фізична модель company.
-- MySQL 8.0.16+ / InnoDB / utf8mb4.
-- Виконуйте один раз у новій порожній схемі; DROP не використовується.
CREATE DATABASE IF NOT EXISTS `company`
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `company`;

CREATE TABLE `department` (
  `department_id` INT NOT NULL AUTO_INCREMENT,
  `department_name` VARCHAR(30) NOT NULL,
  `city` VARCHAR(30) NOT NULL DEFAULT 'Lviv',
  `street` VARCHAR(40) NOT NULL,
  `building_no` INT NULL,
  PRIMARY KEY (`department_id`),
  CONSTRAINT `ck_department_1` CHECK (building_no IS NULL OR building_no > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `employee` (
  `employee_id` INT NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(30) NOT NULL,
  `first_name` VARCHAR(30) NOT NULL,
  `last_name` VARCHAR(30) NOT NULL,
  `position` VARCHAR(30) NOT NULL,
  `employment_date` DATE NOT NULL,
  `department_id` INT NULL,
  `manager_id` INT NULL,
  `rate` DECIMAL(12,2) NOT NULL,
  `bonus` DECIMAL(12,2) NULL,
  PRIMARY KEY (`employee_id`),
  CONSTRAINT `uq_employee_1` UNIQUE (`user_name`),
  INDEX `idx_employee_department_id` (`department_id`),
  CONSTRAINT `fk_employee_department_id` FOREIGN KEY (`department_id`)
    REFERENCES `department` (`department_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX `idx_employee_manager_id` (`manager_id`),
  CONSTRAINT `fk_employee_manager_id` FOREIGN KEY (`manager_id`)
    REFERENCES `employee` (`employee_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_employee_1` CHECK (rate >= 0),
  CONSTRAINT `ck_employee_2` CHECK (bonus IS NULL OR bonus >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `customer` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(30) NOT NULL,
  `last_name` VARCHAR(30) NOT NULL,
  `genger` CHAR(1) NOT NULL,
  `birth_date` DATE NOT NULL,
  `phone_number` VARCHAR(20) NOT NULL,
  `email` VARCHAR(254) NOT NULL,
  `discount` DECIMAL(5,2) NULL,
  PRIMARY KEY (`customer_id`),
  CONSTRAINT `ck_customer_1` CHECK (genger IN ('F', 'M')),
  CONSTRAINT `ck_customer_2` CHECK (discount IS NULL OR discount BETWEEN 0 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `product` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `product_name` VARCHAR(100) NOT NULL,
  `product_description` VARCHAR(500) NOT NULL,
  `category` VARCHAR(50) NOT NULL,
  `manufacture` VARCHAR(100) NOT NULL,
  `product_type` VARCHAR(50) NOT NULL,
  `amount` INT NOT NULL DEFAULT 0,
  `price` DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (`product_id`),
  CONSTRAINT `ck_product_1` CHECK (amount >= 0),
  CONSTRAINT `ck_product_2` CHECK (price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `orders` (
  `orders_id` INT NOT NULL AUTO_INCREMENT,
  `employee_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  `transaction_type` INT NOT NULL,
  `transaction_moment` DATETIME NOT NULL,
  `amount` INT NOT NULL,
  PRIMARY KEY (`orders_id`),
  INDEX `idx_orders_employee_id` (`employee_id`),
  CONSTRAINT `fk_orders_employee_id` FOREIGN KEY (`employee_id`)
    REFERENCES `employee` (`employee_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX `idx_orders_product_id` (`product_id`),
  CONSTRAINT `fk_orders_product_id` FOREIGN KEY (`product_id`)
    REFERENCES `product` (`product_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX `idx_orders_customer_id` (`customer_id`),
  CONSTRAINT `fk_orders_customer_id` FOREIGN KEY (`customer_id`)
    REFERENCES `customer` (`customer_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX `idx_orders_extra_1` (`transaction_moment`),
  CONSTRAINT `ck_orders_1` CHECK (amount > 0),
  CONSTRAINT `ck_orders_2` CHECK (transaction_type IN (1, 2, 3))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

