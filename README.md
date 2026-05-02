# Customer Visit Management App

Offline-first Flutter application for managing customer visits with full offline support and automatic sync.

## Architecture

### Feature-Based Structure
- `core/` - Database, network, repositories, utilities
- `features/` - Feature modules (customer_list, customer_detail, add_customer)

### State Management (BLoC/Cubit)
- CustomerListCubit - Manages list view, search, filters, sync status
- CustomerDetailCubit - Manages customer details and offline updates
- AddCustomerCubit - Handles offline customer creation

### Offline-First Strategy
1. **Local Database**: SQLite with sqflite
2. **Pending Operations Queue**: Tracks create/update operations
3. **Sync Process**: Manual sync button + auto-sync on reconnect
4. **Conflict Resolution**: Local pending changes never overwritten by server data

## Setup Instructions
```bash
npm install -g json-server
json-server --watch db.json --port 3000
```

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Node.js (for json-server)

### Start mock API server:

### Installation

1. Clone repository
2. Install dependencies:
```bash
flutter pub get
```