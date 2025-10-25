import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'invoice_generator.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create invoices table
    await db.execute('''
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
        items TEXT NOT NULL,
        themeColor TEXT NOT NULL,
        fontFamily TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create templates table
    await db.execute('''
      CREATE TABLE templates (
        id TEXT PRIMARY KEY,
        description TEXT NOT NULL,
        unitPrice REAL NOT NULL,
        vatRate REAL NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
