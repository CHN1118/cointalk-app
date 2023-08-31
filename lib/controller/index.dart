// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:ui';
import 'package:get/get.dart';
import 'package:wallet/api/account_api.dart';
import 'package:wallet/api/getcurrencyrate.dart';
import 'package:wallet/common/utils/dapp.dart';
import 'package:wallet/database/index.dart';
import 'package:web3dart/web3dart.dart';

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

  /// 热钱包信息数组
  var hotWalletList = {}.obs;

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
    if (list.length == 0) {
      return;
    }
    list.forEach((e) async {
      e['balance'] =
          await dapp.connect(address: EthereumAddress.fromHex(e['address']));
    });
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
    // dapp.signMessage(); // ?定时获取签名
    // bool islogin =
    //     await utils.isSameAddress(address: currentWallet.value['address']);
    // print('----------------->islogin');
    // print(islogin);
    // if (islogin) {
    //   print('已登录');
    //   // print('当前钱包地址:${DB.box.read('token')}');
    //   print('当前钱包地址:${KVBox.GetAddress()}');
    // } else {
    //   await dapp.signMessage();
    // }
  }

  /// 获取当前价格
  getPrice() async {
    var price = await getCoinPrice();
    if (price != null) {
      print(price);
      usdprice.value = double.parse(price['USD'].toString());
      print('当前价格：$usdprice');
      await getUSDTPrice();
    }
  }

  /// 获取热钱包信息
  getHotWallet({String? psw}) async {
    await getWL();
    String psw = await swi.getpassword();
    await dapp.signMessage(password: psw); // ?定时获取签名
    var h = await AccountApi().my();
    if (h.data['code'] == 0) {
      hotWalletList.value = h.data['data'];
    } else {
      hotWalletList.value = {};
    }
  }
}

//*全局控制器
Controller C = Get.find();
