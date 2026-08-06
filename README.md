# Smart Clinic Database System

## IT244 – Introduction to Databess Project

## Project Overview

The **Smart Clinic Database System** is a relational database developed to support the main clinical, administrative, and financial activities of a private outpatient clinic. It organizes patient and doctor information, medical specialties, appointments, consultations, prescriptions, medication inventory, and payment transactions within one consistent MySQL database.

The project applies database design and implementation principles through an enhanced entity-relationship model, a normalized relational schema, integrity constraints, coherent fictional data, SQL operations, a reusable reporting view, and an inventory-control trigger. The accompanying reports and MySQL Workbench evidence document the design, implementation, testing process, and verified results.

## Project Objectives

- Design a clear ER/EER model for the clinic's main entities and relationships.
- Transform the conceptual model into a normalized relational schema.
- Implement the database in MySQL using suitable keys and integrity constraints.
- Populate all tables with logically connected fictional data for academic testing.
- Demonstrate SELECT, JOIN, nested, aggregate, UPDATE, DELETE, VIEW, and TRIGGER operations.
- Apply transaction control to test data-changing operations without permanently altering the original dataset.
- Provide verifiable MySQL Workbench evidence for the populated tables and SQL results.
- Maintain an organized repository containing the complete project deliverables.

## Task Distribution Among Team Members

| Student | ID | Contribution |
|---|---:|---|
| Sultan Aljohani | 240035689 | Group Leader and Repository Manager; Task 1: database design, EER model, relational mapping, repository organization, and integration review |
| Amjad Najmi | 240020509 | Task 2: MySQL database implementation, table creation, constraints, fictional data insertion, and population verification |
| Abdulaziz Alharbi | 250021379 | Task 3: SQL operations, transaction testing, VIEW, TRIGGER, result verification, and execution evidence |

Task 4, technical cross-review, testing, project reflection, and final documentation were completed collaboratively by all team members.

## Database Design

The database contains ten related tables:

| Table | Purpose |
|---|---|
| `clinic_person` | Stores the shared identity and contact attributes of patients and doctors. |
| `patient` | Stores patient-specific medical record, blood group, insurance, emergency contact, and registration data. |
| `specialty` | Stores the clinic's medical specialties, zones, and standard appointment durations. |
| `doctor` | Stores doctor licenses, specialty assignments, office codes, fees, and availability. |
| `appointment` | Connects each patient with a doctor at a scheduled date and time. |
| `consultation` | Records the diagnosis, clinical assessment, service fee, and follow-up information for an appointment. |
| `medication` | Stores medication products, prices, available stock, and reorder levels. |
| `prescription` | Stores prescriptions issued during consultations. |
| `prescription_item` | Connects prescriptions with medications and records dosage, frequency, course, route, and dispensed units. |
| `payment` | Records appointment payments, payment methods, statuses, payer types, and receipt numbers. |

## EER Specialization and Relationships

`CLINIC_PERSON` is the supertype for the shared identity and contact attributes. `PATIENT` and `DOCTOR` are modeled as total and disjoint subtypes at the application level. This approach reduces repeated data while preserving the information specific to each subtype.

The principal relationships are:

- `CLINIC_PERSON 1 — 0..1 PATIENT`
- `CLINIC_PERSON 1 — 0..1 DOCTOR`
- `SPECIALTY 1 — 0..N DOCTOR`
- `PATIENT 1 — 0..N APPOINTMENT`
- `DOCTOR 1 — 0..N APPOINTMENT`
- `APPOINTMENT 1 — 0..1 CONSULTATION`
- `APPOINTMENT 1 — 0..N PAYMENT`
- `CONSULTATION 1 — 0..N PRESCRIPTION`
- `PRESCRIPTION 1 — 0..N PRESCRIPTION_ITEM`
- `MEDICATION 1 — 0..N PRESCRIPTION_ITEM`

`PRESCRIPTION_ITEM` resolves the many-to-many relationship between prescriptions and medications while storing the dosage and course details for each prescribed product.

## Database Implementation

The database was implemented for **MySQL 8.0 or newer** using the InnoDB storage engine and `utf8mb4` character encoding. The implementation includes:

- primary and foreign keys;
- composite and single-column keys;
- `NOT NULL`, `UNIQUE`, `CHECK`, and `ENUM` constraints;
- referential actions using `CASCADE` and `RESTRICT` where appropriate;
- controls that prevent duplicate doctor or patient bookings at the same time;
- validation of Saudi national identifiers and `+966` mobile-number formats;
- fictional Saudi-context personal, clinical, prescription, inventory, and payment data.

The verified sample dataset contains:

| Table | Records |
|---|---:|
| `clinic_person` | 10 |
| `patient` | 5 |
| `specialty` | 5 |
| `doctor` | 5 |
| `appointment` | 7 |
| `consultation` | 5 |
| `medication` | 7 |
| `prescription` | 5 |
| `prescription_item` | 7 |
| `payment` | 7 |

## SQL Operations

The SQL script demonstrates and verifies the required operations:

- filtered and ordered SELECT statements for completed appointments and medication replenishment;
- a multi-table JOIN for appointment, patient, doctor, and specialty information;
- a multi-table JOIN for patient diagnoses, prescriptions, and medications;
- a nested query that identifies patients whose total completed payments exceed the average paid total per paying patient;
- aggregate functions with `GROUP BY` for doctor workload, completed visits, visit charges, and collected payments;
- an `UPDATE` demonstration that temporarily changes a patient's insurance provider;
- a `DELETE` demonstration involving a pending payment record;
- a reusable financial reporting VIEW;
- an inventory-control TRIGGER;
- transaction control through `START TRANSACTION` and `ROLLBACK`.

The UPDATE, DELETE, and TRIGGER demonstrations use rollback verification so the original academic dataset remains unchanged after testing.

### Financial Reporting View

```text
vw_visit_financial_status
```

The view produces one financial summary row for each appointment. It combines appointment, patient, doctor, specialty, consultation, and payment information and calculates the expected charge, net amount paid, and outstanding balance.

### Medication Inventory Trigger

```text
trg_prescription_item_reduce_stock
```

The trigger runs before a prescription item is inserted. It confirms that the medication exists, prevents the requested quantity from exceeding the available clinic stock, and automatically deducts the dispensed units from `stock_on_hand`. The reversible trigger test confirms the stock sequence `150 → 146 → 150`.

## Main Project Files

- [Complete MySQL script](https://github.com/Database-project-lgtm/Smart-Clinical-Database-System/blob/main/database/smart_clinic_database.sql)
- [Final EER diagram](https://github.com/Database-project-lgtm/Smart-Clinical-Database-System/blob/main/diagrams/er_diagram.png)
- [Editable Draw.io diagram source](diagrams/er_diagram_source.drawio)
- [Screenshot evidence index](evidence/Screenshot_Evidence_Index.md)

## Running the Database

1. Install MySQL Server 8.0 or newer.
2. Install and open MySQL Workbench.
3. Open `database/smart_clinic_database.sql`.
4. Connect using an account with permission to create databases, tables, views, and triggers.
5. Execute the complete script from top to bottom using **Execute All**.
6. Refresh the Schemas panel and open `smart_clinic_system`.
7. Confirm that the schema contains ten base tables and the `vw_visit_financial_status` view.
8. Review the table-population statements and Task 3 result sets included in the script.
9. Compare the displayed results with the evidence stored in `evidence/screenshots/`.

> **Important:** The script begins with `DROP DATABASE IF EXISTS smart_clinic_system` to provide a repeatable academic test environment. Do not run it against a database containing information that must be retained.

## Documentation and Evidence

The `Report_docs/` directory contains the team contribution record, mid-project progress report, and final report in the required document formats. The `diagrams/` directory contains the final high-resolution EER diagram and its editable Draw.io source.

The `evidence/screenshots/` directory contains the MySQL Workbench evidence for:

- database-object verification;
- population of all ten tables;
- SELECT, JOIN, nested, and GROUP BY results;
- UPDATE and rollback verification;
- DELETE and rollback verification;
- financial VIEW output;
- TRIGGER execution and stock restoration.

Some longer SQL operations are documented across more than one screenshot to keep both the code and result readable. `evidence/Screenshot_Evidence_Index.md` links every screenshot to the task and operation it verifies.

## Project Structure

```text
Smart-Clinical-Database-System/
├── README.md
├── database/
│   └── smart_clinic_database.sql
├── Report_docs/
│   ├── Smart_Clinic_Team_Contribution-Record.docx
│   ├── Smart_Clinic_Mid_Project_Progress_Report.docx
│   ├── Smart_Clinic_Mid_Project_Progress_Report.pdf
│   ├── Smart_Clinic_Final_Report.docx
│   └── Smart_Clinic_Final_Report.pdf
├── diagrams/
│   ├── er_diagram.png
│   └── er_diagram_source.drawio
└── evidence/
    ├── screenshots/
    └── Screenshot_Evidence_Index.md
```

## Project Artifacts

- **Live Report Folder:**  
  https://drive.google.com/drive/folders/1arzRO-tMa9YdED1HLBBBPtQnomPO1jSw

- **GitHub Repository:**  
  https://github.com/Database-project-lgtm/Smart-Clinical-Database-System

## Academic Data Notice

All names, national identifiers, contact details, medical records, diagnoses, prescriptions, medication records, and payment transactions contained in this project are fictional and were created exclusively for academic database design, implementation, and testing.

