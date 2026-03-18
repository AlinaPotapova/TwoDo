# TwoDo - Home Tasks Management App

TwoDo is a cross-platform Flutter application designed to help you organize and manage your home tasks efficiently. With Firebase integration for authentication and data persistence, TwoDo provides a seamless experience across iOS, Android, web, macOS, Windows, and Linux.

## About TwoDo

TwoDo simplifies your daily home task management by providing:
- **Task Organization** - Create, manage, and organize your household tasks
- **Cross-Platform Support** - Access your tasks from any device (mobile, web, or desktop)
- **Secure Authentication** - Firebase-powered user authentication
- **Real-time Sync** - Your tasks stay synchronized across all devices
- **Clean Dashboard** - Intuitive interface to view and manage your to-do list

## Project Structure

```
lib/
├── main.dart                      # Application entry point
├── core/
│   ├── dependency_injection.dart # Dependency injection setup
│   ├── exception.dart            # Exception handling
│   └── result_widget.dart        # Result state widgets
├── database/
│   └── firebase_db.dart          # Firebase database integration
├── features/
│   ├── authentication/           # User authentication feature
│   └── dashboard/                # Main task dashboard feature
└── shared/
    ├── auth_widgets.dart         # Authentication UI components
    ├── circular_indicator.dart   # Loading indicator widget
    ├── custom_builder.dart       # Custom builder utilities
    └── screen/                   # Shared screen components

packages/
└── shared_ui/                     # Shared UI package for reusable components

android/                           # Android native code
ios/                              # iOS native code
web/                              # Web platform code
macos/                            # macOS desktop code
windows/                          # Windows desktop code
linux/                            # Linux desktop code

firebase.json                      # Firebase configuration
pubspec.yaml                       # Flutter dependencies and project metadata
```

## Key Features

- **Multi-Platform** - Single codebase for iOS, Android, Web, macOS, Windows, and Linux
- **Firebase Integration** - Authentication and cloud database for task persistence
- **Modular Architecture** - Organized feature-based structure for maintainability
- **Shared UI Components** - Reusable UI package for consistent design

## Getting Started

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Prerequisites
- Flutter SDK
- Dart SDK
- Firebase account configured

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure Firebase for your platforms
4. Run `flutter run` to start the app
