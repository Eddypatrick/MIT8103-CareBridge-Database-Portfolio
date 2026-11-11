# Portfolio 5 Evidence

This folder contains screenshots supporting the CareBridge distributed database and cloud deployment exercise. The evidence covers the local PostgreSQL replication demonstration and the practical Amazon RDS deployment.

## A. Local PostgreSQL Replication

### 1. Distributed and Cloud Database Architecture

**Screenshot:** [01-carebridge-distributed-cloud-architecture.png](./01-carebridge-distributed-cloud-architecture.png)

This diagram presents the CareBridge distributed and cloud database architecture, showing the primary PostgreSQL database, standby replica and proposed cloud arrangement.

### 2. Primary Server Replication Status

**Screenshot:** [02-primary-replication-status.png](./02-primary-replication-status.png)

This screenshot shows the primary PostgreSQL server recognising the standby connection. The replication state is `streaming`, with asynchronous synchronisation (`async`).

### 3. Verification of Replicated Data

**Screenshot:** [03-standy-replication-data.png](./03-standy-replication-data.png)

This screenshot shows a test record inserted into the primary CareBridge database on port 5432 and retrieved from the standby database on port 5433. This demonstrates successful physical streaming replication between the two local PostgreSQL instances.

## B. Practical Amazon RDS Deployment

### 4. RDS Instance Status

**Screenshot:** [P5-AWS_RDS-instance.png](./P5-AWS_RDS-instance.png)

This screenshot identifies the CareBridge RDS PostgreSQL instance and shows its AWS status as Available.

### 5. RDS Security Group

**Screenshot:** [P5-AWS-RDS-security-group.png](./P5-AWS-RDS-security-group.png)

This screenshot provides evidence of the security-group configuration for PostgreSQL access. The inbound rule should be reviewed in the image to ensure the full source restriction is visible; sensitive account or network identifiers should be obscured before public submission.

### 6. Manual RDS Snapshot

**Screenshot:** [P5-AWS-RDS-manual-snapshot.png](./P5-AWS-RDS-manual-snapshot.png)

This screenshot shows the manual snapshot named `carebridge-before-timestamptz-migration` with status Available. It provides evidence that a recovery snapshot was created for the RDS instance.

## C. Cloud Database Data Verification

The following screenshots show query results retrieved from the CareBridge database hosted on Amazon RDS.

### 7. Patient Records

**Screenshot:** [P5-AWS-RDS-patient-data-verification.png](./P5-AWS-RDS-patient-data-verification.png)

Shows the patient records retrieved from the cloud database.

### 8. Doctor Records

**Screenshot:** [P5-AWS-RDS-doctors-verification.png](./P5-AWS-RDS-doctors-verification.png)

Shows the doctor records and their department references.

### 9. Appointment Records

**Screenshot:** [P5-AWS-RDS-appointments-verification.png](./P5-AWS-RDS-appointments-verification.png)

Shows appointment records retrieved from the cloud database.

### 10. Prescription Records

**Screenshot:** [P5-AWS-RDS-prescriptions-verification.png](./P5-AWS-RDS-prescriptions-verification.png)

Shows prescription records associated with patients and doctors.

### 11. Prescription Items

**Screenshot:** [P5-AWS-RDS-prescription-items-verification.png](./P5-AWS-RDS-prescription-items-verification.png)

Shows the medication items and dosage instructions associated with prescriptions.

### 12. Laboratory Tests

**Screenshot:** [P5-AWS-RDS-lab-test-verification.png](./P5-AWS-RDS-lab-test-verification.png)

Shows the laboratory tests configured in the CareBridge database.

### 13. Laboratory Orders

**Screenshot:** [P5-AWS-RDS-lab-orders-verification.png](./P5-AWS-RDS-lab-orders-verification.png)

Shows laboratory orders and their recorded status and result.

### 14. Department Records

**Screenshot:** [P5-AWS-RDS-department-verification.png](./P5-AWS-RDS-department-verification.png)

Shows the departments configured in the CareBridge database.

### 15. Consolidated Table Verification

**Screenshot:** [P5-AWS-RDS-consolidated-table-verification.png](./P5-AWS-RDS-consolidated-table-verification.png)

Shows the record counts for the eight CareBridge tables, with 21 records in total at the time of verification.

## Scope and Evidence Notes

- Local streaming replication was demonstrated using two PostgreSQL instances running on the same computer, on ports 5432 and 5433.
- The AWS evidence demonstrates RDS provisioning, pgAdmin connectivity, inspection of the cloud-hosted CareBridge database, data retrieval and creation of a manual snapshot.
- The AWS CareBridge database was already populated when it was inspected. The local migration backup was not restored to that existing cloud database. Therefore, these screenshots should not be interpreted as proof of a completed local-to-cloud database restore.
- The RDS instance was configured as Single-AZ. A Multi-AZ failover test was not demonstrated.
- Before making screenshots public, review them for account identifiers, encryption key identifiers, passwords, and other sensitive values. Keep security-group source details visible only where safe to do so.
