// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:wallet/database/index.dart';
import 'package:wallet/db/kv_box.dart';

// 语言
class Utils {
  getLanguage() {
    var lang = DB.box.read('Language');
    if (lang == 'en_US') {
      return const Locale('en', 'US');
    } else if (lang == 'zh_CN') {
      return const Locale('zh', 'CN');
    } else {
      return const Locale('zh', 'CN');
    }
  }

  /// 格式化时间
  String formatTimestamp(String timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(timestamp.split('0x')[1], radix: 16) * 1000);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
  }

  /// 金额格式化
  double formatBalance(String balance) {
    var balanceInt = BigInt.parse(balance.split('0x')[1], radix: 16);
    var balanceDouble = balanceInt / BigInt.from(10).pow(18);
    // 保留两位小数,不要四舍五入
    return double.parse(balanceDouble.toStringAsFixed(2));
  }

  ///~只显示前五位和后六位
  String formatText({required String text}) {
    if (text.length <= 11) {
      return text;
    } else {
      String abbreviatedText =
          "${text.substring(0, 5)}****${text.substring(text.length - 6, text.length)}";
      return abbreviatedText;
    }
  }

  /// 判断本地的存储的token 对应的地址和当前的地址是否一致
  Future<bool> isSameAddress({required String address}) async {
    var token = await DB.box.read('token');
    print('token-------------$token');
    if (token == null || token['token'] == null || token['address'] == null) {
      return false;
    } else {
      if (token['address'].toLowerCase() == address.toLowerCase()) {
        return true;
      } else {
        return false;
      }
    }
  }
  // Future<bool> isSameAddress({required String address}) async {
  //   var kvAddress = await KVBox.GetAddress();
  //   if (kvAddress != "" && (kvAddress.toLowerCase() == address.toLowerCase())) {
  //     return true;
  //   }
  //   return false;
  // }
}

// 判断是否登录
String checkLoginStatus() {
  var isLogin = DB.box.read('WalletList') ?? [];
  // 延迟一段时间模拟登录状态检查
  if (isLogin.length > 0) {
    return '/LogBackIn';
  } else {
    return '/importwallet';
  }
}

//获取屏幕宽度
double getScreenWidth(BuildContext context, double v) {
  return MediaQuery.of(context).size.width * v;
}

//获取屏幕高度
double getScreenHeight(BuildContext context, double v) {
  return MediaQuery.of(context).size.height * v;
}

//获取状态栏高度
double getStatusBarHeight(BuildContext context) {
  final appBarHeight = AppBar().preferredSize.height; //*appbar高度
  final toolbarHeight = MediaQuery.of(context).padding.top; //*状态栏高度
  return appBarHeight + toolbarHeight;
}

// 判断是否全屏
bool isFullScreen(context) {
  final padding = MediaQuery.of(context).padding;
  var isf = DB.box.read('isFullScreen');
  if (DB.box.read('isFullScreen') != null) {
    return isf;
  } else {
    if (padding.bottom == 0) {
      DB.box.write('isFullScreen', false);
      return false; // 非全屏模式
    } else {
      DB.box.write('isFullScreen', true);
      return true; // 处于全屏模式
    }
  }
  // 判断顶部和底部安全区域是否为零
}

//销毁isFullScreen
void removeFullScreen() {
  DB.box.remove('isFullScreen');
}

//* Bio 是全局的，可以在任意位置使用  是生物识别的实例
var utils = Utils();
