import 'package:red_leaf/Plugins/get/get.dart';
import 'package:red_leaf/Views/DrawerData/faq_screen.dart';
import 'package:red_leaf/Views/DrawerData/support_screen.dart';
import 'package:red_leaf/Views/Customers/customers.dart';
import 'package:red_leaf/Views/Order/orders.dart';
import 'package:red_leaf/Views/Splash/splash_screen.dart';

import '../Views/Customers/customer_details.dart';
import '../Views/DrawerData/about_screen.dart';
import '../Views/DrawerData/guide_screen.dart';
import '../Views/Products/products.dart';
import '../Views/Home/home_screen.dart';
import '../Views/Login/login_screen.dart';
import '../Views/Order/order_details.dart';
import '../Views/Profile/profile_screen.dart';
import '../Views/main_screen.dart';


class RoutingUtils {
  static GetPage splash = GetPage(
    name: '/',
    transition: Transition.fade,
    page: () => SplashScreen(),
  );

  static GetPage main = GetPage(
    name: '/main',
    transition: Transition.fade,
    page: () => MainScreen(),
  );

  static GetPage support = GetPage(
    name: '/support',
    transition: Transition.fade,
    page: () => SupportScreen(),
  );

  static GetPage guide = GetPage(
    name: '/guide',
    transition: Transition.fade,
    page: () => GuideScreen(),
  );

  static GetPage about = GetPage(
    name: '/about',
    transition: Transition.fade,
    page: () => AboutScreen(),
  );

  static GetPage faq = GetPage(
    name: '/faq',
    transition: Transition.fade,
    page: () => FaqScreen(),
  );

  static GetPage home = GetPage(
    name: '/home',
    transition: Transition.fade,
    page: () => HomeScreen(),
  );

  static GetPage login = GetPage(
    name: '/login',
    transition: Transition.fade,
    page: () => LoginScreen(),
  );

  static GetPage profile = GetPage(
    name: '/profile',
    transition: Transition.fade,
    page: () => ProfileScreen(),
  );

  static GetPage products = GetPage(
    name: '/product',
    transition: Transition.fade,
    page: () => ProductsScreen(),
  );

  static GetPage product = GetPage(
    name: '/product',
    transition: Transition.fade,
    page: () => ProfileScreen(),
  );

  static GetPage orders = GetPage(
    name: '/orders',
    transition: Transition.fade,
    page: () => OrdersScreen(),
  );

  static GetPage order = GetPage(
    name: '/order',
    transition: Transition.fade,
    page: () => OrderDetailsScreen(),
  );

  static GetPage customer = GetPage(
    name: '/customer',
    transition: Transition.fade,
    page: () => CustomerDetailsScreen(),
  );

static GetPage customers = GetPage(
    name: '/customers',
    transition: Transition.fade,
    page: () => CustomersScreen(),
  );





}
