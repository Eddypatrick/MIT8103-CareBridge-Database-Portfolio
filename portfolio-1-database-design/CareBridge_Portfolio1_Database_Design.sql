SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
CREATE TABLE doctors (
    doctor_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    department_id INTEGER NOT NULL,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);
INSERT INTO doctors (doctor_name,department_id)
VALUES
      ('Dr. James Okon',1),
	  ('Dr. Mary Ekanem',2),
	  ('Dr. David Essien',3);
SELECT * FROM doctors;
CREATE TABLE patients(
patient_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
patient_name VARCHAR(100)NOT NULL,
date_of_birth DATE NOT NULL,
gender VARCHAR(10) NOT NULL,
phone_number VARCHAR(20)UNIQUE
);
INSERT INTO patients (
    patient_name,
    date_of_birth,
    gender,
    phone_number
)
VALUES
    ('Ada Nwosu', '1992-04-15', 'Female', '08031234567'),
    ('Ibrahim Bello', '1985-09-20', 'Male', '08069876543'),
    ('Chinedu Okafor', '1998-01-10', 'Male', '08051234567');
SELECT*FROM patients;
CREATE TABLE appointments (
    appointment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    appointment_datetime TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',

    FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id),

    CONSTRAINT unique_doctor_appointment
        UNIQUE (doctor_id, appointment_datetime)
);
SELECT*FROM appointments;
CREATE TABLE prescriptionitems (
    prescription_item_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    prescription_id INTEGER NOT NULL,
    medication_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration VARCHAR(50) NOT NULL,

    FOREIGN KEY (prescription_id)
        REFERENCES prescriptions(prescription_id)
);
CREATE TABLE labtests (
    lab_test_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    test_name VARCHAR(100) NOT NULL UNIQUE,
    test_description VARCHAR(255)
);
CREATE TABLE laborders (
    lab_order_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    lab_test_id INTEGER NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    result TEXT,

    FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    FOREIGN KEY (lab_test_id)
        REFERENCES labtests(lab_test_id)
);
INSERT INTO labtests (test_name, test_description)
VALUES
    ('Full Blood Count', 'Measures different components of blood'),
    ('Malaria Test', 'Checks for malaria parasites'),
    ('Blood Glucose Test', 'Measures the level of glucose in the blood');
SELECT*FROM labtests;
INSERT INTO laborders (patient_id, lab_test_id)
VALUES
    (1, 2),
    (2, 1);
SELECT * FROM laborders;
INSERT INTO laborders (patient_id, lab_test_id)
VALUES (999, 2);
SELECT * FROM laborders;
INSERT INTO prescriptionitems
    (prescription_id, medication_name, dosage, frequency, duration)
VALUES
    (999, 'Paracetamol', '500 mg', 'Twice daily', '3 days');
	SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
CREATE TABLE prescriptions (
    prescription_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    prescription_date DATE NOT NULL DEFAULT CURRENT_DATE,

    FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
);
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
CREATE TABLE prescriptionitems (
    prescription_item_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    prescription_id INTEGER NOT NULL,
    medication_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    FOREIGN KEY (prescription_id)
        REFERENCES prescriptions(prescription_id)
);
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
INSERT INTO prescriptions (patient_id, doctor_id)
VALUES
    (1, 1),
    (2, 2);
SELECT * FROM prescriptions;
INSERT INTO prescriptionitems
    (prescription_id, medication_name, dosage, frequency, duration)
VALUES
    (1, 'Paracetamol', '500 mg', 'Twice daily', '3 days'),
    (2, 'Vitamin C', '500 mg', 'Once daily', '5 days');
SELECT*FROM prescriptionitems;
SELECT
    p.prescription_id,
    pt.patient_name,
    d.doctor_name,
    pi.medication_name,
    pi.dosage,
    pi.frequency,
    pi.duration
FROM prescriptions p
JOIN patients pt
    ON p.patient_id = pt.patient_id
JOIN doctors d
    ON p.doctor_id = d.doctor_id
JOIN prescriptionitems pi
    ON p.prescription_id = pi.prescription_id;
SELECT
    lo.lab_order_id,
    pt.patient_name,
    lt.test_name,
    lo.order_date,
    lo.status,
    lo.result
FROM laborders AS lo
INNER JOIN patients AS pt
    ON lo.patient_id = pt.patient_id
INNER JOIN labtests AS lt
    ON lo.lab_test_id = lt.lab_test_id;
ALTER TABLE patients
ADD COLUMN hospital_registration_no VARCHAR(20);
UPDATE patients
SET hospital_registration_no = CASE patient_id
    WHEN 1 THEN 'CBH-2026-001'
    WHEN 2 THEN 'CBH-2026-002'
    WHEN 3 THEN 'CBH-2026-003'
END
WHERE patient_id IN (1, 2, 3);
SELECT
    patient_id,
    patient_name,
    hospital_registration_no
FROM patients;
ALTER TABLE patients
ALTER COLUMN hospital_registration_no SET NOT NULL;

ALTER TABLE patients
ADD CONSTRAINT unique_hospital_registration
UNIQUE (hospital_registration_no);
INSERT INTO patients
    (patient_name, date_of_birth, gender, phone_number, hospital_registration_no)
VALUES
    ('Grace Mensah', '1995-06-12', 'Female', '08035556677', 'CBH-2026-001');
SELECT * FROM appointments;
ALTER TABLE appointments
ADD COLUMN appointment_end_datetime TIMESTAMP NOT NULL;

ALTER TABLE appointments
ADD CONSTRAINT valid_appointment_time
CHECK (appointment_end_datetime > appointment_datetime);
CREATE EXTENSION IF NOT EXISTS btree_gist;
ALTER TABLE appointments
ADD CONSTRAINT no_overlapping_patient_appointments
EXCLUDE USING GIST (
    patient_id WITH =,
    tsrange(
        appointment_datetime,
        appointment_end_datetime,
        '[)'
    ) WITH &&
);
INSERT INTO appointments
    (patient_id, doctor_id, appointment_datetime,
     appointment_end_datetime)
VALUES
    (1, 1, '2026-11-07 10:00:00',
     '2026-11-07 11:00:00');
INSERT INTO appointments
    (patient_id, doctor_id, appointment_datetime,
     appointment_end_datetime)
VALUES
    (1, 2, '2026-11-07 10:30:00',
     '2026-11-07 11:30:00');
INSERT INTO appointments
    (patient_id, doctor_id, appointment_datetime,
     appointment_end_datetime)
VALUES
    (2, 2, '2026-11-07 10:00:00',
     '2026-11-07 11:00:00');
SELECT
    appointment_id,
    patient_id,
    doctor_id,
    appointment_datetime,
    appointment_end_datetime,
    status
FROM appointments
ORDER BY appointment_id;
SELECT
    p.prescription_id,
    pt.patient_name,
    d.doctor_name,
    COUNT(pi.prescription_item_id) AS medication_count
FROM prescriptions p
JOIN patients pt
    ON p.patient_id = pt.patient_id
JOIN doctors d
    ON p.doctor_id = d.doctor_id
LEFT JOIN prescriptionitems pi
    ON p.prescription_id = pi.prescription_id
GROUP BY
    p.prescription_id,
    pt.patient_name,
    d.doctor_name
ORDER BY p.prescription_id;
CREATE OR REPLACE FUNCTION check_prescription_has_item()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    checked_prescription_id INTEGER;
BEGIN
    IF TG_TABLE_NAME = 'prescriptions' THEN
        checked_prescription_id := NEW.prescription_id;

        IF EXISTS (
            SELECT 1
            FROM prescriptions
            WHERE prescription_id = checked_prescription_id
        )
        AND NOT EXISTS (
            SELECT 1
            FROM prescriptionitems
            WHERE prescription_id = checked_prescription_id
        ) THEN
            RAISE EXCEPTION
                'Prescription % must have at least one medication item',
                checked_prescription_id;
        END IF;

    ELSE
        IF TG_OP = 'DELETE' THEN
            checked_prescription_id := OLD.prescription_id;
        ELSE
            checked_prescription_id := NEW.prescription_id;
        END IF;

        IF EXISTS (
            SELECT 1
            FROM prescriptions
            WHERE prescription_id = checked_prescription_id
        )
        AND NOT EXISTS (
            SELECT 1
            FROM prescriptionitems
            WHERE prescription_id = checked_prescription_id
        ) THEN
            RAISE EXCEPTION
                'Prescription % must have at least one medication item',
                checked_prescription_id;
        END IF;

        IF TG_OP = 'UPDATE'
           AND OLD.prescription_id <> NEW.prescription_id THEN

            IF EXISTS (
                SELECT 1
                FROM prescriptions
                WHERE prescription_id = OLD.prescription_id
            )
            AND NOT EXISTS (
                SELECT 1
                FROM prescriptionitems
                WHERE prescription_id = OLD.prescription_id
            ) THEN
                RAISE EXCEPTION
                    'Prescription % must have at least one medication item',
                    OLD.prescription_id;
            END IF;
        END IF;
    END IF;

    RETURN NULL;
END;
$$;
CREATE CONSTRAINT TRIGGER prescription_must_have_item
AFTER INSERT ON prescriptions
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_prescription_has_item();
CREATE CONSTRAINT TRIGGER prescription_item_integrity
AFTER DELETE OR UPDATE ON prescriptionitems
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_prescription_has_item();
BEGIN;

INSERT INTO prescriptions
    (patient_id, doctor_id)
VALUES
    (3, 1);

COMMIT;
SELECT *
FROM prescriptions
ORDER BY prescription_id;
UPDATE laborders
SET
    status = 'Completed',
    result = 'Malaria parasites not detected'
WHERE lab_order_id = 1;
CREATE OR REPLACE FUNCTION prevent_completed_lab_order_deletion()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.status = 'Completed' THEN
        RAISE EXCEPTION
            'Completed laboratory orders cannot be deleted';
    END IF;

    RETURN OLD;
END;
$$;
CREATE TRIGGER prevent_completed_lab_order_delete
BEFORE DELETE ON laborders
FOR EACH ROW
EXECUTE FUNCTION prevent_completed_lab_order_deletion();
DELETE FROM laborders
WHERE lab_order_id = 1;
DELETE FROM laborders
WHERE lab_order_id = 2;
SELECT *
FROM laborders
ORDER BY lab_order_id;
SELECT
    doctor_id,
    appointment_datetime,
    appointment_end_datetime
FROM appointments
ORDER BY doctor_id, appointment_datetime;
ALTER TABLE appointments
ADD CONSTRAINT no_overlapping_doctor_appointments
EXCLUDE USING GIST (
    doctor_id WITH =,
    tsrange(
        appointment_datetime,
        appointment_end_datetime,
        '[)'
    ) WITH &&
);
INSERT INTO appointments
    (patient_id, doctor_id, appointment_datetime,
     appointment_end_datetime)
VALUES
    (3, 1, '2026-11-07 10:30:00',
     '2026-11-07 11:30:00');
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_type = 'BASE TABLE'
ORDER BY table_name;
SELECT
    conrelid::regclass AS table_name,
    conname AS constraint_name,
    contype AS constraint_type
FROM pg_constraint
WHERE connamespace = 'public'::regnamespace
ORDER BY table_name, constraint_name;
SELECT
    trigger_name,
    event_object_table,
    action_timing,
    event_manipulation
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;