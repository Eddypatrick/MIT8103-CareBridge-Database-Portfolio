# Portfolio 4: NoSQL Database Implementation

## 1. Objective

This portfolio demonstrates the implementation of a NoSQL database using MongoDB for the CareBridge Hospital Management System. It explores document-based data storage and the use of embedded documents to organise related patient information.

## 2. Case Study

CareBridge is a hospital management system designed to manage patient information, appointments, prescriptions and laboratory records.

For this portfolio, MongoDB was used to demonstrate how patient information and related clinical records can be stored together in a flexible document structure.

## 3. Database Technology

The implementation used:

- MongoDB Community Server 9.0.4
- MongoDB Compass
- MongoDB Shell (mongosh)
- JavaScript

A database named `carebridge_nosql` was created, with a collection named `patients`.

## 4. Data Model and Implementation

A document-based model was implemented using the `patients` collection.

The patient document contains:

- Hospital registration number
- Full name
- Age
- Gender
- Phone number
- Department
- Embedded appointment information
- Embedded laboratory results

The `appointments` and `lab_results` fields use arrays containing embedded documents. This allows related information to be stored within the patient's main document.

The implementation was recorded in `carebridge-nosql.js`.

### Unique hospital registration number

The script creates a unique ascending index on `hospital_registration_no`. The unique index prevents two patient documents from using the same hospital registration number. This provides a data-integrity safeguard comparable in purpose to the `UNIQUE` constraint used in the PostgreSQL implementation, although MongoDB enforces it through an index.

The index is created before the sample patient is inserted. If the collection already contains duplicate registration numbers, MongoDB will not be able to create the unique index until those duplicates are resolved.

### Why the document model uses embedded records

The patient document embeds appointment and laboratory-result subdocuments because these records relate to an individual patient and can be retrieved together with the patient's profile in this small demonstration. Embedding reduces the need for a separate lookup when the application commonly displays the patient's details and embedded information together.

This is a modelling choice, not a rule that every related record must be embedded. Appointments and laboratory results can grow over time, may need to be queried independently, and may be shared with other workflows. In a larger hospital system, separate collections with patient references could be more appropriate for high-volume or independently managed records. Document size and update patterns would need to be monitored.

Compared with the PostgreSQL design in Portfolios 1–3, MongoDB stores the patient and selected related information as a document, while PostgreSQL separates patients, appointments, lab orders and laboratory tests into related tables connected by keys. The relational approach provides explicit foreign-key constraints and structured joins; this MongoDB example demonstrates flexible document structure and convenient retrieval of embedded information. The two implementations illustrate alternative data models rather than claiming that the single-document MongoDB example replaces the relational hospital database.

## 5. Testing and Results

The MongoDB Shell script contains the following operations:

1. Selected the CareBridge NoSQL database.
2. Created a unique index on the hospital registration number.
3. Inserted a patient document using `insertOne()`.
4. Checked the number of documents using `countDocuments()`.
5. Retrieved patient records using `find()`.
6. Retrieved a specific patient using `findOne()`.

The sample patient document was inserted and retrieved through MongoDB Compass. The collection contained one patient document during verification.

**Execution note:** The sample `insertOne()` operation is intended to be run once for the registration number `CBH-2026-004`. Running it again will produce a duplicate-key error because the unique index correctly prevents a second document with the same registration number. The index-creation command can be run again safely when the index already exists with the same definition.

## 6. Suitability of MongoDB for CareBridge

MongoDB's document-based structure is suitable for demonstrating how related patient information can be organised within a single record.

Embedding appointment and laboratory information allows these related records to be retrieved alongside the patient's details. Its flexible document structure also accommodates changes to the information stored as the system develops. The unique index also helps protect the integrity of patient registration numbers.

For a larger hospital system, frequently growing records such as appointments and laboratory results may eventually be better managed in separate collections, with references where appropriate. This helps avoid unnecessarily large patient documents.

## 7. Evidence

Implementation evidence includes:

- MongoDB Compass showing the `carebridge_nosql` database and `patients` collection.
- The inserted patient document with embedded appointment and laboratory information.
- The `carebridge-nosql.js` implementation file, which contains the MongoDB Shell commands used to create the unique index, insert, count and retrieve documents.

## 8. Conclusion

This portfolio demonstrates the practical use of MongoDB as a NoSQL document database for the CareBridge case study. The implementation shows how patient information and related records can be stored using embedded documents, while a unique index protects the hospital registration number from duplication. It provides an alternative data model alongside the PostgreSQL relational database developed in the earlier portfolios.
