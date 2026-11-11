# CareBridge Test Database Evidence

This folder contains 11 screenshots captured while testing the CareBridge Hospital Management System in a separate PostgreSQL database named `carebridge_test`.

The tests were carried out to verify the database structure, relationships, integrity constraints and triggers. They also checked that invalid operations were rejected and that the original sample records remained unchanged.

The `carebridge_test` database contains two laboratory orders: Ada Nwosu's completed Malaria Test and Ibrahim Bello's pending Full Blood Count, whose result is `NULL`. By comparison, the main `carebridge` database contains one laboratory order, and the backup created before the timestamp migration also contains one. The pending Full Blood Count record belongs to the separate test database and is not part of the main database or its backup.

## Evidence Description

| No. | Screenshot | What it demonstrates |
|---:|---|---|
| 1 | [01-carebridge-test-eight-tables.png](./01-carebridge-test-eight-tables.png) | Verification that all eight CareBridge tables were created successfully. |
| 2 | [02-carebridge-prescription-join.png](./02-carebridge-prescription-join.png) | JOIN results linking patients, doctors, prescriptions and prescription items. |
| 3 | [03-carebridge-laboratory-join.png](./03-carebridge-laboratory-join.png) | JOIN results linking laboratory orders with patient records and laboratory test definitions. |
| 4 | [04a-duplicate-registration.png](./04a-duplicate-registration.png) | The unique hospital registration number constraint rejects a duplicate patient registration. |
| 5 | [04b-invalid-patient-foreign-key.png](./04b-invalid-patient-foreign-key.png) | The patient foreign key rejects an appointment that references a non-existent patient. |
| 6 | [04c-invalid-appointment-time.png](./04c-invalid-appointment-time.png) | The appointment time check constraint rejects an end time earlier than the start time. |
| 7 | [04d-patient-appointment-overlap.png](./04d-patient-appointment-overlap.png) | The exclusion constraint rejects overlapping appointments for the same patient. |
| 8 | [04e-doctor-appointment-overlap.png](./04e-doctor-appointment-overlap.png) | The exclusion constraint rejects overlapping appointments assigned to the same doctor. |
| 9 | [05a-prescription-trigger.png](./05a-prescription-trigger.png) | The deferred constraint trigger prevents a prescription from being committed without a medication item. |
| 10 | [05b-completed-lab-order-trigger.png](./05b-completed-lab-order-trigger.png) | The trigger prevents deletion of a completed laboratory order, protecting its recorded result. |
| 11 | [06-carebridge-test-final-record-counts.png](./06-carebridge-test-final-record-counts.png) | Final record counts confirm that the original sample records remained unchanged after testing. |

## Testing Outcome

The test database successfully enforced the defined constraints and triggers. Invalid operations were rejected as expected, while valid prescription and laboratory relationships were retrieved through SQL JOIN queries.

The final record-count check showed the following sample data totals:

| Table | Final record count |
|---|---:|
| departments | 3 |
| doctors | 3 |
| patients | 3 |
| appointments | 2 |
| prescriptions | 2 |
| prescriptionitems | 2 |
| labtests | 3 |
| laborders | 2 |

**Testing note:** These integrity tests were performed in the separate `carebridge_test` database. The main CareBridge database was not used for the negative tests.
