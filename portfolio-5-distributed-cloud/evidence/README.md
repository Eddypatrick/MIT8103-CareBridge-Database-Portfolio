# Portfolio 5 Evidence

## 1. Proposed Distributed and Cloud Database Architecture

**Screenshot:** `01-carebridge-distributed-cloud-architecture.png`

This screenshot presents the proposed CareBridge distributed and cloud database architecture. It illustrates how hospital users interact with the primary PostgreSQL database and how database replication supports a standby replica for disaster recovery.
# Portfolio 5 Evidence

## 1. Proposed Distributed and Cloud Database Architecture

**Screenshot:** `01-carebridge-distributed-cloud-architecture.png`

This screenshot presents the proposed CareBridge distributed and cloud database architecture. It illustrates how hospital users interact with the primary PostgreSQL database and how replication supports a standby replica for disaster recovery.

## 2. Primary Server Replication Status

**Screenshot:** `02-primary-replication-status.png`

This screenshot shows the primary PostgreSQL server recognising the standby connection on localhost. The replication state is `streaming`, with asynchronous synchronisation (`async`).

## 3. Verification of Replicated Data

**Screenshot:** `03-standby-replicated-data.png`

This screenshot demonstrates successful physical streaming replication in PostgreSQL. A test record inserted into the primary CareBridge database on port 5432 was successfully retrieved from the standby database on port 5433, confirming that database changes were replicated.
