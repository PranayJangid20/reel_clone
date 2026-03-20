# Reels Clone

A simple, robust Instagram/TikTok-style Reels app built in Flutter. This project demonstrates best practices in building scalable media applications that require high-performance scrolling, video playback, and remote database management.

---

## 🏗 Architecture & Design Decisions

This application is built using **Clean Architecture** to enforce separation of concerns, testability, and to decouple the business rules from the UI or external data sources.

### 1. Layers Overview
- **Domain Layer:** The core of the application. Contains Entities (`VideoEntity`, `UserEntity`), Use Cases (`GetVideos`, `LoginUseCase`), and Repository Interfaces. It depends on nothing else.
- **Data Layer:** Handles external data retrieval. Contains Repositories Implementations (`VideoRepositoryImpl`, `AuthRepositoryImpl`) and Data Sources (`VideoRemoteDataSource`, `AuthRemoteDataSource`). We initially used dummy LocalDataSources, then seamlessly switched to Firebase by simply swapping implementations in the DI container.
- **Presentation Layer:** The user-facing UI built with Flutter widgets. Separated cleanly into Pages (`ReelsScreen`, `LoginScreen`) and state management variables.

### 2. State Management (Cubit / BLoC)
- `flutter_bloc` is used extensively for state management to avoid coupling logic into UI Widgets.
- `ReelCubit` dictates video feed states via asynchronous data polling. 
- `AuthCubit` observes user session status, bridging Firebase to the widget tree dynamically. 

### 3. Dependency Injection
- `get_it` handles Service Locators. We initialize all our layer dependencies in `lib/core/di/injection_container.dart` inside the `main.dart` runner. This structure makes swapping between Mock APIs and Real APIs a two-line configuration change.

### 4. Video Engine & Performance Optimizations
- **Advanced Preloading:** Built natively with `flutter_cache_manager`. As the user scrolls vertically through the array, the app pre-downloads the next 3 videos into device storage, ensuring playback begins instantly without buffering.
- **PageView Scroll Magic:** The main feed leverages `PageView.builder` mounted across a vertical axis, capturing identical native feel to popular social apps. Custom listeners immediately tear down un-focused video streams.

### 5. Backend (Firebase)
The project ships fully integrated with:
- **Firebase Auth:** Email and Password authentication supporting real-time cross-device session tracking.
- **Cloud Firestore:** Videos are served via the `demo_reel` collection. The NoSQL infrastructure mirrors exactly onto our `VideoModel` objects instantaneously. 

---

## 🚀 Getting Started

To run this application, ensure that you have initialized a Firebase target locally (so that `firebase_options.dart` exists in your `lib/` directory) and run the command:

```bash
flutter run
```

_Requirements:_
- Flutter SDK
- A Firebase project with Auth & Firestore properly activated.
