# Clean Architecture Implementation

This project has been refactored to follow Clean Architecture principles with BLoC pattern for state management.

## Architecture Layers

### 1. Domain Layer (Business Logic)
- **Entities**: Core business objects (InvoiceEntity, InvoiceItemEntity, TemplateEntity)
- **Repository Interfaces**: Abstract contracts for data operations
- **Use Cases**: Single-responsibility business logic operations
  - `GenerateInvoicePdf`: Generate PDF from invoice data
  - `SaveInvoiceToHistory`: Save invoice to database
  - `GetInvoiceHistory`: Retrieve all invoices
  - `DeleteInvoiceFromHistory`: Remove invoice from history
  - `GetAllTemplates`: Retrieve all templates
  - `AddTemplate`: Add new template
  - `DeleteTemplate`: Remove template

### 2. Data Layer (Data Management)
- **Models**: Data transfer objects with JSON serialization
- **Data Sources**:
  - `InvoiceLocalDataSource`: SQLite operations for invoices
  - `PdfDataSource`: PDF generation logic
  - `TemplateLocalDataSource`: SQLite operations for templates
- **Repository Implementations**: Concrete implementations of domain repositories
- **Database**: SQLite with DatabaseHelper singleton

### 3. Presentation Layer (UI)
- **BLoC**: State management
  - `InvoiceBloc`: Manages invoice generation and history
  - `TemplateBloc`: Manages template CRUD operations
- **Pages**: Full-screen views
  - `CreateInvoicePage`: Main invoice creation form
  - `HistoryPage`: View invoice history
  - `TemplatesPage`: Manage reusable templates
- **Widgets**: Reusable stateless components
  - `CustomTextField`: Reusable text input
  - `SectionHeader`: Section titles
  - `InvoiceItemCard`: Item editor card
  - `TotalCard`: Invoice totals display

### 4. Core Layer (Shared Code)
- **Error Handling**: Failure classes for different error types
- **Use Case Base**: Abstract UseCase class
- **Dependency Injection**: GetIt service locator setup
- **Database**: Shared database helper

## Key Features

### 1. Dependency Injection (GetIt)
- All dependencies are registered in `injection_container.dart`
- Supports easy testing with mockable dependencies
- Lazy initialization for performance

### 2. State Management (BLoC)
- Clear separation of events, states, and business logic
- Reactive UI updates
- Easy error handling

### 3. Database (SQLite)
- Invoice history persistence
- Custom user templates storage
- Automatic database initialization

### 4. Clean Code Principles
- Stateless widgets only (no UI methods)
- Single Responsibility Principle
- Dependency Inversion
- Testable architecture

## Project Structure

```
lib/
├── core/
│   ├── database/
│   │   └── database_helper.dart
│   ├── di/
│   │   └── injection_container.dart
│   ├── error/
│   │   └── failures.dart
│   └── usecases/
│       └── usecase.dart
├── features/
│   ├── invoice/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   └── templates/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

## How to Use

### 1. Initialize the App
The app automatically initializes:
- Database (SQLite)
- Dependency injection (GetIt)
- BLoC providers

### 2. Create Invoice
1. Fill in company and customer information
2. Add invoice items
3. Choose styling options (color, font)
4. Generate PDF
5. Automatically saved to history

### 3. View History
- Access from app bar icon
- View all generated invoices
- Delete old invoices

### 4. Manage Templates
- Create reusable item templates
- Add/delete templates
- Quick add to invoices

## Testing

The architecture makes testing straightforward:
- **Unit Tests**: Test use cases and entities
- **Widget Tests**: Test individual widgets
- **Integration Tests**: Test BLoC with mock repositories

## Future Enhancements

1. **Invoice Templates**: Complete invoice templates (not just items)
2. **Export Options**: Share PDF via email/other apps
3. **Multi-currency**: Support different currencies
4. **Tax Calculations**: More complex tax scenarios
5. **Client Management**: Store and manage client information
6. **Reports**: Analytics and reporting features

## Dependencies

- `flutter_bloc`: ^8.1.6 - State management
- `equatable`: ^2.0.5 - Value equality
- `get_it`: ^7.7.0 - Dependency injection
- `sqflite`: ^2.3.3+1 - Local database
- `dartz`: ^0.10.1 - Functional programming
- `pdf`: ^3.11.3 - PDF generation
- `path_provider`: ^2.1.5 - File system access
- `open_file`: ^3.5.10 - Open generated files
- `intl`: ^0.20.2 - Date formatting

## Migration from Old Code

The original `main.dart` has been preserved. To use the new architecture:
1. Backup your old main.dart
2. Replace with main_new.dart content
3. Run `flutter pub get`
4. Test the application

The new architecture is fully backward compatible in terms of features while providing:
- Better testability
- Cleaner code organization
- Easier maintenance
- Scalability for future features
