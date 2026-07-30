---
description: Running the Application (Mobile & Admin Panel)
---
# Running & Testing Environments

Since this single codebase houses BOTH the mobile app for shopkeepers and the Super Admin panel for Zenvyro Labs, you must specify the platform when running the app to see the correct interface.

## Option 1: Running the Mobile App (Customer Side)
Use an Android emulator or a physical device to launch the mobile ledger experience.
1. Make sure your Android emulator (or physical device) is running.
2. Clear the build cache (optional but recommended if switching platforms).
// turbo
`flutter clean ; flutter pub get`
3. Launch the app on Android.
// turbo
`flutter run -d android`
*If you see the Splash Screen redirect to the Login page, the mobile app is working!*

## Option 2: Running the Super Admin Panel (Web Side)
Use Chrome to launch the Web version of the application. The codebase disables offline databases natively to prevent web crashes.
1. Open Chrome.
2. Clear the build cache to prevent old JS chunks from breaking the launch.
// turbo
`flutter clean ; flutter pub get`
3. Launch the app on Chrome.
// turbo
`flutter run -d chrome`
*Once signed in with an Admin account, the app automatically routes your experience to the `/admin` dashboard instead of the mobile customer ledger.*

## Option 3: Generating the Production Build
To create an APK for testing the production feel on Android devices:
// turbo
`flutter build apk --release`
