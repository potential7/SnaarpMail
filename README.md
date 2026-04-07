# Snaarp Mail

Snaarp Mail is a beautiful email app built with Flutter. It uses real Firebase Authentication for logging in and a local SQLite database to safely store and show your emails!

## Requirements

To test this app on an emulator, you will need:
- **Flutter SDK** (Minimum Version: Flutter 3.0+ / Dart ^3.11.1)
- **Apple iOS SDK** (Minimum Deployment Target: iOS 15.0)
- **Android Studio** (to run the Android Emulator) OR **Xcode** (to run the iOS Simulator).
- An active internet connection (required for the Firebase database to check your passwords).

## How to Run on an Emulator

1. Open your terminal and go to the project folder.
2. Clean the project and download all the required Flutter packages:
   ```bash
   flutter clean
   flutter pub get
   ```
3. **(For iOS Simulators Only):** Install the native Apple packages:
   ```bash
   cd ios
   pod install --repo-update
   cd ..
   ```
4. Start your emulator (Android or iOS) and run the app:
   ```bash
   flutter run
   ```

   ## ✨ Core Features

* **Custom Gmail-Inspired UI:** Features a floating search bar, animated drawer navigation, and high-density email lists to maximize screen real estate.
* **Authentication Flow:** Includes a polished Sign-Up/Login screen with mocked Google OAuth integration and form validation.
* **Inbox Management:** Filter emails by categories (Primary, Promotions, Social) and visually distinguish between read/unread and starred messages.
* **Compose & Send:** A robust compose screen with real-time UI state handling during simulated network requests.
* **Robust Search:** Real-time email filtering using BLoC event debouncing.

## How to Test the App (Sample Guide)
- **Create a Sample Account**: Because I use a real Firebase backend, click "Sign Up" when the app opens and format any fake email (e.g., `test1@example.com`) and a password to create a real sample account instantly!
- **Read Emails**: The app automatically generates sample inbox emails for you to experiment with using a local database. 
- **Send an Email**: Try writing an email and pressing Send. The app will capture it and drop it straight into your Sent folder, perfectly labeled with your sample login email!

## Major Challenges I Faced

1. **Non-Destructive State Management:** I utilized the `flutter_bloc` package to orchestrate the application's core state. A primary challenge was ensuring that transient network errors did not permanently wipe the `MailState` cache. I resolved this by creating a highly immutable, unified state data class that retains local UI structures while emitting non-destructive exception alerts (via `SnackBar`).
2. **Seamless Backend Swapping:** I initially built and tested this project using a mock authentication system. However, because I strictly adhered to **Clean Architecture** principles (separating Domain Entities from Remote Data Sources), it was remarkably easy for me to scale the backend. I seamlessly upgraded the entire application to use real Google Firebase Logins by simply swapping the underlying Data Source layer and injecting it via GetIt—without needing to touch a single line of my Frontend or UI logic!
3. **Custom Routing & Micro-Animations:** Default Material route transitions can feel quite uniform. To elevate the UX to premium enterprise standards, I completely deprecated standard routes and built a globally unified `PageTransition` utility using `PageRouteBuilder`. This ensures that every screen interaction—from tapping an email to executing a deep-search—beautifully micro-scales and fades into view.
