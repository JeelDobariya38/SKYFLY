-- ====================================================================
-- SkyFly Airlines – Airline Reservation & Ticket Booking System
-- Database Initialization & Schema Script
-- Subject: Advanced Java Technologies (AJT)
-- Database: MySQL 8+ / MariaDB
-- Database Name: skyfly_db
-- ====================================================================

CREATE DATABASE IF NOT EXISTS `skyfly_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `skyfly_db`;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `passengers`;
DROP TABLE IF EXISTS `bookings`;
DROP TABLE IF EXISTS `flights`;
DROP TABLE IF EXISTS `routes`;
DROP TABLE IF EXISTS `airports`;
DROP TABLE IF EXISTS `airlines`;
DROP TABLE IF EXISTS `users`;

SET FOREIGN_KEY_CHECKS = 1;

-- --------------------------------------------------------------------
-- 1. Table: users
-- --------------------------------------------------------------------
CREATE TABLE `users` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(120) NOT NULL UNIQUE,
    `phone_number` VARCHAR(20) DEFAULT NULL,
    `password` VARCHAR(255) NOT NULL,
    `role` VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER',
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_users_email` (`email`),
    INDEX `idx_users_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 2. Table: airlines
-- --------------------------------------------------------------------
CREATE TABLE `airlines` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `airline_name` VARCHAR(100) NOT NULL,
    `airline_code` VARCHAR(10) NOT NULL UNIQUE,
    `description` VARCHAR(500) DEFAULT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_airlines_code` (`airline_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 3. Table: airports
-- --------------------------------------------------------------------
CREATE TABLE `airports` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `airport_name` VARCHAR(120) NOT NULL,
    `airport_code` VARCHAR(10) NOT NULL UNIQUE,
    `city` VARCHAR(80) NOT NULL,
    `country` VARCHAR(80) NOT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_airports_code` (`airport_code`),
    INDEX `idx_airports_city` (`city`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 4. Table: routes
-- --------------------------------------------------------------------
CREATE TABLE `routes` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `source_airport_id` BIGINT NOT NULL,
    `destination_airport_id` BIGINT NOT NULL,
    `distance_km` INT DEFAULT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uk_route_source_dest` (`source_airport_id`, `destination_airport_id`),
    CONSTRAINT `fk_route_source` FOREIGN KEY (`source_airport_id`) REFERENCES `airports` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_route_dest` FOREIGN KEY (`destination_airport_id`) REFERENCES `airports` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 5. Table: flights
-- --------------------------------------------------------------------
CREATE TABLE `flights` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `flight_number` VARCHAR(20) NOT NULL,
    `airline_id` BIGINT NOT NULL,
    `route_id` BIGINT NOT NULL,
    `departure_time` DATETIME NOT NULL,
    `arrival_time` DATETIME NOT NULL,
    `total_seats` INT NOT NULL,
    `available_seats` INT NOT NULL,
    `ticket_price` DECIMAL(10,2) NOT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_flights_number` (`flight_number`),
    INDEX `idx_flights_dep_time` (`departure_time`),
    INDEX `idx_flights_status` (`status`),
    CONSTRAINT `fk_flight_airline` FOREIGN KEY (`airline_id`) REFERENCES `airlines` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_flight_route` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 6. Table: bookings
-- --------------------------------------------------------------------
CREATE TABLE `bookings` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `booking_reference` VARCHAR(20) NOT NULL UNIQUE,
    `user_id` BIGINT NOT NULL,
    `flight_id` BIGINT NOT NULL,
    `booking_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `total_amount` DECIMAL(10,2) NOT NULL,
    `passenger_count` INT NOT NULL DEFAULT 1,
    `booking_status` VARCHAR(20) NOT NULL DEFAULT 'CONFIRMED',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_bookings_ref` (`booking_reference`),
    INDEX `idx_bookings_user` (`user_id`),
    INDEX `idx_bookings_status` (`booking_status`),
    CONSTRAINT `fk_booking_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_booking_flight` FOREIGN KEY (`flight_id`) REFERENCES `flights` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 7. Table: passengers
-- --------------------------------------------------------------------
CREATE TABLE `passengers` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `booking_id` BIGINT NOT NULL,
    `full_name` VARCHAR(100) NOT NULL,
    `age` INT NOT NULL,
    `gender` VARCHAR(10) NOT NULL,
    `seat_number` VARCHAR(10) DEFAULT NULL,
    `passport_or_id` VARCHAR(50) DEFAULT NULL,
    CONSTRAINT `fk_passenger_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 8. Table: payments
-- --------------------------------------------------------------------
CREATE TABLE `payments` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `booking_id` BIGINT NOT NULL UNIQUE,
    `transaction_reference` VARCHAR(50) NOT NULL UNIQUE,
    `amount` DECIMAL(10,2) NOT NULL,
    `payment_method` VARCHAR(30) NOT NULL DEFAULT 'SIMULATED',
    `payment_status` VARCHAR(20) NOT NULL DEFAULT 'PAID',
    `payment_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_payments_txn` (`transaction_reference`),
    CONSTRAINT `fk_payment_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================================
-- SEED DATA FOR ACADEMIC DEMONSTRATION
-- ====================================================================

-- 1. Insert Initial Users
-- Passwords hashed using standard Spring Security BCrypt (Admin@123, Customer@123)
-- Admin: admin@skyfly.com / Admin@123
-- Customer: customer@skyfly.com / Customer@123
INSERT INTO `users` (`id`, `full_name`, `email`, `phone_number`, `password`, `role`, `status`) VALUES
(1, 'System Administrator', 'admin@skyfly.com', '+91 9876543210', '$2a$10$wJkXm.f8Oq.K1wQeM4/ZkeL.Dfq1lR2N.n90GjV8n7V7gV1B/dCgy', 'ADMIN', 'ACTIVE'),
(2, 'Demo Customer', 'customer@skyfly.com', '+91 9876501234', '$2a$10$4O64bL1z2.4o8W3e7gK1ee9gD.vK9W0vQ2m1n2k3l4o5p6q7r8s9t', 'CUSTOMER', 'ACTIVE');

-- 2. Insert Airlines
INSERT INTO `airlines` (`id`, `airline_name`, `airline_code`, `description`, `status`) VALUES
(1, 'Air India', 'AI', 'Flag carrier of India operating modern Boeing and Airbus fleet.', 'ACTIVE'),
(2, 'IndiGo', '6E', 'India largest low-cost airline known for punctual operations.', 'ACTIVE'),
(3, 'Emirates', 'EK', 'Premier international carrier connecting Dubai to the world.', 'ACTIVE'),
(4, 'British Airways', 'BA', 'Flag carrier of the United Kingdom serving global destinations.', 'ACTIVE'),
(5, 'Singapore Airlines', 'SQ', 'World renowned airline offering premium Asian hospitality.', 'ACTIVE');

-- 3. Insert Airports
INSERT INTO `airports` (`id`, `airport_name`, `airport_code`, `city`, `country`) VALUES
(1, 'Indira Gandhi International Airport', 'DEL', 'New Delhi', 'India'),
(2, 'Chhatrapati Shivaji Maharaj International Airport', 'BOM', 'Mumbai', 'India'),
(3, 'Kempegowda International Airport', 'BLR', 'Bengaluru', 'India'),
(4, 'Dubai International Airport', 'DXB', 'Dubai', 'United Arab Emirates'),
(5, 'Heathrow Airport', 'LHR', 'London', 'United Kingdom'),
(6, 'John F. Kennedy International Airport', 'JFK', 'New York', 'United States'),
(7, 'Singapore Changi Airport', 'SIN', 'Singapore', 'Singapore'),
(8, 'Dabolim Airport', 'GOI', 'Goa', 'India');

-- 4. Insert Routes
INSERT INTO `routes` (`id`, `source_airport_id`, `destination_airport_id`, `distance_km`, `status`) VALUES
(1, 1, 2, 1148, 'ACTIVE'), -- DEL -> BOM
(2, 2, 1, 1148, 'ACTIVE'), -- BOM -> DEL
(3, 1, 3, 1740, 'ACTIVE'), -- DEL -> BLR
(4, 3, 1, 1740, 'ACTIVE'), -- BLR -> DEL
(5, 2, 4, 1928, 'ACTIVE'), -- BOM -> DXB
(6, 4, 2, 1928, 'ACTIVE'), -- DXB -> BOM
(7, 1, 5, 6710, 'ACTIVE'), -- DEL -> LHR
(8, 5, 1, 6710, 'ACTIVE'), -- LHR -> DEL
(9, 2, 8, 435, 'ACTIVE'),  -- BOM -> GOI
(10, 8, 2, 435, 'ACTIVE'), -- GOI -> BOM
(11, 1, 7, 4150, 'ACTIVE'), -- DEL -> SIN
(12, 1, 6, 11760, 'ACTIVE');-- DEL -> JFK

-- 5. Insert Flights
INSERT INTO `flights` (`id`, `flight_number`, `airline_id`, `route_id`, `departure_time`, `arrival_time`, `total_seats`, `available_seats`, `ticket_price`, `status`) VALUES
(1, 'AI-101', 1, 1, DATE_ADD(NOW(), INTERVAL 4 HOUR), DATE_ADD(NOW(), INTERVAL 6 HOUR), 180, 178, 4500.00, 'SCHEDULED'),
(2, '6E-205', 2, 1, DATE_ADD(NOW(), INTERVAL 8 HOUR), DATE_ADD(NOW(), INTERVAL 10 HOUR), 180, 180, 3800.00, 'SCHEDULED'),
(3, 'AI-102', 1, 2, DATE_ADD(NOW(), INTERVAL 6 HOUR), DATE_ADD(NOW(), INTERVAL 8 HOUR), 180, 180, 4600.00, 'SCHEDULED'),
(4, '6E-310', 2, 3, DATE_ADD(NOW(), INTERVAL 10 HOUR), DATE_ADD(NOW(), INTERVAL 13 HOUR), 186, 186, 5200.00, 'SCHEDULED'),
(5, 'AI-404', 1, 9, DATE_ADD(NOW(), INTERVAL 5 HOUR), DATE_ADD(NOW(), INTERVAL 6 HOUR), 150, 150, 2900.00, 'SCHEDULED'),
(6, 'AI-103', 1, 1, DATE_ADD(CURDATE(), INTERVAL '1 07:00' DAY_MINUTE), DATE_ADD(CURDATE(), INTERVAL '1 09:15' DAY_MINUTE), 180, 180, 4400.00, 'SCHEDULED'),
(7, '6E-206', 2, 1, DATE_ADD(CURDATE(), INTERVAL '1 14:00' DAY_MINUTE), DATE_ADD(CURDATE(), INTERVAL '1 16:20' DAY_MINUTE), 180, 180, 3950.00, 'SCHEDULED'),
(8, 'EK-501', 3, 5, DATE_ADD(NOW(), INTERVAL 12 HOUR), DATE_ADD(NOW(), INTERVAL 15 HOUR), 250, 250, 16500.00, 'SCHEDULED'),
(9, 'BA-142', 4, 7, DATE_ADD(CURDATE(), INTERVAL '1 03:00' DAY_MINUTE), DATE_ADD(CURDATE(), INTERVAL '1 12:45' DAY_MINUTE), 280, 280, 48000.00, 'SCHEDULED'),
(10, 'SQ-401', 5, 11, DATE_ADD(CURDATE(), INTERVAL '2 22:00' DAY_MINUTE), DATE_ADD(CURDATE(), INTERVAL '3 06:30' DAY_MINUTE), 260, 260, 24000.00, 'SCHEDULED');

-- 6. Insert Sample Booking
INSERT INTO `bookings` (`id`, `booking_reference`, `user_id`, `flight_id`, `booking_date`, `total_amount`, `passenger_count`, `booking_status`) VALUES
(1, 'SF-DEMO01', 2, 1, DATE_SUB(NOW(), INTERVAL 1 DAY), 9000.00, 2, 'CONFIRMED');

-- 7. Insert Sample Passengers
INSERT INTO `passengers` (`id`, `booking_id`, `full_name`, `age`, `gender`, `seat_number`, `passport_or_id`) VALUES
(1, 1, 'Demo Customer', 28, 'MALE', '12A', 'ID-982341'),
(2, 1, 'Sarah Customer', 26, 'FEMALE', '12B', 'ID-982342');

-- 8. Insert Sample Payment
INSERT INTO `payments` (`id`, `booking_id`, `transaction_reference`, `amount`, `payment_method`, `payment_status`, `payment_date`) VALUES
(1, 1, 'TXN-DEMO001', 9000.00, 'SIMULATED', 'PAID', DATE_SUB(NOW(), INTERVAL 1 DAY));
