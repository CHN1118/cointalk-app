import 'package:get/get.dart';
import 'package:wallet/views/importwallet/index.dart';
import 'package:wallet/views/index.dart';
import 'package:wallet/views/splash.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: '/',
      page: () => const Index(),
    ),
    GetPage(
      name: '/importwallet',
      page: () => const Importwallet(),
    ),
    GetPage(
      name: '/startup',
      page: () => Splash(),
    ),
  ];
}
