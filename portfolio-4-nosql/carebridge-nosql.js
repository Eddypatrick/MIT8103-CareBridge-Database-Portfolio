// MIT 8103: Advanced Database Systems
// Portfolio 4: NoSQL Implementation
// Case Study: CareBridge Hospital Management System
// Database: MongoDB

// 1. Select the CareBridge NoSQL database
use("carebridge_nosql");

// 2. Enforce unique hospital registration numbers
// This prevents two patient documents from sharing the same registration number.
db["patients"].createIndex(
    { hospital_registration_no: 1 },
    { unique: true }
);

// 3. Insert a patient document
// Run this insertion once for the sample registration number.
// Re-running it will correctly produce a duplicate-key error.
db["patients"].insertOne({
    hospital_registration_no: "CBH-2026-004",
    full_name: "Grace Adebayo",
    age: 34,
    gender: "Female",
    phone: "08030000004",
    department: "General Medicine",

    // Embedded appointment information
    appointments: [
        {
            doctor: "Dr James Okon",
            date: "2026-11-10",
            status: "Confirmed"
        }
    ],

    // Embedded laboratory results
    lab_results: [
        {
            test: "Malaria Test",
            status: "Completed",
            result: "No malaria parasites detected"
        }
    ]
});

// 4. Count the documents in the patients collection
db["patients"].countDocuments({});

// 5. Retrieve all patient documents
db["patients"].find({});

// 6. Retrieve a specific patient
db["patients"].findOne({
    hospital_registration_no: "CBH-2026-004"
});
