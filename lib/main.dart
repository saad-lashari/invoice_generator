import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/presentation/dashboard.dart';
import 'features/invoice/presentation/bloc/invoice_bloc.dart';
import 'features/invoice/presentation/bloc/invoice_event.dart';
import 'features/templates/presentation/bloc/template_bloc.dart';
import 'features/templates/presentation/bloc/template_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<InvoiceBloc>()..add(LoadInvoiceHistoryEvent()),
        ),
        BlocProvider(
          create: (_) => di.sl<TemplateBloc>()..add(LoadTemplatesEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Invoice Generator',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const Dashboard(),
      ),
    );
  }
}
