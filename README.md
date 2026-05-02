# Flutter CVM Nanosoft

## Project Overview
Flutter CVM Nanosoft is a Customer Value Management mobile application built with Flutter. It focuses on managing customer data, providing features to view customer lists, details, and add or update customer information. The app is designed with a strong offline-first architecture, allowing users to interact with the application seamlessly without internet connectivity. It securely synchronizes local changes with a backend server once a connection is established.

## Setup Instructions

1. **Prerequisites**: Ensure you have Flutter installed. The project relies on a Dart SDK constraint of `^3.11.5`.
2. **Clone and Navigate**: Navigate to the project root directory (`flutter_cvm_nanosoft`).
3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
4. **Code Generation**: The project uses `build_runner` for dependency injection (`injectable`) and JSON serialization. Run the following command to generate the necessary files:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
5. **Run the App**:
   ```bash
   flutter run
   ```

## Architecture Explanation
The application employs a feature-based, Clean Architecture-inspired structure, primarily located within the `lib/src` directory:

- **Core (`lib/src/core`)**: Contains application-wide, shared infrastructure such as the database configuration (`SqfLiteService`), network clients (`DioClient`), routing (`go_router`), error handling, dependency injection configurations (`get_it` and `injectable`), and common utilities.
- **Features (`lib/src/features`)**: Encapsulates the specific domains of the app (e.g., `customer`, `intro`, `theme`). Each feature is isolated into layers:
  - **Data**: Models, repositories, and remote/local data sources.
  - **Presentation**: UI elements (Pages, Widgets) and state management (Cubits).

## State Management
**Flutter BLoC** (specifically `Cubit`) is used for managing application state. This pattern allows for a clear separation between the presentation layer and business logic.
- Features are driven by their respective Cubits (e.g., `CustomerListCubit`, `CustomerDetailCubit`, `AddCustomerCubit`).
- `equatable` is used alongside Cubits to ensure efficient state comparisons and prevent unnecessary UI rebuilds.

## Local Database
Local data persistence is powered by **Sqflite** (SQLite for Flutter), providing robust offline capabilities.
- **`customers` table**: Caches the remote customer data and stores newly created offline records.
- **`pending_operations` table**: A critical component for the offline-first approach. It acts as an action queue, logging all mutations (create/update) performed by the user while offline or when sync fails.

## Offline Sync Flow
The app ensures data consistency and high availability through an intelligent synchronization mechanism:

1. **Initial Sync**: When the app starts with an active internet connection, it fetches the latest customer data from the server. It updates the local database while carefully avoiding overwriting any local records that have pending operations.
2. **Offline Actions**: If a user creates or modifies a customer, the change is immediately reflected in the local `customers` table. Concurrently, an entry is recorded in the `pending_operations` table with the operation type (`create` or `update`) and the associated JSON payload.
3. **Synchronization**: Once connectivity is restored (detected via `connectivity_plus`), a sync service iterates through the `pending_operations` queue. It executes the corresponding remote API calls. Upon success, the pending operation is deleted. If an API request fails, a retry counter is incremented up to a maximum of 3 attempts before marking the operation as 'failed'.

## API/Mock Server Setup
The application uses **Dio** for HTTP networking.
- The base URL is currently configured in `lib/src/core/network/api_url.dart` (e.g., `http://192.168.0.101:3000`).
- To test the networking capabilities, you must run a backend or a mock server (such as `json-server` or `WireMock`) accessible at that address, exposing endpoints like `GET /customers`, `POST /customers`, etc.
- **Note**: Be sure to update `ApiUrl.base` to point to your actual local development machine's IP address or remote mock server.

## Known Limitations or Assumptions
- **Mock Server Dependency**: The app assumes a backend API is available at the configured IP address. Without it, the app will operate entirely in offline mode.
- **Conflict Resolution**: The current sync implementation relies on a basic queue system. If the same record is modified on multiple devices simultaneously, the "last write wins" based on when the pending operation is synced, which may cause unhandled data conflicts in complex scenarios.
- **Retry Mechanism limits**: Pending operations are retried only 3 times before failing. Manual user intervention or a background worker might be required to re-trigger failed operations.