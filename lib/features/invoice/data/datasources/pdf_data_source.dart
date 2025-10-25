import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/invoice_entity.dart';

abstract class PdfDataSource {
  Future<File> generatePdf(InvoiceEntity invoice);
  Future<void> openPdf(File file);
}

class PdfDataSourceImpl implements PdfDataSource {
  @override
  Future<File> generatePdf(InvoiceEntity invoice) async {
    final pdf = pw.Document();

    final iconImage =
        (await rootBundle.load('assets/icon.png')).buffer.asUint8List();

    final color = _getColorFromString(invoice.themeColor);
    final font = _getFontFromString(invoice.fontFamily);

    final tableHeaders = [
      'Description',
      'Quantity',
      'Unit Price',
      'VAT',
      'Total',
    ];

    final tableData = invoice.items.map((item) {
      return [
        item.description,
        item.quantity.toString(),
        '\$${item.unitPrice.toStringAsFixed(2)}',
        '${item.vatRate.toStringAsFixed(1)}%',
        '\$${item.totalWithVat.toStringAsFixed(2)}',
      ];
    }).toList();

    final dateFormat = DateFormat('MMM dd, yyyy');

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Row(
              children: [
                pw.Image(
                  pw.MemoryImage(iconImage),
                  height: 72,
                  width: 72,
                ),
                pw.SizedBox(width: 1 * PdfPageFormat.mm),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 17.0,
                        fontWeight: pw.FontWeight.bold,
                        color: color,
                        font: font,
                      ),
                    ),
                    pw.Text(
                      invoice.companyName,
                      style: pw.TextStyle(
                        fontSize: 15.0,
                        color: color,
                        font: font,
                      ),
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      invoice.customerName,
                      style: pw.TextStyle(
                        fontSize: 15.5,
                        fontWeight: pw.FontWeight.bold,
                        color: color,
                        font: font,
                      ),
                    ),
                    pw.Text(
                      invoice.customerEmail,
                      style: pw.TextStyle(
                        fontSize: 14.0,
                        color: color,
                        font: font,
                      ),
                    ),
                    pw.Text(
                      'Invoice #: ${invoice.invoiceNumber}',
                      style: pw.TextStyle(
                        fontSize: 14.0,
                        color: color,
                        font: font,
                      ),
                    ),
                    pw.Text(
                      'Date: ${dateFormat.format(invoice.invoiceDate)}',
                      style: pw.TextStyle(
                        fontSize: 14.0,
                        color: color,
                        font: font,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            if (invoice.notes.isNotEmpty)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Notes:',
                    style: pw.TextStyle(
                      fontSize: 14.0,
                      fontWeight: pw.FontWeight.bold,
                      color: color,
                      font: font,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    invoice.notes,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(
                      fontSize: 14.0,
                      color: color,
                      font: font,
                    ),
                  ),
                  pw.SizedBox(height: 5 * PdfPageFormat.mm),
                ],
              ),
            if (tableData.isNotEmpty) ...[
              pw.Table.fromTextArray(
                headers: tableHeaders,
                data: tableData,
                border: null,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey300),
                cellHeight: 30.0,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerRight,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.centerRight,
                },
              ),
              pw.Divider(),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Row(
                  children: [
                    pw.Spacer(flex: 6),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  'Subtotal',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: color,
                                    font: font,
                                  ),
                                ),
                              ),
                              pw.Text(
                                '\$${invoice.subtotal.toStringAsFixed(2)}',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: color,
                                  font: font,
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  'Total VAT',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: color,
                                    font: font,
                                  ),
                                ),
                              ),
                              pw.Text(
                                '\$${invoice.totalVat.toStringAsFixed(2)}',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: color,
                                  font: font,
                                ),
                              ),
                            ],
                          ),
                          pw.Divider(),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  'Total Amount Due',
                                  style: pw.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pw.FontWeight.bold,
                                    color: color,
                                    font: font,
                                  ),
                                ),
                              ),
                              pw.Text(
                                '\$${invoice.total.toStringAsFixed(2)}',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: color,
                                  font: font,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 2 * PdfPageFormat.mm),
                          pw.Container(height: 1, color: PdfColors.grey400),
                          pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                          pw.Container(height: 1, color: PdfColors.grey400),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ];
        },
        footer: (context) {
          return pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Divider(),
              pw.SizedBox(height: 2 * PdfPageFormat.mm),
              pw.Text(
                invoice.companyName,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, color: color, font: font),
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Address: ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, color: color, font: font),
                  ),
                  pw.Text(
                    invoice.companyAddress,
                    style: pw.TextStyle(color: color, font: font),
                  ),
                ],
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Email: ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, color: color, font: font),
                  ),
                  pw.Text(
                    invoice.companyEmail,
                    style: pw.TextStyle(color: color, font: font),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final dir = await getExternalStorageDirectory();
    final file = File('${dir?.path}/invoice_${invoice.invoiceNumber}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  @override
  Future<void> openPdf(File file) async {
    // This will be handled by the file_handle_api
  }

  PdfColor _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'black':
        return PdfColors.black;
      case 'blue':
        return PdfColors.blue;
      case 'green':
        return PdfColors.green;
      case 'red':
        return PdfColors.red;
      case 'purple':
        return PdfColors.purple;
      case 'orange':
        return PdfColors.orange;
      case 'teal':
        return PdfColors.teal;
      default:
        return PdfColors.blue;
    }
  }

  pw.Font _getFontFromString(String fontName) {
    switch (fontName.toLowerCase()) {
      case 'courier':
        return pw.Font.courier();
      case 'helvetica':
        return pw.Font.helvetica();
      case 'times':
        return pw.Font.times();
      default:
        return pw.Font.helvetica();
    }
  }
}
