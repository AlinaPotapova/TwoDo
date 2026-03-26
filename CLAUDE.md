# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get       # Install dependencies
flutter run           # Run the app
flutter analyze       # Static analysis
flutter test          # Run tests
flutter build apk     # Build Android APK
flutter build ios     # Build iOS app
```

## Architecture

Feature-based Clean Architecture with BLoC/Cubit state management.

### Layer structure (per feature)

```
features/<feature>/
  data/        # Concrete repository implementations (Firebase)
  domain/      # Abstract interfaces and models
  presentation/
    <screen>/
      cubit/   # State management
      <screen>_screen.dart
      <screen>_content.dart
```

### Key patterns

- **Repository pattern**: `AuthRepository` (abstract in `domain/`) → `FirebaseRepository` (concrete in `data/`). Inject via `get_it` service locator set up in `core/dependency_injection.dart`.
- **State management**: Cubits emit sealed state classes (e.g., `LoginInitial`, `LoginLoading`, `LoginSuccess`, `LoginFailure`). UI uses `AppBlocBuilder` (`shared/custom_builder.dart`) which wraps `BlocConsumer`.
- **Error handling**: `Result<T>` sealed class (`core/result_widget.dart`) with `Success`/`Failure` variants — used for repository return values.
- **Dependency injection**: `get_it` for the service locator, with `DependenciesRoot` widget initializing everything in `main.dart`.

### Navigation

Plain Flutter `Navigator` with `pushReplacement`/`pushAndRemoveUntil`. No routing library. Flow: `LoginScreen` → `DashboardScreen` (on `LoginSuccess`) → back to `LoginScreen` (on `DashboardSignedOut`).

### Firebase

- Project ID: `focus-app-abc37`
- Services: Firebase Auth (email/password + Google Sign-In), Firebase Realtime Database
- `lib/firebase_options.dart` is excluded from version control — must be generated via `flutterfire configure` or obtained separately before running the app
- Platform config files: `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`

### Shared components (`lib/shared/`)

- `auth_widgets.dart` — `AuthTextField`, `AuthLabeledField`, `AuthPrimaryButton`
- `custom_builder.dart` — `AppBlocBuilder<C, S>` (BlocConsumer wrapper)
- `circular_indicator.dart` — custom loading indicator
