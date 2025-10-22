# Product Requirements Document: SoftMed24h

## 1. Introduction

**Purpose:** This document outlines the product requirements for SoftMed24h, a mobile application designed to connect patients with doctors for remote consultations.

**Scope:** This PRD covers the initial version of the SoftMed24h application, focusing on a virtual queue system for consultations.

**Target Audience:**
*   **Patients:** Individuals seeking immediate medical consultations without prior appointments.
*   **Doctors:** Licensed medical professionals available to attend to patients on demand.

## 2. Functional Requirements

### 2.1. Landing Page and Consultation Purchase
*   A landing page will be available for customers to purchase a medical consultation.
*   Upon successful purchase, the patient is redirected to a virtual queue.
*   The patient's position in the queue will be displayed in real-time.

### 2.2. Virtual Queue and Doctor's Interface
*   A system background will display the queue of patients in order of arrival.
*   Available doctors can view the queue and call the next patient.

### 2.3. Consultation Initiation
*   When a doctor calls a patient, the patient's registered personal information will be displayed.
*   A button will be available to start a video call via Google Meet, embedded within the system's page.

### 2.4. Medical Records
*   When the video call starts, the patient's medical record form will automatically open.
*   The doctor can enter consultation data and procedures into the medical record.

### 2.5. Prescriptions and Documents
*   During the consultation, the doctor will have an option to prescribe medications and issue documents for the patient.
*   This will be handled through an integration with Memed or Mevo API and will be displayed within the service window.

### 2.6. Consultation Status
*   At the end of the consultation, the doctor must select one of the following statuses:
    *   Completed
    *   Technical Problem
    *   No Answer

## 3. Non-Functional Requirements

### 3.1. Performance
*   The application must be responsive and load quickly, even on slower network connections.
*   Video consultations should have low latency.

### 3.2. Usability
*   The user interface should be intuitive and easy to navigate for both patients and doctors.
*   The design should be clean, professional, and instill a sense of trust.

### 3.3. Security
*   All user data, especially medical information, must be encrypted and stored securely.
*   Compliance with data privacy regulations (e.g., HIPAA, GDPR).

### 3.4. Scalability
*   The application architecture should be scalable to accommodate a growing number of users.