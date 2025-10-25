import 'package:equatable/equatable.dart';

class TemplateEntity extends Equatable {
  final String? id;
  final String description;
  final double unitPrice;
  final double vatRate;
  final DateTime? createdAt;

  const TemplateEntity({
    this.id,
    required this.description,
    required this.unitPrice,
    required this.vatRate,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, description, unitPrice, vatRate, createdAt];
}
