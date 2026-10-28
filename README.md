# Mobile Computing: Flutter Portfolio & State Management Hub
**Hands-on Activity (By Pair)**: Master Compilation App & State Management Architecture

---

## 📌 Project Overview
This Flutter application serves as the **Master Compilation App** for all Mobile Computing laboratory activities. It is architected to scale as a multi-screen portfolio that compiles upcoming laboratory modules into a unified, responsive dashboard with centralized state management.

---

## 🎯 Key Objectives & Requirements Met

| Requirement | Implementation Detail | Location |
| :--- | :--- | :--- |
| **Project Setup** | Production-ready Flutter application with structured modular architecture. | `lib/` |
| **Multi-Screen Navigation** | Named routing system connecting Home Dashboard, Activity 1, Activity 2, Activity 3, and Settings. | `lib/main.dart` |
| **Widget Architecture** | Declarative separation of concerns: `StatelessWidget` for static reusable components, and `StatefulWidget` for local reactive interactions. | `lib/widgets/` & `lib/screens/` |
| **Responsive Layout** | Native layout widgets (`Column`, `Row`, `Expanded`, `Flexible`, `SingleChildScrollView`, `LayoutBuilder`, `Wrap`) ensuring zero overflow across phone, tablet, and desktop views. | Across all screens |
| **Global State Management** | Centralized `AppStateProvider` powered by `provider`. Manages live Dark/Light theme toggles, accent palette, and Student/Pair profile data that immediately synchronizes across the app. | `lib/providers/app_state_provider.dart` |

---

## 📂 Architecture & Directory Structure

```text
lib/
├── main.dart                               # Root entry point, Theme injection, & Named routes
├── models/
│   └── activity_model.dart                 # Activity metadata data class
├── providers/
│   └── app_state_provider.dart             # Global state (ThemeMode, SeedColor, Profile, Progress)
├── screens/
│   ├── home_dashboard_screen.dart          # Master compilation menu & responsive metrics
│   ├── settings_screen.dart                # Dedicated screen for theme & profile management
│   └── activities/
│       ├── activity1_screen.dart           # Activity 1: Interactive Counter Studio (StatefulWidget)
│       ├── activity2_screen.dart           # Activity 2: Bill & Tip Splitter (StatefulWidget)
│       └── activity3_screen.dart           # Activity 3: Lab Checklist & Milestones (StatefulWidget)
└── widgets/
    ├── activity_card.dart                  # Reusable declarative Activity card (StatelessWidget)
    ├── dashboard_header.dart               # Live profile banner & quick theme switch (StatelessWidget)
    └── metric_card.dart                    # Metric tile using Row, Expanded, & Icon (StatelessWidget)
```

---

## 🧩 Declarative UI & Widget Principles

### 1. `StatelessWidget` (Immutable / Pure Presentation)
- **`ActivityCard`** (`lib/widgets/activity_card.dart`): Pure component rendering the activity icon, title, subtitle, description, responsive tags via `Wrap`, and launch button based strictly on props.
- **`MetricCard`** (`lib/widgets/metric_card.dart`): Pure metric tile built with `Row`, `Expanded`, and custom container decorations.
- **`DashboardHeader`** (`lib/widgets/dashboard_header.dart`): Header displaying student avatar initials, pair profile name, and course section subscribed declaratively to `AppStateProvider`.

### 2. `StatefulWidget` (Local Mutable State)
- **`Activity1Screen`** (`lib/screens/activities/activity1_screen.dart`): Manages local counter value, step size modifier (1, 5, 10, 50), dynamic card color selection, and real-time interaction history logs.
- **`Activity2Screen`** (`lib/screens/activities/activity2_screen.dart`): Real-time financial split calculator utilizing `TextEditingController` for currency inputs, tip percentage slider, and guest count steppers.
- **`Activity3Screen`** (`lib/screens/activities/activity3_screen.dart`): Stateful checklist with dialog item creation, task toggle states, and visual progress indicators.
- **`SettingsScreen`** (`lib/screens/settings_screen.dart`): Text editing controllers for profile details, segmented controls for theme switching, and accent color pickers.

---

## 🌐 Global State Management (`Provider`)

The `AppStateProvider` extends `ChangeNotifier`:
- **Theme Mode**: Instant toggle between `ThemeMode.light`, `ThemeMode.dark`, and `ThemeMode.system`.
- **Primary Color Seed**: Dynamically adjusts Material 3 `colorScheme` across all screens.
- **Student Profile**: Real-time updates to Student/Pair names, Course & Section, and Student IDs. Modifying these in the `SettingsScreen` immediately updates the `DashboardHeader` on the Home Dashboard.
- **Lab Completion**: Tracks which activities have been finished and renders live progress indicators.

---

## 🚀 How to Run the Application

### 1. Run Widget & Unit Tests
```bash
flutter test
```
*Validates dashboard rendering, navigation routes, stateful counter interactions, and theme persistence.*

### 2. Launch on Chrome (Web)
```bash
flutter run -d chrome
```

### 3. Launch on Windows Desktop
```bash
flutter run -d windows
```
