---
description: Project Setup & Installation Guide
---
# DigiKhata Clone Setup Workflow

Follow these steps to fully configure the project environment, including the Supabase authentication and database requirements.

1. **Install Flutter Dependencies**
   Ensure all packages are correctly fetched.
   // turbo
   `flutter pub get`

2. **Configure Supabase Authentication (OTP)**
   To successfully log into the mobile app without Twilio integration during development:
   - Go to your Supabase Dashboard -> Authentication -> Providers.
   - Click on **Phone**.
   - Enable Phone provider (even if you don't enter Twilio details).
   - Under **Test phone numbers**, add a new test user:
     - Phone Number: `1234567890` (or your personal number like `923001234567`)
     - OTP: `123456`
   - Hit **Save**.

3. **Verify Database Structure**
   Ensure that the `DigiKhata_Master_Schema` is fully executed in the Supabase SQL Editor.
   You should see the following tables under the `public` schema in the Table Editor:
   - `businesses`
   - `parties`
   - `ledger_entries`
   - `cash_book`

4. **Codebase Platform Alignment**
   The project requires no extra native configuration. Isar handles the local offline database natively on Mobile. The Web version (Admin Panel) ignores Isar initialization automatically.
