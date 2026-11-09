# Portfolio 5: Distributed and Cloud Database Exercise

## Case Study: CareBridge Hospital Management System

### 1. Introduction

CareBridge Hospital Management System is a relational database solution developed using PostgreSQL to manage hospital operations, including patient records, appointments, prescriptions, doctors and laboratory orders.

As the hospital expands its services across multiple branches, a distributed and cloud-based database architecture can improve data availability, scalability, disaster recovery and access to information.

This exercise proposes a cloud-based PostgreSQL architecture for CareBridge, focusing on database replication, availability, consistency, scalability and security.

### 2. Proposed Distributed Database Architecture

The proposed architecture consists of the following components:

```mermaid
flowchart TD
    A[CareBridge Hospital Users] --> B[Cloud PostgreSQL Primary Database]
    B -->|Data Replication| C[Standby Database Replica]
    C --> D[Disaster Recovery]
    B --> E[Multiple Hospital Branches]
```

**Figure 1: Proposed distributed and cloud database architecture for CareBridge.**

The primary database handles the hospital's main transactions, while replication maintains a separate copy of the database on a standby server. The standby replica supports recovery if the primary database becomes unavailable. The architecture also provides a foundation for supporting multiple hospital branches.
  
### 3. Database Replication and Availability

Database replication involves maintaining copies of data across multiple database servers. In the proposed CareBridge architecture, the primary PostgreSQL database sends changes to a standby replica.

PostgreSQL supports two major replication approaches:

**Synchronous Replication:** The primary database waits for confirmation that changes have been received by the standby server before confirming a transaction. This provides stronger data consistency but may increase transaction latency.

**Asynchronous Replication:** The primary database confirms transactions without waiting for the standby server to acknowledge every change. This can improve transaction performance, although the replica may temporarily lag behind the primary database.

For CareBridge, synchronous replication may be considered for critical patient and prescription records where minimising data loss is important. Asynchronous replication may be suitable where performance and network latency are greater concerns.

The standby replica can support disaster recovery if the primary database fails. However, automatic failover requires additional configuration and monitoring.

This approach improves resilience and supports database availability, helping CareBridge maintain access to important hospital information.

### 4. Data Consistency Across Hospital Branches

Data consistency ensures that users and database replicas work with accurate and reliable information.

For CareBridge, consistency is important because patient records, prescriptions, appointments and laboratory results must remain accurate across the hospital's database environment.

The proposed architecture uses PostgreSQL transactions and replication to maintain data integrity.

The following measures will support consistency:

- **ACID transactions:** Ensure that database operations are atomic, consistent, isolated and durable.
- **Primary database writes:** Direct critical updates to the primary database to avoid conflicting updates across replicas.
- **Replication monitoring:** Monitor replication lag to identify delays between the primary database and standby replica.
- **Access control:** Restrict database modifications to authorised personnel.
- **Data validation:** Apply constraints such as primary keys, foreign keys, unique constraints and check constraints.

For critical patient information, the primary database remains the authoritative source. Read operations against a standby replica should account for possible replication delays, particularly when asynchronous replication is used.

These measures help maintain reliable patient information and reduce inconsistencies across CareBridge operations.

### 5. Cloud Database Deployment and Scalability

CareBridge can deploy its PostgreSQL database using Amazon Relational Database Service (Amazon RDS) for PostgreSQL.

Amazon RDS is a managed database service that provides database hosting, automated backups, monitoring and options for high availability.

The proposed cloud deployment offers the following benefits:

- **Scalability:** Database resources can be increased as patient records and hospital transactions grow.
- **Managed backups:** Automated backups support data recovery.
- **High availability:** Multi-AZ deployment can maintain a standby database in another Availability Zone and support failover.
- **Accessibility:** Authorised users can securely access the database from different hospital branches.
- **Maintenance:** Managed database services reduce the administrative burden of routine database operations.

CareBridge can initially use a single primary database with a standby replica. As the hospital expands, additional read replicas can help distribute read workloads.

For future horizontal scaling, patient records and operational data could be distributed across hospital branches using a carefully designed sharding strategy. This would require additional application logic and coordination to maintain data consistency.

Cloud deployment would also require secure network configuration, encryption, role-based access control and regular backup testing.

### 6. Security and Risk Management

CareBridge handles sensitive patient information, making database security essential in both local and cloud environments.

The proposed architecture will adopt the following security measures:

- **Authentication:** Require verified user credentials before granting database access.
- **Role-Based Access Control (RBAC):** Assign permissions according to staff responsibilities. For example, doctors, laboratory personnel and receptionists should have different access privileges.
- **Encryption:** Protect patient information during transmission and while stored in the cloud.
- **Multi-Factor Authentication (MFA):** Add another layer of protection for administrative and privileged accounts.
- **Backup and Recovery:** Maintain regular backups and periodically test database restoration procedures.
- **Monitoring and Auditing:** Record database access and administrative activities to identify suspicious behaviour.
- **Network Security:** Restrict database access to trusted networks and authorised application servers.

Potential risks include network outages, replication delays, unauthorised access, cloud service disruptions and accidental data loss.

These risks can be reduced through secure configuration, continuous monitoring, tested recovery procedures and appropriate access management.

CareBridge must also ensure that its handling of patient information complies with applicable Nigerian data protection requirements, including the Nigeria Data Protection Act (NDPA) 2023.

### 7. Recommendations

Based on the proposed architecture, the following recommendations are made for CareBridge:

1. Adopt a managed PostgreSQL cloud service to support database scalability and reduce infrastructure maintenance.
2. Configure database replication to maintain a standby copy of critical hospital records.
3. Use appropriate replication settings based on the hospital's consistency and performance requirements.
4. Implement automated backups and regularly test disaster recovery procedures.
5. Apply role-based access control, encryption and multi-factor authentication to protect patient information.
6. Consider branch-based sharding only when the volume of data and number of hospital branches justify the additional complexity.
7. Monitor database performance, replication lag and availability continuously.

### 8. Conclusion

The proposed distributed and cloud database architecture provides CareBridge Hospital Management System with a foundation for improved scalability, availability, data protection and disaster recovery.

PostgreSQL replication can support database resilience, while cloud services such as Amazon RDS provide managed infrastructure and high-availability options.

Although this exercise presents a proposed architecture rather than a live cloud deployment, it demonstrates how distributed database concepts can be applied to a practical hospital management system.

The design also highlights the importance of balancing consistency, availability, performance and security when planning a distributed database environment.

### 9. References

1. Miva Open University. (2026). *MIT 8103: Advanced Database Systems, Study Session 2, Lecture 2: Distributed Databases*. Course lecture materials.

2. Miva Open University. (2026). *MIT 8103: Advanced Database Systems, Study Session 2, Lecture 3: Cloud Databases*. Course lecture materials.

3. PostgreSQL Global Development Group. (n.d.). *High Availability, Load Balancing, and Replication*. https://www.postgresql.org/docs/current/high-availability.html

4. Amazon Web Services. (n.d.). *Amazon RDS Documentation*. https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html
