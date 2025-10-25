import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_template.dart';
import '../../domain/usecases/delete_template.dart';
import '../../domain/usecases/get_all_templates.dart';
import 'template_event.dart';
import 'template_state.dart';

class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  final GetAllTemplates getAllTemplates;
  final AddTemplate addTemplate;
  final DeleteTemplate deleteTemplate;

  TemplateBloc({
    required this.getAllTemplates,
    required this.addTemplate,
    required this.deleteTemplate,
  }) : super(TemplateInitial()) {
    on<LoadTemplatesEvent>(_onLoadTemplates);
    on<AddTemplateEvent>(_onAddTemplate);
    on<DeleteTemplateEvent>(_onDeleteTemplate);
  }

  Future<void> _onLoadTemplates(
    LoadTemplatesEvent event,
    Emitter<TemplateState> emit,
  ) async {
    emit(TemplateLoading());

    final result = await getAllTemplates(NoParams());

    result.fold(
      (failure) => emit(TemplateError(failure.message)),
      (templates) => emit(TemplatesLoaded(templates)),
    );
  }

  Future<void> _onAddTemplate(
    AddTemplateEvent event,
    Emitter<TemplateState> emit,
  ) async {
    emit(TemplateLoading());

    final result = await addTemplate(event.template);

    result.fold(
      (failure) => emit(TemplateError(failure.message)),
      (_) {
        emit(TemplateAdded());
        add(LoadTemplatesEvent());
      },
    );
  }

  Future<void> _onDeleteTemplate(
    DeleteTemplateEvent event,
    Emitter<TemplateState> emit,
  ) async {
    emit(TemplateLoading());

    final result = await deleteTemplate(event.id);

    result.fold(
      (failure) => emit(TemplateError(failure.message)),
      (_) {
        emit(TemplateDeleted());
        add(LoadTemplatesEvent());
      },
    );
  }
}
