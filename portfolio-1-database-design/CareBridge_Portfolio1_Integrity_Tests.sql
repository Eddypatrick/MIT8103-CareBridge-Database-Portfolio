-- CareBridge Hospital Management System
-- Portfolio 1: Integrity and Constraint Tests | PostgreSQL 16
--
-- Run against a separate test database/copy created from the setup script.
-- Do not run destructive tests against your only working portfolio database.
-- The negative test statements are commented out intentionally. Uncomment
-- and execute ONE at a time to observe the expected database rejection.

-- 1. Inspect primary, unique, check and exclusion constraints.
SELECT conrelid::regclass AS table_name,
       conname AS constraint_name,
       contype AS constraint_type,
       pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint
WHERE connamespace = 'public'::regnamespace
ORDER BY table_name, constraint_name;

-- 2. Inspect integrity triggers.
SELECT trigger_name, event_object_table, action_timing, event_manipulation
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;

-- 3. Duplicate hospital registration number.
-- Expected: unique-constraint violation.
-- INSERT INTO patients
--     (patient_name, date_of_birth, gender, phone_number, hospital_registration_no)
-- VALUES
--     ('Duplicate Registration', '1990-01-01', 'Female',
--      '08039990000', 'CBH-2026-001');

-- 4. Patient ID that does not exist.
-- Expected: foreign-key violation.
-- INSERT INTO laborders (patient_id, lab_test_id) VALUES (9999, 1);

-- 5. Appointment end time earlier than start time.
-- Expected: check-constraint violation.
-- INSERT INTO appointments
--     (patient_id, doctor_id, appointment_datetime, appointment_end_datetime)
-- VALUES
--     (1, 1, '2026-11-12 10:00:00', '2026-11-12 09:00:00');

-- 6. Same patient booked into overlapping appointments.
-- Expected: no_overlapping_patient_appointments exclusion violation.
-- INSERT INTO appointments
--     (patient_id, doctor_id, appointment_datetime, appointment_end_datetime)
-- VALUES
--     (1, 2, '2026-11-07 10:30:00', '2026-11-07 11:30:00');

-- 7. Same doctor booked into overlapping appointments.
-- Expected: no_overlapping_doctor_appointments exclusion violation.
-- INSERT INTO appointments
--     (patient_id, doctor_id, appointment_datetime, appointment_end_datetime)
-- VALUES
--     (3, 1, '2026-11-07 10:30:00', '2026-11-07 11:30:00');

-- 8. Prescription inserted without a medication item.
-- Expected: deferred constraint-trigger error when COMMIT is attempted.
-- BEGIN;
-- INSERT INTO prescriptions (patient_id, doctor_id) VALUES (3, 1);
-- COMMIT;

-- 9. Attempt to delete a completed laboratory order.
-- Expected: trigger exception.
-- DELETE FROM laborders WHERE lab_order_id = 1;

-- 10. Review valid sample records after the tests.
SELECT * FROM patients ORDER BY patient_id;
SELECT * FROM appointments ORDER BY appointment_id;
SELECT * FROM prescriptions ORDER BY prescription_id;
SELECT * FROM prescriptionitems ORDER BY prescription_item_id;
SELECT * FROM laborders ORDER BY lab_order_id;
