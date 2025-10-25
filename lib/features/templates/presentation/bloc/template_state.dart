import 'package:equatable/equatable.dart';
import '../../domain/entities/template_entity.dart';

abstract class TemplateState extends Equatable {
  const TemplateState();

  @override
  List<Object?> get props => [];
}

class TemplateInitial extends TemplateState {}

class TemplateLoading extends TemplateState {}

class TemplatesLoaded extends TemplateState {
  final List<TemplateEntity> templates;

  const TemplatesLoaded(this.templates);

  @override
  List<Object?> get props => [templates];
}

class TemplateAdded extends TemplateState {}

class TemplateUpdated extends TemplateState {}

class TemplateDeleted extends TemplateState {}

class TemplateError extends TemplateState {
  final String message;

  const TemplateError(this.message);

  @override
  List<Object?> get props => [message];
}
