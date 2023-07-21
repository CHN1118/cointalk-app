import 'package:get/get.dart';
import 'package:wallet/widgets/importwallet/index.dart';
import 'package:wallet/widgets/importwallet/walletname.dart';
import 'package:wallet/widgets/index.dart';
import 'package:wallet/widgets/splash.dart';

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
    GetPage(
        name: '/walletname',
        page: () => Walletname(),
        transition: Transition.topLevel),
  ];
}
