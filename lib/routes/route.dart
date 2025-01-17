import 'package:budget_tracker/pages/screen/home_page.dart';
import 'package:budget_tracker/pages/screen/splash_page.dart';
import 'package:get/get.dart';

class GetPages {
  static String splash = '/';
  static String home = '/home';

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: home,
      page: () => const HomePage(),
    ),
  ];
}
