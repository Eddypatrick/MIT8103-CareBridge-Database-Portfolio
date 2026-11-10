EXPLAIN ANALYZE
SELECT
    a.appointment_id,
    pt.patient_name,
    d.doctor_name,
    a.appointment_datetime,
    a.appointment_end_datetime,
    a.status
FROM appointments AS a
INNER JOIN patients AS pt
    ON a.patient_id = pt.patient_id
INNER JOIN doctors AS d
    ON a.doctor_id = d.doctor_id
WHERE a.appointment_datetime >= TIMESTAMP '2026-11-07 00:00:00'
  AND a.appointment_datetime < TIMESTAMP '2026-11-08 00:00:00'
ORDER BY a.appointment_datetime;
CREATE INDEX idx_appointments_datetime
ON appointments (appointment_datetime);

SELECT
    indexname,
    tablename,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename = 'appointments';

CREATE TABLE appointment_performance_test (
    test_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    appointment_datetime TIMESTAMP NOT NULL
);
INSERT INTO appointment_performance_test (appointment_datetime)
SELECT
    TIMESTAMP '2026-01-01 08:00:00'
    + (n * INTERVAL '5 minutes')
FROM generate_series(1, 100000) AS n;
-- Verify the number of simulated records without displaying all 100,000 rows.
SELECT COUNT(*) AS total_test_appointments
FROM appointment_performance_test;
EXPLAIN ANALYZE
SELECT *
FROM appointment_performance_test
WHERE appointment_datetime >= TIMESTAMP '2026-01-01 10:00:00'
  AND appointment_datetime < TIMESTAMP '2026-01-01 11:00:00';
CREATE INDEX idx_test_appointment_datetime
ON appointment_performance_test (appointment_datetime);
EXPLAIN ANALYZE
SELECT *
FROM appointment_performance_test
WHERE appointment_datetime >= TIMESTAMP '2026-01-01 10:00:00'
  AND appointment_datetime < TIMESTAMP '2026-01-01 11:00:00';
SET enable_indexscan = OFF;
SET enable_bitmapscan = OFF;
SET enable_indexscan = ON;
SET enable_bitmapscan = ON;
SELECT indexname, tablename, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename = 'appointments';
SET enable_indexscan = OFF;
SET enable_bitmapscan = OFF;
EXPLAIN ANALYZE
SELECT *
FROM appointment_performance_test
WHERE appointment_datetime >= TIMESTAMP '2026-01-01 10:00:00'
  AND appointment_datetime < TIMESTAMP '2026-01-01 11:00:00';
SET enable_indexscan = ON;
SET enable_bitmapscan = ON;
