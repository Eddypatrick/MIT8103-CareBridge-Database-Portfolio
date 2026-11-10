# Portfolio 3: Transactions and Concurrency Evidence

This folder contains screenshots from the PostgreSQL 16.5 transaction and concurrency exercises.

| Screenshot | Description |
|---|---|
| [01-create-transaction-demo-table.png](./01-create-transaction-demo-table.png) | Creation of the demonstration table used for transaction exercises. |
| [02-commit-transaction.png](./02-commit-transaction.png) | Execution of a transaction followed by COMMIT. |
| [03-rollback-transaction.png](./03-rollback-transaction.png) | Execution of an update that is reversed using ROLLBACK. |
| [04-rollback-verification.png](./04-rollback-verification.png) | Verification that the rolled-back change was not retained. |
| [05-read-committed-initial-read.png](./05-read-committed-initial-read.png) | Initial read in the READ COMMITTED transaction. |
| [06-read-committed-session-b-update.png](./06-read-committed-session-b-update.png) | Concurrent update committed in Session B. |
| [07-repeatable-read-session-a.png](./07-repeatable-read-session-a.png) | Session A demonstration of REPEATABLE READ isolation. |
| [08-row-level-looking-session-b.png](./08-row-level-looking-session-b.png) | Session B attempts an update while Session A holds a row-level lock. |
| [09-row-level-locking-final-script-execution.png](./09-row-level-locking-final-script-execution.png) | Final execution evidence for the row-level locking exercise. |
| [10-read-committed-second-read.png](./10-read-committed-second-read.png) | Second read used to demonstrate visibility of a committed change under READ COMMITTED. |

The screenshots should be read alongside the Session A and Session B SQL scripts in the parent folder. The filename of screenshot 08 contains a minor spelling error (“looking” instead of “locking”); the screenshot itself is retained unchanged.
