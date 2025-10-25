import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/template_entity.dart';
import '../repositories/template_repository.dart';

class AddTemplate implements UseCase<void, TemplateEntity> {
  final TemplateRepository repository;

  AddTemplate(this.repository);

  @override
  Future<Either<Failure, void>> call(TemplateEntity template) async {
    return await repository.addTemplate(template);
  }
}
