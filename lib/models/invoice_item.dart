class InvoiceItem {
  String description;
  int quantity;
  double unitPrice;
  double vatRate;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.vatRate,
  });

  double get totalPrice => quantity * unitPrice;
  double get vatAmount => totalPrice * (vatRate / 100);
  double get totalWithVat => totalPrice + vatAmount;

  // Common item templates
  static List<InvoiceItem> getTemplates() {
    return [
      InvoiceItem(description: 'Consulting Services', quantity: 1, unitPrice: 100.0, vatRate: 20.0),
      InvoiceItem(description: 'Software Development', quantity: 1, unitPrice: 150.0, vatRate: 20.0),
      InvoiceItem(description: 'Web Design', quantity: 1, unitPrice: 80.0, vatRate: 20.0),
      InvoiceItem(description: 'Mobile App Development', quantity: 1, unitPrice: 200.0, vatRate: 20.0),
      InvoiceItem(description: 'Database Setup', quantity: 1, unitPrice: 75.0, vatRate: 20.0),
      InvoiceItem(description: 'Server Maintenance', quantity: 1, unitPrice: 50.0, vatRate: 20.0),
      InvoiceItem(description: 'Technical Support', quantity: 1, unitPrice: 40.0, vatRate: 20.0),
      InvoiceItem(description: 'Training Session', quantity: 1, unitPrice: 60.0, vatRate: 20.0),
      InvoiceItem(description: 'Project Management', quantity: 1, unitPrice: 90.0, vatRate: 20.0),
      InvoiceItem(description: 'Testing & QA', quantity: 1, unitPrice: 70.0, vatRate: 20.0),
    ];
  }

  InvoiceItem copy() {
    return InvoiceItem(
      description: description,
      quantity: quantity,
      unitPrice: unitPrice,
      vatRate: vatRate,
    );
  }
}
