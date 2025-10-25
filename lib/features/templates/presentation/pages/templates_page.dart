import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/template_entity.dart';
import '../bloc/template_bloc.dart';
import '../bloc/template_event.dart';
import '../bloc/template_state.dart';

class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TemplateBloc, TemplateState>(
        builder: (context, state) {
          if (state is TemplateLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TemplateError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TemplateBloc>().add(LoadTemplatesEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TemplatesLoaded) {
            if (state.templates.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.library_books, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No templates yet'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showAddTemplateDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Template'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.templates.length,
              itemBuilder: (context, index) {
                final template = state.templates[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.description),
                    ),
                    title: Text(template.description),
                    subtitle: Text('VAT: ${template.vatRate}%'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${template.unitPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context
                                .read<TemplateBloc>()
                                .add(DeleteTemplateEvent(template.id!));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTemplateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTemplateDialog(BuildContext context) {
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final vatController = TextEditingController(text: '20.0');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Unit Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: vatController,
              decoration: const InputDecoration(labelText: 'VAT Rate (%)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final template = TemplateEntity(
                description: descriptionController.text,
                unitPrice: double.tryParse(priceController.text) ?? 0.0,
                vatRate: double.tryParse(vatController.text) ?? 20.0,
                createdAt: DateTime.now(),
              );
              context.read<TemplateBloc>().add(AddTemplateEvent(template));
              Navigator.pop(dialogContext);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
