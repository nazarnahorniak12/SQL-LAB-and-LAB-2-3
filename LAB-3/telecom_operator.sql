-- Лабораторна робота 3. Фізична модель telecom_operator.
-- MySQL 8.0.16+ / InnoDB / utf8mb4.
-- Виконуйте один раз у новій порожній схемі; DROP не використовується.
CREATE DATABASE IF NOT EXISTS `telecom_operator`
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `telecom_operator`;

CREATE TABLE `subscriber` (
  `subscriber_id` INT NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(120) NOT NULL,
  `phone_number` VARCHAR(20) NOT NULL,
  `email` VARCHAR(254) NULL,
  `registered_on` DATE NOT NULL,
  PRIMARY KEY (`subscriber_id`),
  CONSTRAINT `uq_subscriber_1` UNIQUE (`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tariff` (
  `tariff_id` INT NOT NULL AUTO_INCREMENT,
  `tariff_name` VARCHAR(80) NOT NULL,
  `monthly_fee` DECIMAL(12,2) NOT NULL,
  `speed_mbps` INT NOT NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`tariff_id`),
  CONSTRAINT `uq_tariff_1` UNIQUE (`tariff_name`),
  CONSTRAINT `ck_tariff_1` CHECK (monthly_fee >= 0),
  CONSTRAINT `ck_tariff_2` CHECK (speed_mbps > 0),
  CONSTRAINT `ck_tariff_3` CHECK (is_active IN (0, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `contract` (
  `contract_id` INT NOT NULL AUTO_INCREMENT,
  `subscriber_id` INT NOT NULL,
  `tariff_id` INT NOT NULL,
  `contract_number` VARCHAR(30) NOT NULL,
  `service_address` VARCHAR(200) NOT NULL,
  `starts_on` DATE NOT NULL,
  `ends_on` DATE NULL,
  `status` VARCHAR(15) NOT NULL DEFAULT 'active',
  PRIMARY KEY (`contract_id`),
  CONSTRAINT `uq_contract_1` UNIQUE (`contract_number`),
  INDEX `idx_contract_subscriber_id` (`subscriber_id`),
  CONSTRAINT `fk_contract_subscriber_id` FOREIGN KEY (`subscriber_id`)
    REFERENCES `subscriber` (`subscriber_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX `idx_contract_tariff_id` (`tariff_id`),
  CONSTRAINT `fk_contract_tariff_id` FOREIGN KEY (`tariff_id`)
    REFERENCES `tariff` (`tariff_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_contract_1` CHECK (ends_on IS NULL OR ends_on >= starts_on),
  CONSTRAINT `ck_contract_2` CHECK (status IN ('active','suspended','closed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `service` (
  `service_id` INT NOT NULL AUTO_INCREMENT,
  `service_name` VARCHAR(80) NOT NULL,
  `monthly_fee` DECIMAL(12,2) NOT NULL,
  `description` VARCHAR(300) NOT NULL,
  PRIMARY KEY (`service_id`),
  CONSTRAINT `uq_service_1` UNIQUE (`service_name`),
  CONSTRAINT `ck_service_1` CHECK (monthly_fee >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `contract_service` (
  `contract_service_id` INT NOT NULL AUTO_INCREMENT,
  `contract_id` INT NOT NULL,
  `service_id` INT NOT NULL,
  `activated_on` DATE NOT NULL,
  `deactivated_on` DATE NULL,
  PRIMARY KEY (`contract_service_id`),
  CONSTRAINT `uq_contract_service_1` UNIQUE (`contract_id`, `service_id`, `activated_on`),
  INDEX `idx_contract_service_contract_id` (`contract_id`),
  CONSTRAINT `fk_contract_service_contract_id` FOREIGN KEY (`contract_id`)
    REFERENCES `contract` (`contract_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX `idx_contract_service_service_id` (`service_id`),
  CONSTRAINT `fk_contract_service_service_id` FOREIGN KEY (`service_id`)
    REFERENCES `service` (`service_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_contract_service_1` CHECK (deactivated_on IS NULL OR deactivated_on >= activated_on)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `payment` (
  `payment_id` INT NOT NULL AUTO_INCREMENT,
  `contract_id` INT NOT NULL,
  `paid_at` DATETIME NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `payment_method` VARCHAR(15) NOT NULL,
  `reference_code` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`payment_id`),
  CONSTRAINT `uq_payment_1` UNIQUE (`reference_code`),
  INDEX `idx_payment_contract_id` (`contract_id`),
  CONSTRAINT `fk_payment_contract_id` FOREIGN KEY (`contract_id`)
    REFERENCES `contract` (`contract_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX `idx_payment_extra_1` (`paid_at`),
  CONSTRAINT `ck_payment_1` CHECK (amount > 0),
  CONSTRAINT `ck_payment_2` CHECK (payment_method IN ('cash','card','bank_transfer'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `support_ticket` (
  `ticket_id` INT NOT NULL AUTO_INCREMENT,
  `contract_id` INT NOT NULL,
  `opened_at` DATETIME NOT NULL,
  `subject` VARCHAR(150) NOT NULL,
  `description` VARCHAR(1000) NOT NULL,
  `status` VARCHAR(15) NOT NULL DEFAULT 'open',
  `closed_at` DATETIME NULL,
  PRIMARY KEY (`ticket_id`),
  INDEX `idx_support_ticket_contract_id` (`contract_id`),
  CONSTRAINT `fk_support_ticket_contract_id` FOREIGN KEY (`contract_id`)
    REFERENCES `contract` (`contract_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_support_ticket_1` CHECK (status IN ('open','in_progress','closed')),
  CONSTRAINT `ck_support_ticket_2` CHECK (closed_at IS NULL OR closed_at >= opened_at),
  CONSTRAINT `ck_support_ticket_3` CHECK ((status = 'closed' AND closed_at IS NOT NULL) OR (status <> 'closed' AND closed_at IS NULL))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

