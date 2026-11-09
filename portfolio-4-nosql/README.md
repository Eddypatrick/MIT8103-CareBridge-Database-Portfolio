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

## 5. Testing and Results

The following MongoDB operations were performed:

1. Selected the CareBridge NoSQL database.
2. Inserted a patient document using `insertOne()`.
3. Checked the number of documents using `countDocuments()`.
4. Retrieved patient records using `find()`.
5. Retrieved a specific patient using `findOne()`.

The document was successfully inserted and retrieved through MongoDB Compass. The collection contained one patient document during verification.

## 6. Suitability of MongoDB for CareBridge

MongoDB's document-based structure is suitable for demonstrating how related patient information can be organised within a single record.

Embedding appointment and laboratory information allows these related records to be retrieved alongside the patient's details. Its flexible document structure also accommodates changes to the information stored as the system develops.

For a larger hospital system, frequently growing records such as appointments and laboratory results may eventually be better managed in separate collections, with references where appropriate. This helps avoid unnecessarily large patient documents.

## 7. Evidence

Implementation evidence includes:

- MongoDB Compass showing the `carebridge_nosql` database and `patients` collection.
- The inserted patient document with embedded appointment and laboratory information.
- The MongoDB Shell commands used to insert, count and retrieve documents.
- The `carebridge-nosql.js` implementation file.

## 8. Conclusion

This portfolio demonstrates the practical use of MongoDB as a NoSQL document database for the CareBridge case study. The implementation shows how patient information and related records can be stored using embedded documents, providing an alternative data model alongside the PostgreSQL relational database developed in the earlier portfolios.
