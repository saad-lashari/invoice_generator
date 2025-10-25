import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/template_entity.dart';
import '../../domain/repositories/template_repository.dart';
import '../datasources/template_local_data_source.dart';
import '../models/template_model.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateLocalDataSource localDataSource;

  TemplateRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<TemplateEntity>>> getAllTemplates() async {
    try {
      final templates = await localDataSource.getTemplates();
      return Right(templates);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TemplateEntity>> getTemplateById(String id) async {
    try {
      final template = await localDataSource.getTemplateById(id);
      return Right(template);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addTemplate(TemplateEntity template) async {
    try {
      final model = TemplateModel.fromEntity(template);
      await localDataSource.addTemplate(model);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTemplate(TemplateEntity template) async {
    try {
      final model = TemplateModel.fromEntity(template);
      await localDataSource.updateTemplate(model);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTemplate(String id) async {
    try {
      await localDataSource.deleteTemplate(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
