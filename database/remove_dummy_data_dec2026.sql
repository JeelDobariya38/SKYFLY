-- ====================================================================
-- SkyFly Airlines - REMOVE the December 2026 dummy data
-- Undoes database/dummy_data_dec2026.sql
--
-- Deletes:
--   * bookings (with their passengers and payments) dated 1-30 Dec 2026
--   * flights departing 1-30 Dec 2026 that have no bookings left
--   * customers with an @example.com e-mail that have no bookings left
-- Keeps (harmless reference data): the extra airlines, airports and routes.
-- Your own data is not touched: real bookings made through the app carry the
-- date you made them, so they are outside the 1-30 Dec 2026 range.
-- ====================================================================

USE `skyfly_db`;

DELETE FROM `passengers` WHERE `booking_id` IN
    (SELECT `id` FROM `bookings` WHERE `booking_date` >= '2026-12-01 00:00:00' AND `booking_date` < '2026-12-31 00:00:00');

DELETE FROM `payments` WHERE `booking_id` IN
    (SELECT `id` FROM `bookings` WHERE `booking_date` >= '2026-12-01 00:00:00' AND `booking_date` < '2026-12-31 00:00:00');

DELETE FROM `bookings`
    WHERE `booking_date` >= '2026-12-01 00:00:00' AND `booking_date` < '2026-12-31 00:00:00';

DELETE FROM `flights`
    WHERE `departure_time` >= '2026-12-01 00:00:00' AND `departure_time` < '2026-12-31 00:00:00'
      AND `id` NOT IN (SELECT `flight_id` FROM `bookings`);

DELETE FROM `users`
    WHERE `email` LIKE '%@example.com' AND `role` = 'CUSTOMER'
      AND `id` NOT IN (SELECT `user_id` FROM `bookings`);
