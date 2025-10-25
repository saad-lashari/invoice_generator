import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/invoice_model.dart';

abstract class InvoiceLocalDataSource {
  Future<void> saveInvoice(InvoiceModel invoice);
  Future<List<InvoiceModel>> getInvoices();
  Future<InvoiceModel> getInvoiceById(String id);
  Future<void> deleteInvoice(String id);
}

class InvoiceLocalDataSourceImpl implements InvoiceLocalDataSource {
  final DatabaseHelper databaseHelper;

  InvoiceLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<void> saveInvoice(InvoiceModel invoice) async {
    final db = await databaseHelper.database;
    final id = invoice.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    await db.insert(
      'invoices',
      {
        'id': id,
        'companyName': invoice.companyName,
        'companyEmail': invoice.companyEmail,
        'companyAddress': invoice.companyAddress,
        'customerName': invoice.customerName,
        'customerEmail': invoice.customerEmail,
        'invoiceNumber': invoice.invoiceNumber,
        'invoiceDate': invoice.invoiceDate.toIso8601String(),
        'notes': invoice.notes,
        'items': json.encode(invoice.items
            .map((item) => {
                  'id': item.id,
                  'description': item.description,
                  'quantity': item.quantity,
                  'unitPrice': item.unitPrice,
                  'vatRate': item.vatRate,
                })
            .toList()),
        'themeColor': invoice.themeColor,
        'fontFamily': invoice.fontFamily,
        'createdAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<InvoiceModel>> getInvoices() async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'invoices',
      orderBy: 'createdAt DESC',
    );

    return result.map((map) {
      return InvoiceModel.fromJson({
        'id': map['id'],
        'companyName': map['companyName'],
        'companyEmail': map['companyEmail'],
        'companyAddress': map['companyAddress'],
        'customerName': map['customerName'],
        'customerEmail': map['customerEmail'],
        'invoiceNumber': map['invoiceNumber'],
        'invoiceDate': map['invoiceDate'],
        'notes': map['notes'],
        'items': json.decode(map['items'] as String),
        'themeColor': map['themeColor'],
        'fontFamily': map['fontFamily'],
      });
    }).toList();
  }

  @override
  Future<InvoiceModel> getInvoiceById(String id) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'invoices',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      throw Exception('Invoice not found');
    }

    final map = result.first;
    return InvoiceModel.fromJson({
      'id': map['id'],
      'companyName': map['companyName'],
      'companyEmail': map['companyEmail'],
      'companyAddress': map['companyAddress'],
      'customerName': map['customerName'],
      'customerEmail': map['customerEmail'],
      'invoiceNumber': map['invoiceNumber'],
      'invoiceDate': map['invoiceDate'],
      'notes': map['notes'],
      'items': json.decode(map['items'] as String),
      'themeColor': map['themeColor'],
      'fontFamily': map['fontFamily'],
    });
  }

  @override
  Future<void> deleteInvoice(String id) async {
    final db = await databaseHelper.database;
    await db.delete(
      'invoices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
