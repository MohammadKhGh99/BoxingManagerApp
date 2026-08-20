# Boxing Coach Manager

Boxing Coach Manager is a local-first Flutter application for managing boxing
participants, training sessions, attendance, and payments from one dashboard.
It is designed for coaches and gym managers who need a straightforward way to
organize day-to-day training operations without requiring an internet connection.

## Features

- Participant management with personal ID, contact details, age, weight class,
  and notes.
- Session scheduling with date, time, session type, duration, and notes.
- Attendance tracking for scheduled sessions.
- Session rosters showing attended participants.
- Payment recording with payment method, amount, description, and status.
- Dashboard statistics for participants, sessions, revenue, and attendance rate.
- Manage Data views for participants, sessions, and payments.
- Database backup and restore for moving data between devices.
- Customizable accent color for the app interface.
- English, Arabic, and Hebrew localization, including right-to-left layouts.
- Android release APK support, with desktop development support through Flutter.

## Technology

- Flutter and Dart
- SQLite through `sqflite`
- Provider for application state management
- Shared Preferences for local settings
- File Picker for selecting database backups

All application data is stored locally on the device. No cloud account or
backend service is required.

## Requirements

- Flutter SDK compatible with Dart `3.5.0` or later within the project SDK range
- Android Studio and an Android SDK for Android builds
- A connected Android device or emulator for Android testing

Check the local Flutter installation with:

```bash
flutter doctor
```

## Getting Started

Install dependencies and run the application:

```bash
flutter pub get
flutter run
```

To run on a specific device:

```bash
flutter devices
flutter run -d <device-id>
```

## Build the Android Release APK

```bash
flutter clean
flutter pub get
flutter build apk --release
```

The generated APK is located at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Transfer this file to an Android device and install it. Android may require
permission to install applications from the file manager or browser used to
open the APK.

## Backup and Restore

The app stores its SQLite database locally. To transfer data from one device to
another:

1. Open the app on the original device.
2. Use the backup action to create a database backup.
3. Transfer the generated `.db` file to the new device.
4. Install and open Boxing Coach Manager on the new device.
5. Use the restore action and select the backup file.

Restoring replaces the data currently stored on the destination device. Create
a backup before restoring if the destination already contains important data.

## Localization

The interface supports:

- English (`en`)
- Arabic (`ar`)
- Hebrew (`he`)

The language can be changed from the language control in the app bar. Payment
method labels and form placeholders are localized while stored payment values
remain consistent internally.

## Project Structure

```text
lib/
main.dart - Application entry point and theme setup
home_page.dart - Dashboard and primary workflows
app_localizations.dart - English, Arabic, and Hebrew strings
accent_color_provider.dart - Persistent accent color state
locale_provider.dart - Current locale state
providers/ - Application state providers
services/ - Database and persistence services
test/                               Flutter widget tests
android/                            Android platform project
```

## Testing and Analysis

Run the widget tests:

```bash
flutter test
```

Run static analysis:

```bash
flutter analyze
```

## Release

Current release: **v1.0.0**

This is the first release of Boxing Coach Manager. Before distributing a
production build through an app store, configure a production Android signing
key and review the application ID and release metadata in the Android project.
