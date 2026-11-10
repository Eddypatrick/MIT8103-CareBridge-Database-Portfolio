# Portfolio 2: Query Optimisation Evidence

This folder contains screenshots supporting the query processing and optimisation activities carried out using PostgreSQL 16.5 and pgAdmin 4.

| Screenshot | Description |
|---|---|
| [01-appointment-query.png](./01-appointment-query.png) | Appointment retrieval using JOIN operations across appointments, patients and doctors. |
| [02-initial-execution-plan.png](./02-initial-execution-plan.png) | Initial EXPLAIN ANALYZE output before creating the appointment date/time index. |
| [03- indexed-execution-plan.png](<./03-%20indexed-execution-plan.png>) | Execution plan after indexing the appointment date/time column. |
| [04-index-verification.png](./04-index-verification.png) | Verification of the created index in PostgreSQL. |
| [05-reproduced-sequential-scan.png](./05-reproduced-sequential-scan.png) | Demonstration of a sequential scan with index and bitmap scans temporarily disabled. |
| [06-performance-before-index.png](./06-performance-before-index.png) | Performance measurement before indexing the 100,000-row test table. |
| [07-performance-after-index.png](./07-performance-after-index.png) | Performance measurement after indexing the same test table. |

Execution times are measurements from the recorded runs and may vary on subsequent executions because of caching and system conditions.
