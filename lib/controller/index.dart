// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:get/get.dart';
import 'package:wallet/api/getcurrencyrate.dart';
import 'package:wallet/common/utils/dapp.dart';
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

  /// 钱包信息数组
  var walletList = [].obs;

  /// 当前账户余额
  var balance = 0.0.obs;

  /// 当前钱包信息
  var currentWallet = {}.obs;

  /// 当前钱包的交易信息
  var currentWalletTx = [].obs;

  /// 当前价格
  var usdprice = 0.0.obs;

  /// 获取钱包信息
  getWL() async {
    var list = DB.box.read('WalletList') ?? []; // 读取钱包信息
    walletList.value = list; // 更新钱包信息数组
    //* active为true的钱包为当前钱包
    currentWallet.value =
        await list.firstWhere((e) => e['active'] == true); // 更新当前钱包信息
    balance.value = await dapp.connect(); // 更新当前钱包余额
    currentWalletTx.value =
        DB.box.read(currentWallet['address'].toLowerCase()) ??
            []; // 更新当前钱包的交易信息
    print('当前钱包信息:$currentWallet');
    print('钱包信息数组:$walletList');
    print('当前钱包余额:${balance.value}');
    print('当前钱包的交易信息:$currentWalletTx');
    getPrice();
  }

  getPrice() async {
    var price = await getCoinPrice();
    usdprice.value = double.parse(price['USD'].toString());
    print('当前价格：$usdprice');
    await getUSDTPrice();
  }
}

//*全局控制器
Controller C = Get.find();
