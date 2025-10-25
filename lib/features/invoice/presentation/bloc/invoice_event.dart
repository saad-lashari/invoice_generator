import 'package:equatable/equatable.dart';
import '../../domain/entities/invoice_entity.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object?> get props => [];
}

class GenerateInvoiceEvent extends InvoiceEvent {
  final InvoiceEntity invoice;

  const GenerateInvoiceEvent(this.invoice);

  @override
  List<Object?> get props => [invoice];
}

class LoadInvoiceHistoryEvent extends InvoiceEvent {}

class DeleteInvoiceEvent extends InvoiceEvent {
  final String id;

  const DeleteInvoiceEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadInvoiceByIdEvent extends InvoiceEvent {
  final String id;

  const LoadInvoiceByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}
