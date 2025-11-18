import 'package:go_router/go_router.dart';
import 'package:shoestorefe/presentation/admin/screens/user/sign_up_screen.dart';
import 'package:shoestorefe/presentation/admin/screens/user/user_screen.dart';
import '../admin/screens/dashboard/dashboard_screen.dart';
import '../admin/screens/brand/brand_screen.dart';
import '../admin/screens/supplier/supplier_screen.dart';
import '../admin/screens/product/product_screen.dart';
import '../admin/screens/order/order_screen.dart';
import '../admin/screens/receipt/receipt_screen.dart';
import '../admin/screens/store/store_screen.dart';
import '../admin/screens/promotion/promotion_screen.dart';
import '../admin/screens/user/login_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(path: '/', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
    GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
    GoRoute(path: '/brand', builder: (_, __) => const BrandScreen()),
    GoRoute(path: '/supplier', builder: (_, __) => const SupplierScreen()),
    GoRoute(path: '/product', builder: (_, __) => const ProductScreen()),
    GoRoute(path: '/order', builder: (_, __) => const OrderScreen()),
    GoRoute(path: '/receipt', builder: (_, __) => const ReceiptScreen()),
    GoRoute(path: '/store', builder: (_, __) => const StoreScreen()),
    GoRoute(path: '/promotion', builder: (_, __) => const PromotionScreen()),
    GoRoute(path: '/user', builder: (_, __) => const UserScreen()),

  ],
);

