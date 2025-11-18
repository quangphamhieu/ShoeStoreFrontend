import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'injection_container.dart' as di;
import 'presentation/routes/app_router.dart';
import 'presentation/customer/provider/customer_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const CustomerApp());
}

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<CustomerProvider>()),
      ],
      child: MaterialApp.router(
        title: 'ShoeStore',
        debugShowCheckedModeBanner: false,
        routerConfig: customerRouter,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB8C77E)),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}