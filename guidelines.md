# Flutter Development Guidelines

This document establishes the standards and best practices for Flutter and Dart development in this project. It is intended for developers who are familiar with programming concepts and want to build beautiful, performant, and maintainable applications.

---

## Table of Contents

1. [Interaction & Tooling](#1-interaction--tooling)
2. [Project Structure](#2-project-structure)
3. [Flutter Style Guide](#3-flutter-style-guide)
4. [Package Management](#4-package-management)
5. [Code Quality](#5-code-quality)
6. [Dart Best Practices](#6-dart-best-practices)
7. [Flutter Best Practices](#7-flutter-best-practices)
8. [Application Architecture](#8-application-architecture)
9. [State Management](#9-state-management)
10. [Data Flow & Serialization](#10-data-flow--serialization)
11. [Routing & Navigation](#11-routing--navigation)
12. [Logging](#12-logging)
13. [Code Generation](#13-code-generation)
14. [Testing](#14-testing)
15. [Visual Design & Theming](#15-visual-design--theming)
16. [Material Theming Best Practices](#16-material-theming-best-practices)
17. [Layout Best Practices](#17-layout-best-practices)
18. [Color Scheme Best Practices](#18-color-scheme-best-practices)
19. [Font Best Practices](#19-font-best-practices)
20. [Documentation](#20-documentation)
21. [Accessibility (A11Y)](#21-accessibility-a11y)

---

## 1. Interaction & Tooling

- Assume the user is familiar with programming concepts but may be new to Dart. When generating code, include explanations for Dart-specific features such as null safety, futures, and streams.
- If a request is ambiguous, ask for clarification on the intended functionality and the target platform (e.g., command-line, web, server).
- When suggesting new dependencies from `pub.dev`, explain their benefits.
- Use the `dart_format` tool to ensure consistent code formatting.
- Use the `dart_fix` tool to automatically fix common errors and help code conform to configured analysis options.
- Use the Dart linter with a recommended set of rules to catch common issues. Use the `analyze_files` tool to run the linter.

---

## 2. Project Structure

The standard Flutter project structure is assumed, with `lib/main.dart` as the primary application entry point.

---

## 3. Flutter Style Guide

- **SOLID Principles:** Apply SOLID principles throughout the codebase.
- **Concise and Declarative:** Write concise, modern, technical Dart code. Prefer functional and declarative patterns.
- **Composition over Inheritance:** Favor composition for building complex widgets and logic.
- **Immutability:** Prefer immutable data structures. Widgets (especially `StatelessWidget`) should be immutable.
- **State Management:** Separate ephemeral state and app state. Use a state management solution for app state to handle separation of concerns.
- **Widgets are for UI:** Compose complex UIs from smaller, reusable widgets.
- **Navigation:** Use a modern routing package like `auto_route` or `go_router`. See [Routing & Navigation](#11-routing--navigation) for more details.

---

## 4. Package Management

| Task | Preferred Method | Fallback Command |
|---|---|---|
| Search packages | `pub_dev_search` tool | Browse pub.dev manually |
| Add dependency | `pub` tool | `flutter pub add <package_name>` |
| Add dev dependency | `pub` tool with `dev:<package_name>` | `flutter pub add dev:<package_name>` |
| Add dependency override | `pub` tool with `override:<package_name>:1.0.0` | `flutter pub add override:<package_name>:1.0.0` |
| Remove dependency | `pub` tool | `dart pub remove <package_name>` |

---

## 5. Code Quality

### Structure
- Adhere to maintainable code structure and separation of concerns (e.g., UI logic separate from business logic).

### Naming Conventions
- Avoid abbreviations. Use meaningful, consistent, and descriptive names for variables, functions, and classes.
- `PascalCase` for classes
- `camelCase` for members, variables, functions, and enums
- `snake_case` for files

### Style
- Lines should be **80 characters or fewer**.
- Keep functions short and single-purpose. Strive for **fewer than 20 lines** per function.

### General Principles
- **Conciseness:** Write code as short as it can be while remaining clear.
- **Simplicity:** Write straightforward code. Clever or obscure code is difficult to maintain.
- **Error Handling:** Anticipate and handle potential errors. Never let code fail silently.
- **Logging:** Use the `logging` package instead of `print`.
- **Testing:** Write code with testability in mind. Use the `file`, `process`, and `platform` packages where appropriate to enable injection of in-memory and fake objects.

---

## 6. Dart Best Practices

- Follow the official [Effective Dart guidelines](https://dart.dev/effective-dart).
- Define related classes within the same library file. For large libraries, export smaller, private libraries from a single top-level library.
- Group related libraries in the same folder.
- Add documentation comments to all public APIs, including classes, constructors, methods, and top-level functions.
- Write clear comments for complex or non-obvious code. Avoid over-commenting and trailing comments.

### Async
- Use `Future`s, `async`, and `await` for asynchronous operations.
- Use `Stream`s for sequences of asynchronous events.
- Ensure robust error handling with all async operations.

### Language Features
- **Null Safety:** Write soundly null-safe code. Leverage Dart's null safety features. Avoid `!` unless the value is guaranteed to be non-null.
- **Pattern Matching:** Use pattern matching where it simplifies code.
- **Records:** Use records to return multiple values when defining an entire class would be cumbersome.
- **Switch Statements:** Prefer exhaustive `switch` statements or expressions — they do not require `break` statements.
- **Exception Handling:** Use `try-catch` blocks with exceptions appropriate to the context. Define custom exceptions for situations specific to your code.
- **Arrow Functions:** Use arrow syntax for simple one-line functions.

---

## 7. Flutter Best Practices

- **Immutability:** Widgets (especially `StatelessWidget`) are immutable. When the UI needs to change, Flutter rebuilds the widget tree.
- **Composition:** Prefer composing smaller widgets over extending existing ones to avoid deep widget nesting.
- **Private Widgets:** Use small, private `Widget` classes instead of helper methods that return a `Widget`.
- **Build Methods:** Break down large `build()` methods into smaller, reusable private Widget classes.
- **List Performance:** Use `ListView.builder` or `SliverList` for long lists to enable lazy loading.
- **Isolates:** Use `compute()` to run expensive calculations (e.g., JSON parsing) in a separate isolate to avoid blocking the UI thread.
- **Const Constructors:** Use `const` constructors for widgets and in `build()` methods whenever possible to reduce rebuilds.
- **Build Method Performance:** Avoid performing expensive operations (network calls, complex computations) directly inside `build()` methods.

---

## 8. Application Architecture

- **Separation of Concerns:** Aim for a separation of concerns similar to MVC/MVVM, with clear Model, View, and ViewModel/Controller roles.
- **Logical Layers:** Organize the project into the following layers:
  - **Presentation** — widgets and screens
  - **Domain** — business logic classes
  - **Data** — model classes and API clients
  - **Core** — shared classes, utilities, and extension types
- **Feature-based Organization:** For larger projects, organize code by feature, where each feature has its own `presentation`, `domain`, and `data` subfolders.

### API Design Principles

When building reusable APIs or libraries:

- **Consider the User:** Design APIs from the perspective of the person who will use them. The API should be intuitive and easy to use correctly.
- **Documentation is Essential:** Good documentation is part of good API design. It should be clear, concise, and include examples.

---

## 9. State Management

- **Built-in Solutions First:** Prefer Flutter's built-in state management solutions. Do not introduce a third-party package unless explicitly requested.

| Scenario | Recommended Approach |
|---|---|
| Sequence of async events | `Stream` + `StreamBuilder` |
| Single async operation | `Future` + `FutureBuilder` |
| Simple, local single-value state | `ValueNotifier` + `ValueListenableBuilder` |
| Complex or shared state | `ChangeNotifier` + `ListenableBuilder` |
| Robust, scalable solution | MVVM pattern |

**Example — `ValueNotifier`:**
```dart
// Define a ValueNotifier to hold the state.
final ValueNotifier<int> _counter = ValueNotifier<int>(0);

// Use ValueListenableBuilder to listen and rebuild.
ValueListenableBuilder<int>(
  valueListenable: _counter,
  builder: (context, value, child) {
    return Text('Count: $value');
  },
);
```

- **Dependency Injection:** Use manual constructor injection to make class dependencies explicit and to manage dependencies between layers.
- **Provider:** If a DI solution beyond manual injection is explicitly requested, `provider` may be used to make services, repositories, or complex state objects available to the UI layer.

### Lint Rules

Include the following as a starting point in `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Add additional lint rules here:
    # avoid_print: false
    # prefer_single_quotes: true
```

---

## 10. Data Flow & Serialization

- **Data Structures:** Define classes to represent the data used in the application.
- **Data Abstraction:** Abstract data sources (API calls, database operations) using Repositories or Services to promote testability.

### JSON Serialization

Use `json_serializable` and `json_annotation` for parsing and encoding JSON data. Use `fieldRename: FieldRename.snake` to convert Dart's `camelCase` fields to `snake_case` JSON keys.

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String firstName;
  final String lastName;

  User({required this.firstName, required this.lastName});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

---

## 11. Routing & Navigation

- **GoRouter:** Use the `go_router` package for declarative navigation, deep linking, and web support.

**Setup example:**
```dart
// 1. Add the dependency
// flutter pub add go_router

// 2. Configure the router
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'details/:id',
          builder: (context, state) {
            final String id = state.pathParameters['id']!;
            return DetailScreen(id: id);
          },
        ),
      ],
    ),
  ],
);

// 3. Use it in your MaterialApp
MaterialApp.router(
  routerConfig: _router,
);
```

- **Authentication Redirects:** Configure `go_router`'s `redirect` property to handle authentication flows, ensuring users are redirected to the login screen when unauthorized and back to their intended destination after login.
- **Navigator:** Use the built-in `Navigator` for short-lived screens that do not need deep linking, such as dialogs or temporary views.

```dart
// Push a new screen onto the stack
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DetailsScreen()),
);

// Pop the current screen to go back
Navigator.pop(context);
```

---

## 12. Logging

Use the `log` function from `dart:developer` for structured logging that integrates with Dart DevTools.

```dart
import 'dart:developer' as developer;

// For simple messages
developer.log('User logged in successfully.');

// For structured error logging
try {
  // ... code that might fail
} catch (e, s) {
  developer.log(
    'Failed to fetch data',
    name: 'myapp.network',
    level: 1000, // SEVERE
    error: e,
    stackTrace: s,
  );
}
```

---

## 13. Code Generation

- Ensure `build_runner` is listed as a dev dependency in `pubspec.yaml` if the project uses code generation.
- Use `build_runner` for all code generation tasks (e.g., `json_serializable`).
- After modifying files that require code generation, run:

```shell
dart run build_runner build --delete-conflicting-outputs
```

---

## 14. Testing

### Running Tests

Use the `run_tests` tool if available; otherwise use `flutter test`.

### Test Libraries

| Test Type | Package |
|---|---|
| Unit tests | `package:test` |
| Widget tests | `package:flutter_test` |
| Integration tests | `package:integration_test` |
| Assertions | `package:checks` (preferred for expressiveness) |

### Best Practices

- Follow the **Arrange-Act-Assert** (or Given-When-Then) pattern.
- Write **unit tests** for domain logic, data layer, and state management.
- Write **widget tests** for UI components.
- Write **integration tests** to verify end-to-end user flows.
- Add `integration_test` as a `dev_dependency` with `sdk: flutter` in `pubspec.yaml`.
- **Prefer fakes or stubs over mocks.** If mocks are necessary, use `mockito` or `mocktail`. Avoid code generation for mocks where possible.
- Aim for **high test coverage**.

---

## 15. Visual Design & Theming

- Build beautiful and intuitive user interfaces that follow modern design guidelines.
- Ensure the app is responsive and adapts to different screen sizes, working correctly on both mobile and web.
- Provide an intuitive navigation bar or controls when multiple pages exist.
- Apply subtle noise texture to the main background for a premium, tactile feel.
- Use multi-layered drop shadows to create depth; cards should appear "lifted."
- Use `Semantics`-aware icons to enhance understanding and navigation.
- Apply elegant shadow and color "glow" effects to interactive elements (buttons, checkboxes, sliders, etc.).
- Emphasize font sizes using hierarchy (hero text, section headlines, body, keywords) to aid readability.

### Theming

- **Centralized Theme:** Define a centralized `ThemeData` object for a consistent application-wide style.
- **Light and Dark Themes:** Implement both light and dark themes with a user-facing theme toggle using `ThemeMode.light`, `ThemeMode.dark`, and `ThemeMode.system`.
- **Color Scheme Generation:** Generate harmonious color palettes from a single seed color using `ColorScheme.fromSeed`.

```dart
final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.light,
  ),
  // ... other theme properties
);
```

- **Color Palette:** Include a wide range of color concentrations and hues to create a vibrant and energetic look and feel.
- **Component Themes:** Use specific theme properties (e.g., `appBarTheme`, `elevatedButtonTheme`) to customize individual Material components.
- **Custom Fonts:** Use the `google_fonts` package and define a `TextTheme` to apply fonts consistently.

```dart
// flutter pub add google_fonts

final TextTheme appTextTheme = TextTheme(
  displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
  titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
  bodyMedium: GoogleFonts.openSans(fontSize: 14),
);
```

### Assets and Images

- Declare all asset paths in `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

- Use `Image.asset` for local images and `Image.network` for remote images.
- Always provide `loadingBuilder` and `errorBuilder` for network images:

```dart
Image.network(
  'https://picsum.photos/200/300',
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;
    return const Center(child: CircularProgressIndicator());
  },
  errorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.error);
  },
)
```

- For cached images, use the `cached_network_image` package.
- Use `ImageIcon` to display custom icons not available in the `Icons` class.

---

## 16. Material Theming Best Practices

### Embrace `ThemeData` and Material 3

- Use `ColorScheme.fromSeed()` to generate a harmonious color palette for both light and dark modes from a single seed color.
- Provide both `theme` and `darkTheme` to `MaterialApp` to support system brightness settings.
- Centralize component styles within `ThemeData` for consistency.
- Control `themeMode` dynamically (e.g., via `ChangeNotifierProvider`) to enable toggling between `ThemeMode.light`, `ThemeMode.dark`, and `ThemeMode.system`.

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 14.0, height: 1.4),
    ),
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
  ),
  home: const MyHomePage(),
);
```

### Design Tokens with `ThemeExtension`

For custom styles outside of standard `ThemeData`, use `ThemeExtension` to define reusable design tokens.

1. Create a class extending `ThemeExtension<T>` with custom properties.
2. Implement `copyWith` and `lerp` (required for theme transitions).
3. Register in `ThemeData`'s `extensions` list.
4. Access tokens via `Theme.of(context).extension<MyColors>()!`.

```dart
@immutable
class MyColors extends ThemeExtension<MyColors> {
  const MyColors({required this.success, required this.danger});

  final Color? success;
  final Color? danger;

  @override
  ThemeExtension<MyColors> copyWith({Color? success, Color? danger}) {
    return MyColors(success: success ?? this.success, danger: danger ?? this.danger);
  }

  @override
  ThemeExtension<MyColors> lerp(ThemeExtension<MyColors>? other, double t) {
    if (other is! MyColors) return this;
    return MyColors(
      success: Color.lerp(success, other.success, t),
      danger: Color.lerp(danger, other.danger, t),
    );
  }
}

// Register
theme: ThemeData(
  extensions: const <ThemeExtension<dynamic>>[
    MyColors(success: Colors.green, danger: Colors.red),
  ],
),

// Use
Container(
  color: Theme.of(context).extension<MyColors>()!.success,
)
```

### Styling with `WidgetStateProperty`

- Use `WidgetStateProperty.resolveWith` to return different values based on the widget's current state.
- Use `WidgetStateProperty.all` as shorthand when the value is the same for all states.

```dart
final ButtonStyle myButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return Colors.green;
      }
      return Colors.red;
    },
  ),
);
```

---

## 17. Layout Best Practices

### Rows and Columns

| Widget | When to Use |
|---|---|
| `Expanded` | Fill remaining space along the main axis |
| `Flexible` | Shrink to fit without necessarily growing |
| `Wrap` | Allow widgets to wrap to the next line on overflow |

> Do not combine `Flexible` and `Expanded` in the same `Row` or `Column`.

### General Content

| Widget | When to Use |
|---|---|
| `SingleChildScrollView` | Content is larger than viewport but fixed in size |
| `ListView.builder` / `GridView.builder` | Long lists or grids (always use builder constructor) |
| `FittedBox` | Scale or fit a single child within its parent |
| `LayoutBuilder` | Responsive layouts requiring decisions based on available space |

### Layering with Stack

- Use `Positioned` to anchor children to specific edges within a `Stack`.
- Use `Align` to position children using alignment values like `Alignment.center`.

### Advanced Layouts with Overlays

Use `OverlayPortal` for UI elements that must appear on top of everything else (e.g., custom dropdowns or tooltips). It manages the `OverlayEntry` lifecycle for you.

```dart
class MyDropdown extends StatefulWidget {
  const MyDropdown({super.key});

  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  final _controller = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: (BuildContext context) {
        return const Positioned(
          top: 50,
          left: 10,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('I am an overlay!'),
            ),
          ),
        );
      },
      child: ElevatedButton(
        onPressed: _controller.toggle,
        child: const Text('Toggle Overlay'),
      ),
    );
  }
}
```

---

## 18. Color Scheme Best Practices

### Contrast Ratios (WCAG 2.1)

| Text Type | Minimum Contrast Ratio |
|---|---|
| Normal text | **4.5:1** |
| Large text (18pt or 14pt bold) | **3:1** |

### Palette Selection

Follow the **60-30-10 Rule** for a balanced color scheme:
- **60%** — Primary/Neutral Color (Dominant)
- **30%** — Secondary Color
- **10%** — Accent Color

### Complementary Colors

Use complementary colors with caution. They work best as accent colors to make elements pop, but are generally poor for text/background pairings as they can cause eye strain.

### Example Palette

| Role | Color | Hex |
|---|---|---|
| Primary | Dark Blue | `#0D47A1` |
| Secondary | Medium Blue | `#1976D2` |
| Accent | Amber | `#FFC107` |
| Neutral/Text | Almost Black | `#212121` |
| Background | Almost White | `#FEFEFE` |

---

## 19. Font Best Practices

### Font Selection

- Limit font families to **one or two** for the entire application.
- Prioritize legibility. Sans-serif fonts are generally preferred for UI body text.
- Consider platform-native system fonts for a native look.
- Use the `google_fonts` package for access to a wide selection of open-source fonts.

### Hierarchy and Scale

- Define a consistent set of font sizes for different text elements (headlines, titles, body, captions).
- Use font weight to differentiate text levels effectively.
- Use color and opacity to de-emphasize less important text.

### Readability

- **Line Height:** Set line height to approximately **1.4×–1.6×** the font size.
- **Line Length:** For body text, aim for **45–75 characters** per line.
- **Avoid All Caps:** Do not use all caps for long-form text.

### Example Typographic Scale

```dart
textTheme: const TextTheme(
  displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
  titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
  bodyLarge: TextStyle(fontSize: 16.0, height: 1.5),
  bodyMedium: TextStyle(fontSize: 14.0, height: 1.4),
  labelSmall: TextStyle(fontSize: 11.0, color: Colors.grey),
),
```

---

## 20. Documentation

Use `dartdoc`-style (`///`) comments for all public APIs.

### Philosophy

- **Comment why, not what.** The code should be self-explanatory; comments should explain intent and reasoning.
- **Write for the reader.** If you had a question and found the answer, add it where you first looked.
- **Avoid useless documentation.** If a comment only restates the obvious from the code's name, omit it.
- **Be consistent.** Use consistent terminology throughout all documentation.

### Commenting Style

- Use `///` for doc comments so documentation generation tools can process them.
- Begin with a **single-sentence summary** ending with a period.
- Add a blank line after the first sentence to separate the summary from the body.
- Avoid repeating information obvious from the code's name or signature.
- Document only the getter or setter for a property — not both.

### Writing Style

- Write concisely. Avoid jargon and unexplained acronyms.
- Use Markdown sparingly. Never use HTML for formatting.
- Enclose code references in backticks and use fenced code blocks with language identifiers.

### What to Document

- All public APIs (highest priority).
- Private APIs where the logic is non-obvious.
- Library-level overviews via a top-level doc comment.
- Parameters, return values, and exceptions using descriptive prose.
- Code samples where they aid understanding.
- Place doc comments before any metadata annotations.

---

## 21. Accessibility (A11Y)

Implement accessibility features to support users with a wide variety of physical abilities, mental abilities, age groups, education levels, and learning styles.

| Guideline | Requirement |
|---|---|
| **Color Contrast** | Text must have a contrast ratio of at least **4.5:1** against its background |
| **Dynamic Text Scaling** | Test that the UI remains usable when the system font size is increased |
| **Semantic Labels** | Use the `Semantics` widget to provide clear, descriptive labels for UI elements |
| **Screen Reader Testing** | Regularly test with TalkBack (Android) and VoiceOver (iOS) |
