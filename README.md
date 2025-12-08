> 🚧 **Work in Progress**
> This project is currently under active development. I am using it to strictly practice
> **Clean Architecture** and **BLoC**. Some features may be incomplete.

# Music Player 🎵

> **Status:** Active Development  
> **Architecture:** Feature-First Clean Architecture  
> **State Management:** BLoC (Business Logic Component)

A robust, offline-first music player built with Flutter, designed to demonstrate enterprise-grade architecture patterns, background audio resilience, and modern UI/UX principles.

## 🏗 Architecture & Design

This project adheres strictly to **Clean Architecture** principles, enforcing a separation of concerns that ensures scalability and testability.

### 1. Domain-Driven Design (DDD)
The codebase is modularized by **Features**, not by layer. Each feature is a self-contained unit:
*   **`lib/features/local music/`**: Responsible for querying the device's storage for audio files (Data Source) and presenting the library (UI).
*   **`lib/features/music_player/`**: The playback engine. Manages the Now Playing screen, transport controls, and synchronization with the OS.
*   **`lib/features/background-notification-feature/`**: A specialized **Infrastructure Module** hosting the `AudioHandler`. It acts as the bridge between the Flutter UI and the Android/iOS media session, ensuring playback survives background process termination.

### 2. Layered Structure
Within each feature:
*   **Domain (Inner Layer):** Pure Dart. Contains `Entities`, `UseCases`, and Repository Interfaces. Zero Flutter dependencies.
*   **Data (Middle Layer):** Implementations. Handles `DataSources` (e.g., `on_audio_query`, `just_audio`), DTOs (`Models`), and Repository Implementations.
*   **Presentation (Outer Layer):** `BLoCs` and `Widgets`. Strictly reactive UI that listens to streams.

## 🚀 Key Features

*   **Offline Playback:** Scans local device storage for audio files.
*   **Background Audio:** Leverages `audio_service` to maintain a foreground service, allowing playback to continue when the screen is off or the app is minimized.
*   **Queue Management:** Implements `ConcatenatingAudioSource` for gapless playback and persistent queue management.
*   **Media Notifications:** Full integration with OS media controls (Android 13+ / iOS Control Center), including Seek bars and Artwork.
*   **Playback Modes:** Support for Shuffle and Repeat (Off/All/One).
*   **Permission Handling:** Graceful handling of Android 13+ `READ_MEDIA_AUDIO` and legacy `READ_EXTERNAL_STORAGE` permissions.

## 🛠 Tech Stack

| Category | Package | Purpose |
| :--- | :--- | :--- |
| **State Management** | `flutter_bloc` | Predictable state transitions using Events/States. |
| **DI** | `get_it` | Service Locator for dependency injection. |
| **Audio Engine** | `just_audio` | Robust audio player with gapless playback support. |
| **Background** | `audio_service` | Manages background execution and media notifications. |
| **Query** | `on_audio_query` | Efficiently queries local content resolvers. |
| **Functional** | `fpdart` | Error handling using `Either<Failure, Success>`. |
| **Code Gen** | `freezed` | Immutable data classes and unions. |

## 📦 Project Structure

```text
lib/
├── core/                  # Shared kernel (DI, Themes, Errors)
├── features/
│   ├── background-notification-feature/
│   │   └── data/          # Service implementation (AudioHandler)
│   ├── local music/       # Library Feature
│   │   ├── data/          # on_audio_query implementation
│   │   ├── domain/        # Song Entities & UseCases
│   │   └── presentation/  # Song List UI & BLoC
│   └── music_player/      # Playback Feature
│       ├── data/          # Repository wrapping AudioHandler
│       ├── domain/        # Playback Interface (Contract)
│       └── presentation/  # Player Controls UI & BLoC
└── main.dart              # Entry point & Initialization
```

## 🔧 Setup & Running

1.  **Prerequisites:** Flutter SDK (Stable), Android Studio / VS Code.
2.  **Dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Code Generation:**
    If you modify BLoC states or Entities, regenerate code:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
4.  **Run:**
    ```bash
    flutter run
    ```

## 🧪 Testing

This project emphasizes unit testing for critical logic.
*   **Audio Handler Tests:** Verifies the integration between `just_audio` and `audio_service`.

```bash
flutter test
```

---
**Note:** This project handles sensitive permissions (`READ_MEDIA_AUDIO`). Ensure you test on a real device or an emulator with valid media files.
