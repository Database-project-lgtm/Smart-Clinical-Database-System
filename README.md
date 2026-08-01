# Smart Clinic Database System

## IT244 – Database Design and Implementation Project

The **Smart Clinic Database System** demonstrates the design and implementation of a complete relational database for a private clinic. The project covers ER/EER modeling, relational schema design, SQL implementation, sample data, and advanced database operations using MySQL.

---

## Team Members

| Name | Student ID |
|---|---:|
| SULTAN ALJOHANI | 240035689 |
| Amjad Najmi | 240020509 |
| Abdulaziz Alharbi | 250021379 |

---

## Project Overview

The system is designed to manage patient records, doctor information and schedules, appointments, treatments, prescribed medicines, and payments. It replaces manual record-keeping with a structured and queryable database that supports data consistency, efficient retrieval, and reliable reporting.

---

## Database Entities

The design contains **six main operational entities**, **one associative entity**, and the **PERSON supertype** used in the EER hierarchy.

| Entity | Type | Description |
|---|---|---|
| PERSON | Supertype | Stores personal attributes shared by patients and doctors |
| PATIENT | Main entity / subtype | Stores patient-specific information |
| DOCTOR | Main entity / subtype | Stores doctor credentials and specialization |
| MEDICINE | Main entity | Stores available medicine information |
| APPOINTMENT | Main entity | Links patients and doctors through scheduled visits |
| TREATMENT | Main entity | Stores treatment details and associated costs |
| PAYMENT | Main entity | Stores financial transactions related to clinic services |
| TREATMENT_MEDICINE | Associative entity | Resolves the many-to-many relationship between treatments and medicines |

When the PERSON supertype is implemented as a separate relation, the physical database contains **eight related tables**.

---

## EER Feature

The EER design includes a **generalization/specialization hierarchy**. PERSON is the supertype and contains the attributes shared by PATIENT and DOCTOR, including `FirstName`, `LastName`, `Phone`, `Email`, and `DateOfBirth`. PATIENT and DOCTOR are subtypes that inherit these common attributes and contain their own role-specific attributes.

This structure reduces repeated data and represents the shared characteristics of patients and doctors more accurately.

---

## Repository Structure

```text
Smart-Clinic-Database-System
|-- README.md
|-- database/
|   `-- smart_clinic_database.sql
|-- Report_docs/
|   |-- Smart_Clinic_Final_Report.docx
|   |-- Smart_Clinic_Mid_Project_Progress_
|   `-- Smart_Clinic_Team_Contribution_Rec
|-- diagrams/
|   |-- er_diagram.mmd
|   |-- er_diagram.png
|   |-- er_diagram_info.txt
|-- evidence/
    `-- screenshots/
```

The complete ER/EER diagram is available in [`diagrams/er_diagram.png`](diagrams/er_diagram.png).

---

## SQL Implementation

The file [`database/smart_clinic_database.sql`](database/smart_clinic_database.sql) includes:

- Database creation and selection
- Table creation with primary keys and foreign keys
- Appropriate data types and integrity constraints
- Sample data insertion with at least five records in each required table
- Basic `SELECT` queries
- Multi-table `JOIN` queries
- Nested queries and subqueries
- Aggregate functions with `GROUP BY`
- Demonstration of `UPDATE` and `DELETE` operations
- View creation
- Trigger creation and testing

---

## How to Run

To deploy and test the Smart Clinic Database System, follow these technical steps:

1.  **Environment Setup**: Ensure **MySQL Server 8.0+** and **MySQL Workbench** are installed and running on your local machine.
2.  **Database Initialization**: Open and execute the `database/smart_clinic_database.sql` script. This will automatically create the `SmartClinic` schema, define all relational tables with appropriate constraints, and populate them with initial sample data.
3.  **Schema Verification**: Run `SHOW TABLES;` to confirm the creation of the 8 core tables (PERSON, PATIENT, DOCTOR, MEDICINE, APPOINTMENT, TREATMENT, PAYMENT, and TREATMENT_MEDICINE).
4.  **Operational Testing**: Execute the labeled SQL queries within the script to verify the implementation of multi-table JOINs, nested subqueries, aggregate functions, and the functionality of implemented Views and Triggers.
5.  **Data Integrity**: The script includes specific `UPDATE` and `DELETE` statements to demonstrate referential integrity and constraint enforcement within the relational model.

---

## Task Distribution Among Team Members

| Task | Responsibility | Member |
|---|---|---|
| Group Leadership and Repository Management | <ul><li>Group Leader</li><li>Repository Manager</li><li>Team coordination</li><li>Repository review and submission prep</li></ul> | **SULTAN ALJOHANI** (240035689) |
| Task 1: Database Design | <ul><li>ER/EER diagram design</li><li>Entity and attribute identification</li><li>Primary and foreign key definitions</li><li>Generalization/specialization hierarchy</li></ul> | **SULTAN ALJOHANI** (240035689) |
| Task 2: Database Implementation | <ul><li>Relational table creation</li><li>Data type and constraint specification</li><li>Sample record insertion</li></ul> | **Amjad Najmi** (240020509) |
| Task 3: SQL Operations | <ul><li>SELECT and JOIN operations</li><li>Nested and aggregate queries</li><li>UPDATE, DELETE, VIEW, and TRIGGER implementation</li></ul> | **Abdulaziz Alharbi** (250021379) |
| Task 4: Reflection | <ul><li>Teamwork and challenge analysis</li><li>Design decision documentation</li><li>Learning outcomes and future improvements</li></ul> | **All Members** |
| Final Report and Documentation | <ul><li>Final report compilation</li><li>Screenshot organization</li></ul> | **All Members** |

---

## Project Status

The repository structure, database description, EER feature, implementation scope, operating instructions, and team responsibilities are documented consistently in this README. Final technical validation should be completed by executing `database/smart_clinic_database.sql` and comparing the generated objects and results with the final ER/EER diagram and report.
