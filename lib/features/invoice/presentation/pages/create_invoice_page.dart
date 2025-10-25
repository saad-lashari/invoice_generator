import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_item_entity.dart';
import '../../../templates/presentation/bloc/template_bloc.dart';
import '../../../templates/presentation/bloc/template_state.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../bloc/invoice_state.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/section_header.dart';
import '../widgets/total_card.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController(
    text: 'Flutter Approach',
  );
  final _companyEmailController = TextEditingController(
    text: 'flutterapproach@gmail.com',
  );
  final _companyAddressController = TextEditingController(
    text: '123 Flutter St, Dart City, FL 12345',
  );
  final _customerNameController = TextEditingController(text: 'John Doe');
  final _customerEmailController = TextEditingController(
    text: 'john@gmail.com',
  );
  final _invoiceNumberController = TextEditingController(text: 'INV-001');
  final _notesController = TextEditingController(
    text: 'Thank you for your business!',
  );

  DateTime _invoiceDate = DateTime.now();
  String _themeColor = 'blue';
  String _fontFamily = 'helvetica';
  List<InvoiceItemEntity> _items = [];
  bool _wasGenerating = false;

  @override
  void initState() {
    super.initState();
    _items.add(
      const InvoiceItemEntity(
        description: 'Consulting Services',
        quantity: 1,
        unitPrice: 100.0,
        vatRate: 20.0,
      ),
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyEmailController.dispose();
    _companyAddressController.dispose();
    _customerNameController.dispose();
    _customerEmailController.dispose();
    _invoiceNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add(
        const InvoiceItemEntity(
          description: '',
          quantity: 1,
          unitPrice: 0.0,
          vatRate: 20.0,
        ),
      );
    });
  }

  void _addItemFromTemplate() {
    final templateState = context.read<TemplateBloc>().state;

    if (templateState is! TemplatesLoaded || templateState.templates.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No templates available')));
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Template'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: templateState.templates.length,
            itemBuilder: (context, index) {
              final template = templateState.templates[index];
              return ListTile(
                leading: const Icon(Icons.description),
                title: Text(template.description),
                subtitle: Text(
                  'Price: \$${template.unitPrice.toStringAsFixed(2)} | VAT: ${template.vatRate}%',
                ),
                onTap: () {
                  setState(() {
                    _items.add(
                      InvoiceItemEntity(
                        description: template.description,
                        quantity: 1,
                        unitPrice: template.unitPrice,
                        vatRate: template.vatRate,
                      ),
                    );
                  });
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added "${template.description}" from template',
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _updateItem(int index, InvoiceItemEntity item) {
    setState(() {
      _items[index] = item;
    });
  }

  double get _subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);
  double get _totalVat => _items.fold(0, (sum, item) => sum + item.vatAmount);
  double get _total => _subtotal + _totalVat;

  void _generateInvoice() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
      return;
    }

    final invoice = InvoiceEntity(
      companyName: _companyNameController.text,
      companyEmail: _companyEmailController.text,
      companyAddress: _companyAddressController.text,
      customerName: _customerNameController.text,
      customerEmail: _customerEmailController.text,
      invoiceNumber: _invoiceNumberController.text,
      invoiceDate: _invoiceDate,
      notes: _notesController.text,
      items: _items,
      themeColor: _themeColor,
      fontFamily: _fontFamily,
    );

    context.read<InvoiceBloc>().add(GenerateInvoiceEvent(invoice));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<InvoiceBloc, InvoiceState>(
        listener: (context, state) {
          final isGenerating =
              state is InvoiceGenerating ||
              (state is InvoiceHistoryLoaded && state.isGenerating);

          // Show success message only when generation just completed
          if (_wasGenerating &&
              !isGenerating &&
              state is InvoiceHistoryLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invoice generated successfully!')),
            );
          }

          if (state is InvoiceError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }

          // Update the flag
          _wasGenerating = isGenerating;
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SectionHeader(
                title: 'Company Information',
                icon: Icons.business,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _companyNameController,
                label: 'Company Name',
                icon: Icons.apartment,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _companyEmailController,
                label: 'Company Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _companyAddressController,
                label: 'Company Address',
                icon: Icons.location_on,
                // maxLines: ,
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                title: 'Customer Information',
                icon: Icons.person,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _customerNameController,
                label: 'Customer Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _customerEmailController,
                label: 'Customer Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                title: 'Invoice Details',
                icon: Icons.description,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _invoiceNumberController,
                label: 'Invoice Number',
                icon: Icons.tag,
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Invoice Date'),
                subtitle: Text(DateFormat('MMM dd, yyyy').format(_invoiceDate)),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _invoiceDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      _invoiceDate = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _notesController,
                label: 'Notes',
                // icon: Icons.note,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                title: 'Styling Options',
                icon: Icons.palette,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _themeColor,
                decoration: const InputDecoration(
                  labelText: 'Theme Color',
                  prefixIcon: Icon(Icons.color_lens),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'black', child: Text('Black')),
                  DropdownMenuItem(value: 'blue', child: Text('Blue')),
                  DropdownMenuItem(value: 'green', child: Text('Green')),
                  DropdownMenuItem(value: 'red', child: Text('Red')),
                  DropdownMenuItem(value: 'purple', child: Text('Purple')),
                  DropdownMenuItem(value: 'orange', child: Text('Orange')),
                  DropdownMenuItem(value: 'teal', child: Text('Teal')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _themeColor = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _fontFamily,
                decoration: const InputDecoration(
                  labelText: 'Font Family',
                  prefixIcon: Icon(Icons.font_download),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'courier', child: Text('Courier')),
                  DropdownMenuItem(
                    value: 'helvetica',
                    child: Text('Helvetica'),
                  ),
                  DropdownMenuItem(value: 'times', child: Text('Times')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _fontFamily = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionHeader(title: 'Invoice Items', icon: Icons.list),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _addItemFromTemplate,
                        icon: const Icon(Icons.library_add),
                        tooltip: 'Add from Template',
                        color: Colors.green,
                      ),
                      IconButton(
                        onPressed: _addItem,
                        icon: const Icon(Icons.add_circle),
                        tooltip: 'Add New Item',
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_items.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      // horizontal: 16,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.inbox, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No items added yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: ElevatedButton.icon(
                                onPressed: _addItemFromTemplate,
                                icon: const Icon(Icons.library_add),
                                label: const Text('Add from Template'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: ElevatedButton.icon(
                                onPressed: _addItem,
                                icon: const Icon(Icons.add),
                                label: const Text('Add New Item'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return _buildItemCard(item, index);
                }),
              if (_items.isNotEmpty) ...[
                const SizedBox(height: 16),
                TotalCard(
                  subtotal: _subtotal,
                  totalVat: _totalVat,
                  total: _total,
                ),
              ],
              const SizedBox(height: 24),
              BlocBuilder<InvoiceBloc, InvoiceState>(
                builder: (context, state) {
                  final isLoading =
                      state is InvoiceGenerating ||
                      (state is InvoiceHistoryLoaded && state.isGenerating);
                  return ElevatedButton.icon(
                    onPressed: isLoading ? null : _generateInvoice,
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.picture_as_pdf),
                    label: Text(
                      isLoading ? 'Generating...' : 'Generate Invoice PDF',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(InvoiceItemEntity item, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Item ${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeItem(index),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: item.description,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) {
                _updateItem(
                  index,
                  InvoiceItemEntity(
                    description: value,
                    quantity: item.quantity,
                    unitPrice: item.unitPrice,
                    vatRate: item.vatRate,
                  ),
                );
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: item.quantity.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Qty',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final qty = int.tryParse(value) ?? 1;
                      _updateItem(
                        index,
                        InvoiceItemEntity(
                          description: item.description,
                          quantity: qty,
                          unitPrice: item.unitPrice,
                          vatRate: item.vatRate,
                        ),
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: item.unitPrice.toStringAsFixed(2),
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final price = double.tryParse(value) ?? 0.0;
                      _updateItem(
                        index,
                        InvoiceItemEntity(
                          description: item.description,
                          quantity: item.quantity,
                          unitPrice: price,
                          vatRate: item.vatRate,
                        ),
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: item.vatRate.toStringAsFixed(1),
                    decoration: const InputDecoration(
                      labelText: 'VAT %',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final vat = double.tryParse(value) ?? 0.0;
                      _updateItem(
                        index,
                        InvoiceItemEntity(
                          description: item.description,
                          quantity: item.quantity,
                          unitPrice: item.unitPrice,
                          vatRate: vat,
                        ),
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${item.totalWithVat.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
