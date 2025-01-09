# EnviroSense

EnviroSense is a Flutter application designed to manage and monitor home devices, providing real-time environmental insights and control.

## Project Structure

- **lib/**: Contains the main Dart code, widgets, controllers, and UI layouts.
- **android/**: Hosts Android-specific files like the AndroidManifest.xml, Gradle configs, and Kotlin entry points.
- **ios/**: Contains iOS-specific implementations including the AppDelegate.swift and Xcode project configuration.
- **linux/**: Holds Linux platform code and the custom GApplication-based entry point.
- **windows/**: Contains Windows platform code and configurations.
- **macos/**: Contains macOS platform code and configurations.

## Setup Instructions

1. Ensure Flutter and Dart tools are installed.
2. Clone the repository:
    ```sh
    git clone git@gitlab.ti.howest.be:ti/2024-2025/s5/ccett/projects/group-14/flutter-app.git
    cd flutter-app
    ```
3. Run `flutter pub get` to fetch all declared dependencies.
4. Execute `flutter run` to build and launch the app on the desired platform.

## Key Features

- **Device Scanning and Configuration**: Manage device settings through the DeviceControlsTab.
- **Room-based Device Assignment**: Assign devices to rooms using the AddDeviceScreen.
- **Caching and Clearing Options**: Manage cache and stored data with database_service and ClearCacheOptionsSheet.
- **Authentication**: Implemented using FirebaseAuth for secure sign-in and registration.
- **Real-time Notifications**: Receive instant notifications for device activities and alerts.

## Firebase Configuration

Ensure you have the correct Firebase configuration files in place:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

### Environment Variables
Create a `.env` file in the root directory of your project by copying the `.env.example` file:
```sh
cp .env.example .env
```

Replace the placeholder values with your actual values.
