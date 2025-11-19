import 'package:go_router/go_router.dart';
import 'package:shoestorefe/presentation/admin/screens/user/sign_up_screen.dart';
import 'package:shoestorefe/presentation/admin/screens/user/user_screen.dart';
import 'package:shoestorefe/core/network/token_handler.dart';
import 'package:shoestorefe/core/utils/auth_utils.dart';
import '../admin/screens/dashboard/dashboard_screen.dart';
import '../admin/screens/brand/brand_screen.dart';
import '../admin/screens/supplier/supplier_screen.dart';
import '../admin/screens/product/product_screen.dart';
import '../admin/screens/order/order_screen.dart';
import '../admin/screens/receipt/receipt_screen.dart';
import '../admin/screens/store/store_screen.dart';
import '../admin/screens/promotion/promotion_screen.dart';
import '../admin/screens/user/login_screen.dart';
import '../customer/screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: "/",
  redirect: (context, state) {
    final isLoggedIn = TokenHandler().hasToken();
    final isLoginRoute =
        state.matchedLocation == '/' || state.matchedLocation == '/signup';

    // Nếu chưa đăng nhập và không phải trang login/signup, điều hướng đến login
    if (!isLoggedIn && !isLoginRoute) {
      return '/';
    }

    // Nếu đã đăng nhập và đang ở trang login/signup, điều hướng dựa trên role
    if (isLoggedIn && isLoginRoute) {
      final role = AuthUtils.getUserRole();
      if (role == "Super Admin" || role == "Admin") {
        return '/dashboard';
      } else if (role == "Customer") {
        return '/home';
      }
    }

    return null; // Không redirect
  },
  routes: [
    GoRoute(path: '/', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
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
