# Portfolio 1: Database Design Evidence

This folder contains screenshots supporting the design, implementation and verification of the CareBridge Hospital Management System.

## Main CareBridge Database Evidence

Screenshots in the main evidence folder (01–05, 07 and 08) were captured from the primary PostgreSQL database, `carebridge`. They document the implemented database structure, query results, integrity controls and the final timestamp migration.

| Screenshot | Description |
|---|---|
| [01 database table and constraints png.png](./01%20database%20table%20and%20constraints%20png.png) | Displays the database tables and their defined constraints. |
| [02 Prescription-Join.png](./02%20Prescription-Join.png) | Shows prescription information retrieved by joining patient, doctor, prescription and prescription item records. |
| [03Laboratory -Join.png](./03Laboratory%20-Join.png) | Shows laboratory orders retrieved with patient and laboratory test information. |
| [04 appointment -overlap.png](./04%20appointment%20-overlap.png) | Supports the appointment-overlap constraint demonstration. |
| [05 Trigger -ptotection.png](./05%20Trigger%20-ptotection.png) | Supports the database trigger protection demonstration. |
| [07-timestamp-column-verification.png](./07-timestamp-column-verification.png) | Verifies that the appointment start, appointment end and laboratory order date columns use `timestamp with time zone` (`TIMESTAMPTZ`). |
| [08-appointment-time-preservation.png](./08-appointment-time-preservation.png) | Confirms that existing appointment times were preserved when interpreted in the `Africa/Lagos` time zone after the migration to `TIMESTAMPTZ`. |

## Separate Test Database Evidence

Additional integrity and trigger tests were performed in the separate `carebridge_test` database, rather than on the primary database. Their screenshots and explanations are documented in [Test Database Evidence](./Test%20Database%20Evidence/README.md).

The test database evidence is kept separate to distinguish test records and test operations from the primary `carebridge` database and its final portfolio evidence.
