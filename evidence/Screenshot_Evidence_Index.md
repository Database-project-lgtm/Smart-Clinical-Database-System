# Smart Clinic Database System

## Screenshot Evidence Index

This file maps every MySQL Workbench screenshot in `evidence/screenshots/` to the corresponding requirement and figure used in the final project report. 

## Evidence Summary

- Total screenshots: **23 JPG files**
- Task 2 evidence: **11 screenshots**
- Task 3 evidence: **12 screenshots**
- Database: `smart_clinic_system`
- DBMS: MySQL 8.0 or newer
- Execution interface: MySQL Workbench


## Repository Location

```text
evidence/
├── Screenshot_Evidence_Index.md
└── screenshots/
    ├── 01_database_objects.jpg
    ├── 02_clinic_person_table.jpg
    ├── ...
    └── 23_trigger_part_b.jpg
```

## Task 2 - Database Implementation Evidence

| Report Reference | Screenshot | Evidence Purpose | Verified Result |
|---|---|---|---|
| Figure 2.1 | [01_database_objects.jpg](screenshots/01_database_objects.jpg) | Database object inventory | 10 base tables and the `vw_visit_financial_status` view are displayed. |
| Figure 2.2 | [02_clinic_person_table.jpg](screenshots/02_clinic_person_table.jpg) | `CLINIC_PERSON` populated table | 10 records are returned. |
| Figure 2.3 | [03_patient_table.jpg](screenshots/03_patient_table.jpg) | `PATIENT` populated table | 5 records are returned. |
| Figure 2.4 | [04_specialty_table.jpg](screenshots/04_specialty_table.jpg) | `SPECIALTY` populated table | 5 records are returned. |
| Figure 2.5 | [05_doctor_table.jpg](screenshots/05_doctor_table.jpg) | `DOCTOR` populated table | 5 records are returned. |
| Figure 2.6 | [06_appointment_table.jpg](screenshots/06_appointment_table.jpg) | `APPOINTMENT` populated table | 7 records are returned. |
| Figure 2.7 | [07_consultation_table.jpg](screenshots/07_consultation_table.jpg) | `CONSULTATION` populated table | 5 records are returned. |
| Figure 2.8 | [08_medication_table.jpg](screenshots/08_medication_table.jpg) | `MEDICATION` populated table | 7 records are returned. |
| Figure 2.9 | [09_prescription_table.jpg](screenshots/09_prescription_table.jpg) | `PRESCRIPTION` populated table | 5 records are returned. |
| Figure 2.10 | [10_prescription_item_table.jpg](screenshots/10_prescription_item_table.jpg) | `PRESCRIPTION_ITEM` populated table | 7 records are returned. |
| Figure 2.11 | [11_payment_table.jpg](screenshots/11_payment_table.jpg) | `PAYMENT` populated table | 7 records are returned. |

## Task 3 - SQL Operations Evidence

| Report Reference | Screenshot | SQL Requirement | Verified Result |
|---|---|---|---|
| Figure 3.1 | [12_select_completed.jpg](screenshots/12_select_completed.jpg) | SELECT completed appointments | 5 completed appointments are returned. |
| Figure 3.2 | [13_select_low_stock.jpg](screenshots/13_select_low_stock.jpg) | SELECT medications at or below reorder level | 4 low-stock medications are returned. |
| Figure 3.3 | [14_join_appointments.jpg](screenshots/14_join_appointments.jpg) | JOIN appointment, patient, doctor, and specialty details | 7 appointment rows are returned. |
| Figure 3.4 | [15_join_prescriptions.jpg](screenshots/15_join_prescriptions.jpg) | JOIN patients, consultations, prescriptions, items, and medications | 7 prescribed medication rows are returned. |
| Figure 3.5 | [16_nested_payments.jpg](screenshots/16_nested_payments.jpg) | Nested query for patients above the average paid total | Patient IDs `102` and `105` are returned. |
| Figure 3.6A | [17_group_by_part_a.jpg](screenshots/17_group_by_part_a.jpg) | Aggregate functions and GROUP BY, Part A | The first portion of the doctor-summary query and evidence is displayed. |
| Figure 3.6B | [18_group_by_part_b.jpg](screenshots/18_group_by_part_b.jpg) | Aggregate functions and GROUP BY, Part B | The complete result contains 5 doctor summary rows. |
| Figure 3.7 | [19_update_rollback.jpg](screenshots/19_update_rollback.jpg) | UPDATE with transaction and ROLLBACK | `No insurance` → `Arabian Shield Cooperative` → `No insurance`. |
| Figure 3.8 | [20_delete_rollback.jpg](screenshots/20_delete_rollback.jpg) | DELETE with transaction and ROLLBACK | Before/deleted/after delete/after rollback = `1 | 1 | 0 | 1`. |
| Figure 3.9 | [21_financial_view.jpg](screenshots/21_financial_view.jpg) | Financial VIEW result | The view returns 7 appointment-level financial rows. |
| Figure 3.10A | [22_trigger_part_a.jpg](screenshots/22_trigger_part_a.jpg) | TRIGGER stock-control test, Part A | The transaction and temporary prescription-item inserts are displayed. |
| Figure 3.10B | [23_trigger_part_b.jpg](screenshots/23_trigger_part_b.jpg) | TRIGGER stock-control test, Part B | Medication stock changes `150` → `146` → `150` after ROLLBACK. |

## Evidence Handling Notes

1. Screenshots `17_group_by_part_a.jpg` and `18_group_by_part_b.jpg` are two parts of one GROUP BY operation.
2. Screenshots `22_trigger_part_a.jpg` and `23_trigger_part_b.jpg` are two parts of one TRIGGER verification operation.

