# Boxing Coach Manager App

A Flutter application designed for boxing coaches to manage their sessions, participants, attendance, and payments. This app is optimized for smartphones and tablets.

## Features

### Mobile-First Design

- **Responsive Layout**: Adapts to different screen sizes (phones and tablets)
- **Bottom Navigation**: Easy navigation between main sections with thumb-friendly controls
- **Touch-Optimized UI**: Large buttons and touch targets for better mobile experience
- **Card-Based Design**: Clean, modern interface with proper spacing for mobile devices

### Core Functionality

- **Dashboard**: Overview of key statistics and today's sessions
- **Session Management**: View and manage upcoming boxing sessions
- **Participant Management**: Track participants and their attendance status
- **Payment Tracking**: Monitor pending payments and financial status
- **Multi-language Support**: Available in English, Arabic, and Hebrew

### Mobile Optimizations Made

1. **Navigation**: Replaced desktop sidebar with mobile bottom navigation
2. **Layout**: Single-column layout instead of multi-column desktop layout
3. **Data Display**: Replaced data tables with mobile-friendly list cards
4. **Quick Actions**: Added floating action button and quick action shortcuts
5. **Responsive Grid**: Stats cards adapt from 2 columns on phones to 4 on tablets
6. **Touch Interactions**: Bottom sheets and modal dialogs for better mobile UX
7. **Typography**: Optimized font sizes for mobile readability

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or later)
- Dart SDK
- A device or emulator to run the app

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

### Supported Platforms

- Android
- iOS
- Web (responsive design)

## Project Structure

```
lib/
├── main.dart              # App entry point
├── home_page.dart         # Mobile-optimized main page
└── app_localizations.dart # Multi-language support
```

## Technologies Used

- Flutter
- Dart
- Provider (State Management)
- Material Design 3
- Multi-language localization

## Mobile-Specific Features

- **Bottom Navigation Bar**: 4 main sections (Dashboard, Sessions, Participants, More)
- **Responsive Stats Grid**: 2x2 on phones, 1x4 on tablets
- **Mobile Data Cards**: Replace desktop data tables with touch-friendly cards
- **Quick Actions**: Floating action button with bottom sheet for common actions
- **Optimized Typography**: Proper font sizes and spacing for mobile screens
- **Touch-Friendly Controls**: Adequate touch targets and spacing

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
