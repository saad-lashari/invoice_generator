import 'package:equatable/equatable.dart';
import '../../domain/entities/template_entity.dart';

abstract class TemplateEvent extends Equatable {
  const TemplateEvent();

  @override
  List<Object?> get props => [];
}

class LoadTemplatesEvent extends TemplateEvent {}

class AddTemplateEvent extends TemplateEvent {
  final TemplateEntity template;

  const AddTemplateEvent(this.template);

  @override
  List<Object?> get props => [template];
}

class UpdateTemplateEvent extends TemplateEvent {
  final TemplateEntity template;

  const UpdateTemplateEvent(this.template);

  @override
  List<Object?> get props => [template];
}

class DeleteTemplateEvent extends TemplateEvent {
  final String id;

  const DeleteTemplateEvent(this.id);

  @override
  List<Object?> get props => [id];
}
