import 'dart:ui';
import 'package:get/get.dart';
import 'package:wallet/database/index.dart';

class Controller extends GetxController {
  bool isLogin = false;
  var language = '中文'.obs;

  setLanguage() {
    var lang = DB.box.read('Language') ?? 'zh_CN';
    if (lang == 'en_US') {
      language.value = 'English';
    } else if (lang == 'zh_CN') {
      language.value = '中文';
    }
  }

  changeLanguage() {
    var lang = DB.box.read('Language') ?? 'zh_CN';
    if (lang == 'en_US') {
      DB.box.write('Language', 'zh_CN');
      const locale = Locale('zh', 'CN');
      Get.updateLocale(locale);
    } else if (lang == 'zh_CN') {
      DB.box.write('Language', 'en_US');
      const locale = Locale('en', 'US');
      Get.updateLocale(locale);
    }
    setLanguage();
  }

  // *钱包信息数组 (Wallet Information Array)
  var walletList = [].obs;

  // *当前钱包信息 (Current Wallet Information)
  var currentWallet = {}.obs;

  // *获取钱包信息 (Get Wallet Information)
  getWalletList() {
    var list = DB.box.read('WalletList') ?? [];
    walletList.value = list;
    if (list.length > 0) {
      currentWallet.value = list[0];
    }
  }
}

//*全局控制器
Controller C = Get.find();
