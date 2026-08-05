/*
===============================================================================
Smart Clinic Database System
IT244 - Database Design and Implementation Project

Project Team
1. Sultan Aljohani     - 240035689 - Group Leader, Repository Manager,
                                      and Task 1: Database Design
2. Amjad Najmi         - 240020509 - Task 2: Database Implementation
3. Abdulaziz Alharbi   - 250021379 - Task 3: SQL Operations

This MySQL 8.0 script contains the relational implementation required for
Tasks 1-3. The project reflection is prepared jointly in the final report.
All names, identifiers, contact details, and medical records are fictional.
===============================================================================
*/

-- =============================================================================
-- PART A - DATABASE SETUP AND RELATIONAL DESIGN
-- =============================================================================

DROP DATABASE IF EXISTS smart_clinic_system;

CREATE DATABASE smart_clinic_system
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE smart_clinic_system;
SET NAMES utf8mb4;

/*
EER design summary
------------------
CLINIC_PERSON is the supertype for shared identity and contact attributes.
PATIENT and DOCTOR are total, disjoint subtypes at the application level.

Main relationships
------------------
SPECIALTY      1 ---- M DOCTOR
PATIENT        1 ---- M APPOINTMENT
DOCTOR         1 ---- M APPOINTMENT
APPOINTMENT    1 ---- 0..1 CONSULTATION
CONSULTATION   1 ---- M PRESCRIPTION
PRESCRIPTION   1 ---- M PRESCRIPTION_ITEM
MEDICATION     1 ---- M PRESCRIPTION_ITEM
APPOINTMENT    1 ---- M PAYMENT

PRESCRIPTION_ITEM resolves the many-to-many relationship between
PRESCRIPTION and MEDICATION while storing the dosage and course details.
*/

CREATE TABLE clinic_person (
    person_id              INT            NOT NULL,
    national_identifier    CHAR(10)       NOT NULL,
    first_name             VARCHAR(45)    NOT NULL,
    last_name              VARCHAR(65)    NOT NULL,
    birth_date             DATE           NOT NULL,
    sex                    ENUM('Female', 'Male') NOT NULL,
    mobile_number          VARCHAR(13)    NOT NULL,
    email_address          VARCHAR(120)   NULL,
    city                   VARCHAR(60)    NOT NULL,
    CONSTRAINT pk_clinic_person PRIMARY KEY (person_id),
    CONSTRAINT uq_clinic_person_national UNIQUE (national_identifier),
    CONSTRAINT uq_clinic_person_mobile UNIQUE (mobile_number),
    CONSTRAINT uq_clinic_person_email UNIQUE (email_address),
    CONSTRAINT ck_clinic_person_national
        CHECK (national_identifier REGEXP '^[12][0-9]{9}$'),
    CONSTRAINT ck_clinic_person_mobile
        CHECK (mobile_number REGEXP '^\\+9665[0-9]{8}$')
) ENGINE = InnoDB;

CREATE TABLE patient (
    patient_id             INT            NOT NULL,
    medical_record_no      VARCHAR(12)    NOT NULL,
    blood_group            ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    insurance_company      VARCHAR(100)   NULL,
    emergency_contact_name VARCHAR(100)   NOT NULL,
    emergency_mobile       VARCHAR(13)    NOT NULL,
    registered_on          DATE           NOT NULL,
    CONSTRAINT pk_patient PRIMARY KEY (patient_id),
    CONSTRAINT uq_patient_medical_record UNIQUE (medical_record_no),
    CONSTRAINT fk_patient_person
        FOREIGN KEY (patient_id) REFERENCES clinic_person (person_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_patient_emergency_mobile
        CHECK (emergency_mobile REGEXP '^\\+9665[0-9]{8}$')
) ENGINE = InnoDB;

CREATE TABLE specialty (
    specialty_id           SMALLINT       NOT NULL,
    specialty_name         VARCHAR(80)    NOT NULL,
    clinic_zone            VARCHAR(20)    NOT NULL,
    standard_slot_minutes  SMALLINT       NOT NULL DEFAULT 30,
    CONSTRAINT pk_specialty PRIMARY KEY (specialty_id),
    CONSTRAINT uq_specialty_name UNIQUE (specialty_name),
    CONSTRAINT ck_specialty_slot
        CHECK (standard_slot_minutes BETWEEN 15 AND 120)
) ENGINE = InnoDB;

CREATE TABLE doctor (
    doctor_id              INT            NOT NULL,
    specialty_id           SMALLINT       NOT NULL,
    professional_license   VARCHAR(25)    NOT NULL,
    office_code            VARCHAR(12)    NOT NULL,
    hired_on               DATE           NOT NULL,
    consultation_fee       DECIMAL(9, 2)  NOT NULL,
    availability_status    ENUM('Active', 'Leave', 'Inactive') NOT NULL DEFAULT 'Active',
    CONSTRAINT pk_doctor PRIMARY KEY (doctor_id),
    CONSTRAINT uq_doctor_license UNIQUE (professional_license),
    CONSTRAINT uq_doctor_office UNIQUE (office_code),
    CONSTRAINT fk_doctor_person
        FOREIGN KEY (doctor_id) REFERENCES clinic_person (person_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_doctor_specialty
        FOREIGN KEY (specialty_id) REFERENCES specialty (specialty_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_doctor_fee CHECK (consultation_fee >= 0)
) ENGINE = InnoDB;

CREATE TABLE appointment (
    appointment_id         INT            NOT NULL,
    patient_id             INT            NOT NULL,
    doctor_id              INT            NOT NULL,
    starts_at              DATETIME       NOT NULL,
    planned_minutes        SMALLINT       NOT NULL,
    appointment_status     ENUM('Booked', 'Completed', 'Cancelled', 'No Show') NOT NULL DEFAULT 'Booked',
    booking_source         ENUM('Reception', 'Phone', 'Portal', 'Walk-in') NOT NULL,
    visit_reason           VARCHAR(250)   NOT NULL,
    booked_at              TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_appointment PRIMARY KEY (appointment_id),
    CONSTRAINT uq_appointment_doctor_time UNIQUE (doctor_id, starts_at),
    CONSTRAINT uq_appointment_patient_time UNIQUE (patient_id, starts_at),
    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (patient_id) REFERENCES patient (patient_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_appointment_doctor
        FOREIGN KEY (doctor_id) REFERENCES doctor (doctor_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_appointment_minutes
        CHECK (planned_minutes BETWEEN 15 AND 120)
) ENGINE = InnoDB;

CREATE TABLE consultation (
    consultation_id        INT            NOT NULL,
    appointment_id         INT            NOT NULL,
    consulted_at           DATETIME       NOT NULL,
    diagnosis              VARCHAR(220)   NOT NULL,
    assessment_notes       VARCHAR(600)   NOT NULL,
    service_fee            DECIMAL(9, 2)  NOT NULL DEFAULT 0.00,
    follow_up_date         DATE           NULL,
    CONSTRAINT pk_consultation PRIMARY KEY (consultation_id),
    CONSTRAINT uq_consultation_appointment UNIQUE (appointment_id),
    CONSTRAINT fk_consultation_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointment (appointment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_consultation_service_fee CHECK (service_fee >= 0)
) ENGINE = InnoDB;

CREATE TABLE medication (
    medication_id          INT            NOT NULL,
    generic_name           VARCHAR(100)   NOT NULL,
    brand_name             VARCHAR(100)   NOT NULL,
    strength               VARCHAR(35)    NOT NULL,
    dosage_form            ENUM('Tablet', 'Capsule', 'Cream', 'Sachet', 'Suspension', 'Mouthwash', 'Other') NOT NULL,
    unit_price             DECIMAL(9, 2)  NOT NULL,
    stock_on_hand          INT            NOT NULL,
    reorder_level          INT            NOT NULL,
    requires_prescription  BOOLEAN        NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_medication PRIMARY KEY (medication_id),
    CONSTRAINT uq_medication_product
        UNIQUE (brand_name, strength, dosage_form),
    CONSTRAINT ck_medication_price CHECK (unit_price >= 0),
    CONSTRAINT ck_medication_stock CHECK (stock_on_hand >= 0),
    CONSTRAINT ck_medication_reorder CHECK (reorder_level >= 0)
) ENGINE = InnoDB;

CREATE TABLE prescription (
    prescription_id        INT            NOT NULL,
    consultation_id        INT            NOT NULL,
    issued_at              DATETIME       NOT NULL,
    general_instructions   VARCHAR(400)   NULL,
    CONSTRAINT pk_prescription PRIMARY KEY (prescription_id),
    CONSTRAINT fk_prescription_consultation
        FOREIGN KEY (consultation_id) REFERENCES consultation (consultation_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE prescription_item (
    prescription_id        INT            NOT NULL,
    medication_id          INT            NOT NULL,
    dose_description       VARCHAR(100)   NOT NULL,
    frequency_per_day      TINYINT        NOT NULL,
    course_days            SMALLINT       NOT NULL,
    units_dispensed        SMALLINT       NOT NULL,
    administration_route   ENUM('Oral', 'Topical', 'Dental', 'Other') NOT NULL,
    item_instructions      VARCHAR(300)   NULL,
    CONSTRAINT pk_prescription_item
        PRIMARY KEY (prescription_id, medication_id),
    CONSTRAINT fk_prescription_item_header
        FOREIGN KEY (prescription_id) REFERENCES prescription (prescription_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_prescription_item_medication
        FOREIGN KEY (medication_id) REFERENCES medication (medication_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_prescription_item_frequency CHECK (frequency_per_day BETWEEN 1 AND 12),
    CONSTRAINT ck_prescription_item_course CHECK (course_days > 0),
    CONSTRAINT ck_prescription_item_units CHECK (units_dispensed > 0)
) ENGINE = InnoDB;

CREATE TABLE payment (
    payment_id             INT            NOT NULL,
    appointment_id         INT            NOT NULL,
    amount                 DECIMAL(9, 2)  NOT NULL,
    recorded_at            DATETIME       NOT NULL,
    payment_method         ENUM('Cash', 'Card', 'Bank Transfer', 'Insurance') NOT NULL,
    payment_status         ENUM('Pending', 'Paid', 'Refunded', 'Failed') NOT NULL DEFAULT 'Pending',
    payer_type             ENUM('Patient', 'Insurance') NOT NULL,
    receipt_number         VARCHAR(35)    NULL,
    CONSTRAINT pk_payment PRIMARY KEY (payment_id),
    CONSTRAINT uq_payment_receipt UNIQUE (receipt_number),
    CONSTRAINT fk_payment_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointment (appointment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_payment_amount CHECK (amount > 0)
) ENGINE = InnoDB;

-- =============================================================================
-- PART B - FICTIONAL SAMPLE DATA
-- Every principal table contains at least five records.
-- =============================================================================

START TRANSACTION;

INSERT INTO clinic_person
    (person_id, national_identifier, first_name, last_name, birth_date, sex,
     mobile_number, email_address, city)
VALUES
    (101, '1084512376', 'Khalid Mansour', 'Alotaibi',    '1991-05-14', 'Male',   '+966561234501', 'khalid.alotaibi@example.sa',  'Riyadh'),
    (102, '1073625148', 'Rawan Saleh',    'Alghamdi',    '1988-11-02', 'Female', '+966561234502', 'rawan.alghamdi@example.sa',    'Riyadh'),
    (103, '1062748351', 'Salman Turki',   'Alharbi',     '1997-03-26', 'Male',   '+966561234503', 'salman.alharbi@example.sa',     'Al Kharj'),
    (104, '1165832409', 'Hessa Fahad',    'Almutairi',   '2016-08-19', 'Female', '+966561234504', 'hessa.almutairi@example.sa',    'Riyadh'),
    (105, '1051947283', 'Rakan Majed',    'Aldosari',    '1983-12-07', 'Male',   '+966561234505', 'rakan.aldosari@example.sa',     'Diriyah'),
    (201, '1048372615', 'Lina Saad',      'Alqahtani',   '1980-04-10', 'Female', '+966569876501', 'lina.alqahtani@clinic.example.sa', 'Riyadh'),
    (202, '1037461928', 'Bandar Nasser',  'Alshammari',  '1976-09-21', 'Male',   '+966569876502', 'bandar.alshammari@clinic.example.sa', 'Riyadh'),
    (203, '1026583741', 'Abeer Khalid',   'Alzahrani',   '1985-01-16', 'Female', '+966569876503', 'abeer.alzahrani@clinic.example.sa', 'Riyadh'),
    (204, '1019274658', 'Mazen Omar',     'Alsubaie',    '1979-06-30', 'Male',   '+966569876504', 'mazen.alsubaie@clinic.example.sa', 'Riyadh'),
    (205, '1092847365', 'Reem Abdullah',  'Alharbi',     '1984-02-08', 'Female', '+966569876505', 'reem.alharbi@clinic.example.sa', 'Riyadh');

INSERT INTO patient
    (patient_id, medical_record_no, blood_group, insurance_company,
     emergency_contact_name, emergency_mobile, registered_on)
VALUES
    (101, 'MR-260101', 'O+',  'Bupa Arabia',       'Mansour Alotaibi',  '+966551110101', '2026-06-02'),
    (102, 'MR-260102', 'A-',  'Tawuniya',          'Saleh Alghamdi',    '+966551110102', '2026-06-05'),
    (103, 'MR-260103', 'B+',  'MedGulf',           'Turki Alharbi',     '+966551110103', '2026-06-09'),
    (104, 'MR-260104', 'O-',  'Al Rajhi Takaful',  'Fahad Almutairi',   '+966551110104', '2026-06-12'),
    (105, 'MR-260105', 'AB+', NULL,                'Majed Aldosari',    '+966551110105', '2026-06-15');

INSERT INTO specialty
    (specialty_id, specialty_name, clinic_zone, standard_slot_minutes)
VALUES
    (11, 'Family Medicine', 'Ground-G1', 30),
    (22, 'Cardiology',      'First-C1',  45),
    (33, 'Dermatology',     'First-D2',  30),
    (44, 'Pediatrics',      'Second-P1', 30),
    (55, 'Dentistry',       'Second-D3', 60);

INSERT INTO doctor
    (doctor_id, specialty_id, professional_license, office_code, hired_on,
     consultation_fee, availability_status)
VALUES
    (201, 11, 'SCFHS-FM-2601', 'G-104', '2020-03-15', 140.00, 'Active'),
    (202, 22, 'SCFHS-CR-2602', 'C-208', '2018-10-01', 320.00, 'Active'),
    (203, 33, 'SCFHS-DM-2603', 'D-212', '2021-05-20', 240.00, 'Active'),
    (204, 44, 'SCFHS-PD-2604', 'P-305', '2019-01-12', 190.00, 'Active'),
    (205, 55, 'SCFHS-DN-2605', 'D-318', '2022-08-08', 230.00, 'Active');

INSERT INTO appointment
    (appointment_id, patient_id, doctor_id, starts_at, planned_minutes,
     appointment_status, booking_source, visit_reason)
VALUES
    (1101, 101, 201, '2026-07-21 09:00:00', 30, 'Completed', 'Portal',    'Recurring headache and neck muscle tension'),
    (1102, 102, 202, '2026-07-22 10:00:00', 45, 'Completed', 'Reception', 'Elevated home blood pressure readings'),
    (1103, 103, 203, '2026-07-23 11:00:00', 30, 'Completed', 'Phone',     'Dry and inflamed skin on both forearms'),
    (1104, 104, 204, '2026-07-24 13:00:00', 30, 'Completed', 'Reception', 'Vomiting, diarrhea, and reduced appetite'),
    (1105, 105, 205, '2026-07-25 15:00:00', 60, 'Completed', 'Walk-in',   'Bleeding gums and persistent bad breath'),
    (1106, 101, 203, '2026-08-08 16:00:00', 30, 'Booked',    'Portal',    'Follow-up assessment for a new skin lesion'),
    (1107, 102, 201, '2026-07-27 10:30:00', 30, 'Cancelled', 'Phone',     'General fatigue and sleep disturbance');

INSERT INTO consultation
    (consultation_id, appointment_id, consulted_at, diagnosis,
     assessment_notes, service_fee, follow_up_date)
VALUES
    (2101, 1101, '2026-07-21 09:35:00', 'Tension-type headache',
     'Neurological screening was normal. Hydration, posture correction, and short-term analgesia were advised.', 40.00, '2026-08-04'),
    (2102, 1102, '2026-07-22 10:50:00', 'Stage 1 hypertension',
     'Medication was initiated with home pressure monitoring and reduced dietary sodium.', 110.00, '2026-08-19'),
    (2103, 1103, '2026-07-23 11:35:00', 'Atopic dermatitis',
     'The patient was advised to avoid fragranced products and use a short topical treatment course.', 60.00, '2026-08-06'),
    (2104, 1104, '2026-07-24 13:35:00', 'Viral gastroenteritis',
     'Oral rehydration, light meals, temperature observation, and warning-sign education were provided.', 50.00, NULL),
    (2105, 1105, '2026-07-25 16:05:00', 'Gingivitis with dental calculus',
     'Professional cleaning was completed and oral hygiene instructions were demonstrated.', 180.00, '2026-08-22');

INSERT INTO medication
    (medication_id, generic_name, brand_name, strength, dosage_form, unit_price,
     stock_on_hand, reorder_level, requires_prescription)
VALUES
    (3101, 'Ibuprofen',               'Brufen',          '400 mg',       'Tablet',     1.10,  70, 80, FALSE),
    (3102, 'Azithromycin',            'Zithromax',       '250 mg',       'Capsule',    4.50, 150, 50, TRUE),
    (3103, 'Losartan',                'Cozaar',           '50 mg',        'Tablet',     2.20,  65, 70, TRUE),
    (3104, 'Mometasone furoate',      'Elocon',           '0.1%',         'Cream',     22.00,  35, 40, TRUE),
    (3105, 'Oral rehydration salts',  'Hydralyte',        '20.5 g',       'Sachet',     3.75, 120, 60, FALSE),
    (3106, 'Chlorhexidine',           'Corsodyl',         '0.2%',         'Mouthwash', 18.00,  45, 50, FALSE),
    (3107, 'Paracetamol',             'Panadol Children', '120 mg/5 mL',  'Suspension', 16.50,  90, 50, FALSE);

INSERT INTO prescription
    (prescription_id, consultation_id, issued_at, general_instructions)
VALUES
    (4101, 2101, '2026-07-21 09:38:00', 'Use only when the headache interferes with daily activity.'),
    (4102, 2102, '2026-07-22 10:53:00', 'Measure blood pressure at home and record the readings.'),
    (4103, 2103, '2026-07-23 11:38:00', 'Stop use and contact the clinic if irritation becomes worse.'),
    (4104, 2104, '2026-07-24 13:38:00', 'Give frequent fluids and monitor for signs of dehydration.'),
    (4105, 2105, '2026-07-25 16:08:00', 'Continue brushing and flossing carefully during treatment.');

INSERT INTO prescription_item
    (prescription_id, medication_id, dose_description, frequency_per_day,
     course_days, units_dispensed, administration_route, item_instructions)
VALUES
    (4101, 3101, 'One tablet after food',       2,  5, 10, 'Oral',    'Do not take on an empty stomach.'),
    (4102, 3103, 'One tablet',                  1, 30, 30, 'Oral',    'Take at the same time every day.'),
    (4103, 3104, 'Apply a thin layer',          2,  7,  1, 'Topical', 'Apply only to affected skin.'),
    (4104, 3105, 'One sachet in clean water',   3,  3,  9, 'Oral',    'Prepare a fresh solution each time.'),
    (4104, 3107, 'Ten milliliters when needed', 3,  3,  1, 'Oral',    'Use the supplied measuring device.'),
    (4105, 3106, 'Rinse with 15 milliliters',   2,  7,  1, 'Dental',  'Do not swallow the mouthwash.'),
    (4105, 3101, 'One tablet after food',       2,  3,  6, 'Oral',    'Use only for post-cleaning discomfort.');

INSERT INTO payment
    (payment_id, appointment_id, amount, recorded_at, payment_method,
     payment_status, payer_type, receipt_number)
VALUES
    (5101, 1101, 180.00, '2026-07-21 09:45:00', 'Cash',          'Paid',    'Patient',   'RC-260721-01'),
    (5102, 1102, 250.00, '2026-07-22 10:55:00', 'Insurance',     'Paid',    'Insurance', 'RC-260722-01'),
    (5103, 1102, 180.00, '2026-07-22 10:57:00', 'Card',          'Paid',    'Patient',   'RC-260722-02'),
    (5104, 1103, 300.00, '2026-07-23 11:42:00', 'Card',          'Paid',    'Patient',   'RC-260723-01'),
    (5105, 1104, 240.00, '2026-07-24 13:42:00', 'Insurance',     'Paid',    'Insurance', 'RC-260724-01'),
    (5106, 1105, 410.00, '2026-07-25 16:12:00', 'Bank Transfer', 'Paid',    'Patient',   'RC-260725-01'),
    (5107, 1106,  50.00, '2026-08-03 14:10:00', 'Card',          'Pending', 'Patient',   NULL);

COMMIT;

-- =============================================================================
-- PART C - TASK 2 VERIFICATION AND SCREENSHOT QUERIES
-- Run each statement separately so the code and its result appear together.
-- =============================================================================

SHOW TABLES FROM smart_clinic_system;

SELECT 'clinic_person' AS table_name, COUNT(*) AS row_count FROM clinic_person
UNION ALL SELECT 'patient', COUNT(*) FROM patient
UNION ALL SELECT 'specialty', COUNT(*) FROM specialty
UNION ALL SELECT 'doctor', COUNT(*) FROM doctor
UNION ALL SELECT 'appointment', COUNT(*) FROM appointment
UNION ALL SELECT 'consultation', COUNT(*) FROM consultation
UNION ALL SELECT 'medication', COUNT(*) FROM medication
UNION ALL SELECT 'prescription', COUNT(*) FROM prescription
UNION ALL SELECT 'prescription_item', COUNT(*) FROM prescription_item
UNION ALL SELECT 'payment', COUNT(*) FROM payment;

SELECT * FROM clinic_person ORDER BY person_id;
SELECT * FROM patient ORDER BY patient_id;
SELECT * FROM specialty ORDER BY specialty_id;
SELECT * FROM doctor ORDER BY doctor_id;
SELECT * FROM appointment ORDER BY starts_at;
SELECT * FROM consultation ORDER BY consultation_id;
SELECT * FROM medication ORDER BY medication_id;
SELECT * FROM prescription ORDER BY prescription_id;
SELECT * FROM prescription_item ORDER BY prescription_id, medication_id;
SELECT * FROM payment ORDER BY payment_id;

-- =============================================================================
-- PART D - TASK 3 SQL OPERATIONS
-- Each assessed operation has a purpose statement and a verifiable result.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- TASK 3.1A - SELECT STATEMENT
-- Purpose: Display completed appointments in chronological order for the
-- clinic's completed-visit register.
-- -----------------------------------------------------------------------------
SELECT
    appointment_id,
    starts_at,
    planned_minutes,
    booking_source,
    visit_reason
FROM appointment
WHERE appointment_status = 'Completed'
ORDER BY starts_at;

-- -----------------------------------------------------------------------------
-- TASK 3.1B - SELECT STATEMENT
-- Purpose: Identify products that have reached or fallen below their reorder
-- thresholds so the clinic can prioritize replenishment.
-- -----------------------------------------------------------------------------
SELECT
    medication_id,
    brand_name,
    strength,
    stock_on_hand,
    reorder_level,
    (reorder_level - stock_on_hand) AS units_below_target
FROM medication
WHERE stock_on_hand <= reorder_level
ORDER BY stock_on_hand, brand_name;

-- -----------------------------------------------------------------------------
-- TASK 3.2A - JOIN QUERY
-- Purpose: Produce a readable appointment schedule containing the patient,
-- doctor, specialty, booking status, and appointment time.
-- -----------------------------------------------------------------------------
SELECT
    a.appointment_id,
    a.starts_at,
    CONCAT(pp.first_name, ' ', pp.last_name) AS patient_name,
    CONCAT(dp.first_name, ' ', dp.last_name) AS doctor_name,
    s.specialty_name,
    a.appointment_status
FROM appointment AS a
JOIN patient AS p
    ON p.patient_id = a.patient_id
JOIN clinic_person AS pp
    ON pp.person_id = p.patient_id
JOIN doctor AS d
    ON d.doctor_id = a.doctor_id
JOIN clinic_person AS dp
    ON dp.person_id = d.doctor_id
JOIN specialty AS s
    ON s.specialty_id = d.specialty_id
ORDER BY a.starts_at;

-- -----------------------------------------------------------------------------
-- TASK 3.2B - JOIN QUERY
-- Purpose: Connect patients and diagnoses with the medicines issued to them,
-- including dosage, course length, and administration route.
-- -----------------------------------------------------------------------------
SELECT
    pat.medical_record_no,
    CONCAT(cp.first_name, ' ', cp.last_name) AS patient_name,
    c.diagnosis,
    m.brand_name AS medication,
    m.strength,
    pi.dose_description,
    pi.frequency_per_day,
    pi.course_days,
    pi.administration_route
FROM patient AS pat
JOIN clinic_person AS cp
    ON cp.person_id = pat.patient_id
JOIN appointment AS a
    ON a.patient_id = pat.patient_id
JOIN consultation AS c
    ON c.appointment_id = a.appointment_id
JOIN prescription AS pr
    ON pr.consultation_id = c.consultation_id
JOIN prescription_item AS pi
    ON pi.prescription_id = pr.prescription_id
JOIN medication AS m
    ON m.medication_id = pi.medication_id
ORDER BY patient_name, medication;

-- -----------------------------------------------------------------------------
-- TASK 3.3 - NESTED QUERY
-- Purpose: Find patients whose total completed payments are higher than the
-- average total paid per paying patient, rather than the average single payment.
-- -----------------------------------------------------------------------------
SELECT
    pat.patient_id,
    pat.medical_record_no,
    CONCAT(cp.first_name, ' ', cp.last_name) AS patient_name,
    SUM(pay.amount) AS patient_paid_total
FROM patient AS pat
JOIN clinic_person AS cp
    ON cp.person_id = pat.patient_id
JOIN appointment AS a
    ON a.patient_id = pat.patient_id
JOIN payment AS pay
    ON pay.appointment_id = a.appointment_id
WHERE pay.payment_status = 'Paid'
GROUP BY pat.patient_id, pat.medical_record_no, cp.first_name, cp.last_name
HAVING SUM(pay.amount) > (
    SELECT AVG(patient_total)
    FROM (
        SELECT
            a2.patient_id,
            SUM(pay2.amount) AS patient_total
        FROM appointment AS a2
        JOIN payment AS pay2
            ON pay2.appointment_id = a2.appointment_id
        WHERE pay2.payment_status = 'Paid'
        GROUP BY a2.patient_id
    ) AS paid_by_patient
)
ORDER BY patient_paid_total DESC;

-- -----------------------------------------------------------------------------
-- TASK 3.4 - AGGREGATE FUNCTIONS WITH GROUP BY
-- Purpose: Summarize each doctor's bookings, completed visits, average visit
-- length, completed-visit charges, and collected payments. Payment totals are
-- aggregated by appointment before the main join to avoid duplicated charges.
-- -----------------------------------------------------------------------------
SELECT
    d.doctor_id,
    CONCAT(cp.first_name, ' ', cp.last_name) AS doctor_name,
    s.specialty_name,
    COUNT(a.appointment_id) AS total_bookings,
    SUM(CASE WHEN a.appointment_status = 'Completed' THEN 1 ELSE 0 END)
        AS completed_visits,
    ROUND(AVG(CASE WHEN a.appointment_status = 'Completed'
                   THEN a.planned_minutes END), 2)
        AS average_completed_minutes,
    COALESCE(SUM(CASE WHEN a.appointment_status = 'Completed'
                      THEN d.consultation_fee + COALESCE(c.service_fee, 0)
                      ELSE 0 END), 0.00)
        AS completed_visit_charges,
    COALESCE(SUM(pt.net_paid), 0.00) AS net_collected
FROM doctor AS d
JOIN clinic_person AS cp
    ON cp.person_id = d.doctor_id
JOIN specialty AS s
    ON s.specialty_id = d.specialty_id
LEFT JOIN appointment AS a
    ON a.doctor_id = d.doctor_id
LEFT JOIN consultation AS c
    ON c.appointment_id = a.appointment_id
LEFT JOIN (
    SELECT
        appointment_id,
        SUM(CASE
                WHEN payment_status = 'Paid' THEN amount
                WHEN payment_status = 'Refunded' THEN -amount
                ELSE 0
            END) AS net_paid
    FROM payment
    GROUP BY appointment_id
) AS pt
    ON pt.appointment_id = a.appointment_id
GROUP BY d.doctor_id, cp.first_name, cp.last_name, s.specialty_name
ORDER BY completed_visits DESC, doctor_name;

-- -----------------------------------------------------------------------------
-- TASK 3.5 - UPDATE STATEMENT
-- Purpose: Demonstrate adding an insurance provider to an uninsured patient's
-- profile. ROLLBACK restores the original academic data after verification.
-- -----------------------------------------------------------------------------
SET @insurance_before = (
    SELECT COALESCE(insurance_company, 'No insurance')
    FROM patient
    WHERE patient_id = 105
);

START TRANSACTION;

UPDATE patient
SET insurance_company = 'Arabian Shield Cooperative'
WHERE patient_id = 105;

SELECT
    patient_id,
    medical_record_no,
    @insurance_before AS insurance_before_update,
    insurance_company AS insurance_after_update
FROM patient
WHERE patient_id = 105;

ROLLBACK;

SELECT
    patient_id,
    COALESCE(insurance_company, 'No insurance') AS insurance_after_rollback
FROM patient
WHERE patient_id = 105;

-- -----------------------------------------------------------------------------
-- TASK 3.6 - DELETE STATEMENT
-- Purpose: Demonstrate deletion of a pending payment authorization and verify
-- that ROLLBACK restores the row for subsequent project operations.
-- -----------------------------------------------------------------------------
SET @pending_before_delete = (
    SELECT COUNT(*)
    FROM payment
    WHERE payment_id = 5107
      AND payment_status = 'Pending'
);

START TRANSACTION;

DELETE FROM payment
WHERE payment_id = 5107
  AND payment_status = 'Pending';

SET @deleted_payment_rows = ROW_COUNT();

SET @pending_after_delete = (
    SELECT COUNT(*)
    FROM payment
    WHERE payment_id = 5107
);

ROLLBACK;

SET @pending_after_rollback = (
    SELECT COUNT(*)
    FROM payment
    WHERE payment_id = 5107
);

SELECT
    @pending_before_delete AS rows_before_delete,
    @deleted_payment_rows AS deleted_rows,
    @pending_after_delete AS rows_after_delete,
    @pending_after_rollback AS rows_after_rollback;

-- -----------------------------------------------------------------------------
-- TASK 3.7 - VIEW
-- Purpose: Create a reusable visit-level financial report showing expected
-- charges, net payments, and outstanding balances for every appointment.
-- -----------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_visit_financial_status;

CREATE VIEW vw_visit_financial_status AS
SELECT
    a.appointment_id,
    a.starts_at,
    CONCAT(pp.first_name, ' ', pp.last_name) AS patient_name,
    CONCAT(dp.first_name, ' ', dp.last_name) AS doctor_name,
    s.specialty_name,
    a.appointment_status,
    c.diagnosis,
    CASE
        WHEN c.consultation_id IS NULL THEN NULL
        ELSE d.consultation_fee + c.service_fee
    END AS expected_charge,
    COALESCE(SUM(CASE
                     WHEN pay.payment_status = 'Paid' THEN pay.amount
                     WHEN pay.payment_status = 'Refunded' THEN -pay.amount
                     ELSE 0
                 END), 0.00) AS net_paid,
    CASE
        WHEN c.consultation_id IS NULL THEN NULL
        ELSE (d.consultation_fee + c.service_fee)
             - COALESCE(SUM(CASE
                                WHEN pay.payment_status = 'Paid' THEN pay.amount
                                WHEN pay.payment_status = 'Refunded' THEN -pay.amount
                                ELSE 0
                            END), 0.00)
    END AS outstanding_balance
FROM appointment AS a
JOIN patient AS pat
    ON pat.patient_id = a.patient_id
JOIN clinic_person AS pp
    ON pp.person_id = pat.patient_id
JOIN doctor AS d
    ON d.doctor_id = a.doctor_id
JOIN clinic_person AS dp
    ON dp.person_id = d.doctor_id
JOIN specialty AS s
    ON s.specialty_id = d.specialty_id
LEFT JOIN consultation AS c
    ON c.appointment_id = a.appointment_id
LEFT JOIN payment AS pay
    ON pay.appointment_id = a.appointment_id
GROUP BY
    a.appointment_id,
    a.starts_at,
    pp.first_name,
    pp.last_name,
    dp.first_name,
    dp.last_name,
    s.specialty_name,
    a.appointment_status,
    c.consultation_id,
    c.diagnosis,
    d.consultation_fee,
    c.service_fee;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SELECT *
FROM vw_visit_financial_status
ORDER BY starts_at;

-- -----------------------------------------------------------------------------
-- TASK 3.8 - TRIGGER
-- Purpose: Prevent a prescription from dispensing more units than available
-- and deduct the dispensed quantity from medication inventory automatically.
-- -----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_prescription_item_reduce_stock;

DELIMITER $$

CREATE TRIGGER trg_prescription_item_reduce_stock
BEFORE INSERT ON prescription_item
FOR EACH ROW
BEGIN
    DECLARE v_stock_available INT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_stock_available = NULL;

    SELECT stock_on_hand
    INTO v_stock_available
    FROM medication
    WHERE medication_id = NEW.medication_id;

    IF v_stock_available IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Medication record was not found.';
    ELSEIF NEW.units_dispensed > v_stock_available THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Requested quantity exceeds available clinic stock.';
    ELSE
        UPDATE medication
        SET stock_on_hand = stock_on_hand - NEW.units_dispensed
        WHERE medication_id = NEW.medication_id;
    END IF;
END$$

DELIMITER ;

SHOW TRIGGERS FROM smart_clinic_system LIKE 'prescription_item';

-- Trigger test: a temporary prescription dispenses four units of medication
-- 3102. The stock changes from 150 to 146, then ROLLBACK restores it to 150.
SET @stock_before_trigger = (
    SELECT stock_on_hand
    FROM medication
    WHERE medication_id = 3102
);

START TRANSACTION;

INSERT INTO prescription
    (prescription_id, consultation_id, issued_at, general_instructions)
VALUES
    (4199, 2104, '2026-07-24 13:45:00',
     'Temporary prescription used to verify the inventory trigger.');

INSERT INTO prescription_item
    (prescription_id, medication_id, dose_description, frequency_per_day,
     course_days, units_dispensed, administration_route, item_instructions)
VALUES
    (4199, 3102, 'One capsule', 1, 4, 4, 'Oral',
     'Temporary item used only during the trigger test.');

SET @stock_after_trigger = (
    SELECT stock_on_hand
    FROM medication
    WHERE medication_id = 3102
);

ROLLBACK;

SET @stock_after_rollback = (
    SELECT stock_on_hand
    FROM medication
    WHERE medication_id = 3102
);

SELECT
    @stock_before_trigger AS stock_before_trigger,
    @stock_after_trigger AS stock_after_trigger,
    @stock_after_rollback AS stock_after_rollback;

/*
Optional negative trigger test
------------------------------
Run the following statement separately if evidence of the rejection rule is
required. MySQL should return the custom "Requested quantity exceeds available
clinic stock" error. It is commented out so the complete script runs without an
intentional failure.

INSERT INTO prescription_item
    (prescription_id, medication_id, dose_description, frequency_per_day,
     course_days, units_dispensed, administration_route, item_instructions)
VALUES
    (4101, 3102, 'Invalid test quantity', 1, 1, 9999, 'Oral',
     'This row must be rejected by the trigger.');
*/

-- =============================================================================
-- END OF SMART CLINIC DATABASE IMPLEMENTATION
-- =============================================================================
