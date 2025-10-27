## Checklist

- [x] Overview
- [x] Flutter Frontend Implementation
  - [x] UI/UX Flow
  - [x] Widgets and Components
  - [x] State Management
  - [x] API Integration
  - [x] Navigation
- [x] Python (FastAPI) Backend Implementation
  - [x] API Endpoints
  - [x] Database Schema (Example additions)
  - [x] Security Considerations
  - [x] Email Service Integration
- [x] Testing

# Forget Password Functionality

This document outlines the implementation details for the "Forget Password" feature, covering both the Flutter frontend and the Python (FastAPI) backend.

## 1. Overview

The "Forget Password" functionality allows users to reset their password if they have forgotten it. This typically involves:
1.  User requests a password reset by providing their email address.
2.  Backend sends a password reset link/code to the user's email.
3.  User clicks the link/enters the code, which directs them to a password reset form.
4.  User sets a new password.

## 2. Flutter Frontend Implementation

### 2.1 UI/UX Flow

*   **Forget Password Screen:** A dedicated screen where the user enters their registered email address.
*   **Email Sent Confirmation:** A confirmation message displayed after the email is successfully sent.
*   **Reset Password Screen:** A screen where the user enters and confirms their new password, typically accessed via a link from their email.

### 2.2 Widgets and Components

*   `TextFormField` for email input.
*   `ElevatedButton` for submitting the request.
*   `CircularProgressIndicator` for loading states.
*   `SnackBar` or `AlertDialog` for feedback (success/error messages).

### 2.3 State Management

*   Use a suitable state management solution (e.g., Provider, BLoC, Riverpod) to handle:
    *   Email input state.
    *   Loading state during API calls.
    *   Error messages.
    *   Password and confirm password input states on the reset screen.

### 2.4 API Integration

*   **Request Password Reset:**
    *   Call the backend API endpoint (e.g., `/auth/forgot-password`) with the user's email.
    *   Handle success (show confirmation) and error (display error message) responses.
*   **Reset Password:**
    *   Call the backend API endpoint (e.g., `/auth/reset-password`) with the reset token/code, new password, and password confirmation.
    *   Handle success (navigate to login) and error responses.

### 2.5 Navigation

*   Navigate to the "Forget Password" screen from the login screen.
*   Navigate to the login screen after a successful password reset.

## 3. Python (FastAPI) Backend Implementation

### 3.1 API Endpoints

*   **`POST /auth/forgot-password`**
    *   **Request Body:** `{"email": "user@example.com"}`
    *   **Functionality:**
        *   Validate email.
        *   Check if the email exists in the database.
        *   Generate a unique, time-limited password reset token.
        *   Store the token (hashed) and its expiry in the database associated with the user.
        *   Send an email to the user containing a link with the reset token (e.g., `https://your-app.com/reset-password?token=YOUR_TOKEN`).
    *   **Response:** `{"message": "Password reset email sent."}` or appropriate error.

*   **`POST /auth/reset-password`**
    *   **Request Body:** `{"token": "YOUR_TOKEN", "new_password": "new_password123", "confirm_password": "new_password123"}`
    *   **Functionality:**
        *   Validate the reset token (check existence, expiry, and validity).
        *   Validate `new_password` and `confirm_password` (e.g., match, complexity requirements).
        *   Hash the `new_password`.
        *   Update the user's password in the database with the new hashed password.
        *   Invalidate or delete the used reset token from the database.
    *   **Response:** `{"message": "Password has been reset successfully."}` or appropriate error.

### 3.2 Database Schema (Example additions)

*   **User Model:**
    *   `password_reset_token`: `String` (nullable, stores hashed token)
    *   `password_reset_expires_at`: `DateTime` (nullable)

### 3.3 Security Considerations

*   **Token Generation:** Use cryptographically secure random tokens.
*   **Token Expiry:** Ensure tokens expire after a short period (e.g., 15-60 minutes).
*   **Token Invalidation:** Invalidate tokens immediately after use.
*   **Password Hashing:** Always store hashed passwords (e.g., using `bcrypt`).
*   **Rate Limiting:** Implement rate limiting on the "forgot password" request endpoint to prevent abuse.
*   **Email Service:** Use a secure email service for sending reset links.

### 3.4 Email Service Integration

*   Integrate with an email sending library/service (e.g., `python-multipart`, `smtplib`, SendGrid, Mailgun) to send password reset emails.
*   Email content should be clear and include the reset link.

## 4. Testing

*   **Frontend:**
    *   Unit tests for widgets and state management.
    *   Integration tests for the full user flow.
*   **Backend:**
    *   Unit tests for token generation, validation, and password hashing.
    *   Integration tests for API endpoints (requesting and resetting password).