-- MIT 8103: Advanced Database Systems
-- Portfolio 3: Transactions and Concurrency
-- Case Study: CareBridge Hospital
-- Database: PostgreSQL 16.5
-- Session B: Concurrent Transactions


-- SECTION 4: READ COMMITTED
-- Update appointment status to Confirmed

BEGIN;

UPDATE appointment_transaction_demo
SET appointment_status = 'Confirmed'
WHERE demo_id = 1;

COMMIT;


-- SECTION 5: REPEATABLE READ
-- Update appointment status to Completed

BEGIN;

UPDATE appointment_transaction_demo
SET appointment_status = 'Completed'
WHERE demo_id = 1;

COMMIT;

-- Update appointment status to Checked In

BEGIN;

UPDATE appointment_transaction_demo
SET appointment_status = 'Checked In'
WHERE demo_id = 1;

COMMIT;


-- SECTION 6: ROW-LEVEL LOCKING
-- Attempt to update an appointment while Session A holds its lock

BEGIN;

UPDATE appointment_transaction_demo
SET appointment_status = 'Under Review'
WHERE demo_id = 1;

COMMIT;


-- FINAL VERIFICATION

SELECT demo_id, patient_name, appointment_status
FROM appointment_transaction_demo
WHERE demo_id = 1;
