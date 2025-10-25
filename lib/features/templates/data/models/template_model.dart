import '../../domain/entities/template_entity.dart';

class TemplateModel extends TemplateEntity {
  const TemplateModel({
    super.id,
    required super.description,
    required super.unitPrice,
    required super.vatRate,
    super.createdAt,
  });

  factory TemplateModel.fromEntity(TemplateEntity entity) {
    return TemplateModel(
      id: entity.id,
      description: entity.description,
      unitPrice: entity.unitPrice,
      vatRate: entity.vatRate,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'unitPrice': unitPrice,
      'vatRate': vatRate,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'],
      description: json['description'],
      unitPrice: json['unitPrice'],
      vatRate: json['vatRate'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}
