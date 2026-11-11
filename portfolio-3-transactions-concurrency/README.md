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

## Practical Walkthrough: Two Database Sessions

The demonstration uses the separate `appointment_transaction_demo` table so that transaction experiments do not alter the main CareBridge appointment records. The SQL is split between `portfolio-3-session-a.sql` and `portfolio-3-session-b.sql`.

1. **Prepare the demonstration table:** Run the table-creation statement in Session A. Insert the test appointment and commit it. Later demonstrations use `demo_id = 1`.
2. **COMMIT and ROLLBACK:** Session A inserts and commits a test row. It then changes row 1 to `Cancelled` inside a new transaction and issues `ROLLBACK`. The verification SELECT should show that the cancellation was not saved.
3. **READ COMMITTED:** Begin the Session A transaction at READ COMMITTED and run its first SELECT. While Session A remains open, run the Session B update to `Confirmed` and commit it. Run Session A's second SELECT. Under READ COMMITTED, a new statement can see data committed by another transaction after the first statement began.
4. **REPEATABLE READ:** Begin a new Session A transaction at REPEATABLE READ and run the first SELECT. In Session B, run the two update transactions in order, first setting the status to `Completed`, then to `Checked In`, committing each. Session A's second SELECT continues to see its original transaction snapshot. Commit Session A before proceeding.
5. **Row-level lock:** In Session A, begin a transaction and run the SELECT ... FOR UPDATE statement for row 1. While Session A holds the lock, execute Session B's update to `Under Review`. The Session B update waits for the row lock to be released. Commit Session A; Session B can then complete and commit.

**Execution notes:** Use two separate pgAdmin Query Tool tabs connected to the same demonstration database, one for Session A and one for Session B. Follow the order above and do not run all statements in one session or as one uninterrupted batch, because the concurrent behaviour depends on timing between sessions. The scripts assume that row `demo_id = 1` exists. For a fresh demonstration, create the table and insert the initial test row first; if the table already contains data, inspect the IDs and adjust the demonstration row consistently before rerunning. The table-creation statement uses `IF NOT EXISTS`, so it does not reset existing test data.

## Evidence

Screenshots of the SQL statements, execution results, and transaction behaviour are provided in the `Evidence` folder.

## Conclusion

The practical exercise demonstrated how PostgreSQL manages transactions and concurrent database operations. It improved my understanding of data consistency, isolation levels, rollback mechanisms, and row-level locking.
