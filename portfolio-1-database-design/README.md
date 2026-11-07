# Portfolio 1: Database Design and Modelling

## 1. Database Tables and Constraints

**SQL Code**

```sql
SELECT
    table_name,
    constraint_name,
    constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'public'
  AND table_name IN (
      'departments',
      'doctors',
      'patients',
      'appointments',
      'prescriptions',
      'prescriptionitems',
      'labtests',
      'laborders'
  )
  AND constraint_name !~ '^[0-9]+_[0-9]+_[0-9]+_not_null$'
ORDER BY table_name, constraint_type;
```

**Evidence**

![Database Tables and Constraints](evidence/01 database table and constraints.png)

**Further Explanation:** This query displays the CareBridge database tables and their constraints, which help maintain data accuracy and integrity.

## 2. Prescription Details Using JOIN

**SQL Code**

```sql
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
```

**Evidence**

![Prescription JOIN](evidence/02 prescription join.png)

**Further Explanation:** The JOIN combines related records to display each patient's medication, dosage, frequency, duration and prescribing doctor.

## 3. Laboratory Orders Using JOIN

**SQL Code**

```sql
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
```

**Evidence**

![Laboratory JOIN](evidence/03 Laboratory-join.png)

**Further Explanation:** This query connects patient records with laboratory tests to display the requested test, its status and available results.

## 4. Appointment-Overlap Constraints

**SQL Code**

```sql
SELECT
    conname AS constraint_name,
    conrelid::regclass AS table_name,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint
WHERE conname IN (
    'no_overlapping_patient_appointments',
    'no_overlapping_doctor_appointments'
);
```

**Evidence**

![Appointment Overlap Constraints](evidence/04 appointment-overlap.png)

**Further Explanation:** These constraints prevent patients and doctors from being assigned overlapping appointments, helping to avoid scheduling conflicts.

## 5. Trigger Protection

**SQL Code**

```sql
SELECT
    trigger_name,
    event_object_table,
    action_timing,
    event_manipulation
FROM information_schema.triggers
WHERE trigger_schema = 'public'
  AND trigger_name IN (
      'prescription_must_have_item',
      'prescription_item_integrity',
      'prevent_completed_lab_order_delete'
  )
ORDER BY event_object_table, trigger_name;
```

**Evidence**

![Trigger Protection](evidence/05 Trigger-protection.png)

**Further Explanation:** These triggers enforce hospital rules by ensuring prescriptions contain medication items and protecting completed laboratory orders from deletion.

## Tools and Technologies

- PostgreSQL 16
- pgAdmin 4
