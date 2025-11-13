import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'injection_container.dart' as di;
import 'presentation/routes/app_router.dart';
import 'presentation/admin/provider/brand_provider.dart';
import 'presentation/admin/provider/menu_provider.dart';
import 'presentation/admin/provider/store_provider.dart';
import 'presentation/admin/provider/supplier_provider.dart';
import 'presentation/admin/provider/product_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<BrandProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<StoreProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<SupplierProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProductProvider>()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],
      child: MaterialApp.router(
        title: 'ShoeStore Admin',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}
