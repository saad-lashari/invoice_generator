import 'package:equatable/equatable.dart';

class InvoiceItemEntity extends Equatable {
  final String? id;
  final String description;
  final int quantity;
  final double unitPrice;
  final double vatRate;

  const InvoiceItemEntity({
    this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.vatRate,
  });

  double get totalPrice => quantity * unitPrice;
  double get vatAmount => totalPrice * (vatRate / 100);
  double get totalWithVat => totalPrice + vatAmount;

  @override
  List<Object?> get props => [id, description, quantity, unitPrice, vatRate];
}
