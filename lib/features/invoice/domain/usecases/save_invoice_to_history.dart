import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/invoice_entity.dart';
import '../repositories/invoice_repository.dart';

class SaveInvoiceToHistory implements UseCase<void, InvoiceEntity> {
  final InvoiceRepository repository;

  SaveInvoiceToHistory(this.repository);

  @override
  Future<Either<Failure, void>> call(InvoiceEntity invoice) async {
    return await repository.saveToHistory(invoice);
  }
}
