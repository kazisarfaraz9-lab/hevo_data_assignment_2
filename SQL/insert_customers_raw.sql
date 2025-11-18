INSERT INTO customers_raw (customer_id, email, phone, country_code, updated_at, created_at) VALUES
(101, 'John@example.com', '111-222-3333', 'US', '2025-07-01 10:15:00', '2025-01-01 08:00:00'),
(101, 'john.d@example.com', '(111)2223333', 'usa', '2025-07-03 14:25:00', '2025-01-01 08:00:00'),

(102, 'alice@example.com', NULL, 'UnitedStates', '2025-07-01 09:10:00', NULL),

(103, 'michael@abc.com', '9998887777', NULL, '2025-07-02 12:45:00', '2025-03-01 10:00:00'),

(104, 'bob@xyz.com', NULL, 'IND', '2025-07-05 15:00:00', '2025-03-10 09:30:00'),
(104, 'bob@xyz.com', NULL, 'India', '2025-07-06 18:00:00', '2025-03-10 09:30:00'),

(106, 'duplicate@email.com', '1234567890', 'SINGAPORE', '2025-07-01 08:00:00', '2025-04-01 11:45:00'),
(106, 'duplicate@email.com', '123-456-7890', 'SG', '2025-07-10 12:00:00', '2025-04-01 11:45:00'),

(108, NULL, NULL, NULL, NULL, NULL);