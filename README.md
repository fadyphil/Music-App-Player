> 🚧 **Work in Progress**
> This project is currently under active development. I am using it to strictly practice
> **Clean Architecture** and **BLoC**. Some features may be incomplete.

---

title: Music Player Architecture Reference
description: A production-grade Flutter application demonstrating Feature-First Clean Architecture, BLoC, and Offline-First principles.
tags: [flutter, clean-architecture, bloc, audio, sqlite]

---

# Music Player 🎵

> **Status:** Active Development (Beta)  
> **Architecture:** Feature-First Clean Architecture (DDD)  
> **State Management:** BLoC (Business Logic Component)

## Overview

This project serves as a strictly typed, production-grade reference implementation for **Clean Architecture** in Flutter. It is designed to demonstrate how to build a scalable, testable, and offline-first mobile application that survives background process termination and strictly enforces separation of concerns.

Unlike simple "todo apps," this project tackles real-world complexity:

- **Background Audio:** Managing Android/iOS media sessions (`MediaSessionService`) when the app is killed.
- **Persistence:** A local SQLite database for analytics and `SharedPreferences` for flags.
- **Hardware Permissions:** Graceful handling of Android 13+ granular media permissions.
- **User Identity:** Local-first user profiles with avatar customization and physics-based interactions.

## Getting Started

### Prerequisites

- **Flutter SDK:** Stable channel (v3.10+)
- **Platform:** Android (min SDK 21) or iOS (min 13.0). _Desktop support is experimental._

### Installation & Run

1.  **Clone and Install:**

    ```bash
    git clone [repository_url]
    flutter pub get
    ```

2.  **Code Generation (Mandatory):**
    This project uses `freezed` and `json_serializable`. You must run the build runner before launching:

    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

3.  **Run Application:**
    ```bash
    flutter run
    ```

## Architecture & Design (Reference)

The codebase follows the **Feature-First** packaging strategy. Each feature is a self-contained module with its own "Three-Layer" architecture.

### Directory Structure

```text
lib/
├── core/                  # Shared Kernel (DI, Themes, Failures)
├── features/
│   ├── analytics/         # [Feature] Listening History & Graphs
│   ├── home/              # [Feature] Navigation Shell & Orchestration
│   ├── local music/       # [Feature] Device Storage Scanning
│   ├── music_player/      # [Feature] Audio Engine & UI
│   ├── onboarding/        # [Feature] First-Time User Experience & Registration
│   └── profile/           # [Feature] User Identity & System Settings
└── main.dart              # Entry Point & Service Locator
```

### The Three Layers (Per Feature)

1.  **Domain (Inner Layer):**

    - **Role:** Business Logic & Rules.
    - **Contents:** `Entities` (Pure Dart classes), `UseCases` (Single-action classes), `Repository Interfaces`.
    - **Dependencies:** ZERO Flutter dependencies. Pure Dart.

2.  **Data (Middle Layer):**

    - **Role:** Data Retrieval & Transformation.
    - **Contents:** `DataSources` (API/DB/File), `DTOs` (Models), `Repository Implementations`.
    - **Dependencies:** External packages (`sqflite`, `dio`, `on_audio_query`).

3.  **Presentation (Outer Layer):**
    - **Role:** UI & State Management.
    - **Contents:** `Pages`, `Widgets`, `BLoCs` / `Cubits`.
    - **Dependencies:** Flutter, `flutter_bloc`.

## Feature Catalog

| Feature          | Description                                                               | Key Tech                               |
| :--------------- | :------------------------------------------------------------------------ | :------------------------------------- |
| **Local Music**  | Scans device storage for audio files using `ContentResolver`.             | `on_audio_query`, `permission_handler` |
| **Music Player** | Robust playback engine with gapless queue, shuffle, and repeat.           | `just_audio`, `audio_service`          |
| **Analytics**    | Tracks playback history and visualizes data (Top Genres, Daily Activity). | `sqflite`, `fl_chart`                  |
| **Onboarding**   | First-run experience with "Auditory Profile" registration (Avatar/Name).  | `flutter_animate`, `bloc`              |
| **Profile**      | User identity management, UI customization, and Deep Cache Purge.         | `image_picker`, `path_provider`        |
| **Background**   | Keeps audio alive when the app is minimized or screen is off.             | `Android Foreground Service`           |

## Tech Stack & Decisions

| Category         | Package                 | Reasoning                                                        |
| :--------------- | :---------------------- | :--------------------------------------------------------------- |
| **State**        | `flutter_bloc`          | Ensures unidirectional data flow and easy testing of states.     |
| **DI**           | `get_it`                | Decouples instantiation from usage (Service Locator pattern).    |
| **Functional**   | `fpdart`                | Enforces error handling via `Either<Failure, Success>` types.    |
| **Immutability** | `freezed`               | Prevents side-effects in State objects and Entities.             |
| **Database**     | `sqflite`               | High-performance SQL engine for aggregation queries (Analytics). |
| **Media**        | `image_picker`          | Native image selection for user avatars.                         |
| **Assets**       | `flutter_native_splash` | Provides a seamless launch experience on Android 12+.            |

## Troubleshooting

### Common Errors

**Error:** `Missing concrete implementation of ...` or `The method ... isn't defined.`

- **Cause:** The generated files (`*.g.dart`, `*.freezed.dart`) are out of sync.
- **Fix:** Run `dart run build_runner build --delete-conflicting-outputs`.

**Error:** `Permission denied (READ_MEDIA_AUDIO)`

- **Cause:** Testing on Android 13+ emulator without granting runtime permissions.
- **Fix:** Accept the system dialog, or manually enable permissions in App Settings.

**Error:** `No Material widget found`

- **Cause:** Using Material widgets (like `TextField`) without a `Scaffold` or `Material` ancestor.
- **Fix:** Ensure top-level pages are wrapped in `Scaffold`.

---

_Maintained by the Engineering Team. For deep architectural changes, consult the `05_Architecture.md` manifesto._