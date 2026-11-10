-- MIT 8103: Advanced Database Systems
-- Portfolio 3: Transactions and Concurrency
-- Case Study: CareBridge Hospital
-- Database: PostgreSQL 16.5
-- Session A


-- SECTION 1: Create a demonstration table

CREATE TABLE IF NOT EXISTS appointment_transaction_demo (
    demo_id SERIAL PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    doctor_name VARCHAR(100) NOT NULL,
    appointment_datetime TIMESTAMP NOT NULL,
    appointment_status VARCHAR(30) DEFAULT 'Scheduled'
);


-- SECTION 2: Insert a test appointment using a transaction

BEGIN;

INSERT INTO appointment_transaction_demo
(patient_name, doctor_name, appointment_datetime, appointment_status)
VALUES
('Test Patient 2', 'Dr James Okon', '2026-11-09 10:00:00', 'Scheduled');

COMMIT;


-- SECTION 3: Demonstrate ROLLBACK

BEGIN;

UPDATE appointment_transaction_demo
SET appointment_status = 'Cancelled'
WHERE demo_id = 1;

ROLLBACK;


-- SECTION 3A: Verify the rollback

SELECT demo_id, patient_name, appointment_status
FROM appointment_transaction_demo
WHERE demo_id = 1;


-- SECTION 4: Demonstrate READ COMMITTED isolation

BEGIN ISOLATION LEVEL READ COMMITTED;

-- First read
SELECT demo_id, appointment_status
FROM appointment_transaction_demo
WHERE demo_id = 1;

-- Run the Session B update to Confirmed and COMMIT.

-- Second read
SELECT demo_id, appointment_status
FROM appointment_transaction_demo
WHERE demo_id = 1;

SHOW transaction_isolation;

COMMIT;


-- SECTION 5: Demonstrate REPEATABLE READ isolation

BEGIN ISOLATION LEVEL REPEATABLE READ;

-- First read
SELECT demo_id, appointment_status
FROM appointment_transaction_demo
WHERE demo_id = 1;

-- Run the Session B update to Checked In and COMMIT.

-- Second read
SELECT demo_id, appointment_status
FROM appointment_transaction_demo
WHERE demo_id = 1;

SHOW transaction_isolation;

COMMIT;


-- SECTION 6: Concurrency control using row-level locking

BEGIN;

SELECT *
FROM appointment_transaction_demo
WHERE demo_id = 1
FOR UPDATE;

-- While this transaction remains open, run Session B
-- update to Under Review and COMMIT.

-- After Session B completes, release the lock.
COMMIT;


-- FINAL VERIFICATION

SELECT demo_id, patient_name, appointment_status
FROM appointment_transaction_demo
WHERE demo_id = 1;
