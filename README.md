# EnviroSense

EnviroSense is a Flutter application designed to manage and monitor home devices, providing real-time environmental insights and control.

## Key Features

- **Device Scanning and Configuration**: Manage device settings through the DeviceControlsTab.
- **Room-based Device Assignment**: Assign devices to rooms using the AddDeviceScreen.
- **Caching and Clearing Options**: Manage cache and stored data with database_service and ClearCacheOptionsSheet.
- **Authentication**: Implemented using FirebaseAuth for secure sign-in and registration.
- **Real-time Notifications**: Receive instant notifications for device activities and alerts.

## Architecture

EnviroSense follows the Model-View-Controller (MVC) architecture pattern to separate concerns and improve code maintainability.

- **Model**: Represents the data layer, including data structures and business logic. Models are located in the `lib/data/models/` directory.
- **View**: Represents the UI layer, including widgets and layouts. Views are located in the `lib/presentation/views/` directory.
- **Controller**: Acts as an intermediary between the Model and View, handling user input and updating the View. Controllers are located in the `lib/presentation/controllers/` directory.

### Implementation

1. **Models**: Define data structures and business logic. For example, `DeviceModel` represents a device with properties like `id`, `name`, and `status`.
2. **Views**: Create UI components using Flutter widgets. For example, `DeviceListView` displays a list of devices.
3. **Controllers**: Handle user interactions and update the View. For example, `DeviceController` manages device-related actions like adding or removing devices.

By following the MVC pattern, we ensure a clear separation of concerns, making the codebase easier to understand, test, and maintain.

## Project Structure

- **lib/**: Contains the main Dart code, widgets, controllers, and UI layouts.
- **android/**: Hosts Android-specific files like the AndroidManifest.xml, Gradle configs, and Kotlin entry points.
- **ios/**: Contains iOS-specific implementations including the AppDelegate.swift and Xcode project configuration.
- **linux/**: Holds Linux platform code and the custom GApplication-based entry point.
- **windows/**: Contains Windows platform code and configurations.
- **macos/**: Contains macOS platform code and configurations.

## Packages

EnviroSense uses several packages to enhance its functionality. Below is an overview of the key packages and their purposes:

- **firebase_core**: Required for initializing Firebase in the Flutter app.
- **firebase_auth**: Provides authentication features, allowing users to sign in and register securely.
- **firebase_messaging**: Enables real-time notifications for device activities and alerts.
- **connectivity_plus**: Used to check the network connectivity status of the device.
- **shared_preferences**: Allows storing simple data persistently across app launches.
- **sqflite**: Provides SQLite database support for local data storage.
- **flutter_dotenv**: Loads environment variables from a `.env` file, useful for managing configuration settings.
- **google_fonts**: Allows using Google Fonts in the app for a consistent and attractive typography.
- **logging**: Provides logging capabilities to help with debugging and monitoring the app's behavior.

These packages are essential for implementing the core features of EnviroSense, such as authentication, real-time notifications, data storage, and network connectivity checks.

## APIs

EnviroSense interacts with several APIs to provide its functionality. Below is an overview of the key APIs used:

- **Deno Server API**: This custom API is used for managing and controlling home devices. It provides endpoints for device data & configuration, status updates, and other device-related operations.
    - The OpenAPI documenteation can be seen [here](http://94.130.75.173:8101/)
- **Weather API**: This API is used to fetch real-time weather data, which is integrated into the app to provide environmental insights. The weather data includes temperature, humidity, and other relevant metrics.
    - We use [weatherapi.com](weatherapi.com)

## Firebase Configuration

Ensure you have the correct Firebase configuration files in place:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

## Environment Variables
Create a `.env` file in the root directory of your project by copying the `.env.example` file:
```sh
cp .env.example .env
```

Replace the placeholder values with your actual values.

## Setup Instructions

1. Ensure Flutter and Dart tools are installed.
2. Clone the repository:
    ```sh
    git clone git@gitlab.ti.howest.be:ti/2024-2025/s5/ccett/projects/group-14/flutter-app.git
    cd flutter-app
    ```
3. Run `flutter pub get` to fetch all declared dependencies.
4. Execute `flutter run` to build and launch the app on the desired platform.

