# Portfolio 3: Transactions and Concurrency

## Objective

This portfolio demonstrates transaction management and concurrency control in a relational database using the CareBridge Hospital Management System.

## Activities

The following activities were implemented using PostgreSQL 16.5 and pgAdmin 4:

1. **Transaction Commit:** Demonstrated how committed database changes are saved permanently.
2. **Transaction Rollback:** Tested how uncommitted changes can be reversed.
3. **READ COMMITTED Isolation:** Demonstrated how a transaction can see changes committed by another session.
4. **REPEATABLE READ Isolation:** Demonstrated how a transaction maintains a consistent view of data during concurrent updates.
5. **Row-Level Locking:** Used `SELECT FOR UPDATE` to prevent conflicting updates while a transaction holds a row lock.

## SQL Scripts

The SQL scripts for Session A and Session B contain the transaction and concurrency demonstrations carried out during this exercise.

## Evidence

Screenshots of the SQL statements, execution results, and transaction behaviour are provided in the `Evidence` folder.

## Conclusion

The practical exercise demonstrated how PostgreSQL manages transactions and concurrent database operations. It improved my understanding of data consistency, isolation levels, rollback mechanisms, and row-level locking.
