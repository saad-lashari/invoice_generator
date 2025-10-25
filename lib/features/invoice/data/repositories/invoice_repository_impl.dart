import 'dart:io';
import 'package:dartz/dartz.dart' hide OpenFile;
import 'package:open_file/open_file.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_local_data_source.dart';
import '../datasources/pdf_data_source.dart';
import '../models/invoice_model.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceLocalDataSource localDataSource;
  final PdfDataSource pdfDataSource;

  InvoiceRepositoryImpl({
    required this.localDataSource,
    required this.pdfDataSource,
  });

  @override
  Future<Either<Failure, File>> generatePdf(InvoiceEntity invoice) async {
    try {
      final file = await pdfDataSource.generatePdf(invoice);
      await OpenFile.open(file.path);
      return Right(file);
    } catch (e) {
      return Left(FileFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveToHistory(InvoiceEntity invoice) async {
    try {
      final model = InvoiceModel.fromEntity(invoice);
      await localDataSource.saveInvoice(model);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceEntity>>> getHistory() async {
    try {
      final invoices = await localDataSource.getInvoices();
      return Right(invoices);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InvoiceEntity>> getHistoryById(String id) async {
    try {
      final invoice = await localDataSource.getInvoiceById(id);
      return Right(invoice);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFromHistory(String id) async {
    try {
      await localDataSource.deleteInvoice(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
