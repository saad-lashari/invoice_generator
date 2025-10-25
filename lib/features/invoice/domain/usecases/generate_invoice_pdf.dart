import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/invoice_entity.dart';
import '../repositories/invoice_repository.dart';

class GenerateInvoicePdf implements UseCase<File, InvoiceEntity> {
  final InvoiceRepository repository;

  GenerateInvoicePdf(this.repository);

  @override
  Future<Either<Failure, File>> call(InvoiceEntity invoice) async {
    return await repository.generatePdf(invoice);
  }
}
