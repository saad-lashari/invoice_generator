import 'package:flutter/material.dart';

class TotalCard extends StatelessWidget {
  final double subtotal;
  final double totalVat;
  final double total;

  const TotalCard({
    super.key,
    required this.subtotal,
    required this.totalVat,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTotalRow('Subtotal:', subtotal),
            const Divider(),
            _buildTotalRow('Total VAT:', totalVat),
            const Divider(thickness: 2),
            _buildTotalRow('Total Amount:', total, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Colors.blue : null,
          ),
        ),
      ],
    );
  }
}
