import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/invoice_entity.dart';

abstract class InvoiceState extends Equatable {
  const InvoiceState();

  @override
  List<Object?> get props => [];
}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceGenerating extends InvoiceState {}

class InvoiceGenerated extends InvoiceState {
  final File file;

  const InvoiceGenerated(this.file);

  @override
  List<Object?> get props => [file];
}

class InvoiceHistoryLoaded extends InvoiceState {
  final List<InvoiceEntity> invoices;
  final bool isGenerating;

  const InvoiceHistoryLoaded(this.invoices, {this.isGenerating = false});

  @override
  List<Object?> get props => [invoices, isGenerating];

  InvoiceHistoryLoaded copyWith({
    List<InvoiceEntity>? invoices,
    bool? isGenerating,
  }) {
    return InvoiceHistoryLoaded(
      invoices ?? this.invoices,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }
}

class InvoiceLoadedById extends InvoiceState {
  final InvoiceEntity invoice;

  const InvoiceLoadedById(this.invoice);

  @override
  List<Object?> get props => [invoice];
}

class InvoiceDeleted extends InvoiceState {}

class InvoiceError extends InvoiceState {
  final String message;

  const InvoiceError(this.message);

  @override
  List<Object?> get props => [message];
}
