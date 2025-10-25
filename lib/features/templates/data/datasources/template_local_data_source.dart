import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/template_model.dart';

abstract class TemplateLocalDataSource {
  Future<List<TemplateModel>> getTemplates();
  Future<TemplateModel> getTemplateById(String id);
  Future<void> addTemplate(TemplateModel template);
  Future<void> updateTemplate(TemplateModel template);
  Future<void> deleteTemplate(String id);
}

class TemplateLocalDataSourceImpl implements TemplateLocalDataSource {
  final DatabaseHelper databaseHelper;

  TemplateLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<TemplateModel>> getTemplates() async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'templates',
      orderBy: 'createdAt DESC',
    );

    return result.map((map) {
      return TemplateModel(
        id: map['id'] as String,
        description: map['description'] as String,
        unitPrice: map['unitPrice'] as double,
        vatRate: map['vatRate'] as double,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
    }).toList();
  }

  @override
  Future<TemplateModel> getTemplateById(String id) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'templates',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      throw Exception('Template not found');
    }

    final map = result.first;
    return TemplateModel(
      id: map['id'] as String,
      description: map['description'] as String,
      unitPrice: map['unitPrice'] as double,
      vatRate: map['vatRate'] as double,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  Future<void> addTemplate(TemplateModel template) async {
    final db = await databaseHelper.database;
    final id = template.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    await db.insert(
      'templates',
      {
        'id': id,
        'description': template.description,
        'unitPrice': template.unitPrice,
        'vatRate': template.vatRate,
        'createdAt': (template.createdAt ?? DateTime.now()).toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateTemplate(TemplateModel template) async {
    final db = await databaseHelper.database;
    await db.update(
      'templates',
      {
        'description': template.description,
        'unitPrice': template.unitPrice,
        'vatRate': template.vatRate,
      },
      where: 'id = ?',
      whereArgs: [template.id],
    );
  }

  @override
  Future<void> deleteTemplate(String id) async {
    final db = await databaseHelper.database;
    await db.delete(
      'templates',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
