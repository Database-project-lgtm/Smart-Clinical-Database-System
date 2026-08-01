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
Smart-Clinic-Database-System/
|-- README.md
|-- database/
|   `-- smart_clinic_database.sql
|-- docs/
|   |-- Smart_Clinic_Final_Report.docx
|   |-- Smart_Clinic_Mid_Project_Progress_Report.docx
|   `-- Smart_Clinic_Team_Contribution_Record.docx
|-- diagrams/
|   `-- smart_clinic_erd.png
`-- evidence/
    `-- screenshots/
```

The complete ER/EER diagram is available in [`diagrams/smart_clinic_erd.png`](diagrams/smart_clinic_erd.png).

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

## How to Use

### 1. Requirements

Install the following software before running the project:

- MySQL Server 8.0 or later
- MySQL Workbench 8.0 or later
- A local MySQL user account with permission to create databases, tables, views, and triggers
- Git is optional and is needed only when cloning the repository through the command line

### 2. Obtain the Project Files

Download the repository as a ZIP file from GitHub and extract it, or clone it using the repository's **Code** button. After extraction, confirm that the following files are present:

- `database/smart_clinic_database.sql`
- `diagrams/smart_clinic_erd.png`
- `README.md`

The SQL file must remain inside the `database` folder so that the documented command-line path works correctly.

### 3. Start MySQL

1. Start the MySQL Server service.
2. Open MySQL Workbench.
3. Open an existing local connection or create a new connection.
4. Enter the MySQL username and password when requested.
5. Confirm that the connection opens successfully before loading the script.

### 4. Run the SQL File in MySQL Workbench

1. From the MySQL Workbench menu, select **File > Open SQL Script**.
2. Open `database/smart_clinic_database.sql` from the project folder.
3. Review the script and confirm that the selected connection is a local academic or test database environment.
4. Click the **Execute All or Selection** lightning-bolt button, or press `Ctrl + Shift + Enter`.
5. Wait until the script finishes executing.
6. Review the **Action Output** panel and confirm that the statements completed without red error messages.
7. In the **SCHEMAS** panel, click the refresh icon.
8. Locate the database created by the script and double-click its name to set it as the default schema.
9. Expand **Tables**, **Views**, and **Triggers** to confirm that the database objects were created.

> **Important:** Run the project only in a local test environment. The script includes demonstrations of `UPDATE` and `DELETE`; these statements should use the intended transaction and rollback logic when they are included only as academic evidence.

### 5. Verify the Database Tables and Data

Run the following statement after selecting the database created by the script:

```sql
SHOW TABLES;
```

The design should include the following relations:

```text
PERSON
PATIENT
DOCTOR
MEDICINE
APPOINTMENT
TREATMENT
PAYMENT
TREATMENT_MEDICINE
```

Next, inspect the inserted sample data:

```sql
SELECT * FROM PERSON;
SELECT * FROM PATIENT;
SELECT * FROM DOCTOR;
SELECT * FROM MEDICINE;
SELECT * FROM APPOINTMENT;
SELECT * FROM TREATMENT;
SELECT * FROM PAYMENT;
SELECT * FROM TREATMENT_MEDICINE;
```

If the MySQL installation treats table names as case-sensitive, use the exact capitalization displayed by `SHOW TABLES`.

### 6. Verify the View and Trigger

To display all views in the selected database, run:

```sql
SHOW FULL TABLES WHERE Table_type = 'VIEW';
```

To display the installed triggers, run:

```sql
SHOW TRIGGERS;
```

Run the view's `SELECT` statement and the trigger test statements included in `smart_clinic_database.sql`. Confirm that the view returns the expected joined information and that the trigger performs its defined action without violating any constraint.

### 7. Review the Required SQL Operations

The SQL file is organized into labeled sections. Execute the required queries individually and verify the output for each of the following:

1. Basic `SELECT` query
2. Conditional query using `WHERE`
3. Multi-table `JOIN`
4. Nested query or subquery
5. Aggregate query using `COUNT`, `SUM`, or `AVG` with `GROUP BY`
6. `UPDATE` operation
7. `DELETE` operation
8. View query
9. Trigger test

For academic evidence, capture the SQL statement and its complete result grid in the same screenshot whenever possible.

### 8. Command-Line Method

As an alternative to MySQL Workbench, open a terminal in the folder that contains `Smart-Clinic-Database-System`, enter the project folder, and run:

```bash
cd Smart-Clinic-Database-System
mysql -u root -p < database/smart_clinic_database.sql
```

Enter the MySQL password when prompted. If a different MySQL username is used, replace `root` in the command with that username.

To verify the imported database from the command line, connect to MySQL:

```bash
mysql -u root -p
```

Then run:

```sql
SHOW DATABASES;
```

Select the database created by the script and continue with the verification statements provided above.

### 9. View the ER/EER Diagram

Open `diagrams/smart_clinic_erd.png` and verify that it clearly displays:

- All entities and their attributes
- Primary and foreign keys
- Relationship names
- Cardinality and participation constraints
- The PERSON, PATIENT, and DOCTOR generalization/specialization hierarchy
- The associative entity between TREATMENT and MEDICINE

### 10. Collect Screenshot Evidence

Save the required screenshots inside `evidence/screenshots/`. Recommended evidence includes:

- Successful execution of the complete SQL script
- The populated tables
- Results of the required `SELECT`, `JOIN`, nested, and aggregate queries
- Evidence of the `UPDATE` and `DELETE` demonstrations
- View output
- Trigger creation and test output
- ER/EER diagram

Use clear filenames such as `01_database_created.png`, `02_patient_table.png`, and `03_join_query.png` so that the evidence is easy to match with the final report.

### 11. Common Troubleshooting

| Problem | Recommended action |
|---|---|
| `Access denied` | Confirm the MySQL username, password, and account privileges. |
| MySQL server is unavailable | Start the MySQL service and test the Workbench connection again. |
| Database or table already exists | Review the script's `DROP` and `IF EXISTS` statements, or run it in a fresh local test environment. Do not delete unrelated data. |
| Foreign-key constraint error | Execute the full script in its original order so that parent records are created before dependent records. |
| View or trigger is missing | Confirm that the MySQL account has `CREATE VIEW` and `TRIGGER` privileges, then rerun the relevant section. |
| Table name is not recognized | Use the exact table-name capitalization returned by `SHOW TABLES`. |
| SQL file path is not found | Confirm that the terminal is currently inside the repository root and that the SQL file remains in the `database` folder. |

---

## Task Distribution Among Team Members

| Task | Responsibility | Member |
|---|---|---|
| Task 1: Database Design | Designed the ER/EER diagram, identified entities and attributes, defined primary and foreign keys, specified relationships and cardinalities, and implemented the generalization/specialization hierarchy | **SULTAN ALJOHANI** (240035689) |
| Task 2: Database Implementation | Created the relational tables with suitable data types and constraints and inserted the required sample records | **Amjad Najmi** (240020509) |
| Task 3: SQL Operations | Developed and tested the required SELECT, JOIN, nested, aggregate, UPDATE, DELETE, VIEW, and TRIGGER operations | **Abdulaziz Alharbi** (250021379) |
| Task 4: Reflection | Jointly wrote the 300–500-word reflection addressing teamwork, challenges, design decisions, learning outcomes, and possible future improvements | **All Members** |
| Final Report and Documentation | Compiled the final report, organized the screenshots, reviewed the repository, and prepared the submission files | **All Members** |

---

## Project Status

The repository structure, database description, EER feature, implementation scope, operating instructions, and team responsibilities are documented consistently in this README. Final technical validation should be completed by executing `database/smart_clinic_database.sql` and comparing the generated objects and results with the final ER/EER diagram and report.
