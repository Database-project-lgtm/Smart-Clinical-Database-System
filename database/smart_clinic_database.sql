-- ============================================================
-- Smart Clinic Database System
-- Project: IT244 - Database Design and Implementation
-- ============================================================

-- ============================================================
-- TASK 2: Database Implementation
-- ============================================================

-- ============================================================
-- 1. Create the Database
-- ============================================================
DROP DATABASE IF EXISTS SmartClinic;
CREATE DATABASE SmartClinic;
USE SmartClinic;

-- ============================================================
-- 2. Create Tables with Appropriate Data Types and Constraints
-- ============================================================

-- Table: PATIENT
CREATE TABLE PATIENT (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),
    Phone VARCHAR(20) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(200),
    RegistrationDate DATE NOT NULL DEFAULT (CURRENT_DATE)
);

-- Table: DOCTOR
CREATE TABLE DOCTOR (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    LicenseNumber VARCHAR(50) UNIQUE NOT NULL,
    HourlyRate DECIMAL(10, 2) NOT NULL CHECK (HourlyRate > 0)
);

-- Table: MEDICINE
CREATE TABLE MEDICINE (
    MedicineID INT AUTO_INCREMENT PRIMARY KEY,
    MedicineName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL CHECK (Price > 0),
    Description VARCHAR(255),
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0),
    ExpiryDate DATE NOT NULL
);

-- Table: APPOINTMENT
CREATE TABLE APPOINTMENT (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Scheduled' 
        CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled', 'No-Show')),
    Reason VARCHAR(255),
    Notes TEXT,
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES DOCTOR(DoctorID) ON DELETE CASCADE
);

-- Table: TREATMENT
CREATE TABLE TREATMENT (
    TreatmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentID INT,
    TreatmentDate DATE NOT NULL,
    TreatmentType VARCHAR(100) NOT NULL,
    Description TEXT,
    Cost DECIMAL(10, 2) NOT NULL CHECK (Cost >= 0),
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES DOCTOR(DoctorID) ON DELETE CASCADE,
    FOREIGN KEY (AppointmentID) REFERENCES APPOINTMENT(AppointmentID) ON DELETE SET NULL
);

-- Table: PAYMENT
CREATE TABLE PAYMENT (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    TreatmentID INT,
    Amount DECIMAL(10, 2) NOT NULL CHECK (Amount > 0),
    PaymentDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    PaymentMethod VARCHAR(30) NOT NULL 
        CHECK (PaymentMethod IN ('Cash', 'Credit Card', 'Debit Card', 'Insurance', 'Check')),
    Status VARCHAR(20) NOT NULL DEFAULT 'Paid' 
        CHECK (Status IN ('Paid', 'Pending', 'Refunded')),
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (TreatmentID) REFERENCES TREATMENT(TreatmentID) ON DELETE SET NULL
);

-- Table: TREATMENT_MEDICINE (Associative Entity for Many-to-Many between TREATMENT and MEDICINE)
CREATE TABLE TREATMENT_MEDICINE (
    TreatmentMedicineID INT AUTO_INCREMENT PRIMARY KEY,
    TreatmentID INT NOT NULL,
    MedicineID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Dosage VARCHAR(100),
    Instructions VARCHAR(255),
    FOREIGN KEY (TreatmentID) REFERENCES TREATMENT(TreatmentID) ON DELETE CASCADE,
    FOREIGN KEY (MedicineID) REFERENCES MEDICINE(MedicineID) ON DELETE CASCADE,
    UNIQUE KEY (TreatmentID, MedicineID)
);

-- ============================================================
-- 3. Insert Data (at least 5 records into each main table)
-- ============================================================

-- Insert into PATIENT
INSERT INTO PATIENT (FirstName, LastName, DateOfBirth, Gender, Phone, Email, Address, RegistrationDate) VALUES
('Ahmed', 'Al-Rashid', '1985-03-15', 'M', '0501234567', 'ahmed.rashid@email.com', '12 King Fahd St, Riyadh', '2024-01-10'),
('Fatima', 'Al-Saud', '1990-07-22', 'F', '0502345678', 'fatima.saud@email.com', '45 Olaya Rd, Riyadh', '2024-01-15'),
('Mohammed', 'Al-Qahtani', '1978-11-08', 'M', '0503456789', 'mohammed.qahtani@email.com', '78 Tahlia St, Jeddah', '2024-02-01'),
('Sara', 'Al-Harbi', '1995-01-30', 'F', '0504567890', 'sara.harbi@email.com', '23 Corniche Rd, Dammam', '2024-02-15'),
('Khalid', 'Al-Otaibi', '1982-09-12', 'M', '0505678901', 'khalid.otaibi@email.com', '56 Airport Rd, Riyadh', '2024-03-01'),
('Noura', 'Al-Zahrani', '1988-05-25', 'F', '0506789012', 'noura.zahrani@email.com', '89 Prince Sultan St, Jeddah', '2024-03-10'),
('Abdullah', 'Al-Ghamdi', '2000-12-03', 'M', '0507890123', 'abdullah.ghamdi@email.com', '34 Al-Balad St, Jeddah', '2024-03-20');

-- Insert into DOCTOR
INSERT INTO DOCTOR (FirstName, LastName, Specialization, Phone, Email, LicenseNumber, HourlyRate) VALUES
('Dr. Omar', 'Al-Mansour', 'Cardiology', '0551234567', 'omar.mansour@clinic.com', 'LIC-001', 350.00),
('Dr. Aisha', 'Al-Bakr', 'Dermatology', '0552345678', 'aisha.bakr@clinic.com', 'LIC-002', 280.00),
('Dr. Hassan', 'Al-Tamimi', 'Orthopedics', '0553456789', 'hassan.tamimi@clinic.com', 'LIC-003', 320.00),
('Dr. Layla', 'Al-Farsi', 'Pediatrics', '0554567890', 'layla.farsi@clinic.com', 'LIC-004', 300.00),
('Dr. Saleh', 'Al-Dosari', 'Neurology', '0555678901', 'saleh.dosari@clinic.com', 'LIC-005', 400.00);

-- Insert into MEDICINE
INSERT INTO MEDICINE (MedicineName, Category, Price, Description, StockQuantity, ExpiryDate) VALUES
('Amoxicillin 500mg', 'Antibiotics', 25.50, 'Broad-spectrum antibiotic', 500, '2026-06-30'),
('Paracetamol 500mg', 'Pain Relief', 12.00, 'Pain and fever reducer', 1000, '2027-03-15'),
('Metformin 850mg', 'Diabetes', 45.00, 'Blood sugar control medication', 300, '2026-09-01'),
('Lisinopril 10mg', 'Cardiovascular', 38.75, 'Blood pressure medication', 200, '2026-12-20'),
('Ibuprofen 400mg', 'Pain Relief', 18.50, 'Anti-inflammatory pain reliever', 750, '2027-01-10'),
('Cetirizine 10mg', 'Antihistamine', 15.00, 'Allergy relief medication', 600, '2026-08-25'),
('Omeprazole 20mg', 'Digestive', 22.00, 'Acid reflux treatment', 400, '2026-11-15');

-- Insert into APPOINTMENT
INSERT INTO APPOINTMENT (PatientID, DoctorID, AppointmentDate, AppointmentTime, Status, Reason, Notes) VALUES
(1, 1, '2024-06-10', '09:00:00', 'Completed', 'Annual heart checkup', 'ECG normal, blood pressure 130/85'),
(2, 2, '2024-06-12', '10:30:00', 'Completed', 'Skin rash consultation', 'Eczema diagnosed, prescription given'),
(3, 3, '2024-06-15', '11:00:00', 'Completed', 'Knee pain follow-up', 'MRI results reviewed, physical therapy recommended'),
(4, 4, '2024-06-18', '08:30:00', 'Scheduled', 'Child vaccination', 'Due for routine childhood vaccines'),
(5, 5, '2024-06-20', '14:00:00', 'Cancelled', 'Chronic headaches', 'Patient rescheduled'),
(6, 1, '2024-06-22', '09:30:00', 'Completed', 'High blood pressure monitoring', 'Medication adjusted'),
(7, 2, '2024-06-25', '11:00:00', 'Scheduled', 'Acne treatment consultation', 'First visit');

-- Insert into TREATMENT
INSERT INTO TREATMENT (PatientID, DoctorID, AppointmentID, TreatmentDate, TreatmentType, Description, Cost) VALUES
(1, 1, 1, '2024-06-10', 'Cardiac Examination', 'Full cardiac assessment including ECG and blood work', 450.00),
(2, 2, 2, '2024-06-12', 'Dermatology Treatment', 'Topical treatment for eczema with moisturizing regimen', 200.00),
(3, 3, 3, '2024-06-15', 'Orthopedic Consultation', 'Knee examination and physical therapy prescription', 350.00),
(5, 5, NULL, '2024-06-20', 'Neurological Assessment', 'CT scan and neurological evaluation for headaches', 600.00),
(6, 1, 6, '2024-06-22', 'Blood Pressure Management', 'Medication adjustment and lifestyle counseling', 300.00),
(4, 4, 4, '2024-06-18', 'Pediatric Vaccination', 'Routine childhood immunizations', 150.00),
(1, 1, NULL, '2024-07-01', 'Follow-up Cardiac', 'Follow-up ECG and cholesterol check', 250.00);

-- Insert into PAYMENT
INSERT INTO PAYMENT (PatientID, TreatmentID, Amount, PaymentDate, PaymentMethod, Status) VALUES
(1, 1, 450.00, '2024-06-10', 'Credit Card', 'Paid'),
(2, 2, 200.00, '2024-06-12', 'Cash', 'Paid'),
(3, 3, 350.00, '2024-06-15', 'Insurance', 'Paid'),
(5, NULL, 100.00, '2024-06-20', 'Credit Card', 'Pending'),
(6, 5, 300.00, '2024-06-22', 'Debit Card', 'Paid'),
(4, 6, 150.00, '2024-06-18', 'Insurance', 'Paid'),
(1, 7, 250.00, '2024-07-01', 'Cash', 'Paid');

-- Insert into TREATMENT_MEDICINE
INSERT INTO TREATMENT_MEDICINE (TreatmentID, MedicineID, Quantity, Dosage, Instructions) VALUES
(1, 4, 30, '10mg daily', 'Take once daily in the morning with water'),
(1, 3, 60, '850mg twice daily', 'Take with meals to reduce stomach upset'),
(2, 1, 21, '500mg three times daily', 'Complete the full course of antibiotics'),
(2, 2, 14, '500mg as needed', 'Take every 6 hours for pain relief'),
(3, 5, 30, '400mg twice daily', 'Take with food to avoid stomach irritation'),
(4, 2, 20, '500mg as needed', 'For headache episodes only'),
(5, 4, 30, '10mg daily', 'Continue as prescribed, monitor blood pressure'),
(6, 6, 14, '10mg daily', 'Take in the morning, may cause drowsiness'),
(7, 3, 60, '850mg twice daily', 'Take with meals, monitor blood sugar levels');


-- ============================================================
-- TASK 3: SQL Operations
-- ============================================================

-- ============================================================
-- 3.1 SELECT Statements
-- ============================================================

-- Query 1: Retrieve all patients with their full details
-- Purpose: Displays complete patient information for administrative review
SELECT PatientID, FirstName, LastName, DateOfBirth, Gender, Phone, Email, Address, RegistrationDate
FROM PATIENT;

-- Query 2: Find all doctors specialized in Cardiology
-- Purpose: Retrieves doctors with a specific specialization for patient referral
SELECT DoctorID, FirstName, LastName, Specialization, HourlyRate
FROM DOCTOR
WHERE Specialization = 'Cardiology';

-- ============================================================
-- 3.2 JOIN Queries
-- ============================================================

-- Query 3: List all appointments with patient and doctor names
-- Purpose: Provides a comprehensive view of appointments linking patients to their doctors
SELECT 
    a.AppointmentID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
    a.AppointmentDate,
    a.AppointmentTime,
    a.Status,
    a.Reason
FROM APPOINTMENT a
JOIN PATIENT p ON a.PatientID = p.PatientID
JOIN DOCTOR d ON a.DoctorID = d.DoctorID
ORDER BY a.AppointmentDate, a.AppointmentTime;

-- Query 4: List all treatments with medicines prescribed
-- Purpose: Shows which medicines were prescribed for each treatment
SELECT 
    t.TreatmentID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    m.MedicineName,
    tm.Dosage,
    tm.Quantity,
    tm.Instructions
FROM TREATMENT t
JOIN PATIENT p ON t.PatientID = p.PatientID
JOIN TREATMENT_MEDICINE tm ON t.TreatmentID = tm.TreatmentID
JOIN MEDICINE m ON tm.MedicineID = m.MedicineID
ORDER BY t.TreatmentID;

-- ============================================================
-- 3.3 Nested (Sub) Queries
-- ============================================================

-- Query 5: Find patients who have appointments with Cardiologists
-- Purpose: Identifies patients seeing cardiology specialists for heart-related care
SELECT DISTINCT CONCAT(p.FirstName, ' ', p.LastName) AS PatientName, p.Phone
FROM PATIENT p
WHERE p.PatientID IN (
    SELECT PatientID 
    FROM APPOINTMENT 
    WHERE DoctorID IN (
        SELECT DoctorID 
        FROM DOCTOR 
        WHERE Specialization = 'Cardiology'
    )
);

-- Query 6: Find treatments that cost more than the average treatment cost
-- Purpose: Identifies high-cost treatments for financial analysis
SELECT 
    t.TreatmentID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    t.TreatmentType,
    t.Cost
FROM TREATMENT t
JOIN PATIENT p ON t.PatientID = p.PatientID
WHERE t.Cost > (SELECT AVG(Cost) FROM TREATMENT);

-- ============================================================
-- 3.4 Aggregate Functions with GROUP BY
-- ============================================================

-- Query 7: Total revenue per doctor
-- Purpose: Calculates the total treatment revenue generated by each doctor
SELECT 
    CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
    d.Specialization,
    COUNT(t.TreatmentID) AS TotalTreatments,
    SUM(t.Cost) AS TotalRevenue
FROM DOCTOR d
LEFT JOIN TREATMENT t ON d.DoctorID = t.DoctorID
GROUP BY d.DoctorID, d.FirstName, d.LastName, d.Specialization
ORDER BY TotalRevenue DESC;

-- Query 8: Number of appointments per status
-- Purpose: Provides statistics on appointment outcomes for operational analysis
SELECT 
    Status,
    COUNT(*) AS AppointmentCount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM APPOINTMENT), 2) AS Percentage
FROM APPOINTMENT
GROUP BY Status;

-- Query 9: Total payments made per payment method
-- Purpose: Analyzes payment preferences of patients for financial reporting
SELECT 
    PaymentMethod,
    COUNT(*) AS TransactionCount,
    SUM(Amount) AS TotalAmount,
    AVG(Amount) AS AverageAmount
FROM PAYMENT
GROUP BY PaymentMethod;

-- ============================================================
-- 3.5 UPDATE and DELETE Statements
-- ============================================================

-- Update: Change a doctor's hourly rate after a promotion
-- Purpose: Updates Dr. Al-Tamimi's rate from 320 to 380 after receiving a promotion
UPDATE DOCTOR 
SET HourlyRate = 380.00 
WHERE DoctorID = 3;

-- Verify the update
SELECT DoctorID, CONCAT(FirstName, ' ', LastName) AS DoctorName, HourlyRate
FROM DOCTOR 
WHERE DoctorID = 3;

-- Update: Change appointment status after completion
-- Purpose: Marks appointment 4 as Completed since the vaccination was administered
UPDATE APPOINTMENT 
SET Status = 'Completed' 
WHERE AppointmentID = 4;

-- Delete: Remove a cancelled appointment (appointment 5 was cancelled)
-- Purpose: Cleans up the system by removing cancelled appointments older than 30 days
DELETE FROM APPOINTMENT 
WHERE AppointmentID = 5 AND Status = 'Cancelled';

-- Verify deletion
SELECT AppointmentID, Status, Reason FROM APPOINTMENT;

-- ============================================================
-- 3.6 VIEW
-- ============================================================

-- Create VIEW: Patient Treatment Summary
-- Purpose: Provides a consolidated view of patient treatment history with doctor and payment info
CREATE VIEW PatientTreatmentSummary AS
SELECT 
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    p.Phone,
    COUNT(DISTINCT t.TreatmentID) AS TotalTreatments,
    SUM(t.Cost) AS TotalSpent,
    MAX(t.TreatmentDate) AS LastTreatmentDate
FROM PATIENT p
LEFT JOIN TREATMENT t ON p.PatientID = t.PatientID
GROUP BY p.PatientID, p.FirstName, p.LastName, p.Phone;

-- Query the VIEW
SELECT * FROM PatientTreatmentSummary;

-- ============================================================
-- 3.7 TRIGGER
-- ============================================================

-- Create TRIGGER: Auto-update medicine stock after treatment
-- Purpose: Automatically reduces medicine stock when a treatment-medicine record is inserted
DELIMITER //

CREATE TRIGGER UpdateMedicineStock
AFTER INSERT ON TREATMENT_MEDICINE
FOR EACH ROW
BEGIN
    UPDATE MEDICINE 
    SET StockQuantity = StockQuantity - NEW.Quantity
    WHERE MedicineID = NEW.MedicineID;
END //

DELIMITER ;

-- Test the trigger by inserting a new treatment-medicine record
-- First, check current stock
SELECT MedicineName, StockQuantity FROM MEDICINE WHERE MedicineID = 1;

-- Insert a new treatment medicine record to trigger stock update
INSERT INTO TREATMENT_MEDICINE (TreatmentID, MedicineID, Quantity, Dosage, Instructions) VALUES
(7, 1, 10, '500mg three times daily', 'Take with meals');

-- Verify the stock was automatically reduced
SELECT MedicineName, StockQuantity FROM MEDICINE WHERE MedicineID = 1;


-- ============================================================
-- EER Feature: Specialization/Generalization - Person -> Patient / Doctor
-- ============================================================
-- Note: In the relational model, the EER generalization/specialization
-- is implemented by having a common "PERSON" entity with shared attributes,
-- and specialized entities (PATIENT, DOCTOR) with their unique attributes.
-- 
-- Generalization hierarchy:
--   PERSON (supertype) - shared: FirstName, LastName, Phone, Email, DateOfBirth
--     ├── PATIENT (subtype) - unique: Address, RegistrationDate, Gender
--     └── DOCTOR (subtype) - unique: Specialization, LicenseNumber, HourlyRate
--
-- This is documented in the EER diagram and represents an overlapping 
-- specialization (a person can be both a patient and a doctor).
