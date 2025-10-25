import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/template_repository.dart';

class DeleteTemplate implements UseCase<void, String> {
  final TemplateRepository repository;

  DeleteTemplate(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteTemplate(id);
  }
}
