import 'package:get/get.dart';
import 'package:wallet/widgets/importwallet/creat_psw.dart';
import 'package:wallet/widgets/importwallet/index.dart';
import 'package:wallet/widgets/importwallet/log_back_in.dart';
import 'package:wallet/widgets/importwallet/mnemonic.dart';
import 'package:wallet/widgets/importwallet/wallet_name.dart';
import 'package:wallet/widgets/index.dart';
import 'package:wallet/widgets/splash.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
        name: '/', page: () => const Index(), transition: Transition.topLevel),
    GetPage(
      name: '/importwallet',
      page: () => const Importwallet(),
    ),
    GetPage(
      name: '/startup',
      page: () => const Splash(),
    ),
    GetPage(
        name: '/walletname',
        page: () => const Walletname(),
        transition: Transition.topLevel),
    GetPage(
        name: '/mnemonic',
        page: () => const Mnemonic(),
        transition: Transition.topLevel),
    GetPage(
      name: '/CreatPsw',
      page: () => CreatPsw(
        title: '创建钱包密码',
      ),
    ),
    GetPage(
      name: '/LogBackIn',
      page: () => const LogBackIn(),
    ),
  ];
}
