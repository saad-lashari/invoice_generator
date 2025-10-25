import 'dart:convert';
import '../../domain/entities/invoice_item_entity.dart';

class InvoiceItemModel extends InvoiceItemEntity {
  const InvoiceItemModel({
    super.id,
    required super.description,
    required super.quantity,
    required super.unitPrice,
    required super.vatRate,
  });

  factory InvoiceItemModel.fromEntity(InvoiceItemEntity entity) {
    return InvoiceItemModel(
      id: entity.id,
      description: entity.description,
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
      vatRate: entity.vatRate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'vatRate': vatRate,
    };
  }

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      id: json['id'],
      description: json['description'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'],
      vatRate: json['vatRate'],
    );
  }

  String toJsonString() => json.encode(toJson());

  factory InvoiceItemModel.fromJsonString(String jsonString) {
    return InvoiceItemModel.fromJson(json.decode(jsonString));
  }
}
