import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/template_entity.dart';
import '../repositories/template_repository.dart';

class GetAllTemplates implements UseCase<List<TemplateEntity>, NoParams> {
  final TemplateRepository repository;

  GetAllTemplates(this.repository);

  @override
  Future<Either<Failure, List<TemplateEntity>>> call(NoParams params) async {
    return await repository.getAllTemplates();
  }
}
