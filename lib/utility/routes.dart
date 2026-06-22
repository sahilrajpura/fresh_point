import 'package:fresh_point/app/cart/cart_screen.dart';
import 'package:fresh_point/app/delivery_boy/dashboard/dashboard_controller.dart';
import 'package:fresh_point/app/delivery_boy/dashboard/dashboard_screen.dart';
import 'package:fresh_point/app/delivery_boy/pending_order/pending_order_screen.dart';
import 'package:fresh_point/app/home/home_screen.dart';
import 'package:fresh_point/app/login/login_screen.dart';
import 'package:fresh_point/app/order/order_screen.dart';
import 'package:fresh_point/app/order_detail/order_detail_screen.dart';
import 'package:fresh_point/app/policy/policy_screen.dart';
import 'package:fresh_point/app/product_detail/product_detail_screen.dart';
import 'package:fresh_point/app/product_list/product_list_screen.dart';
import 'package:fresh_point/app/register/register_screen.dart';
import 'package:fresh_point/app/splash/splash_screen.dart';
import 'package:fresh_point/utility/auth_gaurd.dart';
import 'package:get/get.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String product = '/product';
  static const String productdetail = '/productdetail';
  static const String order = '/order';
  static const String orderDetail = '/orderDetail';
  static const String policy = '/policy';
  static const String cart = '/cart';
  static const String deliveryDashboard = '/deliveryDashboard';
  static const String pendingOrders = '/pending-orders';

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: login,
      page: () => LoginScreen(),
    ),

    GetPage(
      name: register,
      page: () => RegisterScreen(),
    ),

    GetPage(
      name: home,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
      middlewares: [
        AuthMiddlewareIsUser(),
      ],
    ),

    GetPage(
      name: product,
      page: () => ProductListScreen(),
    ),

    GetPage(
      name: productdetail,
      page: () => ProductDetailsScreen(),
    ),

    GetPage(
      name: cart,
      page: () => CartScreen(),
    ),

    GetPage(
      name: order,
      page: () => OrderScreen(),
    ),

    GetPage(
      name: orderDetail,
      page: () => OrderDetailScreen(),
    ),

    GetPage(
      name: policy,
      page: () => PolicyScreen(),
    ),

    GetPage(
      name: AppRouter.deliveryDashboard,
      page: () => const DashboardScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DashboardController>(
          () => DashboardController(),
        );
      }),
    ),
    GetPage(
      name: pendingOrders,
      page: () => PendingOrderScreen(),
    ),
  ];
}
