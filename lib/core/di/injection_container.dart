import 'package:get_it/get_it.dart';
import '../../features/invoice/data/datasources/invoice_local_data_source.dart';
import '../../features/invoice/data/datasources/pdf_data_source.dart';
import '../../features/invoice/data/repositories/invoice_repository_impl.dart';
import '../../features/invoice/domain/repositories/invoice_repository.dart';
import '../../features/invoice/domain/usecases/delete_invoice_from_history.dart';
import '../../features/invoice/domain/usecases/generate_invoice_pdf.dart';
import '../../features/invoice/domain/usecases/get_invoice_history.dart';
import '../../features/invoice/domain/usecases/save_invoice_to_history.dart';
import '../../features/invoice/presentation/bloc/invoice_bloc.dart';
import '../../features/templates/data/datasources/template_local_data_source.dart';
import '../../features/templates/data/repositories/template_repository_impl.dart';
import '../../features/templates/domain/repositories/template_repository.dart';
import '../../features/templates/domain/usecases/add_template.dart';
import '../../features/templates/domain/usecases/delete_template.dart';
import '../../features/templates/domain/usecases/get_all_templates.dart';
import '../../features/templates/presentation/bloc/template_bloc.dart';
import '../database/database_helper.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Invoice
  // Bloc
  sl.registerFactory(
    () => InvoiceBloc(
      generateInvoicePdf: sl(),
      saveInvoiceToHistory: sl(),
      getInvoiceHistory: sl(),
      deleteInvoiceFromHistory: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GenerateInvoicePdf(sl()));
  sl.registerLazySingleton(() => SaveInvoiceToHistory(sl()));
  sl.registerLazySingleton(() => GetInvoiceHistory(sl()));
  sl.registerLazySingleton(() => DeleteInvoiceFromHistory(sl()));

  // Repository
  sl.registerLazySingleton<InvoiceRepository>(
    () => InvoiceRepositoryImpl(
      localDataSource: sl(),
      pdfDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<InvoiceLocalDataSource>(
    () => InvoiceLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PdfDataSource>(
    () => PdfDataSourceImpl(),
  );

  // Features - Templates
  // Bloc
  sl.registerFactory(
    () => TemplateBloc(
      getAllTemplates: sl(),
      addTemplate: sl(),
      deleteTemplate: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllTemplates(sl()));
  sl.registerLazySingleton(() => AddTemplate(sl()));
  sl.registerLazySingleton(() => DeleteTemplate(sl()));

  // Repository
  sl.registerLazySingleton<TemplateRepository>(
    () => TemplateRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<TemplateLocalDataSource>(
    () => TemplateLocalDataSourceImpl(sl()),
  );

  // Core
  sl.registerLazySingleton(() => DatabaseHelper.instance);
}
