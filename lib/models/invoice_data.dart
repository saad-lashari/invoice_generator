import 'invoice_item.dart';

class InvoiceData {
  // Company Information
  String companyName;
  String companyEmail;
  String companyAddress;
  
  // Customer Information
  String customerName;
  String customerEmail;
  
  // Invoice Details
  String invoiceNumber;
  DateTime invoiceDate;
  String notes;
  
  // Items
  List<InvoiceItem> items;
  
  InvoiceData({
    this.companyName = 'Flutter Approach',
    this.companyEmail = 'flutterapproach@gmail.com',
    this.companyAddress = 'Merul Badda, Anandanagor, Dhaka 1212',
    this.customerName = 'John Doe',
    this.customerEmail = 'john@gmail.com',
    this.invoiceNumber = 'INV-001',
    DateTime? invoiceDate,
    this.notes = 'Thank you for your business!',
    List<InvoiceItem>? items,
  }) : invoiceDate = invoiceDate ?? DateTime.now(),
       items = items ?? [];
  
  // Calculate totals
  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get totalVat => items.fold(0, (sum, item) => sum + item.vatAmount);
  double get total => subtotal + totalVat;
}
