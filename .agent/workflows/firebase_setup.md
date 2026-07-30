---
description: Firebase Configuration (Push Notifications)
---
# Firebase Push Notifications Setup

Follow these exact steps in your VS Code terminal to link the project to Firebase Cloud Messaging (FCM). Firebase will only be used to handle notifications, while Supabase continues driving our authentication and data.

## Step 1: Create the Project
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Click **Add Project** and name it `DigiKhata-Clone` (or any Zenvyro Labs name you prefer).
3. Disable Google Analytics (optional, saves time).
4. Click **Create Project**.

## Step 2: Install Firebase Tools (If not already installed)
In your VS Code terminal, make sure you can execute `firebase` commands and the FlutterFire CLI.
// turbo
`npm install -g firebase-tools`

// turbo
`dart pub global activate flutterfire_cli`

## Step 3: Login and Link
Run the login command in your terminal. This will open your web browser so you can log into your Google Account.
> **Note**: Do not run this as a turbo command because it requires browser user interaction. Type this directly in your terminal:
`firebase login`

## Step 4: Configure FlutterFire
Now that you are logged in, run the configuration command. It will automatically detect your Firebase project and generate the `firebase_options.dart` file for Android, iOS, and Web.
> **Note**: Type this directly in your terminal and follow the arrow-key prompts to select the `DigiKhata-Clone` project:
`flutterfire configure`

Once you successfully execute Step 4 and see `FirebaseOptions` generated in `lib/firebase_options.dart`, the backend setup is officially 100% finished!
