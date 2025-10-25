import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/invoice_entity.dart';

abstract class InvoiceRepository {
  Future<Either<Failure, File>> generatePdf(InvoiceEntity invoice);
  Future<Either<Failure, void>> saveToHistory(InvoiceEntity invoice);
  Future<Either<Failure, List<InvoiceEntity>>> getHistory();
  Future<Either<Failure, InvoiceEntity>> getHistoryById(String id);
  Future<Either<Failure, void>> deleteFromHistory(String id);
}
