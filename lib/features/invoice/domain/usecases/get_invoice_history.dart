import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/invoice_entity.dart';
import '../repositories/invoice_repository.dart';

class GetInvoiceHistory implements UseCase<List<InvoiceEntity>, NoParams> {
  final InvoiceRepository repository;

  GetInvoiceHistory(this.repository);

  @override
  Future<Either<Failure, List<InvoiceEntity>>> call(NoParams params) async {
    return await repository.getHistory();
  }
}
