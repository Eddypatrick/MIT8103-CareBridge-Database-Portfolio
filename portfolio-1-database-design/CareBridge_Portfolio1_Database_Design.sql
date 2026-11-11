-- CareBridge Hospital Management System
-- Portfolio 1: Database Design and Modelling | PostgreSQL 16
--
-- Creates the eight-table schema, integrity rules and valid sample data.
-- IMPORTANT: Run only in a NEW, EMPTY database. Do not run against the
-- existing CareBridge database, because its objects already exist.

BEGIN;

CREATE EXTENSION IF NOT EXISTS btree_gist;

-- Reference tables
CREATE TABLE departments (
    department_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE doctors (
    doctor_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    department_id INTEGER NOT NULL REFERENCES departments(department_id)
);

CREATE TABLE patients (
    patient_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    phone_number VARCHAR(20) UNIQUE,
    hospital_registration_no VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE labtests (
    lab_test_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    test_name VARCHAR(100) NOT NULL UNIQUE,
    test_description VARCHAR(255)
);

-- Operational tables
CREATE TABLE appointments (
    appointment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(patient_id),
    doctor_id INTEGER NOT NULL REFERENCES doctors(doctor_id),
    appointment_datetime TIMESTAMPTZ NOT NULL,
    appointment_end_datetime TIMESTAMPTZ NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    CONSTRAINT unique_doctor_appointment
        UNIQUE (doctor_id, appointment_datetime),
    CONSTRAINT valid_appointment_time
        CHECK (appointment_end_datetime > appointment_datetime),
    CONSTRAINT no_overlapping_patient_appointments
        EXCLUDE USING GIST (
            patient_id WITH =,
            tstzrange(appointment_datetime, appointment_end_datetime, '[)') WITH &&
        ),
    CONSTRAINT no_overlapping_doctor_appointments
        EXCLUDE USING GIST (
            doctor_id WITH =,
            tstzrange(appointment_datetime, appointment_end_datetime, '[)') WITH &&
        )
);

CREATE TABLE prescriptions (
    prescription_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(patient_id),
    doctor_id INTEGER NOT NULL REFERENCES doctors(doctor_id),
    prescription_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE prescriptionitems (
    prescription_item_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    prescription_id INTEGER NOT NULL REFERENCES prescriptions(prescription_id),
    medication_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration VARCHAR(50) NOT NULL
);

CREATE TABLE laborders (
    lab_order_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(patient_id),
    lab_test_id INTEGER NOT NULL REFERENCES labtests(lab_test_id),
    order_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    result TEXT
);

-- Deferred integrity rule: a prescription must have at least one item
-- when its transaction commits.
CREATE OR REPLACE FUNCTION check_prescription_has_item()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    checked_prescription_id INTEGER;
BEGIN
    IF TG_TABLE_NAME = 'prescriptions' THEN
        checked_prescription_id := NEW.prescription_id;
    ELSIF TG_OP = 'DELETE' THEN
        checked_prescription_id := OLD.prescription_id;
    ELSE
        checked_prescription_id := NEW.prescription_id;
    END IF;

    IF EXISTS (
        SELECT 1 FROM prescriptions
        WHERE prescription_id = checked_prescription_id
    )
    AND NOT EXISTS (
        SELECT 1 FROM prescriptionitems
        WHERE prescription_id = checked_prescription_id
    ) THEN
        RAISE EXCEPTION
            'Prescription % must have at least one medication item',
            checked_prescription_id;
    END IF;

    IF TG_TABLE_NAME = 'prescriptionitems'
       AND TG_OP = 'UPDATE'
       AND OLD.prescription_id <> NEW.prescription_id
       AND EXISTS (
           SELECT 1 FROM prescriptions
           WHERE prescription_id = OLD.prescription_id
       )
       AND NOT EXISTS (
           SELECT 1 FROM prescriptionitems
           WHERE prescription_id = OLD.prescription_id
       ) THEN
        RAISE EXCEPTION
            'Prescription % must have at least one medication item',
            OLD.prescription_id;
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

-- Protect completed laboratory orders from deletion.
CREATE OR REPLACE FUNCTION prevent_completed_lab_order_deletion()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.status = 'Completed' THEN
        RAISE EXCEPTION 'Completed laboratory orders cannot be deleted';
    END IF;
    RETURN OLD;
END;
$$;

CREATE TRIGGER prevent_completed_lab_order_delete
BEFORE DELETE ON laborders
FOR EACH ROW
EXECUTE FUNCTION prevent_completed_lab_order_deletion();

-- Valid demonstration records. Identity values start at 1 in this fresh database.
INSERT INTO departments (department_name)
VALUES ('General Medicine'), ('Paediatrics'), ('Laboratory');

INSERT INTO doctors (doctor_name, department_id)
VALUES ('Dr. James Okon', 1), ('Dr. Mary Ekanem', 2), ('Dr. David Essien', 3);

INSERT INTO patients
    (patient_name, date_of_birth, gender, phone_number, hospital_registration_no)
VALUES
    ('Ada Nwosu', '1992-04-15', 'Female', '08031234567', 'CBH-2026-001'),
    ('Ibrahim Bello', '1985-09-20', 'Male', '08069876543', 'CBH-2026-002'),
    ('Chinedu Okafor', '1998-01-10', 'Male', '08051234567', 'CBH-2026-003');

INSERT INTO labtests (test_name, test_description)
VALUES
    ('Full Blood Count', 'Measures different components of blood'),
    ('Malaria Test', 'Checks for malaria parasites'),
    ('Blood Glucose Test', 'Measures the level of glucose in the blood');

INSERT INTO appointments
    (patient_id, doctor_id, appointment_datetime, appointment_end_datetime, status)
VALUES
    (1, 1, TIMESTAMPTZ '2026-11-07 10:00:00 Africa/Lagos', TIMESTAMPTZ '2026-11-07 11:00:00 Africa/Lagos', 'Scheduled'),
    (2, 2, TIMESTAMPTZ '2026-11-07 11:00:00 Africa/Lagos', TIMESTAMPTZ '2026-11-07 11:30:00 Africa/Lagos', 'Scheduled');

-- Deferred trigger validates these prescriptions at COMMIT, after their items exist.
INSERT INTO prescriptions (patient_id, doctor_id)
VALUES (1, 1), (2, 2);

INSERT INTO prescriptionitems
    (prescription_id, medication_name, dosage, frequency, duration)
VALUES
    (1, 'Paracetamol', '500 mg', 'Twice daily', '3 days'),
    (2, 'Vitamin C', '500 mg', 'Once daily', '5 days');

INSERT INTO laborders (patient_id, lab_test_id, status, result)
VALUES
    (1, 2, 'Completed', 'Malaria parasites not detected'),
    (2, 1, 'Pending', NULL);

COMMIT;

-- Verification: list the eight tables.
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Verification: prescription JOIN.
SELECT p.prescription_id, pt.patient_name, d.doctor_name,
       pi.medication_name, pi.dosage, pi.frequency, pi.duration
FROM prescriptions AS p
JOIN patients AS pt ON p.patient_id = pt.patient_id
JOIN doctors AS d ON p.doctor_id = d.doctor_id
JOIN prescriptionitems AS pi ON p.prescription_id = pi.prescription_id
ORDER BY p.prescription_id;

-- Verification: laboratory JOIN.
SELECT lo.lab_order_id, pt.patient_name, lt.test_name,
       lo.order_date, lo.status, lo.result
FROM laborders AS lo
JOIN patients AS pt ON lo.patient_id = pt.patient_id
JOIN labtests AS lt ON lo.lab_test_id = lt.lab_test_id
ORDER BY lo.lab_order_id;
