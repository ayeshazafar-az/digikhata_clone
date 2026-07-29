# 📘 Digital Business Ledger & Accounting System (DigiKhata Clone)

A production-grade, offline-first digital ledger application designed to help businesses manage their daily transactions, customer accounts, and cash flow efficiently. Built with a clean architecture approach, this project replicates the core functionalities of DigiKhata while featuring a custom Blue Theme and robust Super Admin dashboard.

## 🚀 Tech Stack
* **Frontend:** Flutter (Mobile & Web)
* **Backend & Auth:** Supabase (PostgreSQL, GoTrue Auth)
* **Local Database:** Isar (For offline-first capabilities & fast caching)
* **State Management:** Riverpod
* **Routing:** GoRouter
* **Push Notifications:** Firebase Cloud Messaging (FCM)

## ✨ Key Features
### 📱 Mobile Application (User)
* **Offline-First Architecture:** Add transactions without the internet; auto-syncs when online.
* **Multi-Business Support:** Manage multiple shops or businesses under a single account.
* **Customer Ledger:** Track "Cash In" and "Cash Out" (Credit/Debit entries).
* **Automated Reporting:** Export daily/weekly/monthly reports to PDF and Excel.
* **Secure Authentication:** OTP login, PIN code setup, and Biometric authentication.
* **Modern UI/UX:** Responsive Blue Theme design with Zenvyro Labs branding.

### 👑 Web Panel (Super Admin)
* **Dashboard Analytics:** View system-wide statistics and activity.
* **User & Business Management:** Block/unblock users and view business profiles.
* **Announcement Engine:** Send FCM push notifications and manage app banners.

## 🏗 Architecture
This project follows a **Feature-First Clean Architecture**, ensuring scalability, testability, and separation of concerns. 

* **State Management:** Handled via Riverpod for predictable and safe state mutations.
* **Local Sync Engine:** Utilizes background queues to push local Isar transactions to Supabase to prevent data loss during poor connectivity.

---
*Powered by Zenvyro Labs*