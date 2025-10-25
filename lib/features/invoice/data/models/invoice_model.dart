import 'dart:convert';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_item_entity.dart';
import 'invoice_item_model.dart';

class InvoiceModel extends InvoiceEntity {
  const InvoiceModel({
    super.id,
    required super.companyName,
    required super.companyEmail,
    required super.companyAddress,
    required super.customerName,
    required super.customerEmail,
    required super.invoiceNumber,
    required super.invoiceDate,
    required super.notes,
    required super.items,
    super.themeColor,
    super.fontFamily,
  });

  factory InvoiceModel.fromEntity(InvoiceEntity entity) {
    return InvoiceModel(
      id: entity.id,
      companyName: entity.companyName,
      companyEmail: entity.companyEmail,
      companyAddress: entity.companyAddress,
      customerName: entity.customerName,
      customerEmail: entity.customerEmail,
      invoiceNumber: entity.invoiceNumber,
      invoiceDate: entity.invoiceDate,
      notes: entity.notes,
      items: entity.items,
      themeColor: entity.themeColor,
      fontFamily: entity.fontFamily,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'companyEmail': companyEmail,
      'companyAddress': companyAddress,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'invoiceNumber': invoiceNumber,
      'invoiceDate': invoiceDate.toIso8601String(),
      'notes': notes,
      'items': items
          .map((item) => InvoiceItemModel.fromEntity(item).toJson())
          .toList(),
      'themeColor': themeColor,
      'fontFamily': fontFamily,
    };
  }

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'],
      companyName: json['companyName'],
      companyEmail: json['companyEmail'],
      companyAddress: json['companyAddress'],
      customerName: json['customerName'],
      customerEmail: json['customerEmail'],
      invoiceNumber: json['invoiceNumber'],
      invoiceDate: DateTime.parse(json['invoiceDate']),
      notes: json['notes'],
      items: (json['items'] as List)
          .map((item) => InvoiceItemModel.fromJson(item))
          .cast<InvoiceItemEntity>()
          .toList(),
      themeColor: json['themeColor'] ?? 'blue',
      fontFamily: json['fontFamily'] ?? 'helvetica',
    );
  }

  String toJsonString() => json.encode(toJson());

  factory InvoiceModel.fromJsonString(String jsonString) {
    return InvoiceModel.fromJson(json.decode(jsonString));
  }
}
