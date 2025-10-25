# Clean Architecture Implementation Guide

## Summary

Your invoice generator app has been successfully refactored into a **Clean Architecture** with:
- ✅ **BLoC Pattern** for state management
- ✅ **GetIt** for dependency injection
- ✅ **SQLite** for persistent storage (history & templates)
- ✅ **Stateless Widgets** only (no UI methods in widgets)
- ✅ **Complete separation of concerns** across layers

## What's Been Created

### Core Architecture Files

1. **Domain Layer** (`lib/features/*/domain/`)
   - Entities: Pure business objects with no dependencies
   - Repository Interfaces: Contracts for data operations
   - Use Cases: Single-responsibility business operations

2. **Data Layer** (`lib/features/*/data/`)
   - Models: Data transfer objects with JSON serialization
   - Data Sources: Local database and PDF generation
   - Repository Implementations: Concrete data operations

3. **Presentation Layer** (`lib/features/*/presentation/`)
   - BLoC: State management (events, states, bloc)
   - Pages: Full-screen application views
   - Widgets: Reusable stateless components

4. **Core Layer** (`lib/core/`)
   - Database helper
   - Dependency injection container
   - Error handling
   - Base use case class

### New Features Added

1. **Invoice History** - View and manage all generated invoices
2. **Custom Templates** - Create and reuse item templates
3. **Persistent Storage** - SQLite database for history and templates
4. **Navigation** - Multiple pages with routing
5. **Better Error Handling** - Proper error states and user feedback

## How to Switch to New Architecture

### Option 1: Gradual Migration (Recommended)

1. **Backup your current code:**
   ```bash
   cp lib/main.dart lib/main_old.dart
   ```

2. **Test the new implementation:**
   ```bash
   cp lib/main_new.dart lib/main.dart
   flutter run
   ```

3. **If issues occur, rollback:**
   ```bash
   cp lib/main_old.dart lib/main.dart
   ```

### Option 2: Direct Switch

Simply replace the content of `lib/main.dart` with `lib/main_new.dart`:
```bash
mv lib/main.dart lib/main_backup.dart
mv lib/main_new.dart lib/main.dart
flutter run
```

## File Structure

```
lib/
├── core/
│   ├── database/
│   │   └── database_helper.dart          # SQLite setup
│   ├── di/
│   │   └── injection_container.dart      # GetIt DI setup
│   ├── error/
│   │   └── failures.dart                 # Error classes
│   └── usecases/
│       └── usecase.dart                  # Base use case
├── features/
│   ├── invoice/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── invoice_local_data_source.dart
│   │   │   │   └── pdf_data_source.dart
│   │   │   ├── models/
│   │   │   │   ├── invoice_model.dart
│   │   │   │   └── invoice_item_model.dart
│   │   │   └── repositories/
│   │   │       └── invoice_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── invoice_entity.dart
│   │   │   │   └── invoice_item_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── invoice_repository.dart
│   │   │   └── usecases/
│   │   │       ├── generate_invoice_pdf.dart
│   │   │       ├── save_invoice_to_history.dart
│   │   │       ├── get_invoice_history.dart
│   │   │       └── delete_invoice_from_history.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── invoice_bloc.dart
│   │       │   ├── invoice_event.dart
│   │       │   └── invoice_state.dart
│   │       ├── pages/
│   │       │   ├── create_invoice_page.dart
│   │       │   └── history_page.dart
│   │       └── widgets/
│   │           ├── custom_text_field.dart
│   │           ├── section_header.dart
│   │           ├── invoice_item_card.dart
│   │           └── total_card.dart
│   └── templates/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── template_local_data_source.dart
│       │   ├── models/
│       │   │   └── template_model.dart
│       │   └── repositories/
│       │       └── template_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── template_entity.dart
│       │   ├── repositories/
│       │   │   └── template_repository.dart
│       │   └── usecases/
│       │       ├── get_all_templates.dart
│       │       ├── add_template.dart
│       │       └── delete_template.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── template_bloc.dart
│           │   ├── template_event.dart
│           │   └── template_state.dart
│           └── pages/
│               └── templates_page.dart
├── main_new.dart                         # New main entry point
└── main.dart                             # Original (preserved)
```

## Key Improvements

### 1. Testability
Each layer can be tested independently:
```dart
// Example: Test use case with mock repository
test('should generate PDF successfully', () async {
  // Arrange
  final mockRepository = MockInvoiceRepository();
  final useCase = GenerateInvoicePdf(mockRepository);

  // Act
  final result = await useCase(testInvoice);

  // Assert
  expect(result.isRight(), true);
});
```

### 2. Maintainability
- Clear separation of concerns
- Easy to locate and fix bugs
- Changes in one layer don't affect others

### 3. Scalability
- Easy to add new features
- Reusable components
- Modular structure

### 4. Code Quality
- No stateful widgets with business logic
- All widgets are stateless
- Business logic in use cases
- UI logic in BLoC

## Usage Examples

### Creating an Invoice
```dart
// User fills form → Triggers event
context.read<InvoiceBloc>().add(
  GenerateInvoiceEvent(invoice),
);

// BLoC processes → Updates state
// Widget rebuilds automatically
BlocBuilder<InvoiceBloc, InvoiceState>(
  builder: (context, state) {
    if (state is InvoiceLoading) {
      return CircularProgressIndicator();
    }
    if (state is InvoiceGenerated) {
      return SuccessMessage();
    }
    // ...
  },
);
```

### Adding a Template
```dart
// Create template
final template = TemplateEntity(
  description: 'Web Development',
  unitPrice: 150.0,
  vatRate: 20.0,
);

// Add via BLoC
context.read<TemplateBloc>().add(
  AddTemplateEvent(template),
);

// Template saved to SQLite automatically
```

### Viewing History
```dart
// Load history
context.read<InvoiceBloc>().add(
  LoadInvoiceHistoryEvent(),
);

// BLoC fetches from database
// UI updates with results
```

## Database Schema

### Invoices Table
```sql
CREATE TABLE invoices (
  id TEXT PRIMARY KEY,
  companyName TEXT NOT NULL,
  companyEmail TEXT NOT NULL,
  companyAddress TEXT NOT NULL,
  customerName TEXT NOT NULL,
  customerEmail TEXT NOT NULL,
  invoiceNumber TEXT NOT NULL,
  invoiceDate TEXT NOT NULL,
  notes TEXT,
  items TEXT NOT NULL,          -- JSON array
  themeColor TEXT NOT NULL,
  fontFamily TEXT NOT NULL,
  createdAt TEXT NOT NULL
)
```

### Templates Table
```sql
CREATE TABLE templates (
  id TEXT PRIMARY KEY,
  description TEXT NOT NULL,
  unitPrice REAL NOT NULL,
  vatRate REAL NOT NULL,
  createdAt TEXT NOT NULL
)
```

## Navigation

The app now has three main screens:

1. **Create Invoice** (`/`) - Main invoice creation
2. **History** (`/history`) - View invoice history
3. **Templates** (`/templates`) - Manage templates

Access via:
- App bar icons
- Direct navigation: `Navigator.pushNamed(context, '/history')`

## Troubleshooting

### Issue: Database not initializing
**Solution:** Ensure `WidgetsFlutterBinding.ensureInitialized()` is called in `main()`

### Issue: BLoC not updating UI
**Solution:** Wrap widget with `BlocBuilder` or `BlocListener`

### Issue: Dependency not found
**Solution:** Ensure `await di.init()` completes before `runApp()`

### Issue: PDF generation fails
**Solution:** Check that `assets/icon.png` exists in your assets folder

## Next Steps

1. **Test the Application**
   ```bash
   flutter run
   ```

2. **Add Unit Tests**
   - Test use cases
   - Test BLoC
   - Test repositories

3. **Add Widget Tests**
   - Test individual widgets
   - Test page interactions

4. **Customize**
   - Add more templates
   - Customize PDF layout
   - Add more features

## Benefits of This Architecture

✅ **Clean Separation** - Business logic separate from UI
✅ **Testable** - Easy to write unit and widget tests
✅ **Maintainable** - Clear structure, easy to navigate
✅ **Scalable** - Easy to add new features
✅ **Reusable** - Components can be reused
✅ **Type-Safe** - Strongly typed with proper error handling
✅ **State Management** - BLoC handles all state changes
✅ **Dependency Injection** - Loosely coupled components
✅ **Persistent Storage** - SQLite for data persistence
✅ **Professional** - Industry-standard architecture

## Additional Resources

- [BLoC Documentation](https://bloclibrary.dev/)
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [GetIt Documentation](https://pub.dev/packages/get_it)
- [SQLite in Flutter](https://pub.dev/packages/sqflite)

---

**Note:** Your original `main.dart` has been preserved. The new implementation is in `main_new.dart`. You can switch between them at any time.
