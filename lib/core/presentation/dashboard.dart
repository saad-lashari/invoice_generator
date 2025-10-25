import 'package:flutter/material.dart';
import '../../features/invoice/presentation/pages/create_invoice_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/templates/presentation/pages/templates_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HistoryPage(),
    const TemplatesPage(),
    const CreateInvoicePage(),
  ];

  final List<String> _titles = [
    'Invoice History',
    'Templates',
    'Create Invoice',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Templates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Create',
          ),
        ],
      ),
    );
  }
}
