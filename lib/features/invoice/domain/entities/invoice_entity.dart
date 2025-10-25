import 'package:equatable/equatable.dart';
import 'invoice_item_entity.dart';

class InvoiceEntity extends Equatable {
  final String? id;
  final String companyName;
  final String companyEmail;
  final String companyAddress;
  final String customerName;
  final String customerEmail;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final String notes;
  final List<InvoiceItemEntity> items;
  final String themeColor;
  final String fontFamily;

  const InvoiceEntity({
    this.id,
    required this.companyName,
    required this.companyEmail,
    required this.companyAddress,
    required this.customerName,
    required this.customerEmail,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.notes,
    required this.items,
    this.themeColor = 'blue',
    this.fontFamily = 'helvetica',
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get totalVat => items.fold(0, (sum, item) => sum + item.vatAmount);
  double get total => subtotal + totalVat;

  @override
  List<Object?> get props => [
        id,
        companyName,
        companyEmail,
        companyAddress,
        customerName,
        customerEmail,
        invoiceNumber,
        invoiceDate,
        notes,
        items,
        themeColor,
        fontFamily,
      ];
}
