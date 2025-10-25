import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/delete_invoice_from_history.dart';
import '../../domain/usecases/generate_invoice_pdf.dart';
import '../../domain/usecases/get_invoice_history.dart';
import '../../domain/usecases/save_invoice_to_history.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final GenerateInvoicePdf generateInvoicePdf;
  final SaveInvoiceToHistory saveInvoiceToHistory;
  final GetInvoiceHistory getInvoiceHistory;
  final DeleteInvoiceFromHistory deleteInvoiceFromHistory;

  InvoiceBloc({
    required this.generateInvoicePdf,
    required this.saveInvoiceToHistory,
    required this.getInvoiceHistory,
    required this.deleteInvoiceFromHistory,
  }) : super(InvoiceInitial()) {
    on<GenerateInvoiceEvent>(_onGenerateInvoice);
    on<LoadInvoiceHistoryEvent>(_onLoadInvoiceHistory);
    on<DeleteInvoiceEvent>(_onDeleteInvoice);
  }

  Future<void> _onGenerateInvoice(
    GenerateInvoiceEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    // Preserve history state if it exists
    final currentState = state;
    if (currentState is InvoiceHistoryLoaded) {
      emit(currentState.copyWith(isGenerating: true));
    } else {
      emit(InvoiceGenerating());
    }

    final result = await generateInvoicePdf(event.invoice);

    await result.fold(
      (failure) async {
        if (currentState is InvoiceHistoryLoaded) {
          emit(currentState.copyWith(isGenerating: false));
          // Show error in snackbar instead
        } else {
          emit(InvoiceError(failure.message));
        }
      },
      (file) async {
        // Also save to history
        await saveInvoiceToHistory(event.invoice);

        // Reload history to include the new invoice
        final historyResult = await getInvoiceHistory(NoParams());
        historyResult.fold(
          (failure) => emit(InvoiceError(failure.message)),
          (invoices) => emit(InvoiceHistoryLoaded(invoices)),
        );
      },
    );
  }

  Future<void> _onLoadInvoiceHistory(
    LoadInvoiceHistoryEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(InvoiceLoading());

    final result = await getInvoiceHistory(NoParams());

    result.fold(
      (failure) => emit(InvoiceError(failure.message)),
      (invoices) => emit(InvoiceHistoryLoaded(invoices)),
    );
  }

  Future<void> _onDeleteInvoice(
    DeleteInvoiceEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(InvoiceLoading());

    final result = await deleteInvoiceFromHistory(event.id);

    result.fold(
      (failure) => emit(InvoiceError(failure.message)),
      (_) {
        emit(InvoiceDeleted());
        // Reload history after deletion
        add(LoadInvoiceHistoryEvent());
      },
    );
  }
}
