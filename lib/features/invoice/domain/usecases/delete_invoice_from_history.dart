import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/invoice_repository.dart';

class DeleteInvoiceFromHistory implements UseCase<void, String> {
  final InvoiceRepository repository;

  DeleteInvoiceFromHistory(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteFromHistory(id);
  }
}
