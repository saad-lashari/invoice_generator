import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/template_entity.dart';

abstract class TemplateRepository {
  Future<Either<Failure, List<TemplateEntity>>> getAllTemplates();
  Future<Either<Failure, TemplateEntity>> getTemplateById(String id);
  Future<Either<Failure, void>> addTemplate(TemplateEntity template);
  Future<Either<Failure, void>> updateTemplate(TemplateEntity template);
  Future<Either<Failure, void>> deleteTemplate(String id);
}
