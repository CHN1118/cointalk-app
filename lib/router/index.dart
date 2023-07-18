import 'package:get/get.dart';
import 'package:wallet/views/splash.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: '/startup',
      page: () => Splash(),
    ),
    // GetPage(
    //   name: '/intro',
    //   page: () => Intro(),
    // ),
    // GetPage(
    //   name: '/',
    //   page: () => const HomePage(),
    // ),
    // GetPage(
    //   name: '/login',
    //   page: () => const Login(),
    // ),
  ];
}
