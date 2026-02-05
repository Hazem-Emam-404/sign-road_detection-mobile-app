# SignGuard - Intelligent Traffic Sign Detection

SignGuard is a premium Flutter application designed to enhance road safety and driver awareness through real-time traffic sign detection and interactive learning. Built with a focus on ease of use and accessibility, SignGuard leverages advanced image processing to identify road signs instantly.

> **📥 Download Now**: [Get the latest APK](https://www.dropbox.com/scl/fi/ytcqjfnka22m1uvcag7ng/app-release.apk?rlkey=lgw96iok2awz3nzc0s2elm54h&st=3ifd1rzj&dl=0) | [Get the latest IPA](https://www.dropbox.com/scl/fi/8r110un12i8f6r9c7p31m/road_sign_detection.ipa?rlkey=sgyzl85nr3fdfx8lz04hhy44b&st=0fpqtbvv&dl=0)
> **📔Preview Now**: [Preview](https://singguar.netlify.app/)

## 🚀 Key Features

*   **Real-time Detection**: Instantly detect and identify traffic signs using the device camera.
*   **Image Upload Analysis**: Analyze images from your gallery to identify signs offline.
*   **Interactive Learning**: Learn about different traffic signs through an engaging quiz and catalog system.
*   **Text-to-Speech (TTS)**: Receive auditory feedback for detected signs, supporting Arabic language for local relevance.
*   **Smart Settings**: Customize your experience with dark mode, sound settings, and more.
*   **Offline Capability**: Core detection features work without an active internet connection (model dependent).

## 🛠️ Technology Stack

*   **Framework**: [Flutter](https://flutter.dev/) (Dart)
*   **State Management**: [Riverpod](https://riverpod.dev/)
*   **Networking**: [Dio](https://pub.dev/packages/dio)
*   **Dependency Injection**: Riverpod
*   **Image Processing**: Native Camera integration & custom ML integration
*   **Audio**: `just_audio` & `flutter_tts` for seamless sound effects and speech
*   **Local Storage**: `shared_preferences`

## 📂 Project Structure

```
lib/
├── features/
│   ├── detection/    # Real-time camera detection logic
│   ├── home/         # Main dashboard and navigation
│   ├── learn/        # Educational content and quizzes
│   ├── upload/       # Image picker and static analysis
│   └── settings/     # App configuration and preferences
├── main.dart         # Entry point
└── ...
```

## 🚥 Getting Started

Follow these steps to set up the project locally.

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.3.0 or higher)
*   Android Studio / VS Code with Flutter extensions
*   Active internet connection for fetching dependencies

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/sign-road_detection-mobile-app.git
    cd sign-road_detection-mobile-app
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Environment Setup**
    Create a `.env` file in the root directory (refer to `.env.example` if available) to configure any necessary API keys or environment variables.

4.  **Run the App**
    Connect your device or start an emulator and run:
    ```bash
    flutter run
    ```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
